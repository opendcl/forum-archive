(defun WAITING (lstInfo / c:general_sc_waiting_OnInitialize isDone lstPos)

  (cond
    
    ;; Reaktor
    
    ((vlr-current-reaction-name) nil)

    ;; Anzeigen
    
    (lstInfo

     (dcl_project_load "general" nil)
     (defun c:general_sc_waiting_OnInitialize ( /)
       (dcl_control_setcaption general_sc_waiting_txt_head (cdr (assoc "Head" lstInfo)))
       (dcl_control_setcaption general_sc_waiting_txt_todo (cdr (assoc "ToDo" lstInfo)))
       (if (not lstPos) (dcl_form_center general_sc_waiting))
     ); c:waiting_OnInitialize


     ;; Nicht lokal setzen

     (defun c:general_sc_waiting_pic_OnPaint (isHasFocus /)
       (princ "\nDrawText\r")
       (dcl_PictureBox_DrawText general_sc_waiting_pic (list (list 4 4 -10 -24 (cdr (assoc "Title" lstInfo)) 0 nil)))
     ); c:general_sc_waiting_pic_OnPaint
     
     (defun c:general_sc_waiting_OnCancelClose (bCancelling /) T)

     (cond
       ((not general_sc_waiting) nil)
       ((dcl_Form_IsActive general_sc_waiting) (c:general_sc_waiting_OnInitialize))
       ((setq lstPos (cdr (assoc "Position" lstInfo)))
	(dcl_Form_show general_sc_waiting (car lstPos) (cadr lstPos)))
       (T (dcl_Form_show general_sc_waiting))
     ))

    ;; Ausblenden
    
    ((and dcl_project_load general_sc_waiting (dcl_Form_IsActive general_sc_waiting)) (dcl_Form_Close general_sc_waiting))
    
  ); cond
  nil
); WAITING


(defun c:test ()
  (WAITING (list (cons "Title" "Please wait!") (cons "Head" "OpenOffice will be loaded!") (cons "ToDo" "Please wait until OpenOffice will be loaded!")))
  (getstring "\nPress Enter to continue: ")
  (waiting nil)
  (princ)
); test