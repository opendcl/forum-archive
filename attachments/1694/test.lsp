
(DeFun C:test ()

 (SetVar "BlipMode" 0)
 (command "-osnap" "off")

 (command "_OPENDCL")

 (dcl_Project_Load "D:/design/lisp_cim/test.odcl" T)

 (Run_form1)
)

(defun Run_Form1 ()
   (dcl_Form_Show test_Form1)
)

;(defun c:test_Form1_OnInitialize (/))

(defun c:test_Form1_Next_OnClicked (/)
   (dcl_Form_Close test_Form1 )
   (Run_form2)
)

(defun Run_Form2 ()
   (dcl_Form_Show test_Form2)
)

;(defun c:test_Form2_OnInitialize (/))

(defun c:test_Form2_Back_OnClicked (/)
   (dcl_Form_Close test_Form2)
   (Run_form1)
)





