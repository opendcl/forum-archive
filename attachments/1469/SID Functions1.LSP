(defun c:sids (/)
  (setq cmdecho (getvar "CMDECHO"))
  (setvar "CMDECHO" 0)
  (command "_OPENDCL")
  (setvar "CMDECHO" cmdecho)
  (dcl_Project_Load "SIDFunctions1.odcl")
  (setq continue t)
  (while continue
    (setq continue nil)
    (setq flag1 (dcl_Form_Show SIDFunctions1_LIST_SID))
    (cond
      ((= flag1 1) (setq continue nil))
      ((= flag1 2) (setq continue nil))
;;;      ((= flag1 3)
;;;       (setq layname (cdr (assoc 8 (entget (car (entsel))))))
;;;      )
    )
  )
  (princ)
)

(defun c:SIDFunctions1_LIST_SID_OnInitialize (/)
  (dcl_Control_GetPos SIDFunctions1_LIST_SID)
)


(defun c:SIDFunctions1_LIST_SID_EXIT_BUTTON_OnClicked (/)
  (dcl_Form_Close SIDFunctions1_LIST_SID 1)
)


(defun c:SIDFunctions_LIST_SID_CANCEL_BUTTON_OnClicked (/)
  (dcl_Form_Close SIDFunctions1_LIST_SID 2)
)


;;;(defun c:SIDFunctions_LIST_SID_SELECTION_SCREEN_BUTTON_OnClicked (/ layname)
;;;  (dcl_Form_Close SIDFunctions1_LIST_SID 3)
;;;)

