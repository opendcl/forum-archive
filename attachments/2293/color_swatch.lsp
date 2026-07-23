(setvar 'cmdecho 0)
(vl-cmdf "_Opendcl")
(setvar 'cmdecho 1)

(defun c:CSW ( / idx ret)
  (setq idx 0)
  (repeat 255
    (eval
      (read
        (strcat
          "(defun c:color_swatch/COLOR_SWATCH/COLOR" (itoa (setq idx (1+ idx))) "#OnClicked ()"
            "(ColorButtonOnClick " (itoa idx) ")"
          ")"
        )
      )
    )
  )
  (dcl-LoadProject "color_swatch")
  (setq ret (dcl-Form-Show color_swatch/COLOR_SWATCH))
  (cond
    ((= 1000 ret) ; Exit.
      nil
    )
    ((= 0 ret)
      (princ "\nByBlock")
    )
    ((= 256 ret)
      (princ "\nByLayer")
    )
    (T
      (princ (strcat "\nACI " (itoa ret)))
    )
   )
  (princ)
)

(defun ColorButtonOnClick (idx)
  (dcl-Form-Close color_swatch/COLOR_SWATCH idx)
)

(defun c:color_swatch/COLOR_SWATCH/EXITBUTTON#OnClicked ()
  (dcl-Form-Close color_swatch/COLOR_SWATCH 1000)
)

(defun c:color_swatch/COLOR_SWATCH/BBLOCK#OnClicked ()
  (dcl-Form-Close color_swatch/COLOR_SWATCH 0)
)

(defun c:color_swatch/COLOR_SWATCH/BLAYER#OnClicked ()
  (dcl-Form-Close color_swatch/COLOR_SWATCH 256)
)

(princ)
