(defun c:ComboTest ( )
  (command "OPENDCL")
  (dcl_Project_Load "ComboTest" T)
  (dcl_Form_Show ComboTest_Form1)
  (princ)
)

(defun c:ComboTest_Form1_OnInitialize ( )
  (dcl_ImageComboBox_SetCurSel ComboTest_Form1_ImageCombo1 1)
  (c:ComboTest_Form1_ImageCombo1_OnSelChanged 1 "Yellow")
  (princ)
)

(defun c:ComboTest_Form1_ImageCombo1_OnSelChanged (ItemIndexOrCount Value / col)
  (print ItemIndexOrCount)
  (print Value)
  (dcl_Control_SetText ComboTest_Form1_TextBox1 Value)
  (setq col
    (cond
      ((= (substr Value 1 4) "RGB:")
        (kg_ColorRgbToOle (read (strcat "(" (vl-string-translate "," " "  (substr Value 5)) ")")))
      )
      ((eval (read (strcat "ac" Value))))
      ((atoi Value))
    )
  )
  (dcl_Control_SetForeColor ComboTest_Form1_TextBox1 col)
)

; (dcl_ImageComboBox_GetCurSel ComboTest_Form1_ImageCombo1)
; (dcl_ImageComboBox_GetLBText ComboTest_Form1_ImageCombo1 (dcl_ImageComboBox_GetCurSel ComboTest_Form1_ImageCombo1))

(defun kg_ColorRgbToOle (rgbLst)
  (+
    (lsh (car rgbLst) 16)
    (lsh (cadr rgbLst) 8)
    (caddr rgbLst)
  )
)

(princ "\nType ComboTest to run the command ")
(princ)






