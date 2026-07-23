(vl-cmdf "_Opendcl")

(defun c:HideFuncTest_Modal (
                              / c:HideFuncTest/FormModal/TextButton1#OnClicked
                                c:Nested_FunctionA
                                Nested_FunctionB
                            )

  (defun c:HideFuncTest/FormModal/TextButton1#OnClicked ()
    (dcl-Form-Close HideFuncTest/FormModal)
  )

  (defun c:Nested_FunctionA ()
    (princ "c:Nested_FunctionA")
  )

  (defun Nested_FunctionB ()
    (princ "Nested_FunctionB")
  )

  (dcl-Project-Load "HideFuncTest" T)
  (dcl-Form-Show HideFuncTest/FormModal)

  (c:Nested_FunctionA)
  (Nested_FunctionB)
  (princ)
)

(defun c:HideFuncTest_Modeless ( )
  (dcl-Project-Load "HideFuncTest" T)
  (dcl-Form-Show HideFuncTest/FormModeless)
  (princ)
)

(defun HideFuncTest/FormModeless/TextButton1#OnClicked ()
  (dcl-Form-Close HideFuncTest/FormModeless)
)

(princ "\nUse HideFuncTest_Modal or HideFuncTest_Modeless ")
(princ)
