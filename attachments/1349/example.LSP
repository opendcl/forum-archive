

(command "opendcl")

(defun c:ex ()
  (dcl_project_load "example" t)
  (dcl_form_show example_form1)
  (princ)
)


(defun c:example_Form1_TextButton1_OnClicked (/)
  (dcl_Form_Close example_Form1 )
)


(defun c:example_Form1_OnInitialize (/)
  (dcl_Control_SetValue example_Form1_CheckBox1 0)
  (dcl_Control_SetVisible example_Form1_OptionList1 NIL)
  
)



(defun c:example_Form1_CheckBox1_OnClicked (Value /)
    (setq cb_value (dcl_Control_GetValue example_Form1_CheckBox1))

  (cond ((= cb_value 0)
	 ((dcl_Control_SetVisible example_Form1_OptionList1 NIL))
        )
    
        ((= cb_value 1)
	 ((dcl_Control_SetVisible example_Form1_OptionList1 T))
        )          

  
)

  
)
