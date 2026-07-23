(defun c:TextBoxTest ( / c:TextBoxTest_Form1_OnInitialize stringList)

  (defun c:TextBoxTest_Form1_OnInitialize ()
    (foreach
      control
      (list ; Controls before first TextBox.
        TextBoxTest_Form1_TextButton0
        TextBoxTest_Form1_TextButton1
      )
      (dcl_Control_ZOrder control 0)
    )
    (mapcar
      '(lambda (index string / control)
        (setq control (eval (read (strcat "TextBoxTest_Form1_TextBox" (itoa index)))))
        (dcl_Control_SetText control string)
        (dcl_Control_ZOrder control 0)
      )
      '(0 1 2 3 4 5)
      stringList
    )
  )

  (setvar 'cmdecho 0)
  (command "OPENDCL")
  (setvar 'cmdecho 1)

  (setq stringList '("A" "B" "C"))
  (dcl_Project_Load "TextBoxTest" T)
  (dcl_Form_Show TextBoxTest_Form1)
)
