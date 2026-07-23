(defun c:ColTest ( / )
  (command "OPENDCL")
  (dcl_Project_Load "ColorComboTest" T)
  (dcl_Form_Show ColorComboTest_ColComboModeless)
  (princ)
)

(defun c:ColorComboTest_ColComboModeless_OnInitialize (/)
  (dcl_ComboBox_SetCurSel ColorComboTest_ColComboModeless_ComboBox1 2)
  (c:ColorComboTest_ColComboModeless_ComboBox1_OnSelChanged 2 "Red")
)

(defun c:ColorComboTest_ColComboModeless_ComboBox1_OnSelChanged (ItemIndexOrCount Value / col)
  (print ItemIndexOrCount)
  (print Value)
  (dcl_Control_SetText ColorComboTest_ColComboModeless_TextBox1 Value)
  (setq col (dcl_ComboBox_GetItemData ColorComboTest_ColComboModeless_ComboBox1 ItemIndexOrCount))
  (dcl_Control_SetForeColor ColorComboTest_ColComboModeless_TextBox1 col)
  (dcl_Control_SetBackColor ColorComboTest_ColComboModeless_TextBox1 (if (= col 0) -16 0)) ; avoid black text on black
)

(princ "\nType COLTEST to run the command ")
(princ)

