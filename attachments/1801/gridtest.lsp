(command "OPENDCL")

(defun c:test ()

  (dcl_Project_Load "Grid_test" T)

  (dcl_Form_Show Grid_test_Form1)
  
     (princ)
)


(defun c:Grid_test_Form1_OnInitialize (/)

(dcl_Grid_AddRow Grid_test_Form1_Grid1 "" "Test1" "Test2" "Test3" "")

(dcl_Grid_SetCellStyle Grid_test_Form1_Grid1 0 1 18)

(dcl_Grid_SetCellStyle Grid_test_Form1_Grid1 0 4 6)

(dcl_Grid_SetCellDropList Grid_test_Form1_Grid1 0 1 '("Test1" "Test2" "Test3"))

)


(defun c:Grid_test_Form1_GraphicButton1_OnClicked (/)

(dcl_Form_Close Grid_test_Form1)

)

