
;;; This sample demonstrates the modeless form.
;;;
;;;
;; Main program    
(defun c:Rect (/ cmdecho )
	;; Ensure OpenDCL Runtime is (quietly) loaded
	(setq cmdecho (getvar "CMDECHO"))
        (setvar "OSMODE" 0)
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
(defun c:Rectangle_Form1_TextBox1_OnKillFocus  ( / )
(setq side1 (dcl_Control_GetText Rectangle_Form1_TextBox1))
    (drawrectangle)(princ ));defun

       
(defun c:Rectangle_Form1_TextBox2_OnKillFocus ( /)
    (drawrectangle)(princ ));defun

(defun c:Rectangle_Form1_CloseButton_OnClicked (/)
    (setq esg nil)
    (dcl_Form_Close Rectangle_Form1)
    (princ));defun CloseButton

;*******************************************************************************************
(defun ent_sec_gruppo ( / ) 
(cond ((= esg nil)(command "_.SELECT" (entlast) "")
                  (setq esg (ssget "P")))
      ((/= esg nil)  (command "_.SELECT" (entlast) esg "" )  
                     (setq esg (ssget "P")))));defun
;****************************************************************************

;;DrawRectangle 
(defun DrawRectangle ( / side1 side2 p1 p2 p3 p4 )
 (command "_erase" esg "" )
(setq side1 (atof (dcl_Control_GetText Rectangle_Form1_TextBox1)))
(setq side2 (atof (dcl_Control_GetText Rectangle_Form1_TextBox2)))
(setq p1 ptStart
      p2 (polar p1 ang side1)
      p3 (polar p2 (+ ang (/ pi 2)) side2)
      p4 (polar p3 (+ ang pi) side1))
(command "_line" p1 p2 "")
    (ent_sec_gruppo)
(command "_line" p2 p3 "")
(ent_sec_gruppo)
 (command "_line" p3 p4 "")
(ent_sec_gruppo)
  (command "_line" p4 p1 "")
    (ent_sec_gruppo) 
);defun DrawRectangle
(princ "\nType Rect")
(princ)
    