(vl-cmdf "_Opendcl")

(defun c:HideFuncTest_Modeless ( )
  (dcl-Project-Load "HideFuncTest" T)
  (dcl-Form-Show HideFuncTest/FormModeless)
  (princ)
)

(defun HideFuncTest/FormModeless/BtnNoCPrefix#OnClicked (/)
  (dcl_MessageBox "Event handler names without the 'C:' prefix are supported")
)

(defun c:*HideFuncTest/FormModeless/BtnMyZoomCommand#OnClicked ()
  (dcl-SendString "MyZoomCommand\n")
)

(defun c:*HideFuncTest/FormModeless/BtnOk#OnClicked ()
  (dcl-Form-Close HideFuncTest/FormModeless)
)

(defun c:MyZoomCommand ( / )
  (command "_.zoom" "_extents" "_.zoom" "0.8x")
  (princ)
)

(princ "\nUse HideFuncTest_Modeless ")
(princ)
