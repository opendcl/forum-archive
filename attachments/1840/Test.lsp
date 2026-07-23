;;for test.odcl

(command "opendcl")

;;put your folder here
(dcl_project_load "C:\\uMill\\research\\test.odcl" T)

(defun c:test ()
	(dcl_Form_Show Test_One)
)

;;form events to test, if checked in project
;;use instead of OnCancelClose when enter suppression needed

;;escape pressed
(defun c:Test_One_OnCancel (/)
  (dcl_MessageBox "OnCancel:")
)

;;enter pressed
(defun c:Test_One_OnOK (/)
  (dcl_MessageBox "OnOK:")
)

;;;suppress enter, butn returns are shifted to 0 & 1
;(defun c:Test_One_OnCancelClose (Reason /)
;	t
;)

(defun c:Test_One_OnCancelClose (Reason /)
	(cond
		(
			(= Reason 0)
			t
		)
		(
			(= reason 1)
  		(dcl_MessageBox "OnCancelClose:")
			(dcl_Form_Close Test_One 2)
		)
	)
)

;;OK Button
(defun c:Test_One_btOK_OnClicked (/)
  (dcl_MessageBox "btOK:")
  (dcl_Form_Close Test_One 1)
)

;;Cancel button
(defun c:Test_One_btCancel_OnClicked (/)
  (dcl_MessageBox "btCancel:")
  (dcl_Form_Close Test_One 2)
)

