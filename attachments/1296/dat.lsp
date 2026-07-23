(command "OPENDCL")

(defun c:dat()
     (dcl_Project_Load "dat" T)
     (dcl_Form_Show dat_Form2)
     (princ)
);defun



(defun c:dat_Form2_TextButton1_OnClicked (/)
  (dcl_Form_Close dat_Form2)
);defun

(defun c:dat_Form2_TextButton2_OnClicked (/)
  (dcl_Form_Close dat_Form2)
);defun

(defun c:dat_Form2_TextButton3_OnClicked (/)
  (dcl_Control_SetText dat_Form2_TextBox1 (dcl_Form_Show dat_Form3))
);defun

