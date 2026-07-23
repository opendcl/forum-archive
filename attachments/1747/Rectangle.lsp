;;;
;;; OpenDCL Sample: Modeless
;;;
;;; This sample demonstrates the modeless form.
;;;
;;;
;; Main program    (load"rectangle")
(defun c:Rectangle (/ cmdecho )
	;; Ensure OpenDCL Runtime is (quietly) loaded
	(setq cmdecho (getvar "CMDECHO"))
	(setvar "CMDECHO" 0)
	(command "_OPENDCL")
	(setvar "CMDECHO" cmdecho)
(setq ptStart (vl-catch-all-apply 'getpoint (list "\nStart point: ")))
(setq ang     (vl-catch-all-apply 'getangle (list ptStart "\nDirection angle: ")))   
	;; Load the project
	(dcl_Project_Load (FindFile "Rectangle.odcl")T)
	;; Show the main form
       ;(dcl_Form_Show Modeless_DemoModeless)
        (dcl_Form_Show Rectangle_Form1)
	;; This is a modeless form, so (dcl_Form_Show) returns immediately,
	;; leaving the event handlers to manage the form.
       (dcl_Control_setText Rectangle_Form1_TextBox1 "800");Set side1 to 800
       (dcl_Control_setText Rectangle_Form1_TextBox2 "400");set side2 to "400"
       (dcl_Control_SetList Rectangle_Form1_ComboBox1 (list "name" "name1" "name2"))
       (dcl_Control_SetText Rectangle_Form1_ComboBox1 "name")
    
     (DrawRectangle)
	(princ)
)

;|<<OpenDCL Event Handlers>>|;

(defun c:Rectangle_Form1_TextBox1_OnReturnPressed (/)

(drawrectangle)   
)



(defun c:Rectangle_Form1_CloseButton_OnClicked (/)
    (dcl_Form_Close Rectangle_Form1)
    (princ)
)




;;DrawRecatngle 
(defun DrawRectangle ( / side1 side2 p1 p2 p3 p4 )
(setq side1 (atof (dcl_Control_GetText Rectangle_Form1_TextBox1)))
(setq side2 (atof (dcl_Control_GetText Rectangle_Form1_TextBox2)))
(setq p1 ptStart
      p2 (polar p1 ang side1)
      p3 (polar p2 (+ ang (/ pi 2)) side2)
      p4 (polar p3 (+ ang pi) side1))
(command "_line" p1 p2 p3 p4 p1 "")
);defun DrawRectangle


(princ "\nType Rectangle")
(princ)
    