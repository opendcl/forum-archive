(vl-load-com)
(defun c:test (/ isActive)
  (if (not modelesscbb_test)
    (dcl_project_load "modelesscbb")
  ); if

  (cond
    ((and (setq isActive (dcl_Form_IsActive modelesscbb_test))
          (dcl_Form_IsVisible modelesscbb_test)) (c:modelesscbb_test_OnInitialize))

    (isActive (dcl_Form_Hide gis_sc_overlap nil) (c:modelesscbb_test_OnInitialize))

    (T (setq isOnInit T) (dcl_form_show modelesscbb_test))
  ); cond

  (princ)
); c:test

(defun c:modelesscbb_test_OnInitialize (/)
  (princ "\nOnInitialize\r")
  (dcl_ComboBox_Clear modelesscbb_test_cbb_text)
  (dcl_ComboBox_Addlist modelesscbb_test_cbb_text (list "Item1" "Item2" "Item3"))
  (setq ***strMyName*** "")
  (dcl_Control_SetText modelesscbb_test_cbb_text "Click here to enter a new name")

  
  (setq isOnInit nil)
); c:modelesscbb_test_OnInitialize

(defun c:modelesscbb_test_OnDocActivated (/)
  (princ "\nOnDocActivated\r")
  (if (or (not ***strMyName***) (= ***strMyName*** ""))
    (c:modelesscbb_test_OnInitialize)
    (progn
      (setq isOnInit T)
      (dcl_Control_SetText modelesscbb_test_cbb_text ***strMyName***)
      (setq isOnInit nil)
    ); progn
  ); if
); c:modelesscbb_test_OnDocActivated

(defun c:modelesscbb_test_OnEnteringNoDocState (/)
  (princ "\nOnEnteringNoDocState\r")
  (dcl_form_close modelesscbb_test)
); c:modelesscbb_test_OnEnteringNoDocState

(defun c:modelesscbb_test_OnCancelClose (intIsESC /)
  (princ "\nOnCancelClose\r")
  (/= intIsESC 1)
); c:modelesscbb_test_OnCancelClose

(defun c:modelesscbb_test_cbb_text_OnDropDown (/)
  (princ "\nOnDropDown\r")
); c:modelesscbb_test_cbb_text_OnDropDown

(defun c:modelesscbb_test_cbb_text_OnEditChanged (strNewValue /)
  (princ "\nOnEditChanged\r")
  (if (and (not isOnInit) (/= (vl-string-trim " " strNewValue) ""))
    (setq ***strMyName*** strNewValue)
  ); if
); c:modelesscbb_test_cbb_text_OnEditChanged

(defun c:modelesscbb_test_cbb_text_OnKillFocus (/ strNewValue)
  (princ "\nOnKillFocus\r")
  (if (and (not isOnInit)
	   (setq strNewValue (dcl_ComboBox_GetTBText modelesscbb_test_cbb_text))
	   (/= (vl-string-trim " " strNewValue) ""))
    (setq ***strMyName*** strNewValue)
  ); if
  (dcl_Control_SetKeepFocus modelesscbb_test nil)
); c:modelesscbb_test_cbb_text_OnKillFocus

(defun c:modelesscbb_test_cbb_text_OnSelChanged (intItemIndex strValue /)
  (princ "\nOnSelChanged\r")
  (setq ***strMyName*** strValue)
); c:modelesscbb_test_cbb_text_OnSelChanged

(defun c:modelesscbb_test_cbb_text_OnSetFocus (/)
  (princ "\nOnSetFocus\r")
  (dcl_Control_SetKeepFocus modelesscbb_test T)
  (if (and (not isOnInit)
	   (= ***strMyName*** ""))
    (dcl_ComboBox_ClearEdit modelesscbb_test_cbb_text)
  ); if
); c:modelesscbb_test_cbb_text_OnSetFocus

(defun c:modelesscbb_test_pb_accept_OnClicked (/)
  (princ "\nOnButtonClicked\r")
  (dcl_form_close modelesscbb_test)
); c:modelesscbb_test_pb_accept_OnClicked

(princ "\nCall TEST to run!\r")
(princ)