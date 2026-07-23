(defun c:dirotool (/ cmdecho)

	;; Ensure OpenDCL Runtime is (quietly) loaded
	(setq cmdecho (getvar "CMDECHO"))
	(setvar "CMDECHO" 0)
	(command "_OPENDCL")
	(setvar "CMDECHO" cmdecho)

	;; Load the project
	;; (dcl_Project_Load (*ODCL:Samples:FindFile "Methods.odcl"))
        (dcl_Project_Load "c:\\diro\\cad\\2012\\dcl\\DiroTool.odcl")

	;; Show the main form
	(dcl_Form_Show diroTool_Main)

	;; This is a modal form, so (dcl_Form_Show) does not return until
	;; the modal form is closed. In the meantime, the event handlers
	;; manage the form.

	(princ)
  )

(defun c:diroTool_Main_cmdAlignAttribut_OnClicked (/)
  (c:aa)
)

