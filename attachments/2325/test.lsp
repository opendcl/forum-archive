(dcl-project-load "test" T)

;------------------------------------------------------------------------------
(defun c:test/dlg#OnMouseEntered ()
  nil
)

;------------------------------------------------------------------------------
(defun c:test/dlg#OnMouseMovedOff ()
  nil
)

;------------------------------------------------------------------------------
(defun c:test/dlg#OnInitialize (/)
  (dcl-Control-SetVisible test/dlg/pbar nil)
)

;------------------------------------------------------------------------------
(defun c:test/dlg/btnClose#OnClicked ()
  (dcl-Form-Close test/dlg)
)

;------------------------------------------------------------------------------
(defun c:test/dlg/btnRun#OnClicked (/ time count i)
  (dcl-Control-SetVisible test/dlg/pbar t)
  (dcl_Control_SetMaxValue test/dlg/pbar 100)

  (setq time (getvar "MilliSecs")
        count 80000
        i 0)
  (repeat count
    (dcl-Control-SetValue test/dlg/pbar (fix (/ (* (setq i (1+ i)) 100) count)))
  )
  (print (* (- (getvar "MilliSecs") time) 1E-3) )

  (dcl-Control-SetVisible test/dlg/pbar nil)
  (princ)
)

;------------------------------------------------------------------------------
(defun c:test/dlg/btnCancel#OnClicked (/)
  (dcl-Form-Close test/dlg)
)


;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
(defun c:test()
  (dcl-Form-Show test/dlg)
  (princ)
)

