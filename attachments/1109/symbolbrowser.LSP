(defun c:symbolbrowser ()
  (command "OPENDCL")
  (if (not dwglist_dwglist)
    (dcl_project_load "dwglist")
  ); if
  (if (and dwglist_dwglist
	   (not (dcl_Form_IsActive dwglist_dwglist)))
    (dcl_form_show dwglist_dwglist)
  ); if
  (princ)
); c:symbolbrowser

(defun c:dwglist_dwglist_OnInitialize (/ strFolder)
  (setq strFolder (getvar "DWGPREFIX"))
  (dcl_ComboBox_AddPath dwglist_dwglist_cbb_dir strFolder)
  (dcl_ComboBox_SelectString dwglist_dwglist_cbb_dir strFolder)
  (dcl_DWGList_Dir dwglist_dwglist_lst_dwg strFolder)
  (dcl_Control_SetText dwglist_dwglist_edt_info "Select a folder or a file!")
); c:dwglist_dwglist_OnInitialize

(defun c:dwglist_dwglist_OnEnteringNoDocState (/)
  (if (dcl_Form_IsActive dwglist_dwglist) (dcl_form_close dwglist_dwglist))
); c:dwglist_dwglist_OnEnteringNoDocState

(defun c:dwglist_dwglist_cbb_dir_OnSelChanged (intItemIndexOrCount strFolder /)
  (dcl_DWGList_Dir dwglist_dwglist_lst_dwg strFolder)
  (dcl_Control_SetText dwglist_dwglist_edt_info "Select a folder or a file!")
); c:dwglist_dwglist_cbb_dir_OnSelChanged

(defun c:dwglist_dwglist_pb_up_OnClicked (/ strFolder lstChars)
  (setq strFolder (dcl_DWGList_GetDir dwglist_dwglist_lst_dwg))
  (if (setq lstChars (reverse (cdr (member 92 (reverse (vl-string->list strFolder))))))
    (progn
      (setq strFolder (apply 'strcat (mapcar 'chr lstChars)))
      (dcl_DWGList_Dir dwglist_dwglist_lst_dwg strFolder)
      (dcl_ComboBox_AddPath dwglist_dwglist_cbb_dir strFolder)
      (dcl_ComboBox_SelectString dwglist_dwglist_cbb_dir strFolder)
      (dcl_Control_SetText dwglist_dwglist_edt_info "Select a folder or a file!")
    ); progn
  ); if
); c:dwglist_dwglist_pb_up_OnClicked

(defun c:dwglist_dwglist_lst_dwg_OnSelChanged (intCount strValue / strFile lstDate)
  (setq strFile (dcl_DWGList_GetFileName dwglist_dwglist_lst_dwg))
  (if (vl-file-directory-p strFile)
    (dcl_Control_SetText dwglist_dwglist_edt_info "This is a folder. Please doubleclick to get in!")
    (progn
      (setq lstDate (mapcar 'itoa (vl-file-systime strFile)))
      (dcl_Control_SetText dwglist_dwglist_edt_info
	(strcat (vl-filename-base strFile) (vl-filename-extension strFile)
		"\r\nSize: " (rtos (vl-file-size strFile) 2 0)
		"\r\nDate: " (car lstDate) "/" (cadr lstDate) "/" (caddr lstDate) " " (nth 3 lstDate) ":" (nth 4 lstDate) ":" (nth 5 lstDate)))
    ); progn
  ); if
); c:dwglist_dwglist_lst_dwg_OnSelChanged

(defun c:dwglist_dwglist_lst_dwg_OnFolderChanged (strFolderPath /)
  (dcl_ComboBox_AddPath dwglist_dwglist_cbb_dir strFolderPath)
  (dcl_ComboBox_SelectString dwglist_dwglist_cbb_dir strFolderPath)
  (dcl_Control_SetText dwglist_dwglist_edt_info "Select a folder or a file!")
); c:dwglist_dwglist_lst_dwg_OnFolderChanged

(defun c:dwglist_dwglist_lst_dwg_OnDblClicked (/ strFile)
  (if (setq strFile (dcl_DWGList_GetFileName dwglist_dwglist_lst_dwg))
    (progn
      (vl-bb-set '***strDoc*** strFile)
      (dcl_sendstring "symbolbrowser_open ")
    ); progn
  ); if
); c:dwglist_dwglist_lst_dwg_OnDblClicked

(defun c:symbolbrowser_open (/ strFile errDoc)
  (if (setq strFile (vl-bb-ref '***strDoc***))
    (if (vl-catch-all-error-p (setq errDoc (vl-catch-all-apply 'vla-open (list (vla-get-documents (vlax-get-acad-object)) strFile))))
      (dcl_MessageBox (strcat "I couldn't open the drawing, " (getvar "LOGINNAME") "!") "Error" 2 1)
      (vla-Activate errDoc)
    ); if
  ); if
  (vl-bb-set '***strDoc*** nil)
  (princ)
); c:symbolbrowser_open

(vl-load-com)