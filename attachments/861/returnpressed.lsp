(defun c:test ()
  (dcl_project_load "D:/returnpressed" T)
  (dcl_Form_Show returnpressed_Form1)

  (defun c:returnpressed_Form1_TB1_OnReturnPressed (/)
    (alert "Please, I would like to make a test before close my dialog box !!!")
    )
  (defun c:returnpressed_Form1_GraphicButton1_OnClicked (/)
   (if (= (dcl_Control_GetText returnpressed_Form1_TB1) "OK")
     (progn
       (alert "You win !")
       (dcl_Form_close returnpressed_Form1)
       )
     (progn
       (alert "Should be ok in edittext to close !")
       )
     )
    )
  )




