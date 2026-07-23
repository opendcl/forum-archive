
; note: put these values in Get_ControlName once prj.odcl completed
; brd (x y)	offset due to the border of the Form
; org (x y)	position of the reference-control (upper-left)
; del (x y) 	size of the reference-control (upper-left)
; int (x y)	spacing between the controls

; brd depending on Form type + TitleBar :
; Form				TitleBar=true	TitleBar=false
; Modal				'(3 23) 	'(0 0)
; Modeless			'(8 26)		'(7 7)
; Palette			'(0 0)
; ControlBar(Docked) 		'(0 17)
; ControlBar(UnDocked) 		'(6 24)
(defun c:go ()
  (dcl_Project_Load "try" T)
  (setq prj "ControlsArray"
	dia "pctArray"
	ref "pctA0"
	brd '(3 23)
	org (list (dcl_Control_GetLeft prj dia ref) (dcl_Control_GetTop prj dia ref))
	del (list (dcl_Control_GetWidth prj dia ref) (dcl_Control_GetHeight prj dia ref))
	int '(8 8)
  )
  (dcl_Project_Load prj T)
  (dcl_Form_Show prj dia)
)

; MouseEntered/MouseMovedOff (uniques triggers)
; note: *PCT is a global handler
(defun c:ControlsArray_pctArray_pct_OnMouseEntered ()  
  (setq *PCT (Get_ControlName))
  ; paint it
  (dcl_Control_SetBackColor prj dia *PCT 16711808)
)
(defun c:ControlsArray_pctArray_pct_OnMouseMovedOff ()
  (dcl_Control_SetBackColor prj dia *PCT -6)  
)

(defun Get_ControlName (/ a b c d e f pos)
  ; pos = position index
  (setq pos (mapcar '(lambda(a b c d e f) (fix (/ (- a b c d) (+ e f)))) (dcl_GetMouseCoords) (dcl_Control_GetPos prj dia) org brd del int))
  (strcat "pct" (nth (car pos) '("A" "B" "C" "D")) (nth (last pos) '("0" "1" "2" "3")))
)

