
(DeFun C:test ()

 (SetVar "BlipMode" 0)
; (command "_osnap" "off")

 (command "_OPENDCL")

 (dcl_Project_Load "F:/cad2000/lisp_cim/test.odcl" T)
 
 (setq nOpen T)
 
 (run_form1)

 (while NOpen
    (cond (NOpenForm1 (run_form1))
          (NOpenForm2 (run_form2))
    )
 )
)

(defun Run_Form1 ()
   (dcl_Form_Show test_Form1)
)
(defun Run_Form2 ()
   (dcl_Form_Show test_Form2)
)

(defun c:test_Form1_Next_OnClicked (/) 
   (setq NOpenForm2 T)
   (setq NOpenForm1 nil)
   (dcl_Form_Close test_Form1)
)

(defun c:test_Form2_Back_OnClicked (/)
   (setq NOpenForm1 T)
   (setq NOpenForm2 nil)
   (dcl_Form_Close test_Form2)
)

(defun c:test_Form2_TextButton1_OnClicked (/)
   (setq NOpen nil)
   (dcl_Form_Close test_Form2)
)
(defun c:test_Form1_OnCancel (/)
     (setq NOpen nil)
     (dcl_Form_Close test_Form1)
)

(defun c:test_Form2_OnCancel (/)
     (setq NOpen nil)
     (dcl_Form_Close test_Form2)
     (princ)
)



