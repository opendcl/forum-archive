(defun c:test ()
  (dcl_project_load "D:/Test" T)
  (dcl_form_show Test_Form1)
  (princ)
)

(defun c:Test_Form1_OnInitialize (/)
  (defun c:Test_Form1_show_OnClicked (/)
  (dcl_Control_SetVisible Test_Form1_visible T)
)
   (defun c:Test_Form1_hide_OnClicked (/)
  (dcl_Control_SetVisible Test_Form1_visible nil)
)

)




