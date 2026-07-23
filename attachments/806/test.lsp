(defun c:test ()
  (setq el (entsel "Select an entity >"))
  (dcl_project_load "D:/Test" T)
  (dcl_form_show Test_Form1)
  (princ)
)

(defun c:Test_Form1_OnInitialize (/)
  (defun c:Test_Form1_BlockView1_OnClicked (/)
  (dcl_MessageBox "You never clicked on me !")
)
(dcl_Control_SetEnabled Test_Form1_BlockView1 T)
)



