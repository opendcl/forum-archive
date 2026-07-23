(vl-load-com)
(command "OPENDCL")


;;;---------------------------------------------------------------------------
;;;

;|<<MAIN>>|;

(defun c:Hype1 (/ dialogreturn)
  (dcl_project_load "HYPE-01" T)
  (dcl_form_show HYPE-01_F)
  ;;------  
  (princ)
)

;;;---------------------------------------------------------------------------
;;;
;|<<OPENDCL Handlers Event>>|;

;;;-------------------------------------------
(defun c:Hype-01_F_Populate_OnClicked (/)
  (setq longTextString (list
                         "1. this is first line of text"                         
                         "2. this is second line"
                         "3. third line"
                         "4. etc."
                        )
  )
  (dcl_ListBox_AddList Hype-01_F_ListBox1 longTextString)
)

;;;-------------------------------------------
(defun c:Hype-01_F_ListBox1_OnSelChanged (ItemIndexOrCount Value /)
  (dcl_MessageBox Value "Selected Value from ListBox" 2 2)
)

;;;---------------------------------------------------------------------------
;;;
(princ)

 ;|«Visual LISP© Format Options»
(80 2 65 2 nil "end of " 80 50 0 0 0 nil nil nil T)
;*** DO NOT add text below the comment! ***|;
