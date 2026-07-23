(defun c:BasicInput_CALCULATOR_OnInitialize (/)
  (dcl_Control_ZOrder BasicInput_CALCULATOR_REGISTER_X 1)
)

(defun c:BasicInput_CALCULATOR_OnCancelClose (Reason /)
  (if (not (/= Reason 1))
    (dcl_Control_SetFocus BasicInput_CALCULATOR_REGISTER_X)
    (dcl_TextBox_SetSel BasicInput_CALCULATOR_REGISTER_X 0 -1)
  )
)

(defun c:BasicInput_CALCULATOR_ENTER_BUTTON_OnClicked (/)
  (dcl_Control_SetText BasicInput_CALCULATOR_REGISTER_X
                       (rtos (atof (dcl_Control_GetText BasicInput_CALCULATOR_REGISTER_X)) 2 (getvar "luprec"))
  )
  (dcl_Control_SetText BasicInput_CALCULATOR_REGISTER_T (dcl_Control_GetText BasicInput_CALCULATOR_REGISTER_Z))
  (dcl_Control_SetText BasicInput_CALCULATOR_REGISTER_Z (dcl_Control_GetText BasicInput_CALCULATOR_REGISTER_Y))
  (dcl_Control_SetText BasicInput_CALCULATOR_REGISTER_Y (dcl_Control_GetText BasicInput_CALCULATOR_REGISTER_X))
  (dcl_Control_SetFocus BasicInput_CALCULATOR_REGISTER_X)
)

(defun c:BasicInput_CALCULATOR_REGISTER_X_OnReturnPressed (/)
  (dcl_Control_SetText BasicInput_CALCULATOR_REGISTER_X
                       (rtos (atof (dcl_Control_GetText BasicInput_CALCULATOR_REGISTER_X)) 2 (getvar "luprec"))
  )
  (dcl_Control_SetText BasicInput_CALCULATOR_REGISTER_T (dcl_Control_GetText BasicInput_CALCULATOR_REGISTER_Z))
  (dcl_Control_SetText BasicInput_CALCULATOR_REGISTER_Z (dcl_Control_GetText BasicInput_CALCULATOR_REGISTER_Y))
  (dcl_Control_SetText BasicInput_CALCULATOR_REGISTER_Y (dcl_Control_GetText BasicInput_CALCULATOR_REGISTER_X))
  (dcl_Control_SetFocus BasicInput_CALCULATOR_REGISTER_X)
)

(defun c:BasicInput_CALCULATOR_REGISTER_X_OnSetFocus (/)
  (dcl_TextBox_SetSel BasicInput_CALCULATOR_REGISTER_X 0 -1)
)