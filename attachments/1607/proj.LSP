(defun test (strText / nSize settext c:proj_form_OnInitialize c:proj_form_editbox_OnEditChanged)
  (dcl_project_load "d:\\proj.odcl")
  (if (null strText) (setq strText "Test"))

  (defun settext ()
    (dcl_Control_SetCaption proj_form_label strText)
    (dcl_control_setwidth proj_form_label (+ 4 (* (strlen strText) nSize)))
  ); settext

  (defun c:proj_form_OnInitialize (/)
    (setq nSize (atoi (rtos (* 0.8 (abs (dcl_Control_GetFontSize proj_form_label))) 2 0)))
    (dcl_Control_SetText proj_form_editbox strText)
    (settext)
  ); c:proj_form_OnInitialize

  (defun c:proj_form_editbox_OnEditChanged (strNewValue /)
    (setq strText strNewValue)
    (settext)
  ); c:proj_form_editbox_OnEditChanged

  (dcl_Form_Show proj_form)
  
); test