(defun trstkfarben ( / fn)
    ;;
    ;; Ensure the OpenDCL.##.ARX is loaded.
    (OR (VL-SYMBOL-VALUE 'ODCL_GETVERSIONEX)
        (AND (SETQ fn (FINDFILE "OpenDCL_ARXLoader.LSP"))
             (LOAD fn (STRCAT "Failed to load :- " fn))
        )
        (ALERT (STRCAT "Failed to load OpenDCL_ARXLoader.LSP"))
        (EXIT)
    )
    ;;
    ;; Ensure the Project ODC file is loaded.    
    (OR (ODCL_PROJECT_LOAD "trstkfarben" T) (EXIT))
    ;;
    ;; Show the modal dialog .. 
    ;;


(defun c:trstkfarben_Start_OnInitialize ( /)
     ;;(Odcl_MessageBox "To Do: code must be added to event handler\r\nc:trstkfarben_Start_OnInitialize" "To do")
     (Odcl_Control_ZOrder trstkfarben_Start_Keine 1)
)



  (ODCL_FORM_SHOW trstkfarben_Start)
     ;; The Event handlers manage the form here. 
    (PRINC) 
)


;;-----------------------------------------------------------

;; wird beim aufruf des forumlars ausgeführt

(defun c:trstkfarben_Start_Keine_OnClicked ( /)
     ;;(Odcl_MessageBox "To Do: code must be added to event handler\r\nc:trstkfarben_Start_Keine_OnClicked" "To do")
     (setq GTRSTKFARBE 0)
     (Odcl_Form_CloseAll 0)
)

(defun c:trstkfarben_Start_Gelb_OnClicked ( /)
     ;;(Odcl_MessageBox "To Do: code must be added to event handler\r\nc:trstkfarben_Start_Gelb_OnClicked" "To do")
     (setq GTRSTKFARBE 51)
     (Odcl_Form_CloseAll 0)
)

(defun c:trstkfarben_Start_Rot_OnClicked ( /)
     ;;(Odcl_MessageBox "To Do: code must be added to event handler\r\nc:trstkfarben_Start_Rot_OnClicked" "To do")
     (setq GTRSTKFARBE 11)
     (Odcl_Form_CloseAll 0)
)

(defun c:trstkfarben_Start_Braun_OnClicked ( /)
     ;;(Odcl_MessageBox "To Do: code must be added to event handler\r\nc:trstkfarben_Start_Braun_OnClicked" "To do")
     (setq GTRSTKFARBE 39)
     (Odcl_Form_CloseAll 0)
)


(defun c:trstkfarben_Start_Blau_OnClicked ( /)
     ;;(Odcl_MessageBox "To Do: code must be added to event handler\r\nc:trstkfarben_Start_Blau_OnClicked" "To do")
     (setq GTRSTKFARBE 161)
     (Odcl_Form_CloseAll 0)
)

(defun c:trstkfarben_Start_Grun_OnClicked ( /)
     ;;(Odcl_MessageBox "To Do: code must be added to event handler\r\nc:trstkfarben_Start_Grun_OnClicked" "To do")
     (setq GTRSTKFARBE 91)
     (Odcl_Form_CloseAll 0)
)


(defun c:trstkfarben_Start_Violett_OnClicked ( /)
     ;;(Odcl_MessageBox "To Do: code must be added to event handler\r\nc:trstkfarben_Start_Violett_OnClicked" "To do")
     (setq GTRSTKFARBE 221)
     (Odcl_Form_CloseAll 0)
)

;;-----------------------------------------------------------

(princ)

;|«Visual LISP© Format Options»
(80 4 50 2 nil "end of " 80 50 0 0 2 nil nil nil T)
;*** DO NOT add text below the comment! ***|;
