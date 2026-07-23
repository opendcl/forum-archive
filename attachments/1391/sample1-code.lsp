(defun c:sample1 ()

  (command "_OPENDCL")

  (defun c:sample1_Form1_OnInitialize (/)
    (dcl_Control_SetValue sample1_Form1_CheckBox1 0)
    (dcl_Control_SetValue sample1_Form1_CheckBox2 0)
    (dcl_Control_SetValue sample1_Form1_CheckBox3 0)
    (dcl_Control_SetValue sample1_Form1_CheckBox4 0)
    (dcl_Control_SetEnabled sample1_Form1_TextButton2 nil)
    (dcl_Control_SetEnabled sample1_Form1_TextBox1 nil)
  )

  (defun c:sample1_Form1_CheckBox1_OnClicked (Value /)
    (dcl_Control_SetEnabled sample1_Form1_TextButton2 T)
    (princ)
  )

  (defun c:sample1_Form1_CheckBox2_OnClicked (Value /)
    (dcl_Control_SetEnabled sample1_Form1_TextButton2 T)
    (princ)
  )

  (defun c:sample1_Form1_CheckBox3_OnClicked (Value /)
    (dcl_Control_SetEnabled sample1_Form1_TextButton2 T)
    (princ)
  )

  (defun c:sample1_Form1_CheckBox4_OnClicked (Value /)
    (dcl_Control_SetEnabled sample1_Form1_TextBox1 T)
    (princ)
  )

  (defun c:sample1_Form1_TextButton2_OnClicked (/)
    (dcl_MessageBox
      "To Do: code must be added to event handler\r\nc:sample1_Form1_TextButton2_OnClicked"
      "To do"
    )
    (princ)
  )

  (defun c:sample1_Form1_TextButton1_OnClicked (/)
    (dcl_Form_Close sample1_Form1)
  )
  
  (if
    (dcl_Project_Load "sample1.odcl")
     (dcl_Form_Show sample1_Form1)
  )

  (princ)
)

