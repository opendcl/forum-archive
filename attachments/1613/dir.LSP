(defun c:dlgdir (/ c:dir_dlg_dir_OnInitialize c:dir_dlg_dir_cbb_dir_OnSelChanged
		   c:dir_dlg_dir_cbb_dir_OnMouseMove c:dir_dlg_dir_cbb_dir_OnKillFocus
		   c:dir_dlg_dir_pb_cancel c:dir_dlg_dir_pb_accept strPath isFocus)
  (dcl_project_load "dir" T)
  (setq strPath (getenv "TEMP"))

  (defun c:dir_dlg_dir_OnInitialize (/ intNum)
    (if (minusp (setq intNum (dcl_ComboBox_FindStringExact dir_dlg_dir_cbb_dir strPath)))
      (progn
	(dcl_ComboBox_AddPath dir_dlg_dir_cbb_dir strPath)
	(setq intNum (dcl_ComboBox_FindStringExact dir_dlg_dir_cbb_dir strPath))
      ); progn
    ); if
    (if (> intNum -1)
      (dcl_ComboBox_SetCurSel dir_dlg_dir_cbb_dir intNum))
  ); c:dir_dlg_dir_OnInitialize

  (defun c:dir_dlg_dir_cbb_dir_OnSelChanged (intItemIndexOrCount strValue)
    (dcl_ComboBox_Dir dir_dlg_dir_cbb_dir (setq strPath strValue))
    (princ (strcat "\nOnSelChanged: " strPath "\r\n"))
  ); c:dir_dlg_dir_cbb_dir_OnSelChanged

  (defun c:dir_dlg_dir_cbb_dir_OnMouseMove (intFlags intX intY /)
    (cond
      ((not isFocus)
	(setq isFocus T)
	(setq strPath (dcl_combobox_getdir dir_dlg_dir_cbb_dir))
	;; Don't use alert here otherwise it will call OnKillFocus
	;; and ends up finally in an endless loop
	(princ (strcat "\nOnMouseMove (ohne Fokus): " strPath "\r\n")))

      ((/= (strcase strPath) (strcase (dcl_combobox_getdir dir_dlg_dir_cbb_dir)))
       (setq strPath (dcl_combobox_getdir dir_dlg_dir_cbb_dir))
       (princ (strcat "\nOnMouseMove (mit Fokus): " strPath "\r\n")))
      
    ); cond
  ); c:dir_dlg_dir_cbb_dir_OnMouseMove

  (defun c:dir_dlg_dir_cbb_dir_OnKillFocus (/)
    (setq strPath (dcl_combobox_getdir dir_dlg_dir_cbb_dir))
    (princ (strcat "\nOnKillFocus: " strPath "\r\n"))
    (setq isFocus nil)
  ); c:dir_dlg_dir_cbb_dir_OnKillFocus

  (defun c:dir_dlg_dir_pb_cancel (/) (dcl_form_close dir_dlg_dir 2))
  
  (defun c:dir_dlg_dir_pb_accept (/)
    (setq strPath (dcl_combobox_getdir dir_dlg_dir_cbb_dir))
    (dcl_form_close dir_dlg_dir 1)
  ); c:dir_dlg_dir_pb_accept

  (if (= (dcl_form_show dir_dlg_dir) 1)
    (alert strPath)
  ); if
  (princ)
); c:dlgdir