(setq $version_arx
	 (strcat "opendcl"
		 (if
		   (and
		     (setq proc_arch (getenv "PROCESSOR_ARCHITECTURE"))
		     (< 1 (strlen proc_arch))
		     (eq "64" (substr proc_arch (1- (strlen proc_arch))))
		     )
		   ".x64."
		   "."
		   )
		 (substr (getvar "acadver") 1 2)
		 ".arx"
		 ))
(if (not (member $version_arx (arx)))(arxload (findfile $version_arx) "ObjectDCL.arx not found."))


(if (not(dcl_Form_IsActive text_box_Modeless1))(dcl_project_load "D:/Text_box" T))

(defun c:text_box_Modeless1_0_OnClicked (/)
  (dcl_Control_SetFilterStyle text_box_Modeless1_text 0)
)

(defun c:text_box_Modeless1_7_OnClicked (/)
  (dcl_Control_SetFilterStyle text_box_Modeless1_text 7)
)

(defun c:text_box_Modeless1_Update_OnClicked (/)
  (dcl_Form_Close text_box_Modeless1)
  (dcl_Form_Show text_box_Modeless1)
)


(dcl_Form_Show text_box_Modeless1)

