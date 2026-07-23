(setq App (vlax-Get-Acad-Object)
Doc (vla-Get-ActiveDocument App)
DwgProps (vla-Get-SummaryInfo Doc)
)

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


(defun c:dwgbrowser_browser_release_button_OnClicked (/)
(dcl_Form_Show dwgbrowser_Form3)
)

(defun c:dwgbrowser_Form3_close_release_form_OnClicked (/)
(dcl_Form_Close dwgbrowser_Form3)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun c:dwgbrowser_Form3_OnInitialize (/ ofile curline file_content_list get_cust_bb)
;(dcl_Control_SetEnabled dwgbrowser_Form3_RevLog nil)
;(dcl_Control_SetEnabled dwgbrowser_Form3_Label4 nil)
(setq get_cur_date (menucmd "M=$(edtime,$(getvar,date), MON DD YYYY)"))
(setq order_number (vl-Filename-Base (vl-Filename-Directory (getvar "Dwgprefix"))))
(vla-GetCustomByIndex DwgProps 0 'aa 'bb)
(dcl_Control_SetCaption dwgbrowser_Form3_customer bb)

(dcl_Control_SetCaption dwgbrowser_Form3_order order_number)

(dcl_Control_SetValue dwgbrowser_Form3_RevLog 0)
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
    (list "Drawing Title" 0 225) 
    (list "Drawing No." 0 100) 
    (list "Revision" 0 100)
  )
)

(setq sho_lst nil)

(defun remitem (lst pos)
  (vl-remove-if
    (function
      (lambda (x)
        (eq (nth pos lst) x)
      )
    )
    lst
  )
)

) ; end Form3 OnInitialize


(defun c:dwgbrowser_Form3_TextButton1_OnClicked (/ items title rev dwgnum make_lst stritem)



(setq items (dcl_ListBox_GetSelectedItems dwgbrowser_Form3_ListBox1))
(setq newits items)

;;get title
(setq title (substr (nth 0 items) 1 42)) 

;;gets rev
(setq rev (substr (nth 0 items) 53))
    (while (< (strlen rev) 6)
      (setq rev (strcat rev " "))
    ); end while
(SETQ AMREV REv)

;;gets dwg number
(setq dwgnum (substr (nth 0 items) 43 10))
(SETQ amrev1 dwgnum)

(defun make_list (strItem) 
 (list strItem)
)

(if sho_lst
 (progn 
  (setq make_lst (mapcar 'list (make_list title) (make_list dwgnum) (make_list rev)))
  (setq sho_lst (append sho_lst make_lst))
 )
(progn
  (setq make_lst (mapcar 'list (make_list title) (make_list dwgnum) (make_list rev)))
  (setq sho_lst (append sho_lst make_lst))
 )
)

(dcl_ListView_FillList dwgbrowser_Form3_ListView1 sho_lst)

) ;end defun

;;;;;;;;;;;; clears list on exit;;;;;;;;;;;

(defun c:dwgbrowser_Form3_OnCancel (/)
(setq sho_lst nil)
)
(defun c:dwgbrowser_Form3_OnCancelClose (Reason /)
(setq sho_lst nil)
)
(defun c:dwgbrowser_Form3_OnClose (UpperLeftX UpperLeftY /)
(setq sho_lst nil)
)

;;;;;;;;;;;;;;;;;;deletes item from list;;;;;;;;;;;;;;;;;;

(defun c:dwgbrowser_Form3_ListView1_OnClicked (delRow delCol /)
(setq delete_row delrow)
(setq delete_col delcol)
;	 (dcl_MessageBox (strcat "Column " (itoa delCol) ", Row " (itoa delRow))
;					  "Clicked Location"
;	 )
(setq am5 (dcl_ListView_GetColumnItems dwgbrowser_Form3_ListView1 delcol))
)


(defun c:dwgbrowser_Form3_delete_item_OnClicked (/)

(dcl_Form_Show dwgbrowser_delete_confirm)

) ;; end defun

(defun c:dwgbrowser_delete_confirm_yes_delete_OnClicked (/)
(setq amnth (dcl_ListView_GetCurSel dwgbrowser_Form3_ListView1))
(setq sho_lst (remitem sho_lst AMNTH))

(dcl_ListView_Clear dwgbrowser_Form3_ListView1)
(dcl_ListView_FillList dwgbrowser_Form3_ListView1 sho_lst)
(dcl_Form_Close dwgbrowser_delete_confirm)

)

(defun c:dwgbrowser_delete_confirm_no_delete_OnClicked (/)
(dcl_Form_Close dwgbrowser_delete_confirm)
)


;;;;;;;;;;;;;;;;;;;creates the drawing release;;;;;;;;;;;;;

(defun c:dwgbrowser_Form3_TextButton2_OnClicked (/)
(dcl_Form_Show dwgbrowser_operation_request)
)





(defun c:dwgbrowser_Form4_release_selection_OnClicked  (/ nlst ndx lst_cnt DWGCNT 
                                                   OLD_FILE FILE_CNT FILE_EXT OLD_filename 
                                                   NEW_FILENAME FILE_path NEW_FILE
                                                )

(dcl_Control_SetValue dwgbrowser_operation_request_complete 0)
(dcl_Control_SetValue dwgbrowser_operation_request_preliminary 0)
(dcl_Control_SetValue dwgbrowser_operation_request_incomplete 0)
(dcl_Control_SetValue dwgbrowser_operation_request_revised 0)
(dcl_Control_SetValue dwgbrowser_operation_request_preorder 0)
(dcl_Control_SetText dwgbrowser_operation_request_other_input "")



(if (= 1 (dcl_Control_GetValue dwgbrowser_operation_request_complete))
 (PROGN
 (setq selection_a "[X] A. ")
 )
 (PROGN
 (setq selection_a "[ ] A.")
 )
)
(if (= 1 (dcl_Control_GetValue dwgbrowser_operation_request_preliminary))
 (PROGN
 (setq selection_b "[X] B. ")
 )
 (PROGN
 (setq selection_b "[ ] B.")
 )
)
(if (= 1 (dcl_Control_GetValue dwgbrowser_operation_request_incomplete))
 (PROGN
 (setq selection_C "[X] C. ")
 )
 (PROGN
 (setq selection_c "[ ] C.")
 )
)
(if (= 1 (dcl_Control_GetValue dwgbrowser_operation_request_revised))
 (PROGN
 (setq selection_d "[X] D. ")
 )
 (PROGN
 (setq selection_d "[ ] D.")
 )
)
(if (= 1 (dcl_Control_GetValue dwgbrowser_operation_request_preorder))
 (PROGN
 (setq selection_e "[X] E. ")
 )
 (PROGN
 (setq selection_e "[ ] E.")
 )
)
(if (= 1 (dcl_Control_GetValue dwgbrowser_operation_request_other))
 (PROGN
 (setq selection_f (strcat "[X] F. " (dcl_Control_GetText dwgbrowser_operation_request_other_input)))
 )
 (PROGN
 (setq selection_f "[ ] F.")
 )
)

              (setq dwg_release_file (strcat (getvar "dwgprefix") "DWG-REL" get_cur_date ".REL"
                                     )
              )
		   (SETQ OLD_FILE (FINDFILE dwg_release_file))
		   (if OLD_FILE
			(progn
			  (SETQ FILE_CNT (LENGTH (vl-directory-files (vl-Filename-Directory OLD_FILE) "*.REL" 1)))
			  (SETQ FILE_EXT (vl-filename-extension OLD_filE))
			  (setq OLD_filename (vl-filename-base OLD_file))
			  (SETQ NEW_FILENAME (STRCAT OLD_FILENAME "["(ITOA FILE_CNT)"]" FILE_EXT))
			  (setq FILE_path (vl-filename-directory OLD_file))
			  (SETQ NEW_FILE (STRCAT FILE_PATH "\\" NEW_FILENAME))
			  (vl-file-rename OLD_file NEW_FILE)
			);  END PROGN
		   ) ; END IF

              (setq printfile (open dwg_release_file "w")) 
                (write-line " " printfile)
                (write-line (strcat "\t" "\t" "           PRODUCTION DRAWING RELEASE") printfile)
                (write-line (strcat "\t" "\t" "\t" "Confidential--Property of NAO, Inc.") printfile)
                (write-line " " printfile)
                (write-line (strcat "Release Date: " get_cur_date "\t" "\t" "\t" "\t"                                               "Order No.: " order_number) 
                 printfile)
                (write-line " " printfile)
                (write-line (strcat "    Title" "\t" "\t" "\t" "\t" "\t"  "    Drawing No." "       Rev. No.")                  printfile)
                (write-line (strcat "    -------------------------------" "                 " "-----------" "       "  "--------") 
                 printfile)

(setq ndx 0)
(setq lst_cnt (length sho_lst)) ; counts how many lines
(SETQ DWGCNT (itoa 1))
(repeat lst_cnt
  (setq nlst (nth ndx sho_lst))
                (setq str "")
                (setq spacer "       ")
                (setq spcr "   ")
                (foreach item nlst 
                 (setq str (strcat str item spacer))
                 (setq str1 (strcat dwgcnt spcr str))
                )
                (write-line str1 printfile)
                (setq ndx (1+ ndx))
(setq reverse_dwgcnt (atoi dwgcnt))
(setq DWGCNT (itoa (1+ reverse_dwgcnt)))
)
                (write-line " " printfile)
                (write-line " " printfile)
                (write-line " " printfile)
                (write-line " " printfile)
                (write-line " " printfile)
                (write-line (strcat "\t" "\t" "\t" "----TYPE OF OPERATION REQUESTED----") printfile)
                (write-line " " printfile)
                (write-line (STRCAT selection_a "Engineering Complete--Proceed with Fabrication")                                  printfile)
                (write-line (STRCAT selection_b "Preliminary Drawings--Not for Construction") printfile)
                (write-line (STRCAT selection_c "Incomplete Drawing Package--Proceed with Fabrication" "\n      (Remainder of Drawings to Follow)") 
                 printfile)
                (write-line (STRCAT selection_d "Revised Drawings--Destroy Previous Copies") printfile)
                (write-line (STRCAT selection_e "Incomplete Set Issued for Pre-Ordering") printfile)
                (write-line selection_f printfile)
                (write-line " " printfile)
                (write-line " " printfile)
                (write-line (strcat "Customer: " "cusname" "\t" "\t" "\t" "\t" "\t"
                                    "Order No.: " order_number
                            ) 
                 printfile)
                (write-line " " printfile)
                (write-line " " printfile)
                (write-line (strcat "Drafting: _______ " get_cur_date "\t"
                                    "  Approved: ______________ " get_cur_date) 
                 printfile)
                (write-line (strcat "\t" "\t" "\t" "Date" "\t" "\t" "\t" "\t" "\t" " Date") printfile)
                (write-line " " printfile)
                (write-line " " printfile)
                (write-line " " printfile)
                (write-line "[Form NAO - 37, Rev. 3 08/98]" printfile)
              (close printfile)

  ;(dos_spool dwg_release_file (dos_getprn))
(dcl_Form_Close dwgbrowser_operation_request)
;;;;;;;;;;;;;;;; print revision log;;;;;;;;;;;;;;;;;;

     (setq s_lst nil)
     (setq lst_len (length sho_lst))
     (setq lstcnt2 0)
     (setq lstcnt1 0)
     (repeat lst_len
      (setq rev_lst (nth lstcnt1 sho_lst))
       (if (and (wcmatch (nth 2 rev_lst) "*Rev.*") (wcmatch (nth 1 rev_lst) "*-*"))
        (progn
          ;(dcl_Control_SetEnabled dwgbrowser_Form3_RevLog T)
          ;(dcl_Control_SetEnabled dwgbrowser_Form3_Label4 T)
          (setq make_rev_lst (mapcar 'list (make_list (nth 1 rev_lst))
                                           (make_list (strcat (nth 2 rev_lst) "   "))
                             )
          )
          (setq s_lst (append s_lst make_rev_lst))
        ) ; end progn
       ) ; end if
      (setq lstcnt1 (1+ lstcnt1))
     ) ; end repeat

 (if (= 1 (dcl_Control_GetValue dwgbrowser_Form3_RevLog))
  (progn
     (setq temprevlog (vl-filename-mktemp "c:\\revision.txt"))
     ;(setq temprevlog "c:\\revtest6.txt")
     (setq printlog (open temprevlog "a"))
                (write-line " " printlog)
                (write-line (strcat "\t" "\t" "           DOCUMENT REVISION LOG") printlog)
                (write-line (strcat "\t" "\t" "\t" "Confidential--Property of NAO, Inc.") printlog)
                (write-line (strcat "Date: " get_cur_date) printlog)
                (write-line (strcat "\t" "\t" "\t" "\t" "\t" "Order No.: " order_number) 
                 printlog)
                (write-line (strcat "\t" "\t" "\t" "\t" "\t" "Customer: " "cusname") 
                 printlog)
                (write-line " " printlog)
                (write-line (strcat "Drawing No. " "| Draftsman" "| Prod." "| Shop." "| Store "
                                   "| Q.A.D." "| Shipping" "| Panel" "| Purch."
                            )
                 printlog)
                (write-line (strcat "\t" "    |" "\t" "       " "|" " Supv." "| Supv." "| Room "
                                     " | " "\t" "     |" "\t" "       |" " Shop " "|"
                            )
                 printlog)
                (write-line "------------|----------|------|------|-------|-------|---------|------|--------"                    printlog)
                ;(write-line "            |" printlog)

         (repeat (length s_lst)                                       ;replace s_lst with new_rev_lst
            (setq sx "")
            (setq spacer 
               (strcat "|" "          |" "      |" "      |" "       |" "       |" "         |" "      |"))
            (foreach x (nth lstcnt2 s_lst)                               ;replace s_lst with new_rev_lst
              (setq sx (strcat sx x " " spacer "\n" "  "))
            )
            (write-line (strcat " " sx  
                            "----------|----------|------|------|-------|-------|---------|------|--------")
             printlog)
            (setq lstcnt2 (1+ lstcnt2))
         ) ; end repeat
            (write-line " " printlog)
            (write-line " " printlog)
            (write-line " " printlog)
            (write-line " " printlog)
            (write-line " " printlog)
            (write-line " " printlog)
            (write-line "[Form NAO 4, Rev. 9 07/00]" printlog)
         (close printlog)
(dos_spool temprevlog (dos_getprn))
  ) ; end progn
;(vl-file-delete temprevlog)
 ) ; end if dcl control

) ;end defun dwgbrowser_Form3_TextButton2_OnClicked


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; add standards or other files ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; to the current drawing list ;;;;;;;;;;;;;;;;;;;;;;;;

(defun c:dwgbrowser_Form3_addition_OnClicked (/)
(setq added_text (dcl_Control_GetText dwgbrowser_Form3_TextBox1))

(IF (/= ADDED_TEXT "")
  (PROGN
    (while (< (strlen added_text) 42)
      (setq added_text (strcat added_text " "))
    ); end while

(setq added_dwg (dcl_Control_GetText dwgbrowser_Form3_added_dwg))
(if (= "" added_dwg)
 (progn 
  (setq added_dwg "          ")
 )
 (progn
  ;(setq added_dwg (dcl_Control_GetText dwgbrowser_Form3_added_dwg))
    (while (< (strlen added_dwg) 10)
      (setq added_dwg (strcat added_dwg " "))
    ); end while
  )
)

(setq added_rev (dcl_Control_GetText dwgbrowser_Form3_added_rev))
(if (= "" added_rev)
 (progn
  (setq added_rev "      ")
 )
 (progn
  (setq added_rev (strcat "Rev." (dcl_Control_GetText dwgbrowser_Form3_added_rev)))
    (while (< (strlen added_rev) 6)
      (setq added_rev (strcat added_rev " "))
    ); end while
 )
)
(setq added_file (strcase (strcat added_text added_dwg added_rev)))
(dcl_ListBox_AddList dwgbrowser_Form3_ListBox1 added_file)
(dcl_ListView_AddItem dwgbrowser_Form3_ListView1 added_text added_dwg added_rev)

  (setq add_make_lst (mapcar 'list (make_list added_text) (make_list added_dwg) (make_list added_rev)))
  (setq sho_lst (append sho_lst add_make_lst))

(setq dwg_lst_loc (findfile (strcat 
                          (vl-filename-base (vl-filename-directory (getvar "dwgprefix"))) ".txt"
                         )
                )
)
(if dwg_lst_loc
   (setq dwg_lst (open dwg_lst_loc "a"))
   (setq dwg_lst (open (strcat get_cur_date dwg_lst_loc) "w"))
)
   (write-line added_file dwg_lst)
   (close dwg_lst);

(dcl_Control_SetText dwgbrowser_Form3_TextBox1 "")
(dcl_Control_SetText dwgbrowser_Form3_added_dwg "")
(dcl_Control_SetText dwgbrowser_Form3_added_rev "")
))
) ; end defun




