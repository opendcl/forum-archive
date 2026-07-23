(command "opendcl")

(defun c:color_swatch()
  (dcl_LoadProject "color_swatch")
  (dcl_Form_Show "color_swatch" "color_swatch")
 ) 

(defun c:color_swatch_COLOR_SWATCH_EXITBUTTON_OnClicked (/)
  (dcl_Form_Close "color_swatch" "color_swatch")
)

(defun c:kolor_OnClicked (/)
(command "color" (dcl_Control_GetBackColor kolor))
(dcl_Form_Close "color_swatch" "color_swatch")
)


