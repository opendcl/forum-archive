
(defun c:go (/ tmp)
  (command "OPENDCL")
  (dcl_Project_Load "ToggleForm" T)
  
  (setq tmp 1)
  (while (> tmp 0)
    (setq tmp (dcl_Form_Show "ToggleForm" (if (= tmp 1) "Form1" "Form2")))
  )
  (princ)
)
(defun c:ToggleForm_Form1_TextButton1_OnClicked (/)
  (dcl_Form_Close ToggleForm_Form1 2)
)
(defun c:ToggleForm_Form2_TextButton1_OnClicked (/)
  (dcl_Form_Close ToggleForm_Form2 1)
)
(defun c:ToggleForm_Form1_OnCancelClose (Reason /)
  (dcl_Form_Close ToggleForm_Form1 0)
)
(defun c:ToggleForm_Form2_OnCancelClose (Reason /)
  (dcl_Form_Close ToggleForm_Form2 0)
)



