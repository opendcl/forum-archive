(defun c:optionlist ()

  (command "OPENDCL")
  (dcl_project_load "option" T)

  (initget "A B")

  (if (and option_list (not (dcl_Form_IsActive option_list))) (dcl_Form_Show option_list 100 100))

  (setq uRes (vl-catch-all-apply 'getpoint (list "\nPick point [A/B]: ")))

  (if (and option_list (dcl_Form_IsActive option_list)) (dcl_Form_Close option_list))

  (cond
    ((not uRes) (alert "You've pressed ENTER!"))
    ((vl-catch-all-error-p uRes) (alert "You've pressed ESC!"))
    ((listp uRes) (alert (strcat "You've picked a point: " (vl-prin1-to-string uRes) "!")))
    (T (alert (strcat "You've typed in an option: " uRes "!")))
  ); cond

  (princ)
); optionlist

(vl-load-com)
(princ "\nTYPE OPTIONLIST to start!\n")
(princ)