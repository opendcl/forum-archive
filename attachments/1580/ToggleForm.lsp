
(defun c:go ()
  (command "OPENDCL")
  (dcl_Project_Load "ToggleForm" T)
  (dcl_Form_Show ToggleForm_Form1)
  (princ)
)
(defun c:ToggleForm_Form1_TextButton1_OnClicked (/)
  (dcl_Form_Close ToggleForm_Form1)
  (dcl_Form_Show ToggleForm_Form2)
)
(defun c:ToggleForm_Form2_TextButton1_OnClicked (/)
  (dcl_Form_Close ToggleForm_Form2)
  (dcl_Form_Show ToggleForm_Form1) ; doesn't work :-(
)

