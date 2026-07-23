;; Test Code
;; 20091111 kdub@home

;|<<Main>>|;


(defun c:doit () (c:Test60012b))

;;----------------------------------------------------------------
(defun c:Test60012b (/ DialogReturn)
  (command "_OPENDCL")
  (dcl_Project_Load "kdub60012b.odcl" T)
  ;; Show the main form
  (setq DialogReturn (dcl_Form_Show kdub60012b_Main))
  ;;------
  (princ)
)
 ;|<<Support>>|;

 ;|<<OpenDCL Event Handlers>>|;


;;-----------
;;-----------
(princ " << Enter DOIT or 'Test60012b' command to run >> \n")


 ;|«Visual LISP© Format Options»
(80 2 65 2 nil "end of " 80 50 0 0 0 nil nil nil T)
;*** DO NOT add text below the comment! ***|;
