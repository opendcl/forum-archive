(command "opendcl")


(defun C:reshow_Form1_GraphicButton1_OnClicked (/)
  (if (dcl_Form_IsActive reshow_Form1)
      (dcl_Form_close reshow_Form1)
  )
    
  (command ".line" pause "@10,10" "")
  (princ)
)


(defun C:show (/)
  (dcl_Project_Load "reshow.odcl" T)
  (dcl_Form_Show reshow_Form1)
  (princ)
)
