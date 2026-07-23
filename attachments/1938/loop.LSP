(defun c:test ()
  (dcl_project_load "f:\\loop.odcl" T)
  (if (not (dcl_Form_IsActive loop_loop)) (dcl_form_show loop_loop))
  (dcl_Control_SetCaption loop_loop_txtStart "Looping stopped")
  (princ)
); test

(defun c:loop_loop_pbStart_OnClicked (/)
  (c:increase_all)
)

(defun c:loop_loop_pbStop_OnClicked (/)
  (setq ***value*** nil)
  (dcl_Control_SetCaption loop_loop_txtStart "Looping stopped")
)

(defun c:increase_all()
  (setq ***value*** 0)
  (dcl_DelayedInvoke 1000 "(c:increase)")
); c:increase_all

(defun c:increase() 
  (if (and ***value*** (< ***value*** 20))
    (progn
      (dcl_Control_SetCaption loop_loop_txtStart (strcat "State " (itoa (setq ***value*** (1+ ***value***)))))
      (dcl_control_forceupdatenow loop_loop_txtStart)
      (dcl_DelayedInvoke 1000 "(c:increase)")
    ); progn
    (c:loop_loop_pbStop_OnClicked)
  ); if
); c:increase
