(defun c:pal_Form1_OnMouseEntered (/)
  (print "c:pal_Form1_OnMouseEntered")
)

(defun c:pal_Form1_OnSize (NewWidth NewHeight /)
  (print "c:pal_Form1_OnSize")
)

(setvar 'cmdecho 0)
(command "OPENDCL")
(setvar 'cmdecho 1)
(dcl_Project_Load "pal" T)
(dcl_Form_Show pal_Form1)
