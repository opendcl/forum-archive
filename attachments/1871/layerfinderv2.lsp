;;; c:llfp <LayerListFilePrint>
;;; Save the layer list to a file, (can be imported to Excel)
;;;
(vl-load-com)
(defun ax:layer-list (/ lst layer)
  (vlax-for layer (vla-get-Layers
                    (vla-get-ActiveDocument
                      (vlax-get-acad-object)
                    )
                  )
        (setq lst (cons
                (list
                  (vla-get-name layer)
                ) lst))
  )
  (vl-sort lst
           (function (lambda (e1 e2)
                       (< (strcase (car e1)) (strcase (car e2)))
                     )
           )
  )
  (princ lst)
  (setq lstwhole lst)
)
;|
;;; Writes layer list to specified file
;;; (layer-list-fprint "test.txt")
;;; return: T if file was created, else nil
(defun layer-list-fprint (fn / f row col)
  (if (setq f (open fn "w"))
    (progn
      ; print header
        (foreach row (ax:layer-list)
        (foreach col row
          (prin1 col f)
          (princ " " f) ; for tabulated (princ "\t" f)
        )
        (princ "\n" f)
      )
      (close f)
      T
    )
    nil
  )
)

(defun c:llfp (/ fn)
  vl-layer-list)
 ;| (if (setq fn vl-layer-list)                
             ;|(getfiled "Save layer list as"
                       (strcat (vl-filename-base (getvar "dwgname")) ".txt")
                       "txt"
                       1
             )
      )
    (if (layer-list-fprint fn)
      (princ "\nLayer list created.")
      (princ "\nError: Layer list not created!")
    )
  )
  (princ)
)|;