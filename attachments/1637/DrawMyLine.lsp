(vl-load-com)
(setq *activeDocument* (vla-get-activedocument (vlax-get-acad-object)))
(setq *globalData* nil) ; reset on reload

(defun c:DrawMyLineStart ( / )
  (command "OPENDCL")
  (dcl_Project_Load "DrawMyLine" T)
  (dcl_Form_Show DrawMyLine_Form1)
  (princ)
)

(defun c:DrawMyLine_Form1_TextButton1_OnClicked (/)
  (setq *globalData* '((0 0 0) (1 1 1)))
  (vla-sendcommand *activeDocument* "DrawMyLine ")
  (princ)
)

(defun c:DrawMyLine ()
  (if *globalData*
    (progn
      (setvar 'cmdecho 0)
      (command "_.line" (car *globalData*) (cadr *globalData*) "")
    )
    (princ "\nError: data missing ")
  )
  (princ)
)

(princ "\nType DRAWMYLINESTART to start the program ")
(princ)
