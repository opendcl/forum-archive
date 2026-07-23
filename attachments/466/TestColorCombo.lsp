;;;------------------------------------------------------------------
;;;------------------------------------------------------------------
;;;
(pragma '((unprotect-assign kdub:protect-assign)))
(defun kdub:protect-assign (symbollist)
  (eval (list 'pragma
              (list 'quote (list (cons 'protect-assign symbollist)))
        )
  )
)
(pragma '((protect-assign kdub:protect-assign)))
;;;------------------------------------------------------------------
;;;------------------------------------------------------------------
;;;
(pragma '((unprotect-assign kdub:unprotect-assign)))
(defun kdub:unprotect-assign (symbollist)
  (eval (list 'pragma
              (list 'quote (list (cons 'unprotect-assign symbollist)))
        )
  )
)
(pragma '((unprotect-assign kdub:unprotect-assign)))
;;;------------------------------------------------------------------
;;;------------------------------------------------------------------
;;;
(pragma '((unprotect-assign kdub:DefineConstantVar)))
(defun kdub:DefineConstantVar (quotedSymbolName symbolValue)
  (kdub:unprotect-assign (list quotedSymbolName))
  (set quotedSymbolName symbolValue)
  (kdub:protect-assign (list quotedSymbolName))
  (princ)
)
(pragma '((protect-assign kdub:DefineConstantVar)))
;;;------------------------------------------------------------------
;;;------------------------------------------------------------------ 
;;;
(or kglobal_acadapp
    (kdub:DefineConstantVar 'kglobal_acadapp (vlax-get-acad-object))
)
(or kglobal_activedoc
    (kdub:DefineConstantVar 'kglobal_activedoc
                            (vla-get-activedocument kglobal_acadapp)
    )
)
(or kglobal_modelspace
    (kdub:DefineConstantVar 'kglobal_modelspace
                            (vla-get-modelspace kglobal_activedoc)
    )
)
(or kglobal_layers
    (kdub:DefineConstantVar 'kglobal_layers
                            (vla-get-layers kglobal_activedoc)
    )
)
;;;------------------------------------------------------------------
;;;------------------------------------------------------------------
;;;
(pragma '((unprotect-assign kdub:safeItem)))
(defun kdub:safeItem (collection item / returnvalue)
  (if (not (vl-catch-all-error-p
             (setq returnvalue (vl-catch-all-apply 'vla-item
                                                   (list collection item)
                               )
             )
           )
      )
    returnvalue
  )
)
(pragma '((protect-assign kdub:safeItem)))
;;;------------------------------------------------------------------
;;;------------------------------------------------------------------
;;;
(pragma '((unprotect-assign kdub:listCollectionMemberNames)))
(defun kdub:listCollectionMemberNames
       (collection / itemname returnvalue)
  (setq returnvalue '())
  (vlax-for each collection
    (setq itemname    (vla-get-name each)
          returnvalue (cons itemname returnvalue)
    )
  )
  (reverse returnvalue)
)
(pragma '((protect-assign kdub:listCollectionMemberNames)))
;;;------------------------------------------------------------------
;;;------------------------------------------------------------------
;;;
;;;------------------------------------------------------------------
;;;------------------------------------------------------------------
;;;


(defun c:doit () (TestColorCombo))
;;;------------------------------------------------------------------
;;;------------------------------------------------------------------
;;;

(defun TestColorCombo (/
                       _ConvertColorStringToNumber
                       ;;
                       currentLayerColorNumber
                      )
  (setq currentLayerColorNumber
         (vla-get-Color (vla-get-activelayer
                          (vla-get-activedocument
                            (vlax-get-acad-object)
                          )
                        )
         )
  )
  ;;-----------------------------------------------------------
  ;;
  ;; Convert the return value from the dcl_ComboBox_GetTBText Method to a Color Number (0-256)
  ;; (_ConvertColorStringToNumber "12")
  ;; (_ConvertColorStringToNumber "Color 122")
  ;; (_ConvertColorStringToNumber "Cyan") (_ConvertColorStringToNumber "0")
  ;;
  (defun _ConvertColorStringToNumber (ColorString / tmp)
    (cond
      ((numberp
         (setq tmp (read (vl-string-subst "" "Color " ColorString)))
       )
       tmp
      )
      ((numberp (setq
                  tmp (eval
                        (read
                          (strcat "ac"
                                  (vl-string-subst "" "Color " ColorString)
                          )
                        )
                      )
                )
       )
       tmp
      )
      (t 256)
    )
  )
  ;;-----------------------------------------------------------
  ;;
  (defun _ResetComboBox (ColorNumber / stringValue listIndex)
    (cond ((Setq listIndex (dcl_ComboBox_FindColor
                             TestColorCombo_Main_ComboBox1
                             ColorNumber
                           )
           )
           ;; the color exists in the display list, so select it by it's index
           (dcl_ComboBox_SetCurSel TestColorCombo_Main_ComboBox1
                                   listIndex
           )
          )
          ;;
          ;; the color is not in the combo display,
          ;; so add it if it's a valid color number.
          ((and (>= ColorNumber 8) (<= ColorNumber 256))
           (dcl_ComboBox_AddColor TestColorCombo_Main_ComboBox1
                                  ColorNumber
           )
           (dcl_ComboBox_SetCurSel
             TestColorCombo_Main_ComboBox1
             (dcl_ComboBox_FindColor TestColorCombo_Main_ComboBox1
                                     ColorNumber
             )
           )
          )
          ;;
    )
    (Setq stringValue
           (dcl_ComboBox_GetTBText TestColorCombo_Main_ComboBox1
           )
    )
    (c:TestColorCombo_Main_ComboBox1_OnSelChanged 0 stringValue)
  )
  ;;-----------------------------------------------------------
  ;;
  ;; Main Entry Point
  ;;-----------------------------------------------------------
  ;;---------------(findFile "TestColorCombo.odcl")
  (dcl_project_load "TestColorCombo.odcl" T)
  (dcl_form_show TestColorCombo_main)
  ;;
  (princ)
)
;;;------------------------------------------------------------------
;;;------------------------------------------------------------------
;;;
(defun c:TestColorCombo_Main_OnInitialize (/)
  (_ResetComboBox currentLayerColorNumber)
)
;;;------------------------------------------------------------------
;;;------------------------------------------------------------------
;;;
(defun c:TestColorCombo_Main_TextBox3_OnReturnPressed (/)
  (c:TestColorCombo_Main_DoIt_OnClicked)
)
;;;------------------------------------------------------------------
;;;------------------------------------------------------------------
;;;
(defun c:TestColorCombo_Main_ComboBox1_OnSelChanged
       (nSelection sSelText /)
  (dcl_Control_SetText TestColorCombo_Main_TextBox1
                       (itoa (_ConvertColorStringToNumber sSelText))
  )
  (dcl_Control_SetText TestColorCombo_Main_TextBox2 sSelText)
  (dcl_Control_SetText TestColorCombo_Main_TextBox3 "")
)
;;;------------------------------------------------------------------
;;;------------------------------------------------------------------
;;;
(defun c:TestColorCombo_Main_DoIt_OnClicked
       (/ TextValue ColorNumber tmp)
  (Setq TextValue   (dcl_Control_GetText TestColorCombo_Main_TextBox3)
        ColorNumber (if (numberp (setq tmp (read TextValue)))
                      tmp
                      256
                    )
        ColorNumber (if (and (>= ColorNumber 0) (<= ColorNumber 256))
                      ColorNumber
                      256
                    )
  )
  (_ResetComboBox ColorNumber)
)
;;;------------------------------------------------------------------
;;;------------------------------------------------------------------
;;;
































































;;;  
;;;     (if (> 0 (atoi sValue)

;;;  
;;;     (Setq rValue (dcl_ComboBox_SelectString TestColorCombo_Main_ComboBox1 
;;;	 (strcat "Color " sValue)))
;;;  





;;;------------------------------------------------------------------
;;;------------------------------------------------------------------
;;;
;|«Visual LISP© Format Options»
(70 2 45 2 nil "end of " 70 60 0 0 0 nil nil nil T)
;*** DO NOT add text below the comment! ***|;
