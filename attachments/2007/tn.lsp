(defun C:tn (/ cmdecho en ent txto etyp txtn)


	;; Ensure OpenDCL Runtime is (quietly) loaded
	(setq cmdecho (getvar "CMDECHO"))
	(setvar "CMDECHO" 0)
	(command "_OPENDCL")
	(setvar "CMDECHO" cmdecho)

(princ)
) ;end defun check_stock 
 
 ; call the method to load the odcl file.
(dcl-Project-Load "F:\\ACAD\\LISP\\TN.odcl")

; call the method to show the Hello World dialog box example
(dcl-Form-Show tn/Form1)
(princ)
 ;end defun

(defun c:tn/Form1/TextButton4#OnClicked (/)
(dcl-Form-Close tn/Form1)
)

(defun c:tn/Form1/TextButton5#OnClicked (/)
  (dcl-Form-Close tn/Form1)
  (princ)
)
(defun c:tn/Form1#OnOK (/)
  (c:tn/Form1/TextButton4#OnClicked)
  (princ)
)

(princ)