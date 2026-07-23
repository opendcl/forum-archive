(DEFUN C:TESTEVENTS ()
	;LOAD ODCL
	(IF (NOT (IsLoadedArx "opendcl.17.arx"))(LOAD "opendcl.17.arx"))
	(dcl_Project_Load (FINDFILE "TestEvents.odcl"))
	;SHOW FORM
	(SETQ PROG:COUNTER 1)
	(dcl_Form_Show TestEvents_Form1)
)

;form events
(defun c:TestEvents_Form1_OnInitialize (/)
  (setq TEST:OKTOCLOSE NIL)
)

;CANCEL CLOSE IF USER HIT ESC
(defun c:TestEvents_Form1_OnCancelClose (Reason /)
  (NOT TEST:OKTOCLOSE)
)
(defun c:TestEvents_Form1_TextButton1_OnClicked (/)
	(setq TEST:OKTOCLOSE T)
	(dcl_Form_Close TestEvents_Form1 )
)

;TEXTBOX EVENTS
(defun c:TestEvents_Form1_TextBox1_OnKillFocus (/)
  (ALERT "\nOnKillFocus")
	(SETQ TextBox1:VALIDATED (VALIDATE_TextBox1))
)
(defun c:TestEvents_Form1_TextBox1_OnReturnPressed (/)
  (ALERT "\nOnReturnPressed")
	;SELECT TEXT FOR ANOTHER EDIT
	(IF TextBox1:VALIDATED
		(dcl_TextBox_SetSel TestEvents_Form1_TextBox1 0 -1)
	)
	(SETQ TextBox1:VALIDATED NIL)
)
(DEFUN VALIDATE_TextBox1 ()
	(dcl_Control_SetText TestEvents_Form1_TextBox2 (ITOA PROG:COUNTER))
	(SETQ PROG:COUNTER (+ 1 PROG:COUNTER))
	;RETURN 1 TO SIMULATE A SUCESSFUL VALIDATION
	1
)


;Function to check if an ARX is loaded
(defun IsLoadedArx (filename / )(IF (MEMBER (STRCASE filename T) (ARX)) T NIL))