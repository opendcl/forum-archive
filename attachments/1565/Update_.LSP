(defun c:go ()
  (command "OPENDCL")
  (dcl_Project_Load "Update!" T)
  (dcl_Form_Show Update!_Form1) ; ControlBar
;;;  (dcl_Form_Show Update!_Form2) ; Palette
;;;  (dcl_Form_Show Update!_Form3) ; Modeless
  (princ)
)
(defun c:Update!_Form1_TextButton1_OnClicked (/ sel cnt)
  (setq sel (cadr (ssgetfirst))
	cnt (sslength sel))
  
  (repeat cnt
    (setq cnt (1- cnt))
    (setq obj (vlax-ename->vla-object (ssname sel cnt)))
    (vla-delete obj)
    (dcl_SetCmdBarFocus) ; Updates only if "undocked" Dialog
  )
)
