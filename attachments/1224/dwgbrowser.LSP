(defun c:dwgbrowser_browser_OnDocActivated (/)
(dcl_Form_Show dwgbrowser_browser)
(princ)
)


(defun c:dwgbrowser ()
  (setvar "CMDECHO" 0)
  (command "OPENDCL")
  (dcl_project_load "dwgbrowser.odcl" T)
  (vl-load-com)
  (if (and dwgbrowser_browser (not (dcl_Form_IsActive dwgbrowser_browser)))
    (dcl_form_show dwgbrowser_browser)
  ); if
  (princ)
); dwgbrowser

(defun dwgbrowser_filllist (strPath / lstFiles lstDir lstDwg)
  (dcl_ListView_Clear dwgbrowser_browser_lst)
  (dcl_Control_SetCaption dwgbrowser_browser_txt_wait "Please wait, collecting directory information. This may take a few seconds...")
  (dcl_Control_SetVisible dwgbrowser_browser_txt_wait T)
  (dcl_Control_Redraw dwgbrowser_browser_txt_wait)
  
  (if (and (setq strPath (dwgbrowser_check_path strPath))
           (or (< (strlen strPath) 4) (findfile (vl-string-right-trim "\\" strPath)))
           (setq lstFiles (append (setq lstDir (mapcar 'dwgbrowser_dir_info (dwgbrowser_items_sort (vl-remove "."
(vl-remove ".." (vl-directory-files strPath "*" -1))))))

           (setq lstDwg (mapcar 'dwgbrowser_file_info (dwgbrowser_items_sort (vl-directory-files strPath "*.dwg" 1))))))
) ;;end if

    (progn
      (dcl_listview_filllist dwgbrowser_browser_lst lstFiles)
      (dcl_Control_SetVisible dwgbrowser_browser_txt_wait nil)
      (cond
        (lstDwg (repeat (setq intCnt 9)
                  (if (nth (setq intCnt (1- intCnt)) lstDwg)
                   (eval (read "dwgbrowser_browser_dwg1"))
                  ); if
                ))
      ); cond

      (if lstDwg
        (dwgbrowser_fillpreview (length lstDir))
      ); if
    ); progn
    (progn
      ;(dwgbrowser_invisible_all)
      (dcl_Control_SetCaption dwgbrowser_browser_txt_wait "There are no items in the selected directory.")
      (dcl_Control_SetVisible dwgbrowser_browser_txt_wait T)
    ); progn
  ); if
); dwgbrowser_filllist


(defun dwgbrowser_check_path (strPath)
  (if (/= (substr strPath (strlen strPath)) "\\")
    (setq strPath (strcat strPath "\\"))
  ); if
  strPath
); dwgbrowser_check_path

(defun dwgbrowser_items_sort (lstItems)
  (vl-sort lstItems 'dwgbrowser_items_sortitems)
); dwgbrowser_items_sort

(defun dwgbrowser_items_sortitems (strItem1 strItem2)
  (< (strcase strItem1) (strcase strItem2))
); dwgbrowser_items_sortitems

(defun dwgbrowser_dir_info (strFile / strCompleteFile)
  (if (setq strCompleteFile (findfile (strcat strPath strFile)))
    (list (vl-filename-base strFile) 0 "" "")
  ); if
); dwgbrowser_dir_info

(defun dwgbrowser_file_info (strFile / strCompleteFile)
  (if (setq strCompleteFile (findfile (strcat strPath strFile)))
    (if (vl-file-directory-p strCompleteFile)
      (list (vl-filename-base strFile) 0 "" "")
      (list (vl-filename-base strFile) 1 (dwgbrowser_file_size strCompleteFile) (dwgbrowser_file_date strCompleteFile))
    ); if
  ); if
); dwgbrowser_file_info

(defun dwgbrowser_file_size (strFile / reaSize)
  (setq reaSize (float (vl-file-size strFile)))
  (cond
    ((< reaSize 1024) (setq strSize (strcat (rtos reaSize 2 0) " Byte")))
    ((< (setq reaSize (/ reaSize 1024.0)) 1024) (setq strSize (strcat (rtos reaSize 2 2) " KByte")))
    ((< (setq reaSize (/ reaSize 1024.0)) 1024) (setq strSize (strcat (rtos reaSize 2 2) " MByte")))
    ((setq reaSize (/ reaSize 1024.0)) (setq strSize (strcat (rtos reaSize 2 2) " GByte")))
  ); cond
  strSize
); dwgbrowser_file_size


(defun file_getdate (strFile / lstRet oFSObject oFile reaDate intYear intDay is2902  
                                   lstMonths intMonth reaWeek intWeek intDay reaTime  
                                   reaHour intHour reaMinutes intMinutes reaSeconds  
                                   intSeconds reaMSec intMSec)  
  (cond  
    ((not (findfile strFile)) (setq lstRet '(1900 01 0 01 00 00 00 00)))  
    ((setq lstRet (vl-file-systime strFile)) nil)  
    ((not (and (setq oFSObject (vlax-create-object "Scripting.FileSystemObject"))  
               (setq oFile (vl-catch-all-apply 'vlax-invoke-method (list oFSObject "GetFile" strFile)))  
               (not (vl-catch-all-error-p oFile))))  
     (setq lstRet '(1900 01 0 01 00 00 00 00)  
           oFile nil))  
    (oFile  
     (setq reaDate (1- (vlax-get oFile 'DateLastModified)))  
     (setq reaWeek (/ (fix reaDate) 7.0))  
     (setq intWeek (atoi (rtos (* 7.0 (- reaWeek (fix reaWeek))) 2 0)))  
     (setq intYear (+ 1900 (fix (/ reaDate 365.25))))  
     (setq intDay (fix (- reaDate (* (fix (/ reaDate 365.25)) 365.25))))  
     (setq is2902 (= (* 365.25 (fix (/ reaDate 365.25)))  
                     (fix (* 365.25 (fix (/ reaDate 365.25))))))  
  
     (setq lstMonths (list (cons 1 31) (cons 2 (if is2902 29 28)) (cons 3 31) (cons 4 30) (cons 5 31) (cons 6 30)  
                           (cons 7 31) (cons 8 31) (cons 9 30) (cons 10 31) (cons 11 30) (cons 12 31)))  
     (setq intMonth (caar lstMonths))  
  
     (while (and lstMonths (> (- intDay (cdar lstMonths)) 0.0))  
       (setq intDay (- intDay (cdar lstMonths))  
             intMonth (caadr lstMonths)  
             lstMonths (cdr lstMonths))  
     ); while  
  
     (setq reaTime (- reaDate (fix reaDate)))  
     (setq reaHour (* 24.0 reaTime))  
     (setq intHour (fix reaHour))  
     (setq reaMinutes (* 60.0 (- reaHour intHour)))  
     (setq intMinutes (fix reaMinutes))  
     (setq reaSeconds (* 60.0 (- reaMinutes intMinutes)))  
     (setq intSeconds (fix reaSeconds))  
     (setq reaMSec (* 1000.0 (- reaSeconds intSeconds)))  
     (setq intMSec (fix reaMSec))  
     (setq lstRet (list intYear intMonth intWeek intDay intHour intMinutes intSeconds intMSec)))  
  ); cond  
  (mapcar 'vlax-release-object (vl-remove nil (list oFSObject oFile)))  
  lstRet  
); file_getdate  


(defun dwgbrowser_file_date (strFile /)
  (setq lstDate (mapcar 'dwgbrowser_check_digit (mapcar 'itoa (file_getdate strFile))))
  (strcat (car lstDate) "-" (cadr lstDate) "-" (caddr lstDate) " " (cadddr lstDate) ":" (cadddr (cdr lstDate)))
); dwgbrowser_file_date

(defun dwgbrowser_check_digit (strValue)
  (if (= (strlen strValue) 1) (strcat "0" strValue) strValue)
); dwgbrowser_check_digit

(defun dwgbrowser_fillpreview (intItem / strPath intRow strCompleteFile)
  (setq strPath (dwgbrowser_check_path (dcl_ComboBox_GetDir dwgbrowser_browser_dir)))
  (setq intLen (dcl_ListView_GetCount dwgbrowser_browser_lst))
  (foreach intRow '(0 1 2 3 4 5 6 7 8)
    (if (>= (+ intItem (1+ intRow)) intLen)
      (progn
        (setq oControl (eval (read "dwgbrowser_browser_dwg1")))
        (if (setq strCompleteFile (findfile (strcat strPath (dcl_ListView_GetItemText dwgbrowser_browser_lst intRow 0) ".dwg")))
          (dcl_DWGPreview_LoadDwg oControl strCompleteFile)
        ); if
      ); progn
    ); if
  ); foreach
); dwgbrowser_fillpreview

(defun c:dwgbrowser_browser_OnInitialize (/)
  (dcl_Control_SetVisible dwgbrowser_browser_txt_wait nil)
  (dcl_ListView_AddColumns dwgbrowser_browser_lst (list (list "Name" 0 222) (list "Size" 0 100) (list "Date" 0 100)))
  (dwgbrowser_filllist (dcl_ComboBox_GetDir dwgbrowser_browser_dir))
(setq user_name (getvar "loginname"))
(setq first (strcase (substr user_name 1 1)))
(setq user (strcat first (vl-string-left-trim (substr user_name 1 1) user_name)))
(setq user1 user)
;(dcl_Control_SetCaption dwgbrowser_browser_USER user)

(dcl_ListView_AddColumns dwgbrowser_browser_ListView1 (list (list "" 0 80)
)
)

(dcl_ListView_FillList
  dwgbrowser_browser_ListView1 
  (list 
   (list user 0) 
   (list "Dwg" 0)
   (list "100000" 0)
(list "50000" 0)
(list "40000" 0)
(list "Standards" 0)
(list "Sales" 0)
  )
)

); c:dwgbrowser_browser_OnInitialize


(defun c:dwgbrowser_browser_dir_OnSelChanged (intItemIndexOrCount strValue /)
  (dwgbrowser_filllist strValue)
); c:dwgbrowser_browser_dir_OnSelChanged


(defun c:dwgbrowser_browser_up_OnClicked (/ strFolder lstChars)
  (setq strFolder (dcl_ComboBox_GetDir dwgbrowser_browser_dir))
  (if (setq lstChars (reverse (cdr (member 92 (reverse (vl-string->list strFolder))))))
    (progn
      (setq strFolder (apply 'strcat (mapcar 'chr lstChars)))
      (dcl_ComboBox_AddPath dwgbrowser_browser_dir strFolder)
      (dcl_ComboBox_SelectString dwgbrowser_browser_dir strFolder)
      (dwgbrowser_filllist strFolder)
    ); progn
  ); if
); c:dwgbrowser_browser_up_OnClicked


(defun c:dwgbrowser_browser_lst_OnClicked (intRow intColumn / strFile)
  (setq strPath (dwgbrowser_check_path (dcl_ComboBox_GetDir dwgbrowser_browser_dir)))
  (cond
    ((minusp intRow) nil)
    ((zerop (dcl_ListView_GetItemImage dwgbrowser_browser_lst intRow 0)) nil)
    (T (dwgbrowser_fillpreview intRow))
  ); cond
); c:dwgbrowser_browser_lst_OnClicked


(defun c:dwgbrowser_browser_lst_OnClicked (intRow intColumn / strPath strCompleteFile)
  (setq strPath (dwgbrowser_check_path (dcl_ComboBox_GetDir dwgbrowser_browser_dir)))
  (cond
    ((minusp intRow) nil)
    ((zerop (dcl_ListView_GetItemImage dwgbrowser_browser_lst intRow 0))
     (setq strPath (strcat strPath (dcl_ListView_GetItemText dwgbrowser_browser_lst intRow 0)))
     (dcl_ComboBox_AddPath dwgbrowser_browser_dir strPath)
     (dcl_ComboBox_SelectString dwgbrowser_browser_dir strPath)
     (dwgbrowser_filllist strPath))
    ((setq strCompleteFile (findfile (strcat strPath (dcl_ListView_GetItemText dwgbrowser_browser_lst intRow 0) ".dwg")))
     (dcl_DWGPreview_LoadDwg dwgbrowser_browser_dwg1 strCompleteFile))
  ); cond
(setq open_file strcompletefile)
); c:dwgbrowser_browser_lst_OnClicked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;NAO ADDITIONS;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;closes the dialog;;;;;;;;;;;;;

(defun c:dwgbrowser_browser_Close_OnClicked (/)
(dcl_Form_Close dwgbrowser_browser)
(princ)
)

;;;;;;;;;;;save as function;;;;;;;;;;;;;;

(defun c:dwgbrowser_browser_saveas_OnClicked (/)
(initdia)
(command "saveas")
(princ)
)

;;;;;;;;;;import tool;;;;;;;;;;;;;;;;;;;;
(defun c:dwgbrowser_browser_import_tool_OnClicked (/)
  (startapp "Z:\\Questica Import\\NAOtoQuesticaImportTool.exe")
(princ)
)


;;;;;;;;;search function;;;;;;;;;;

(defun c:dwgbrowser_browser_file_search_OnClicked (/)
(dcl_Control_SetCaption dwgbrowser_browser_searching "Searching...")
(dcl_Control_SetCaption dwgbrowser_browser_results "")
  (setq fln (dcl_Control_GetText dwgbrowser_browser_search_box))
   (SETQ dwgsrch (CAR (DOS_FIND (strcat "Q:\\" FLN ".dwg"))))
     (if dwgsrch 
      (progn
        (dcl_Control_SetCaption dwgbrowser_browser_searching "Found!")
        (dcl_Control_SetCaption dwgbrowser_browser_results dwgsrch)
        (setq preview dwgsrch)
      )
      (progn
        (dcl_Control_SetCaption dwgbrowser_browser_searching "Not Found")
        (dcl_Control_SetCaption dwgbrowser_browser_results "")
      )
     )

	(setq sFileName dwgsrch);_ get the path to a dwg file
	(if sFileName
		(progn
                  (dcl_DWGPreview_LoadDwg dwgbrowser_browser_dwg1 sfilename)		
		)
	)

(princ)
)

;;;;;;;;;;;;;;;;;drawing history;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun c:dwgbrowser_browser_history_OnClicked (/)
(dcl_Form_Show dwgbrowser_Form1)
)

(defun c:dwgbrowser_Form1_OnInitialize (/ datafile ofile curline file_content_list)
  (setq datafile (strcat "C:\\dwg-history" (menucmd "M=$(edtime,$(getvar,date), MON DD YYYY)") ".txt")) 
  (dcl_Control_SetText dwgbrowser_Form1_ComboBox1 datafile)
  (setq ofile (open datafile "r"))  
  (while (setq curline (read-line ofile))  
    (setq file_content_list (cons curline file_content_list))  
  )  
  (close ofile)  
  (setq file_content_list (reverse file_content_list)) 
  (dcl_ListBox_Clear dwgbrowser_Form1_ListBox1)
  (dcl_ListBox_AddList dwgbrowser_Form1_ListBox1 file_content_list)  
(princ)
) ;end OnInitialize

(defun c:dwgbrowser_Form1_ListBox1_OnSelChanged (nselection sseltext /)
(dcl_DWGPreview_LoadDwg dwgbrowser_Form1_DwgPreview1 sseltext)
(Setq opfile sseltext)
(princ)
)

(defun c:dwgbrowser_Form1_DwgPreview1_OnDblClicked (/)
(if (findfile opfile)
(progn
(dcl_Form_Close dwgbrowser_Form1)
(vlax-invoke-method (vla-get-Documents (vlax-get-acad-object)) "Open" opfile)
)
(dcl_MessageBox "File no longer exists!")
)
(princ)
)

(defun c:dwgbrowser_Form1_ComboBox1_OnDropDown (/)
(setq hist "C:\\")
(dcl_ComboBox_Dir dwgbrowser_Form1_ComboBox1 hist "*.txt")
(princ)
)

(defun c:dwgbrowser_Form1_ComboBox1_OnSelChanged (ItemCount histfile / file_list datfile ofil curline)
  (setq datfile (strcat "C:\\" histfile))
  (setq ofil (open datfile "r"))  
   (while (setq curline (read-line ofil))  
      (setq file_list (cons curline file_list))  
  )  
  (close ofil)  

  (setq file_list (reverse file_list)) 
  (dcl_ListBox_Clear dwgbrowser_Form1_ListBox1)
  (dcl_ListBox_AddList dwgbrowser_Form1_ListBox1 file_list)
 
(princ)
)

(defun c:dwgbrowser_Form1_OnCancelClose (Reason /)
(dcl_ListBox_Clear dwgbrowser_Form1_ListBox1)
(setq current_hist (strcat "C:\\dwg-history" (menucmd "M=$(edtime,$(getvar,date), MON DD YYYY)") ".txt"))
(dcl_Control_SetText dwgbrowser_Form1_ComboBox1 current_hist)
(dcl_Form_Close dwgbrowser_Form1)
)

(defun c:dwgbrowser_Form1_OnClose (UpperLeftX UpperLeftY /)
(dcl_ListBox_Clear dwgbrowser_Form1_ListBox1)
(setq current_hist (strcat "C:\\dwg-history" (menucmd "M=$(edtime,$(getvar,date), MON DD YYYY)") ".txt"))
(dcl_Control_SetText dwgbrowser_Form1_ComboBox1 current_hist)
(dcl_Form_Close dwgbrowser_Form1)
)


(defun c:dwgbrowser_Form1_file_merge_OnClicked (/)
(dcl_Form_Show dwgbrowser_merge_confirmation)
)


(defun c:dwgbrowser_Form1_dwg_hist_close_OnClicked (/)
(dcl_Form_Close dwgbrowser_Form1)
)

(defun c:dwgbrowser_merge_confirmation_merge_yes_OnClicked (/)
(dcl_Form_Close dwgbrowser_merge_confirmation)
(load "merge_files")
(c:merge)
)

(defun c:dwgbrowser_merge_confirmation_merge_no_OnClicked (/)
(dcl_Form_Close dwgbrowser_merge_confirmation)
)



;;;;;;;;;;;;;;;;;;;;; larger drawing view ;;;;;;;;;;;;;;;;;

(defun c:dwgbrowser_browser_dwg1_OnDblClicked (/ strfile)
	(if (Setq strfile open_file)
           (progn      
             (vl-bb-set '***strDoc*** strFile)
             (dcl_sendstring "browser_open ")
           )
         )
(princ)
)

(defun c:browser_open (/)
  (dcl_Form_Show dwgbrowser_Form2)
  (princ)
); c:browser_open

(defun c:dwgbrowser_Form2_OnInitialize (/ strfile)
 (if (setq strFile (vl-bb-ref '***strDoc***))
    (dcl_BlockView_LoadDwg dwgbrowser_Form2_BlockView1 strfile)
 ); if
  (vl-bb-set '***strDoc*** nil)
 (princ)
)

(defun c:dwgbrowser_Form2_lg_preview_open_OnClicked (/)
(dcl_Form_Close dwgbrowser_Form2)
	(if open_file
(command "._VBAStmt" (strcat "AcadApplication.Documents.Open \"" open_file "\""))
;(vlax-invoke-method (vla-get-Documents (vlax-get-acad-object)) "Open" open_file)

(princ)
)
)

(defun c:dwgbrowser_Form2_insert_OnClicked (/)
(dcl_Form_Close dwgbrowser_Form2)
(command  "-INSERT" open_file pause "" "" "")
)


(defun c:dwgbrowser_Form2_lg_preview_close_OnClicked (/)
(dcl_Form_Close dwgbrowser_Form2)
(princ)
)


;;;;;;;;;;;;;;;; shortcut buttons;;;;;;;;;;;;;;;


(defun c:dwgbrowser_browser_ListView1_OnDblClicked (nRow nCol / strFolder lstChars)
(if (= nrow 0) ;user button
(progn
	(IF (= user "Andrew") (setq user "M:\\ANDY MILOREY\\"))
	(IF (= user "Joe") (setq user "M:\\JOE GILMAN"))
	(IF (= user "Jimoz") (setq user "M:\\JIM OSWALD"))
	(IF (= user "Victor") (setq user "M:\\VICTOR DEJESUS"))
  (if (setq lstChars (reverse (cdr (member 92 (reverse (vl-string->list user))))))
    (progn
      (setq user (apply 'strcat (mapcar 'chr lstChars)))
      (dcl_ComboBox_AddPath dwgbrowser_browser_dir user)
      (dcl_ComboBox_SelectString dwgbrowser_browser_dir user)
      (dwgbrowser_filllist user)
    ); progn
  ); if
) ;progn
) ;if

(if (= nrow 1) ; dwg button
(progn
(SETQ strfolder "M:\\")
  (if (setq lstChars (reverse (cdr (member 92 (reverse (vl-string->list strFolder))))))
    (progn
      (setq strFolder (apply 'strcat (mapcar 'chr lstChars)))
      (dcl_ComboBox_AddPath dwgbrowser_browser_dir strFolder)
      (dcl_ComboBox_SelectString dwgbrowser_browser_dir strFolder)
      (dwgbrowser_filllist strFolder)
    ); progn
  ); if
) ;progn
) ;if

(if (= nrow 2) ; 100000 button
(progn
(SETQ strfolder "Q:\\1000__Series\\")
  (if (setq lstChars (reverse (cdr (member 92 (reverse (vl-string->list strFolder))))))
    (progn
      (setq strFolder (apply 'strcat (mapcar 'chr lstChars)))
      (dcl_ComboBox_AddPath dwgbrowser_browser_dir strFolder)
      (dcl_ComboBox_SelectString dwgbrowser_browser_dir strFolder)
      (dwgbrowser_filllist strFolder)
    ); progn
  ); if
) ;progn
) ;if

(if (= nrow 3) ; 50000 button
(progn
(SETQ strfolder "Q:\\50000 Series\\")
  (if (setq lstChars (reverse (cdr (member 92 (reverse (vl-string->list strFolder))))))
    (progn
      (setq strFolder (apply 'strcat (mapcar 'chr lstChars)))
      (dcl_ComboBox_AddPath dwgbrowser_browser_dir strFolder)
      (dcl_ComboBox_SelectString dwgbrowser_browser_dir strFolder)
      (dwgbrowser_filllist strFolder)
    ); progn
  ); if
) ;progn
) ;if

(if (= nrow 4) ; 40000 button
(progn
(SETQ strfolder "Q:\\40000 Series\\")
  (if (setq lstChars (reverse (cdr (member 92 (reverse (vl-string->list strFolder))))))
    (progn
      (setq strFolder (apply 'strcat (mapcar 'chr lstChars)))
      (dcl_ComboBox_AddPath dwgbrowser_browser_dir strFolder)
      (dcl_ComboBox_SelectString dwgbrowser_browser_dir strFolder)
      (dwgbrowser_filllist strFolder)
    ); progn
  ); if
) ;progn
) ;if

(if (= nrow 5) ; standard button
(progn
(SETQ strfolder "Q:\\STANDARD\\")
  (if (setq lstChars (reverse (cdr (member 92 (reverse (vl-string->list strFolder))))))
    (progn
      (setq strFolder (apply 'strcat (mapcar 'chr lstChars)))
      (dcl_ComboBox_AddPath dwgbrowser_browser_dir strFolder)
      (dcl_ComboBox_SelectString dwgbrowser_browser_dir strFolder)
      (dwgbrowser_filllist strFolder)
    ); progn
  ); if
) ;progn
) ;if

(if (= nrow 6) ; sales button
(progn
(SETQ strfolder "Q:\\SALES\\")
  (if (setq lstChars (reverse (cdr (member 92 (reverse (vl-string->list strFolder))))))
    (progn
      (setq strFolder (apply 'strcat (mapcar 'chr lstChars)))
      (dcl_ComboBox_AddPath dwgbrowser_browser_dir strFolder)
      (dcl_ComboBox_SelectString dwgbrowser_browser_dir strFolder)
      (dwgbrowser_filllist strFolder)
    ); progn
  ); if
) ;progn
) ;if

(princ)
)



;(dcl_Form_Show dwgbrowser_Form3)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun c:dwgbrowser_Form3_OnInitialize (/ ofile curline file_content_list)

  (setq datafile (findfile "test.txt"))
  (setq ofile (open datafile "r"))  
  (while (setq curline (read-line ofile))  
    (setq file_content_list (cons curline file_content_list))  
  )  
  (close ofile)  
  (setq file_content_list (reverse file_content_list))
(dcl_Control_SetList dwgbrowser_Form3_ListBox1 file_content_list)
;(dcl_Control_SetList dwgbrowser_Form3_ListBox2 (nth 1 file_content_list))
(dcl_ListView_AddColumns dwgbrowser_Form3_ListView1 
  (list 
    (list "Name" 0 100) 
    (list "Size" 0 100) 
    (list "Date" 0 100)
  )
)

)




(defun c:dwgbrowser_Form3_TextButton1_OnClicked (/ items title rev dwgnum make_lst show_lst)

(setq items (dcl_ListBox_GetSelectedItems dwgbrowser_Form3_ListBox1))
(setq new_item items)

;;get title
(setq title (substr (nth 0 items) 1 34)) 

;;gets rev
(setq rev (substr (nth 0 items) 53))

;;gets dwg number
(setq dwgnum (substr (nth 0 items) 43 7))

(setq make_lst (dcl_ListView_AddItem dwgbrowser_Form3_ListView1 title dwgnum rev))
(setq am1 make_lst)

;(setq show_lst (mapcar 'list make_lst))

(dcl_ListView_FillList dwgbrowser_Form3_ListView1 make_lst)

) ;end defun



(defun c:dwgbrowser_Form3_TextButton2_OnClicked (/)

;(Setq DLst (dcl_ListBox_GetSelectedNths dwgbrowser_Form3_ListBox2))
;(setq am1 (dcl_Control_GetList dwgbrowser_Form3_ListBox2))
(setq df "c:\\test3.txt")
 (if (/= df nil)
  (progn
    (setq ff (open df "a"))
      (foreach item am
        (write-line item ff) 
      )
    (close ff)
   )
   (progn
      (setq ff (open df "w"))
       (foreach item am
        (write-line item ff) 
       )
      (close ff)
   )
)



) ;; end defun









