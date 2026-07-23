(defun C:ONPAINT_TEST ()

	
	(defun C:ONPAINT_FRM_ONINITIALIZE (/)
	  (setq back-color 5)
	)

	(defun C:ONPAINT_PB_ONPAINT (HasFocus /)
	  	(dcl-control-setbackcolor 	"onpaint" "frm" "pb" back-color)
		(dcl-PictureBox-Clear 		"onpaint" "frm" "pb")			

	)

	(dcl-project-load "onpaint" T)
	(dcl-form-show "onpaint" "frm")
)


(defun c:OP () (C:ONPAINT_TEST) )