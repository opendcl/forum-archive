(vl-load-com)
(command "OPENDCL")

;;;---------------------------------------------------------------------------
;;;
;;;---------------------------------------------------------------------------
;;;
;|
Main Dialog displays a Child Dialog
.. Main is closed so only a single dialog is displayed.

Child Dialog 'hides to allow interaction with AutoCAD.
Child Dialog redisplays when interaction is completed.

|;

(defun c:t12 (/ lstFormPos intForm
              c:t12_main_selectstuff_onclicked
              c:t12_main_opennew_onclicked
             )
  (defun c:t12_main_selectstuff_onclicked (/)
    (dcl_form_close t12_main 3)
  ); c:t12_main_selectstuff_onclicked

  (defun c:t12_main_opennew_onclicked (/)
    (setq lstFormPos (dcl_control_getpos t12_main))
    (dcl_form_close t12_main 4)
  ); c:t12_main_opennew_onclicked

  (load_project)
  (while (/= (setq intForm
                    (if lstFormPos
                      (dcl_form_show t12_main (car lstFormPos) (cadr lstFormPos))
                      (dcl_form_show t12_main)
                    ); if
                   ) 2) ;; 2 is for escaping the form!
    (cond
      ((= intForm 3) (_dostuff))
      ((= intForm 4) (call_child))
    ); cond
  ); while
  (princ)
); t12

;; Call subform alone

(defun c:t12single ()
  (call_child)
  (princ)
); c:t12single


;; =================== 
;; Library Code common 
;; =================== 

(defun load_project ()
  (or (member "T12" (dcl_getprojects)) (dcl_project_load "T12") (exit))
); load_project

(defun _dostuff (/ pt blip)
  (setq blip (getvar "BLIPMODE"))
  (setvar "BLIPMODE" 1)

  (while (setq pt (getpoint "\n Select a Point"))
    (prompt (strcat "\n " (vl-prin1-to-string pt)))
  ); while

  (setvar "BLIPMODE" blip)
  (redraw)
); _dostuff

(defun call_child (/ intForm c:t12_child_selectstuff_onclicked)

  (defun c:t12_child_selectstuff_onclicked (/)
    (dcl_form_close t12_child 3)
  ); c:t12_child_selectstuff_onclicked

  (load_project)
  (while (/= (setq intForm (dcl_form_show t12_child)) 2)
    (cond
      ((= intForm 3) (_dostuff))
    ); cond
  ); while
  
); call_child

(prompt "\n T12Single, T12 to run.")
(princ)
