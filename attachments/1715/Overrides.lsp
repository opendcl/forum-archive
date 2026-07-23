
(defun c:go ()
    (dcl_Project_Load "overrides" T)
    (dcl_Form_Show overrides_Form)
    (princ)
)

(defun c:overrides_Form_OnInitialize (/)
    (dcl_Control_SetColumnStyleList overrides_Form_grdOVR '(3 31 33 32 22))
    (dcl_Grid_AddString overrides_Form_grdOVR "")
    
    (dcl_Control_SetColumnStyleList Overrides_Form_Grid '(3 31 33 32 22))
    (dcl_Grid_AddString Overrides_Form_Grid "")
    
    (dcl_Grid_SetCellCheckState Overrides_Form_grdOVR 0 0 0)
    (dcl_Grid_SetCellText overrides_Form_grdOVR 0 1 "7")
    (dcl_Grid_SetCellText overrides_Form_grdOVR 0 2 "Continuous")
    (dcl_Grid_SetCellText overrides_Form_grdOVR 0 3 "0,13 mm")
    (dcl_Grid_SetCellText overrides_Form_grdOVR 0 4 "DuCalque")
    (dcl_Grid_SetCellText overrides_Form_grdOVR 0 5 "DuCalque")
    (dcl_Grid_SetCellImages overrides_Form_grdOVR 0 1 7)
    (dcl_Grid_SetCellImages overrides_Form_grdOVR 0 3 13)
)

(defun c:overrides_Form_grdOVR_OnEndLabelEdit (Row Column /)
    
    (dcl_Grid_SetCellCheckState overrides_Form_Grid 0 0 (dcl_Grid_GetCellCheckState Overrides_Form_grdOVR 0 0))
    (dcl_Grid_SetCellText overrides_Form_Grid 0 1 (dcl_Grid_GetCellText overrides_Form_grdOVR 0 1))
    (dcl_Grid_SetCellText overrides_Form_Grid 0 2 (dcl_Grid_GetCellText overrides_Form_grdOVR 0 2))
    (dcl_Grid_SetCellText overrides_Form_Grid 0 3 (dcl_Grid_GetCellText overrides_Form_grdOVR 0 3))
    (dcl_Grid_SetCellText overrides_Form_Grid 0 4 (dcl_Grid_GetCellText overrides_Form_grdOVR 0 4))
    (dcl_Grid_SetCellImages overrides_Form_Grid 0 1 (car (dcl_Grid_GetCellImages Overrides_Form_grdOVR 0 1)))
    (dcl_Grid_SetCellImages overrides_Form_Grid 0 3 (car (dcl_Grid_GetCellImages overrides_Form_grdOVR 0 3)))
)
