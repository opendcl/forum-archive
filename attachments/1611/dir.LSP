(defun c:dlgdir (/ c:dir_dlg_dir_OnInitialize c:dir_dlg_dir_cbb_dir_OnSelChanged
		   c:dir_dlg_dir_pb_cancel c:dir_dlg_dir_pb_accept strPath)
  (dcl_project_load "dir")
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
    (alert strPath)
  ); c:dir_dlg_dir_cbb_dir_OnSelChanged

  (defun c:dir_dlg_dir_pb_cancel (/) (dcl_form_close dir_dlg_dir 2))
  (defun c:dir_dlg_dir_pb_accept (/) (dcl_form_close dir_dlg_dir 1))

  (dcl_form_show dir_dlg_dir)
); c:dlgdir