(command "_OPENDCL")

(defun c:StartAutoDraw ()
  (dcl-Project-Load "Roy.odcl" T)
  (dcl-Form-Show Roy/Form1)
  (princ)
)

(defun c:Roy/Form1#OnInitialize  (/ P20)
  (dcl-Control-SetCaption Roy/Form1/LblStatus "Started")
  (setq P20 (dcl-Tree-AddParent Roy/Form1/TreeC1 "Autolisp Entsel test"))
  (dcl-Tree-AddChild
    Roy/Form1/TreeC1
    (list
      (list P20 "DrawRectangle")
      (list P20 "DrawCircle")
      (list P20 "DrawEllipse")
    )
  )
)

(defun c:Roy/Form1/TreeC1#OnClicked (/ curentlabel1)
  (setq curentlabel1
    (dcl-Tree-GetItemLabel Roy/Form1/TreeC1
      (dcl-Tree-GetSelectedItem Roy/Form1/TreeC1)
    )
  )
  (cond
    ((= curentlabel1 "DrawRectangle") (DrawRectangle))
    ((= curentlabel1 "DrawCircle")    (DrawCircle)   )
    ((= curentlabel1 "DrawEllipse")   (DrawEllipse)  )
  )
  (princ)
)

(defun c:Roy/Form1/TBLine#OnClicked ()
  (DrawEllipse)
  (princ)
)

(defun c:Roy/Form1/TBLine2#OnClicked ()
  (DrawRectangle)
  (princ)
)

(defun c:Roy/Form1/TButtonExit#OnClicked ()
  (dcl-Form-Close Roy/Form1)
  (princ)
)

(defun DrawEllipse ()
  (dcl-Control-SetCaption Roy/Form1/LblStatus "Select Ellipse")
  (dcl-SendString "(chr 27) (chr 27) (setq p1 (getpoint \"Getpoint (Ellipse)\")) ")
)

(defun DrawRectangle ()
  (dcl-Control-SetCaption Roy/Form1/LblStatus "Select Rectangle")
  (dcl-SendString "(chr 27) (chr 27) (setq p1 (getpoint \"Getpoint (Rectangle)\")) ")
)

(defun DrawCircle ()
  (dcl-Control-SetCaption Roy/Form1/LblStatus "Select circle")
  (dcl-SendString "(chr 27) (chr 27) (setq p1 (getpoint \"Getpoint(circle)\")) ")
)

(defun DrawLine ()
  (dcl-Control-SetCaption Roy/Form1/LblStatus "Select Line")
  (dcl-SendString "(chr 27) (chr 27) (setq p1 (getpoint \"Getpoint (Line)\")) ")
)

(c:StartAutoDraw)
