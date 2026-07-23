;;;;;;;;;
(defun c:DELDIM (/ ss)
  (setq ss (ssget "x" (list (cons 0 "Dimension"))))
  (if ss
    (vl-cmdf ".erase" ss "")
    (princ "\nNo dimensions in this drawing!")
  )
  (princ)
)

;;;;;;;;;

