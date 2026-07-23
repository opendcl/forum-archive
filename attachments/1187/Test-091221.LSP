(command "OPENDCL")
(setq test-text "OnInitialize")

(defun c:Test ()
 (dcl_Project_Load "Test-091221" T)
  (dcl_Control_SetTitleBarText Test-091221_Form1 "Form Title" )
  (dcl_Form_Show Test-091221_Form1)  
(princ)
)

(defun c:Test-091221_Form1_OnInitialize ()
  (dcl_Control_SetText Test-091221_Form1_TextBox1 test-text)
)

(defun c:Test-091221_Form1_TextButtonOk_OnClicked ()
  (dcl_messagebox (dcl_Control_GetText Test-091221_Form1_TextBox1))
)

(defun c:Test-091221_Form1_TextButtonCancel_OnClicked ()
  (dcl_Control_SetText Test-091221_Form1_TextBox1 "OnClicked")
)
