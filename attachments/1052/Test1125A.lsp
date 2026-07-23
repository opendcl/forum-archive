
(vl-load-com)
(command "OPENDCL")

;; Test Code  
;; 20091125 kdub@home 

;|<<MAIN>>|;


;;;---------------------------------------------------------------------------
;;; (findfile "Test1125A.ODCL")
;;;---------------------------------------------------------------------------
;;;
(defun c:doit (/ dialogreturn)
  (dcl_project_load "Test1125A.ODCL" t)
  ;; Show the main form  
  (setq dialogreturn (dcl_form_show test1125a_main))
  ;;------  
  (princ)
)
;;;---------------------------------------------------------------------------
;;;
;|<<SUPPORT>>|;

;;;---------------------------------------------------------------------------
;;; 
;|<<OPENDCL Handlers Event>>|;
(defun c:Test1125A_Main_OnInitialize (/)
  (setq combocontent '("AddColor"     "AddList"      "AddPath"
                       "AddString"    "Clear"        "ClearEdit"
                      )
  )
  (dcl_ComboBox_AddList Test1125A_Main_ComboBox1 combocontent) 
)
;;;-------------------------------------------

(defun c:Test1125A_Main_ComboBox1_OnDropDown (/)
  (dcl_ComboBox_SetDroppedWidth Test1125A_Main_ComboBox1 300)
  ;;(dcl_ComboBox_SetDroppedWidth Test1125A_Main_ComboBox1 70)
)

;;;-------------------------------------------

;;;---------------------------------------------------------------------------
;;;

(prompt "\n DOIT to run.")
(princ)
 ;|«Visual LISP© Format Options»
(70 2 45 2 nil "end of " 70 60 1 1 0 nil nil nil T)
;*** DO NOT add text below the comment! ***|;
