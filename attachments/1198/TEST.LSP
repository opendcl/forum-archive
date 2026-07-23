(defun c:TEST ( / )
  (or LoadRunTime (load "_OpenDclUtils.lsp") (exit))
  (LoadRunTime)
  (LoadODCLProj "test.odcl")
  
  
  (dcl_FORM_SHOW test_FORM)
)

(defun c:Untitled_Form1_Label1_OnClicked (/)
  (dcl_Control_GetCaption TEST_FORM_Label1 "CLICK LABEL1")
)

(defun c:TEST_FORM_Label2_OnClicked (/)
  (dcl_Control_GetCaption TEST_FORM_Label2 "CLICK LABEL2")
)

(defun c:TEST_FORM_TextButton1_OnClicked (/)
  (dcl_Control_GetCaption TEST_FORM_Label1 "CLICK BUTT1")
)

(defun c:TEST_FORM_TextButton2_OnClicked (/)
  (dcl_Control_GetCaption TEST_FORM_Label2 "CLICK BUTT2")
)


