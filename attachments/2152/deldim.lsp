  (setq cmdecho (getvar "CMDECHO"))
  (setvar "CMDECHO" 0)
  (command "_OPENDCL")
  (setvar "CMDECHO" cmdecho)
 
(defun c:ddim () 
 ; call the method to load the deldim.odcl file. 
 (dcl_Project_Load "deldim" T) 
 (dcl_Form_Show deldim/Form1)
 (princ) 
) 

(defun c:deldim/Form1/cmdBDelDim#OnClicked (/)
(load "C:\\Lisps\\function.lsp")
(prompt "\function.lsp Loaded...")
  (c:DELDIM)
  (princ)
)

(defun c:deldim/Form1/cmdDelDim#OnClicked (/)
(load "C:\\Lisps\\function.lsp")
(prompt "\function.lsp Loaded...")
  (c:DELDIM)
  (princ)
)

(defun c:deldim/Form1/cmdClose#OnClicked (/)
  (dcl-Form-Close deldim/Form1)
  (princ)
)

