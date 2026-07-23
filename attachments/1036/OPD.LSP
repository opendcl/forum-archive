
;;|*****|==================================================================================================================
;; used (si-xt) library functions (accessories)
(OR *lastdir* (SETQ *lastdir* ""))
;;-------------------
(DEFUN SI-FILE-OPEN (<STR:DialLabel> <STR:Extension> / ~t)
 (SETQ ~t (GETFILED <STR:DialLabel> *lastdir* <STR:Extension> 8))
 (IF ~t
  (PROGN (SETQ *lastdir* (STRCAT (VL-STRING-RIGHT-TRIM "\\" (VL-FILENAME-DIRECTORY (SETQ ~t (FINDFILE ~t)))) "\\"))
  )
 )
 ~t
)
;;-------------------
(DEFUN SI-FILE-SAVEAS (<STR:DialLabel> <STR:Extension> / ~t)
 (SETQ ~t (GETFILED <STR:DialLabel> *lastdir* <STR:Extension> 1))
 (IF ~t
  (PROGN (SETQ *lastdir* (STRCAT (VL-STRING-RIGHT-TRIM "\\" (VL-FILENAME-DIRECTORY ~t)) "\\")))
 )
 ~t
)
;;-------------------
(DEFUN SI-LST-CLEARDUPLICATES (<LI:> / ~lst ~t)
 (FOREACH
        ~t <LI:>
  (IF (NOT (MEMBER ~t ~lst))
   (SETQ ~lst (CONS ~t ~lst))
  )
 )
 (REVERSE ~lst)
)
;;-------------------
(DEFUN SI-LST-GETSAMEMEMBERS (<LI:1> <LI:2> / ~lst ~t)
 (IF (OR <LI:1> <LI:2>)
  (PROGN (FOREACH
                ~t <LI:1>
          (IF (MEMBER (strcase ~t) <LI:2>)
           (SETQ ~lst (CONS ~t ~lst))
          )
         )
  )
 )
 (SETQ ~lst (REVERSE ~lst))
 (SI-LST-CLEARDUPLICATES ~lst)
)
;;-------------------
(DEFUN SI-UTL-GETSTRING (<STR:Prompt> <STR:Dflt> / ~t)
 (PRINC (STRCAT "\n" <STR:Prompt> " <" <STR:Dflt> ">: "))
 (SETQ ~t (VL-CATCH-ALL-APPLY 'GETSTRING (LIST T)))
 (IF (VL-CATCH-ALL-ERROR-P ~t)
  (SETQ ~t nil)
 )
 (IF (/= ~t "")
  ~t
  <STR:Dflt>
 )
)
(DEFUN SI-GET-DATETODAY (/ ~s)
 (SETQ ~s (RTOS (GETVAR "CDATE") 2))
 (STRCAT (SUBSTR ~s 7 2) "." (SUBSTR ~s 5 2) "." (SUBSTR ~s 3 2))
)
;;|*****|==================================================================================================================


;;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;;||||||||||||||||||||||| *** OpenDCL Fast Project Dump by Slavko Ivanovic *** |||||||||||||||||||||||
;;||||||||||||||||||||||| ver. 0.1 |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;;||||||||||||||||||||||| 14. November 09 ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

(DEFUN C:OPD (/ ~all-events ~error-prompts ~e ~load ~pr ~project ~password ~allforms ~collectall ~dumpfile ~file)
 ;;
 ;;
 ;;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
 ;; load shi*t up
 (SETQ ~all-events (mapcar 'strcase
       (LIST                               ;
        "BeginLabelEdit"    "BeginLabelEdit"    "BeginLabelEdit"    "ButtonClicked"     "Cancel"
        "CancelClose"       "Changed"           "Clicked"           "Close"             "ColumnClick"
        "DblClicked"        "DblClicked"        "DblClicked"        "DeleteItem"        "DocActivated"
        "DragnDropBegin"    "DragnDropFromControl"                  "DragnDropFromOther"
        "DragnDropToAutoCAD"                    "DropDown"          "EditChanged"       "EndLabelEdit"
        "EndLabelEdit"      "EndLabelEdit"      "EnteringNoDocState"                    "FolderChanged"
        "GetDayState"       "Help"              "INITIALIZE"        "ItemExpanded"      "ItemExpanding"
        "KeyDown"           "KeyUp"             "KillFocus"         "MaxText"           "MouseDblClick"
        "MouseDown"         "MouseEntered"      "MouseMove"         "MouseMovedOff"     "MouseUp"
        "MouseWheel"        "NavigationComplete"                    "OK"                "OptionsApply"
        "OptionsCancel"     "OptionsHelp"       "OptionsOk"         "Paint"             "RightClick"
        "RightDblClick"     "ReleasedCapture"   "ReturnPressed"     "Scroll"            "Scrolled"
        "SelChanged"        "SelChanged"        "SelChanged"        "SelChanged"        "SelChanging"
        "Select"            "SetFocus"          "Show"              "Size"              "SplitterMove"
        "TypeChanged"       "Update"
       ))
       ~error-prompts
       (LIST "OpenDCL arx not loaded!"               "Project Load canceled!"
             "OpenDCL project not loaded!"           "Command canceled!"
             "OpenDCL project password not correct!" "Problem collecting data!"
             "Dump saving canceled!"
            )
       ~funcs
       (LIST
        ;;|||||||||||||||||||
        (DEFUN get-all-forms ()
         (IF (EQ ~password "ENTER for None")
          (DCL_PROJECT_GETFORMS ~project)
          (DCL_PROJECT_GETFORMS ~project ~password)
         )
        )
        ;;|||||||||||||||||||
        (DEFUN property-available-p (~o ~p) (MEMBER ~p (DCL_CONTROL_GETPROPERTIES ~o)))
        ;;|||||||||||||||||||
        (DEFUN filter-named-controls (~ctrlst)
         (VL-REMOVE
          nil
          (MAPCAR '(LAMBDA (x)
                    (IF (property-available-p x "(Name)")
                     x
                    )
                   )
                  ~ctrlst
          )
         )
        )
        ;;|||||||||||||||||||
        (DEFUN getname (~ctrl) (DCL_CONTROL_GETPROPERTY ~ctrl "(Name)"))
        ;;|||||||||||||||||||
        (DEFUN get-events (~f)
         (VL-REMOVE
          nil
          (MAPCAR '(LAMBDA (x)
                    (LIST (getname x)
                          (MAPCAR '(LAMBDA (p)
                                    (IF (= (DCL_CONTROL_GETPROPERTY x p) "")
                                     nil
                                     p
                                    )
                                   )
                                  (SI-LST-GETSAMEMEMBERS (DCL_CONTROL_GETPROPERTIES x) ~all-events)
                          )
                    )
                   )
                  ~f
          )
         )
        )
        ;;|||||||||||||||||||
        (DEFUN multitab (~stl)
         (MAPCAR '(LAMBDA (x)
                   (IF (= (TYPE x) 'STR)
                    (STRCAT "\t\t\t\t\t" x)
                   )
                  )
                 ~stl
         )
        )
        ;;|||||||||||||||||||
        (DEFUN fap (~s)
         (SETQ ~f (OPEN ~file "a"))
         (IF (= (TYPE ~s) 'STR)
          (WRITE-LINE ~s ~f)
          (FOREACH
                 @st ~s
           (IF (= (TYPE @st) 'STR)
            (WRITE-LINE @st ~f)
           )
          )
         )
         (CLOSE ~f)
         ~s
        )
        ;;|||||||||||||||||||
        (DEFUN dump-to-file ()
         (fap (LIST "*** OpenDCL Fast Project Dump by Slavko Ivanovic ***	...dump start"
                    (STRCAT "\n"
                            (SI-GET-DATETODAY)
                            "\nProject "
                            ~pr
                            "\nOpenDCL ["
                            (DCL_GETVERSIONEX)
                            "] on ACAD "
                            (GETVAR "acadver")
                            (GETVAR "_vernum")
                    )
                    "=================================================="
                    "Forms\t\tControls\t\tEvents/On"
                    "=================================================="
              )
         )
         (MAPCAR '(LAMBDA (x)
                   (LIST (fap "--------------------------------------------------")
                         (fap (STRCAT "" (CAAAR x)))
                         (fap (multitab (CADAAR x)))
                         (MAPCAR '(LAMBDA (c) (LIST (fap (STRCAT "\t\t" (CAR c))) (fap (multitab (CADR c))))) (CADR x))
                   )
                  )
                 ~collectall
         )
         (fap (LIST "\n--------------------------------------------------"
                    "*** OpenDCL Fast Project Dump by Slavko Ivanovic ***	...dump end"
              )
         )
        )
        ;;|||||||||||||||||||
        (DEFUN clearsyms (~symlst)
         (SETQ ~syl (VL-SYMBOL-VALUE ~symlst))
         (LENGTH (MAPCAR '(LAMBDA (x) (SET x nil)) (CONS ~symlst ~syl)))
        )
       )
 )
 ;; load shi*t end
 ;;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
 ;;
 ;;
 ;;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
 ;; main start
 (OR (AND (SETQ ~e    0
                ~load (VL-CMDF "OpenDCL")
          )
          (SETQ ~e  1
                ~pr (SI-FILE-OPEN "Select OpenDCL Project file" "odcl")
          )
          (SETQ ~e 2
                ~project
                (DCL_PROJECT_LOAD ~pr)
          )
          (SETQ ~e 3
                ~password
                (SI-UTL-GETSTRING "Password?" "ENTER for None")
          )
          (SETQ ~e 4
                ~allforms
                (filter-named-controls (get-all-forms))
          )
          (SETQ ~e 5
                ~collectall
                (MAPCAR '(LAMBDA (x) (LIST (get-events (LIST x)) (get-events (DCL_FORM_GETCONTROLS x)))) ~allforms)
          )
          (SETQ ~e    6
                ~file (SI-FILE-SAVEAS "Save OpenDCL Project Dump file" "txt")
          )
          (PROGN (dump-to-file) (startapp "NOTEPAD.exe" ~file))
     )
     (PRINC (STRCAT "\n * Oops, " (NTH ~e ~error-prompts)))
 )
 ;; main end
 ;;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
 ;;
 ;;
 ;; kill shi*t & out
 (clearsyms '~funcs)
 (PRINC)
)

(PROMPT "\n*** OpenDCL Fast Project Dump v.0.1 loaded.")
(PROMPT "\n*** type OPD [>>enter] to try this")
(PROMPT "\n*** © Slavko Ivanovic, www.SlavkoSolutions.com")

 ;|«Visual LISP© Format Options»
(120 1 43 2 nil "-->" 100 6 2 0 0 nil nil nil T)
;*** DO NOT add text below the comment! ***|;
