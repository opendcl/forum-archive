;; Test   kdub60010.lsp
;; 20091107 
;|<<Main>>|;
(defun c:Test60010 (/ DialogReturn)
  (command "_OPENDCL")
  (dcl_Project_Load "kdub60010.odcl" T)
  ;; Show the main form
  (setq DialogReturn (dcl_Form_Show kdub60010_Main))
  ;;------
  (cond
    ((= DialogReturn 1) (princ "  .... Dialog Closed \n"))
    ((= DialogReturn 2) (princ "  .... Dialog Cancelled [ ESC] \n"))
    ((= DialogReturn 102) (princ "  .... Dialog Cancelled From MessageBox \n"))
    ((= DialogReturn 106) (princ "  .... User Quit to make Coffee \n"))
  )
  (princ)
)
 ;|<<Support>>|;

 ;|<<OpenDCL Event Handlers>>|;
(defun c:Untitled_Main_OnInitialize (/)
  (dcl_Control_SetVisible kdub60010_Main_TextButton1 nil)
  (dcl_Control_SetEnabled kdub60010_Main_TextBox1 nil)
)
;;-----------
(defun c:kdub60010_Main_VisibleToggle_OnClicked (Value /)
  (if (= Value 1)                                                ; if ON      
    (dcl_Control_SetVisible kdub60010_Main_TextButton1 T)        ; Visible
    ;; else
    (dcl_Control_SetVisible kdub60010_Main_TextButton1 nil)      ; NOT Visible
  )
)
;;-----------
(defun c:kdub60010_Main_EnableToggle_OnClicked (Value /)
  (if (= Value 1)                                                ; if ON
    (dcl_Control_SetEnabled kdub60010_Main_TextBox1 T)           ; Enabled
    ;; else
    (dcl_Control_SetEnabled kdub60010_Main_TextBox1 nil)         ; NOT Enabled
  )
)
;;-----------
(defun c:kdub60010_Main_TextButton1_OnClicked (/ response)
  (setq
    reponse (dcl_MessageBox "To Do: Go and make a coffee." "Stuff To do" 26 3)
  )
  (if (or (= reponse 2)                                          ; Cancel
          (= reponse 6)                                          ; Yes
      )
    (dcl_Form_Close kdub60010_Main (+ 100 reponse))
  )
)
;;-----------
(defun c:kdub60010_Main_Bye_OnClicked (/)
  (dcl_Form_Close kdub60010_Main  1)
)

;;-----------
;;-----------
(princ " << Enter 'Test60010' command to run >> \n")


 ;|«Visual LISP© Format Options»
(80 2 65 2 nil "end of " 80 50 0 0 0 nil nil nil T)
;*** DO NOT add text below the comment! ***|;
