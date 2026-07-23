(defun c:MODVAR	(/)
  (dcl_project_load "MODVAR" t)
  (dcl_form_show MODVAR_frmMain)
  (princ)
)

(defun c:MODVAR_frmMain_btnApply_OnClicked (/)
  (dcl_messagebox
    "To Do: code must be added to event handler\r\nc:MODVAR_frmMain_btnApply_OnClicked"
    "To do"
  )
)

(defun c:MODVAR_frmMain_btnCancel_OnClicked (/)
  (dcl_form_close MODVAR_frmMain)
  (dcl_project_unload "MODVAR")
  (princ)
)


;;;(defun c:MODVAR_frmMain_OnInitialize (/)
;;;  (dcl_grid_addstring MODVAR_frmMain_grdVar
;;;		      "Name1\tValue1"
;;;		      "\t"
;;;  )
;;;  (dcl_grid_addstring MODVAR_frmMain_grdVar
;;;		      "Name2\tValue2"
;;;		      "\t"
;;;  )
;;;)

(defun c:MODVAR_frmMain_OnInitialize (/)
  (setq iRowIndex1 (dcl_grid_addrow MODVAR_frmMain_grdVar (list "Row 1")))
  (setq iRowIndex2 (dcl_grid_addrow MODVAR_frmMain_grdVar (list "Row 2")))
)

(princ)
 ;|«Visual LISP© Format Options»
(88 2 40 2 nil "end of " 60 20 1 0 0 T T nil T)
;*** DO NOT add text below the comment! ***|;
