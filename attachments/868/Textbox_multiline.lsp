(defun c:test ()
  (dcl_project_load "D:/Textbox_multiline" T)
  (dcl_Form_Show Textbox_multiline_Form1)
)

(defun c:Textbox_multiline_Form1_TextBox1_OnEditChanged (NewValue /)
  (prompt "\n c:Test_Form1_TextBox1_OnEditChanged")
)




