(DEFUN C:QD (/ Top-Lt1 Top-Lt-on Top_1 Top-1-on)
  (COMMAND "OPENDCL")
  (DCL_PROJECT_LOAD "Quickdraw")
  (DCL_FORM_SHOW Quickdraw_Pal)
  (PRINC)
)
(setvar "cmdecho" 1)
(defun c:QuickDraw_Pal_OnInitialize (/)
  ;(DCL_CONTROL_SETVALUE QuickDraw_Pal_Top-Lt 0)  ;reset control Top-Lt à OFF
  (DCL_CONTROL_SETVALUE QuickDraw_Pal_Top-Lt-1 0);reset chexbox Top-Lt-1 à OFF
  ;(DCL_CONTROL_SETVALUE QuickDraw_Pal_Top 0)     ;reset control Top à OFF
  (DCL_CONTROL_SETVALUE QuickDraw_Pal_Top-1 0)   ;reset chexbox Top-1 à OFF
)

 ;Vue top-lt
(defun c:QuickDraw_Pal_Top-Lt_OnClicked (/)
  (SETQ Top-Lt1 (DCL_CONTROL_GETPROPERTY QuickDraw_Pal_Top-Lt))
  (dcl_Control_SetBackColor QuickDraw_Pal_Top-Lt -11)
)

(defun c:QuickDraw_Pal_Top-Lt-1_OnClicked (Value /)
  (SETQ Top-Lt-on (DCL_CONTROL_GETVALUE QuickDraw_Pal_Top-Lt-1))
)

;Vue Top
(defun c:QuickDraw_Pal_Top_OnClicked (/)
  (SETQ Top_1 (DCL_CONTROL_GETVALUE QuickDraw_Pal_Top))
  (if
    (= Top_1 1)
      (DCL_CONTROL_SETBACKCOLOR QuickDraw_Pal_Top 9)
      (DCL_CONTROL_SETBACKCOLOR QuickDraw_Pal_Top -6)
  )
)  

(defun c:QuickDraw_Pal_Top-1_OnClicked (Value /)
  (SETQ Top-1-on (DCL_CONTROL_GETVALUE QuickDraw_Pal_Top-1))
)

(DEFUN c:QuickDraw_Pal_OK_OnClicked ()
  (DCL_FORM_CLOSE Quickdraw_Pal)
)

 ;|«Visual LISP© Format Options»
(80 2 50 2 nil "end of " 80 50 2 0 2 nil nil nil T)
;*** DO NOT add text below the comment! ***|;
