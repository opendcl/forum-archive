;; Test Code
;; 20091111 kdub@home
;; modified: add OnInitialize : 20091201 kdub@home
;; modified: add Runtime Caption : 20091201 kdub@home
;; modified: add textIncrementer : 20091202 kdub@home 

(vl-load-com)
 ;|<<Main>>|;

;; GLOBAL VARIABLE
(or gvar:testIncrementValue (setq gvar:testIncrementValue 0))
;;

(defun c:doit2 () (c:Test60012b))

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
(defun c:kdub60012b_Main_OnInitialize (/)
  (dcl_Control_SetCaption kdub60012b_Main_RuntimeBuild (dcl_GetVersionEx))
  (dcl_Control_SetCaption kdub60012b_Main_TextValue
                          (strcat "TextValue : " (itoa gvar:testIncrementValue))
  )
)
;;-----------
(defun c:kdub60012b_Main_TextButton6_OnClicked (/)
  (dcl_Control_SetCaption
    kdub60012b_Main_TextValue
    (strcat "TextValue : "
            (itoa (setq gvar:testIncrementValue (1+ gvar:testIncrementValue)))
    )
  )
)
;;-----------
;;-----------
(princ " << Enter DOIT2 or 'Test60012b' command to run >> \n")



 ;|«Visual LISP© Format Options»
(80 2 65 2 nil "end of " 80 50 0 0 0 nil nil nil T)
;*** DO NOT add text below the comment! ***|;
