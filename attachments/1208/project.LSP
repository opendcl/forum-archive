


(command "opendcl")

(defun c:tab ()
  (dcl_project_load "project" t)
  (dcl_form_show project_form1)
  (princ)
)




(defun c:project_Form1_TextButton1_OnClicked (/)

  (dcl_Form_Show project_Form2 )

   (setq ok T)
    (WHILE ok                                 
	(SETQ ok nil)
	(dcl_Form_Show project_Form2 )
)
  )




(defun c:project_Form2_TextButton1_OnClicked (/)

  (dcl_Form_Close project_Form2 )
 
  (setq point (getpoint))

  (setq ok t)
)



 (defun c:project_Form1_TextButton2_OnClicked (/)
  (dcl_Form_Close project_Form1 )
)


(defun c:project_Form2_TextButton2_OnClicked (/)
  (dcl_Form_Close project_Form2 )
)
