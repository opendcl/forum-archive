(DEFUN C:QD (/ Top-Lt1 Top-Lt-on Top_1 Top-1-on)
  (COMMAND "OPENDCL")
  (DCL_PROJECT_LOAD "Quickdraw")
  (DCL_FORM_SHOW Quickdraw_Pal)
  (PRINC)
)
(setvar "cmdecho" 1)
(defun c:QuickDraw_Pal_OnInitialize (/)
  (DCL_CONTROL_SETVALUE QuickDraw_Pal_Top-Lt-1 0);reset chexbox Top-Lt-1 à OFF
  (DCL_CONTROL_SETBACKCOLOR QuickDraw_Pal_Top-Lt -6)
  (DCL_CONTROL_SETVALUE QuickDraw_Pal_Top-1 0)   ;reset chexbox Top-1 à OFF
  (DCL_CONTROL_SETBACKCOLOR QuickDraw_Pal_Top -6)
)

(defun Toggle (picbox chkbox)
  (setq checked (DCL_CONTROL_GETVALUE chkbox))
)

 ;Vue top-lt
(defun c:QuickDraw_Pal_Top-Lt_OnClicked (/ checked)
  (setq checked (zerop (DCL_CONTROL_GETVALUE QuickDraw_Pal_Top-Lt-1)))
  (DCL_CONTROL_SETVALUE QuickDraw_Pal_Top-Lt-1 (if checked 1 0))
  (DCL_CONTROL_SETBACKCOLOR QuickDraw_Pal_Top-Lt (if checked 9 -6))
)

(defun c:QuickDraw_Pal_Top-Lt-1_OnClicked (Value /)
  (DCL_CONTROL_SETBACKCOLOR QuickDraw_Pal_Top-Lt (if (zerop Value) -6 9))
)

;Vue Top
(defun c:QuickDraw_Pal_Top_OnClicked (/)
  (setq checked (zerop (DCL_CONTROL_GETVALUE QuickDraw_Pal_Top-1)))
  (DCL_CONTROL_SETVALUE QuickDraw_Pal_Top-1 (if checked 1 0))
  (DCL_CONTROL_SETBACKCOLOR QuickDraw_Pal_Top (if checked 9 -6))
)  

(defun c:QuickDraw_Pal_Top-1_OnClicked (Value /)
  (DCL_CONTROL_SETBACKCOLOR QuickDraw_Pal_Top (if (zerop Value) -6 9))
)

(defun c:QuickDraw_Pal_OK1_OnClicked (/)
  (DCL_FORM_CLOSE Quickdraw_Pal)
)

 ;|«Visual LISP© Format Options»
(80 2 50 2 nil "end of " 80 50 2 0 2 nil nil nil T)
;*** DO NOT add text below the comment! ***|;
