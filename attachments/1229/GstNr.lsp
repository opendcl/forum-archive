;Test-Version:
(defun C:GNR ()
  (command "OPENDCL")
  (dcl_Project_Load "GstNr" T)

  (defun c:GstNr_GstForm_OnInitialize (/)
    (dcl_Control_SetText GstNr_GstForm_TextBoxKG "19144")
    (dcl_Control_SetText GstNr_GstForm_TextBoxSN "123")
    (dcl_Control_SetText GstNr_GstForm_TextBoxUS "-")
    (dcl_Control_SetText GstNr_GstForm_TextBoxUN "4")
    (dcl_Control_SetValue GstNr_GstForm_CheckGK 1)
  ); c:GstNr_GstForm_OnInitialize

  (dcl_Form_Show GstNr_GstForm)
  
  (princ)
); GNR

(defun c:GstNr_GstForm_OnCancelClose (intIsESC /)
  (/= intIsESC 1) ;; damit wird der Dialog nicht geschlossen, wenn ENTER io einem Textfeld gedrückt wird.
); c:GstNr_GstForm_OnCancelClose

(defun c:GstNr_GstForm_TextBoxKG_OnSetFocus (/)
  (set_focus GstNr_GstForm_TextBoxKG)
); c:GstNr_GstForm_TextBoxKG_OnSetFocus

(defun c:GstNr_GstForm_TextBoxSN_OnSetFocus (/)
  (set_focus GstNr_GstForm_TextBoxSN)
); c:GstNr_GstForm_TextBoxSN_OnSetFocus

(defun c:GstNr_GstForm_TextBoxUS_OnSetFocus (/)
  (set_focus GstNr_GstForm_TextBoxUS)
); c:GstNr_GstForm_TextBoxUS_OnSetFocus

(defun c:GstNr_GstForm_TextBoxUN_OnSetFocus (/)
  (set_focus GstNr_GstForm_TextBoxUN)
); c:GstNr_GstForm_TextBoxUN_OnSetFocus

(defun set_focus (oControl)
  (dcl_Control_SetBackColor oControl 2)
  (dcl_Control_SetForeColor oControl 1)
); set_focus



(defun c:GstNr_GstForm_TextBoxKG_OnKillFocus (/)
  (kill_focus GstNr_GstForm_TextBoxKG)
); c:GstNr_GstForm_TextBoxKG_OnKillFocus

(defun c:GstNr_GstForm_TextBoxSN_OnKillFocus (/)
  (kill_focus GstNr_GstForm_TextBoxSN)
); c:GstNr_GstForm_TextBoxSN_OnKillFocus

(defun c:GstNr_GstForm_TextBoxUS_OnKillFocus (/)
  (kill_focus GstNr_GstForm_TextBoxUS)
); c:GstNr_GstForm_TextBoxUS_OnKillFocus

(defun c:GstNr_GstForm_TextBoxUN_OnKillFocus (/)
  (kill_focus GstNr_GstForm_TextBoxUN)
); c:GstNr_GstForm_TextBoxUN_OnKillFocus

(defun kill_focus (oControl)
  (dcl_Control_SetBackColor oControl -6)
  (dcl_Control_SetForeColor oControl -19)
); kill_focus

(defun c:GstNr_GstForm_OKButton_OnClicked ()
  (setq dl (list (dcl_Control_GetText GstNr_GstForm_TextBoxKG)
                 (dcl_Control_GetText GstNr_GstForm_TextBoxSN)
                 (dcl_Control_GetText GstNr_GstForm_TextBoxUS)
                 (dcl_Control_GetText GstNr_GstForm_TextBoxUN)
                 (dcl_Control_GetValue GstNr_GstForm_CheckGK)
           )
  )
  (dcl_Form_Close GstNr_GstForm)
)

(defun c:GstNr_GstForm_EXButton_OnClicked ()
  (dcl_Form_Close GstNr_GstForm)
)


(defun C:-GNR () (dcl_Project_Unload "GstNr" T) (princ))
