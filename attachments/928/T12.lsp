;|
Test routine for hiding modal form.

|;
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

(defun c:t12 (/
              mainflag
              bflag
              ;;
              c:t12_main_selectstuff_onclicked
              c:t12_main_opennew_onclicked
              c:t12_child_selectstuff_onclicked
             )
  ;;---------------------------------------------
  (defun c:t12_main_selectstuff_onclicked (/)
    (setq mainflag t)
    (dcl_form_close t12_main)
    (_dostuff)
  )
  ;;---------------------------------------------
  (defun c:t12_main_opennew_onclicked (/ positionlist main-x main-y)
    (if (dcl_form_isactive t12_main)
      (progn (setq positionlist (dcl_control_getpos t12_main)
                   main-x       (car positionlist)
                   main-y       (cadr positionlist)
             )
             (dcl_form_close t12_main)
      )
    )
    (setq bflag t)
    (while bflag
      (setq bflag nil)
      (dcl_form_show t12_child main-x main-y)
      ;; 
    )
  )
  ;;--------------------------------------------- 
  (defun c:t12_child_selectstuff_onclicked (/)
    (setq bflag t)
    (dcl_form_close t12_child)
    (_dostuff)
  )
  ;;---------------------------------------------
  ;;---------------------------------------------  
  (or (dcl_project_load "T12" t) (exit))
  (setq mainflag t)
  (while mainflag
    (setq mainflag nil)
    (dcl_form_show t12_main)
    ;; 
  )
  (princ)
)
;;;---------------------------------------------------------------------------
;;;
;;;---------------------------------------------------------------------------
;;;
;;;---------------------------------------------------------------------------
;;;
;; Library Code common
;;
(defun _dostuff (/ pt blip)
  (setq blip (getvar "BLIPMODE"))
  (setvar "BLIPMODE" 1)
  ;;
  (while (setq pt (getpoint "\n Select a Point"))
    (prompt (strcat "\n " (vl-prin1-to-string pt)))
  )
  ;;
  (setvar "BLIPMODE" blip)
  (redraw)
)
;;;---------------------------------------------------------------------------
;;;
;;;---------------------------------------------------------------------------
;;;
;|
Single dialog which 'hides' to allow selection.
Single dialog redisplays when interaction is completed.
|;

(defun c:t12single (/
                    bflag
                    ;;
                    c:t12_child_selectstuff_onclicked
                   )
  (defun c:t12_child_selectstuff_onclicked (/)
    (setq bflag t)
    (dcl_form_close t12_child)
    (_dostuff)
  )
  ;;---------------------------------------------  
  ;;---------------------------------------------
  (or (dcl_project_load "T12" t) (exit))
  (setq bflag t)
  (while bflag
    (setq bflag nil)
    (dcl_form_show t12_child)
    ;; 
  )
  ;;---------------------------------------------  
  (princ)
)
;;;---------------------------------------------------------------------------
;;;
(prompt "\n T12Single, T12 to run.")
(princ)
 ;|«Visual LISP© Format Options»
(70 2 45 2 nil "end of " 70 60 1 1 0 nil nil nil T)
;*** DO NOT add text below the comment! ***|;
