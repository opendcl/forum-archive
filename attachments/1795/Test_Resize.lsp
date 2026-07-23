(command "OPENDCL")

(dcl_Project_Load "Test_Resize" T)

(defun c:TestMod ()
  (dcl_Form_Show Test_Resize_Modal1)
)

(defun c:TestPal ()
  (dcl_Form_Show Test_Resize_Palette1)
)

(princ "\nUse c:TestMod or c:TestPal ")
(princ)
