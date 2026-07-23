(defun c:test ()
;;;
  (setvar "cmdecho" 0)
  (command "_.opendcl")
  (setvar "cmdecho" 1)
;;;
  (defun c:Untitled/Form1/PictureBox1#OnMouseDown (Button Flags X Y /)
    (dcl-MessageBox
      "To Do: code must be added to event handler\r\nc:Untitled/Form1/PictureBox1#OnMouseDown"
      "To do"
    ) ;_ fim de dcl-MessageBox
  ) ;_ fim de defun
;;;

  (dcl_project_load "Test_OnMouseDown" T)

;;;
  (dcl-Form-Show Test_OnMouseDown/Form1)
  (princ)
) ;_ fim de defun
;;;
  
;|«Visual LISP© Format Options»
(120 2 1 2 T "fim de " 90 9 0 0 nil nil T nil T)
;*** DO NOT add text below the comment! ***|;
