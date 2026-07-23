(defun c:coBo ()
    
  (LadeODCLProj "Combobox.odcl")
  (vl-load-com)
  (setvar "CMDECHO" 0)
   
  
  (defun c:Combobox_Dialog1_OnInitialize (/)
  
    (dcl_Control_SetList Combobox_Dialog1_cmbBox1 (list "Item1" "Item2" "Item3" "Item4"))
    (dcl_Control_SetText Combobox_Dialog1_cmbBox1 txtKom)
  )  
  
  
  (defun c:Combobox_Dialog1_btnClose_OnClicked (/)
  
    (dcl_Form_Close Combobox_Dialog1)
  )
  

  (vl-load-com)
  (setq txtKom "Item1")
   
  (dcl_Form_Show Combobox_Dialog1)
  (princ)     
)