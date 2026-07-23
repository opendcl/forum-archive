(defun c:test ()
  (command "opendcl")
  (dcl_project_load "d:\\prj.odcl")
  (dcl_form_show prj_dlg)
  (dcl_Control_SetCaption prj_dlg_Bezeichnung2 "")
  (dcl_Control_SetText prj_dlg_edt "Test")
  (princ)
); test

(defun c:prj_dlg_edt_OnEditChanged (strNewValue /)
  (if (dcl_TextBox_IsModified prj_dlg_edt)
    (dcl_Control_SetCaption prj_dlg_Bezeichnung2 "X")
    (dcl_Control_SetCaption prj_dlg_Bezeichnung2 "")
  ); if
)


(defun c:prj_dlg_edt_OnUpdate (strNewValue /)
  (if (dcl_TextBox_IsModified prj_dlg_edt)
    (dcl_Control_SetCaption prj_dlg_Bezeichnung2 "X")
    (dcl_Control_SetCaption prj_dlg_Bezeichnung2 "")
  ); if
)
