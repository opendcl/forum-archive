(defun c:TestFlash ()
  (vl-load-com)
  (command "_.opendcl")
  (dcl_Project_Load "SimulatingPalette")
  
  (dcl_Form_Show SimulatingPalette_Form1)
  
) ;_ fim de defun
(princ "\nType TestFlash\r")