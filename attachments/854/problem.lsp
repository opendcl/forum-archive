(IF (NOT *MasterDemo*)
  (princ "\nOpenDCL sample programs.\nEnter \"TREE\" to run the sample.\n")
)

(OR dcl_GETVERSIONEX
    (   (lambda ( / proc_arch arxname arxpath )

            ;;  Determine the appropriate arx module for
            ;;  the processor and the AutoCAD version.

            (setq arxname
                (strcat "OpenDCL"
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
                )
            )            
            ;;  Alert the user of a failure to:
            ;;
            ;;      (A) Find the arxfile, or 
            ;;      (B) Load the arxfile.
            ;;
            ;;      and return nil.
            ;;
            ;;  Otherwise just quietly return t.
            
            (cond
                (   (null (setq arxpath (findfile arxname)))
                    (alert (strcat "Couldn't find " arxname ".\nYou may need to add it to an Acad support path"))
                )
                (   (null (arxload arxpath 'nil))
                    (alert (strcat "Failed to load " arxname "."))
                )
                (   t   ) 
            )
        )
    )
)


;; this function loads the project & shows the form
(defun c:TREE (/)
  (or LoadRunTime (load "_OpenDclUtils.lsp") (exit))
  (LoadRunTime)
  (LoadODCLProj "problem.odcl")
  (dcl_FORM_SHOW problem_Main)
  ;; The event handlers manage the form until it is dismissed
  (PRINC)
)

(defun c:TreeView_Main_TextButton1_OnClicked (/)

	(setq fabricwidth  (dcl_TextBox_GetLine problem_Main_TxtBox1 0))
(alert fabricwidth)
	(setq gedoubleerd (dcl_Control_GetValue problem_Main_checkBox1))
	(setq x-repetition  (dcl_TextBox_GetLine problem_Main_TxtBox2 0))
(alert x-repetition)
	(setq y-repetition  (dcl_TextBox_GetLine problem_Main_TxtBox3 0))
(alert y-repetition)
	(setq x-offset (dcl_TextBox_GetLine problem_Main_TxtBox4 0))
(alert x-offset)
	(setq y-offset (dcl_TextBox_GetLine problem_Main_TxtBox5 0))
(alert y-offset)

  	(dcl_Form_Close problem_Main)
)

(defun c:TreeView_Main_TextButton2_OnClicked (/)
  	(dcl_Form_Close problem_Main)
)

(princ)
