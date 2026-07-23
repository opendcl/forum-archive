(defun c:test ()
  (command "_opendcl")
  (dcl_project_load "forms")

  (dcl_form_show forms_blocks)

  (princ)
); test


;; Palette

  (defun c:forms_blocks_OnDocActivated (/)
    (if (dcl_Control_GetKeepFocus forms_blocks)
      (dcl_control_setcaption forms_blocks_txt_progress "KeepFocus active")
      (dcl_control_setcaption forms_blocks_txt_progress "KeepFocus not active\r\nMove mouse here")
    ); if
  ); c:forms_blocks_OnDocActivated

  (defun c:forms_blocks_OnEnteringNoDocState (/)
    (dcl_form_close forms_blocks)
  ); c:forms_blocks_OnEnteringNoDocState

  (defun c:forms_blocks_OnInitialize (/)
    (dcl_control_setkeepfocus forms_blocks nil)
    (dcl_control_setcaption forms_blocks_txt_progress "KeepFocus not active\r\nMove mouse here")
  ); c:forms_blocks_OnInitialize

  (defun c:forms_blocks_OnMouseEntered (/)
    (dcl_control_setkeepfocus forms_blocks T)
    (dcl_control_setcaption forms_blocks_txt_progress "KeepFocus active")
  ); c:forms_blocks_OnMouseEntered

  (defun c:forms_blocks_OnMouseMovedOff (/)
    (dcl_control_setkeepfocus forms_blocks nil)
    (dcl_control_setcaption forms_blocks_txt_progress "KeepFocus not active\r\nMove mouse here")
  ); c:forms_blocks_OnMouseMovedOff