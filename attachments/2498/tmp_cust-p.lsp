(defun c:testcp ()

(command "_OPENDCL")
(dcl_project_load "aiCustomProps" t)

(defun  c:form0#OnInitialize  (/)
  (princ "\nOpened...")  
)



 (defun c:aiCustomProps/CustomProperties/Grid1#OnColumnClick (Column /)
  (princ (strcat "\nCol nr: "(VL-PRINC-TO-STRING Column)))
) 
 (defun c:aiCustomProps/CustomProperties/Grid1#OnSetFocus (/)
  (princ "Grid-focus")
)
(defun c:aiCustomProps/CustomProperties/Grid1#OnDblClicked (Row Column /)
  (princ (strcat "\nrow: "(VL-PRINC-TO-STRING Row)))
  (princ (strcat "\ncol: "(VL-PRINC-TO-STRING Column)))
)

 


(defun  c:ok-btn0#OnClicked (/)
  (princ "\nClose...")
  (dcl_form_close form0 )
  (princ)
)


 (dcl_form_show form0 ) 

)














