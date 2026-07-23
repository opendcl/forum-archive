



(defun c:txtTest_Form1_TextBox1_OnReturnPressed (/)
  (DoOKCode)
)


(defun c:txtTest_Form1_TextButton1_OnClicked (/)
  (DoOKCode)
  (dcl_Form_Close txtTest_Form1)
)


(defun DoOKCode (/)
    (dcl_MessageBox (strcat "You typed: " (dcl_Control_GetText txtTest_Form1_TextBox1)))
    (princ)
)

;;PREVENT THE FORM FROM CLOSING WHEN HITTING ENTER, BUT CLOSES WHEN YOU HIT OK
(defun c:txtTest_Form1_OnCancelClose (Reason /)
  T
)


(defun C:txtTest (/)
  (dcl_Project_Load "txtTest.odcl" T)
  (dcl_Form_Show txtTest_Form1)
  (princ)
)