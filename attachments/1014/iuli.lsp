(command"opendcl")

(defun c:zzz ()

  (dcl_project_load "iuli" )

  (dcl_form_show iuli_form1)

  (princ)

)



(defun c:iuli_Form1_OnInitialize (/)
  (dcl_Control_SetVisible iuli_Form1_TextButton1 t)
)
