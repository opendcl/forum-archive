(command "_OPENDCL")

(defun c:StartAutoDraw ()
  (dcl-Project-Load "Oke3.odcl" T)
  (dcl-Form-Show Oke3/Form1)
  (princ)
)

(defun c:Oke3/Form1#OnInitialize  (/ P20)
  (dcl-Control-SetCaption Oke3/Form1/LblStatus "Started")
  (setq P20 (dcl-Tree-AddParent Oke3/Form1/TreeC1 "Houtafscheider"))
  (dcl-Tree-AddChild
    Oke3/Form1/TreeC1
    (list
      (list P20 "DrawRectangle")
      (list P20 "DrawCircle")
      (list P20 "DrawEllipse")
    )
  )
)

(defun c:Oke3/Form1/TreeC1#OnClicked (/ curentlabel1)
  (setq curentlabel1
    (dcl-Tree-GetItemLabel Oke3/Form1/TreeC1
      (dcl-Tree-GetSelectedItem Oke3/Form1/TreeC1)
    )
  )
  (cond
    ((= curentlabel1 "DrawRectangle") (DrawRectangle))
    ((= curentlabel1 "DrawCircle")    (DrawCircle)   )
    ((= curentlabel1 "DrawEllipse")   (DrawEllipse)  )
  )
  (princ)
)

(defun c:Oke3/Form1/TBLine#OnClicked ()
  (DrawLine)
  (princ)
)

(defun c:Oke3/Form1/TBLine2#OnClicked ()
  (DrawLine)
  (princ)
)

(defun c:Oke3/Form1/TButtonExit#OnClicked ()
  (dcl-Form-Close Oke3/Form1)
  (princ)
)

(defun DrawEllipse ()
  (dcl-Control-SetCaption Oke3/Form1/LblStatus "Drawing Ellipse")
  (dcl-SendString (strcat (chr 27) (chr 27) "_ellipse "))
)

(defun DrawRectangle ()
  (dcl-Control-SetCaption Oke3/Form1/LblStatus "Drawing Rectangle")
  (dcl-SendString (strcat (chr 27) (chr 27) "_rectangle "))
)

(defun DrawCircle ()
  (dcl-Control-SetCaption Oke3/Form1/LblStatus "Drawing circle")
  (dcl-SendString (strcat (chr 27) (chr 27) "_circle "))
)

(defun DrawLine ()
  (dcl-Control-SetCaption Oke3/Form1/LblStatus "Drawing Line")
  (dcl-SendString (strcat (chr 27) (chr 27) "_line "))
)

(c:StartAutoDraw)
