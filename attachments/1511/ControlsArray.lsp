; prj	str		name of the .odcl project
; dia	str		name of the form
(defun c:go (/ prj dia pct)
  
  (setq prj "ControlsArray"
	dia "pctArray")
  
  (dcl_Project_Load prj T)
  
  (dcl_Form_Show prj dia)
)

; MouseEntered/MouseMovedOff
(defun c:ControlsArray_pctArray_pct_OnMouseEntered (/)
  (setq pct (GetControlPos "pctA0" '(3 21) '(8 8)))
  (setq pct (strcat "pct" (nth (car pct) '("A" "B" "C" "D")) (nth (last pct) '("0" "1" "2" "3"))))
  ; paint it
  (dcl_Control_SetBackColor prj dia pct 16711808)
)
(defun c:ControlsArray_pctArray_pct_OnMouseMovedOff (/)
  (dcl_Control_SetBackColor prj dia pct -6)
)

; Retrieves (x y) position index of the control under the mouse, needs the following parameters :
; ref	str		name of the origin (upper-left) control
; int	(ix iy)		interval (x y) between controls
; dfl	(dx dy)		gap (x y) due to the TitleBar of the form and/or to Tabs (if controls are in a TabStrip) :
; 	(0 0)  		the form has no TitleBar - the controls are in the form
; 	(3 21) 		the form has a TitleBar - the controls are in the form
; 	(1 21) 		the form has no TitleBar - the controls are in a TabStrip
; 	(4 44) 		the form has a TitleBar - the controls are in a TabStrip
(defun GetControlPos (ref dfl int / org del a b c d e)
  (setq org (list (dcl_Control_GetLeft prj dia ref) (dcl_Control_GetTop prj dia ref)))
  (setq del (list (dcl_Control_GetWidth prj dia ref) (dcl_Control_GetHeight prj dia ref)))
  (mapcar '(lambda(a b c d e f) (fix (/ (- a b c d) (+ e f)))) (dcl_GetMouseCoords) (dcl_Control_GetPos prj dia) org dfl del int)
)