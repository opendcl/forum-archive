
; the following command will ensure the 
; appropriate OpenDCL ARX file is loaded.

(command "_OPENDCL")

(defun c:Hello ()
   ; call the method to load the HelloWorld.odcl file.
   (dcl_Project_Load "HelloWorld" T)
   ; call the method to show the Hello World dialog box example.
   (dcl_Form_Show HelloWorld_Form1)
   (princ)
)


