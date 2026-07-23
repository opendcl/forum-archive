(dcl_Project_Load "d:/test.odcl" T)

(defun c:Test_Form1_TextButton1_OnClicked (/)
  (dcl_Control_SetCaption Test_Form1_Label1 (itoa (1+ (atoi (dcl_Control_GetCaption Test_Form1_Label1)))))
)

(dcl_form_show Test_Form1)

