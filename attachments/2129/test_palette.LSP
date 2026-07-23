(dcl_project_load "Unbenannt" T)

(defun c:test_palette()
  (dcl_Form_Show Unbenannt/Dialog1)
)

(defun c:Unbenannt/Dialog1/pbtnAO#OnClicked (/)
  (cond
    ((= (dcl-Control-GetCaption Unbenannt/Dialog1/pbtnAO) "-")
      (print "button 'minus' clicked")
      (dcl-Control-SetCaption Unbenannt/Dialog1/pbtnAO "+")
      (dcl-Control-SetHeight Unbenannt/Dialog1 200)
;      (dcl-Form-Resize Unbenannt/Dialog1 (dcl-Control-GetWidth Unbenannt/Dialog1) 200)
    )
    (T
      (print "button 'plus' clicked")
      (dcl-Control-SetCaption Unbenannt/Dialog1/pbtnAO "-")
      (dcl-Control-SetHeight Unbenannt/Dialog1 300)
;      (dcl-Form-Resize Unbenannt/Dialog1 (dcl-Control-GetWidth Unbenannt/Dialog1) 300)
    )
  )
)

(defun c:Unbenannt/Dialog1#OnSize (intNewWidth intNewHeight /)
   (print (strcat "W H: " (itoa intNewWidth) " " (itoa intNewHeight)))
   (print)
)