(defun c:tst1Modal (/)
 (cond
  ((not (dcl-Project-Load "Example_OnClose.odcl" t))
   (dcl_MessageBox (strcat "Project not found: \n \n [" "Example_OnClose.odcl" "]") "error dialogue DCL" 2 4)
  )
  (T (dcl_Form_Show (vl-doc-ref 'Example_OnClose/Form1)))
 )
)
(defun c:tst2Modeless (/)
 (cond
  ((not (dcl-Project-Load "Example_OnClose.odcl" t))
   (dcl_MessageBox (strcat "Project not found: \n \n [" "Example_OnClose.odcl" "]") "error dialogue DCL" 2 4)
  )
  ((not (dcl_Form_IsActive (vl-doc-ref 'Example_OnClose/Form2)))
   (dcl_Form_Show (vl-doc-ref 'Example_OnClose/Form2))
  )
 )
)

;;Modeless
(defun c:Example_OnClose/Form2#OnClose (UpperLeftX UpperLeftY / val1 val2)
 (setq val1 (dcl-Control-GetValue test_CheckBox1)   ;;Error
       val2 (dcl-Control-GetValue test_CheckBox2))  ;;Error
 (dcl_MessageBox (strcat "the value of test_CheckBox1 is: " (cond ((= val1 0) "Unchecked")
								  ((= val1 1) "Checked")
								  ((= val1 2) "Indeterminate"))
			 "\n\n"
			 "the value of test_CheckBox2 is: " (cond ((= val2 0) "Unchecked")
								  ((= val2 1) "Checked")
								  ((= val2 2) "Indeterminate"))
	         )  "Info.." )
 (princ)
)
;;Modal
(defun c:Example_OnClose/Form1#OnClose (UpperLeftX UpperLeftY / val1 val2)
 (setq val1 (dcl-Control-GetValue test_CheckBox1)
       val2 (dcl-Control-GetValue test_CheckBox2))
 (dcl_MessageBox (strcat "the value of test_CheckBox1 is: " (cond ((= val1 0) "Unchecked")
								  ((= val1 1) "Checked")
								  ((= val1 2) "Indeterminate"))
			 "\n\n"
			 "the value of test_CheckBox2 is: " (cond ((= val2 0) "Unchecked")
								  ((= val2 1) "Checked")
								  ((= val2 2) "Indeterminate"))
	         )  "Info.." )
 (princ)
)
(princ)







(princ)