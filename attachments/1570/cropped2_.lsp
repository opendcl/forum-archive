(defun c:go ()
  (command "OPENDCL")
  (dcl_Project_Load "cropped2!" T)
  (dcl_Form_Show cropped2!_Form1) 	; ControlBar	cropped!
  (dcl_Form_Show cropped2!_Form2) 	; Palette	ok
;;;  (dcl_Form_Show cropped2!_Form1 0 0) 	; ControlBar	ok
;;;  (dcl_Form_Show cropped2!_Form2 0 0) 	; Palette	ok
  (princ)
)