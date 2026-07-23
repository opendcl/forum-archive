;;;
;;; Based on the Form Move Sample
;;;
;;; This buttons set the discipline


;; Main program
(defun c:Test (/ cmdecho)

	;; Ensure OpenDCL Runtime is (quietly) loaded
	(setq cmdecho (getvar "CMDECHO"))
	(setvar "CMDECHO" 0)
	(command "_OPENDCL")
	(setvar "CMDECHO" cmdecho)

	;; Load the project
	(dcl-Project-Load (*ODCL:Samples-FindFile "FormMover2.odcl"))

	;; Show the main form
	(dcl-Form-Show FormMover2/Form1)
	(dcl-Form-Resize FormMover2/Form1 150 250)
	(dcl-Form-Center FormMover2/Form1)

	;; This is a modeless form, so (dcl-Form-Show) returns immediately,
	;; leaving the event handlers to manage the form.

	(princ)
)



;|«OpenDCL Event Handlers»|;

(defun c:FormMover2/Form1/GraphicButton1#OnClicked ( /)		; set discipline kunstwerken
	(set_mm)
       (dcl-Form-Close FormMover2/Form1)
)


(defun c:FormMover2/Form1/GraphicButton2#OnClicked ( /)		; set discipline wegen
	(set_m)
        (dcl-Form-Close FormMover2/Form1)
)

(defun c:FormMover2/Form1/GraphicButton3#OnClicked ( /)		; set discipline geo
	(set_geo)
        (dcl-Form-Close FormMover2/Form1)
)
(defun c:FormMover2/Form1/GraphicButton4#OnClicked ( /)		; set discipline tbb
	(set_tbb)
        (dcl-Form-Close FormMover2/Form1)
)



(defun c:FormMover2/Form1/cmdClose#OnClicked ( /);_ CLOSE
	(dcl-Form-Close FormMover2/Form1)
)



(princ)



