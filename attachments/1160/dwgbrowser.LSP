(defun c:dwgbrowser ()
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
  (dcl_Control_SetCaption dwgbrowser_browser_txt_wait "Please wait, until I collected all information of files and subfolders of the current folder...")
  (dcl_Control_SetVisible dwgbrowser_browser_txt_wait T)
  (dcl_Control_Redraw dwgbrowser_browser_txt_wait)
  
  (if (and (setq strPath (dwgbrowser_check_path strPath))
           (or (< (strlen strPath) 4) (findfile (vl-string-right-trim "\\" strPath)))
           (setq lstFiles (append (setq lstDir (mapcar 'dwgbrowser_dir_info (dwgbrowser_items_sort (vl-remove "." (vl-remove ".." (vl-directory-files strPath "*" -1))))))
                                  (setq lstDwg (mapcar 'dwgbrowser_file_info (dwgbrowser_items_sort (vl-directory-files strPath "*.dwg" 1)))))))
    (progn
      (dcl_listview_filllist dwgbrowser_browser_lst lstFiles)
      (dcl_Control_SetVisible dwgbrowser_browser_txt_wait nil)
      (cond
        ((not lstDwg) (dwgbrowser_invisible_all))
        ((> (length lstDwg) 8) (dwgbrowser_visible_all))
        (lstDwg (repeat (setq intCnt 9)
                  (if (nth (setq intCnt (1- intCnt)) lstDwg)
                    (dwgbrowser_visible (eval (read (strcat "dwgbrowser_browser_dwg" (itoa (1+ intCnt))))))
                    (dwgbrowser_invisible (eval (read (strcat "dwgbrowser_browser_dwg" (itoa (1+ intCnt))))))
                  ); if
                ))
      ); cond

      (if lstDwg
        (dwgbrowser_fillpreview (length lstDir))
      ); if
    ); progn
    (progn
      (dwgbrowser_invisible_all)
      (dcl_Control_SetCaption dwgbrowser_browser_txt_wait "There are no items in the selected folder. Please change into another folder.")
      (dcl_Control_SetVisible dwgbrowser_browser_txt_wait T)
    ); progn
  ); if
); dwgbrowser_filllist

(defun dwgbrowser_invisible_all ()
  (mapcar 'dwgbrowser_invisible (list dwgbrowser_browser_dwg1 dwgbrowser_browser_dwg2 dwgbrowser_browser_dwg3
                                      dwgbrowser_browser_dwg4 dwgbrowser_browser_dwg5 dwgbrowser_browser_dwg6
                                      dwgbrowser_browser_dwg7 dwgbrowser_browser_dwg8 dwgbrowser_browser_dwg9))
); dwgbrowser_invisible_all

(defun dwgbrowser_visible_all ()
  (mapcar 'dwgbrowser_visible (list dwgbrowser_browser_dwg1 dwgbrowser_browser_dwg2 dwgbrowser_browser_dwg3
                                    dwgbrowser_browser_dwg4 dwgbrowser_browser_dwg5 dwgbrowser_browser_dwg6
                                    dwgbrowser_browser_dwg7 dwgbrowser_browser_dwg8 dwgbrowser_browser_dwg9))
); dwgbrowser_visible_all

(defun dwgbrowser_invisible (oControl)
  (dcl_DwgPreview_Clear oControl)
  (dcl_Control_SetVisible oControl nil)
); dwgbrowser_invisible

(defun dwgbrowser_visible (oControl)
  (dcl_Control_SetVisible oControl T)
); dwgbrowser_visible

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

(defun dwgbrowser_file_date (strFile / lstDate)
  (setq lstDate (mapcar 'dwgbrowser_check_digit (mapcar 'itoa (vl-file-systime strFile))))
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
      (dwgbrowser_invisible (eval (read (strcat "dwgbrowser_browser_dwg" (itoa (1+ intRow))))))
      (progn
        (setq oControl (eval (read (strcat "dwgbrowser_browser_dwg" (itoa (1+ intRow))))))
        (dwgbrowser_visible oControl)
        (if (setq strCompleteFile (findfile (strcat strPath (dcl_ListView_GetItemText dwgbrowser_browser_lst intRow 0) ".dwg")))
          (dcl_DWGPreview_LoadDwg oControl strCompleteFile)
        ); if
      ); progn
    ); if
  ); foreach
); dwgbrowser_fillpreview

(defun c:dwgbrowser_browser_OnInitialize (/)
  (dcl_Control_SetVisible dwgbrowser_browser_txt_wait nil)
  (dcl_ListView_AddColumns dwgbrowser_browser_lst (list (list "Name" 0 100) (list "Size" 0 100) (list "Date" 0 100)))
  (dwgbrowser_filllist (dcl_ComboBox_GetDir dwgbrowser_browser_dir))
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


(defun c:dwgbrowser_browser_lst_OnDblClicked (intRow intColumn / strPath strCompleteFile)
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
); c:dwgbrowser_browser_lst_OnDblClicked


(defun c:dwgbrowser_browser_sb_OnScrolled (intValue /)
  (dcl_MessageBox "Hier sollte etwas Sinnvolles passieren: An dieser Stelle können Sie nun den Quellcode zur Ereignisfunktion hinzufügen\r\nc:dwgbrowser_browser_sb_OnScrolled" "Ereignisfunktion")
); c:dwgbrowser_browser_sb_OnScrolled


(defun c:dwgbrowser_browser_dwg1_OnDblClicked (/)
  (dcl_MessageBox "Hier sollte etwas Sinnvolles passieren: An dieser Stelle können Sie nun den Quellcode zur Ereignisfunktion hinzufügen\r\nc:dwgbrowser_browser_dwg1_OnDblClicked" "Ereignisfunktion")
); c:dwgbrowser_browser_dwg1_OnDblClicked

