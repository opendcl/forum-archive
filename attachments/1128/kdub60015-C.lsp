;; Test Code
;; 20091111 kdub@home
;; modified: add OnInitialize : 20091201 kdub@home
;; modified: add Runtime Caption : 20091201 kdub@home
;; modified: add textIncrementer : 20091202 kdub@home 
;; modified: additional Controls, rename kdub60015C. 20091210 kdub@home 

(vl-load-com)
 ;|<<Main>>|;

;; GLOBAL VARIABLE
(or gvar:testIncrementValue (setq gvar:testIncrementValue 0))
;;

;;----------------------------------------------------------------
(defun c:doit15 (/ DialogReturn)
  (command "_OPENDCL")
  (dcl_Project_Load "kdub60015C.odcl" T)
  ;; Show the main form
  (setq DialogReturn (dcl_Form_Show kdub60015C_Main))
  ;;------
  (princ)
)
 ;|<<Support>>|;

 ;|<<OpenDCL Event Handlers>>|;
(defun c:kdub60015C_Main_OnInitialize (/)
  (dcl_Control_SetCaption kdub60015C_Main_RuntimeBuild (dcl_GetVersionEx))
  (dcl_Control_SetCaption kdub60015C_Main_TextValue
                          (strcat "TextValue : " (itoa gvar:testIncrementValue))
  )
)
;;-----------
(defun c:kdub60015C_Main_TextButton6_OnClicked (/)
  (dcl_Control_SetCaption kdub60015C_Main_TextValue
                          (strcat "TextValue : "
                                  (itoa (setq gvar:testIncrementValue (1+ gvar:testIncrementValue)))
                          )
  )
)
;;-----------
;;-----------
(princ " << Enter DOIT15 command to run >> \n")



 ;|«Visual LISP© Format Options»
(120 2 65 2 nil "end of " 80 50 0 0 0 nil nil nil T)
;*** DO NOT add text below the comment! ***|;
