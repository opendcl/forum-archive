(defun c:textinput ( / strControl lstLabelEdit cancel_edit
		    c:textinput_textinput_OnInitialize
		    c:textinput_textinput_OnCancelClose
		    c:textinput_textinput_edt_notclose_OnEditChanged
		    c:textinput_textinput_edt_notclose_OnKillFocus
		    c:textinput_textinput_edt_notclose_OnSetFocus
		    c:textinput_textinput_edt_close_OnEditChanged
		    c:textinput_textinput_edt_close_OnKillFocus
		    c:textinput_textinput_edt_close_OnSetFocus
		    c:textinput_textinput_grd_data_OnBeginLabelEdit
		    c:textinput_textinput_grd_data_OnEndLabelEdit
		    c:textinput_textinput_grd_data_OnKillFocus
		    c:textinput_textinput_grd_data_OnSetFocus
		    c:textinput_textinput_pb_close_OnClicked
		    c:textinput_textinput_grd_data_OnSelChanged
		    )

  (defun cancel_edit ()
    (if lstLabelEdit (dcl_Grid_CancelCellEdit textinput_textinput_grd_data))
  ); cancel_edit
  
  (defun c:textinput_textinput_OnInitialize ()
    (dcl_control_settext textinput_textinput_edt_notclose "Line1")
    (dcl_control_settext textinput_textinput_edt_close "Line2")
    (dcl_Grid_AddRow textinput_textinput_grd_data "Line 1" "Line1")
    (dcl_Grid_AddRow textinput_textinput_grd_data "Line 2" "Line2")
  ); c:textinput_textinput_OnInitialize

  (defun c:textinput_textinput_OnCancelClose (intIsESC / bRes)
    (princ (strcat "\nOnCancelClose: " (itoa intIsESC) "\r"))
    (cond
      (lstLabelEdit (cancel_edit) (setq bRes (/= intIsESC 1)))
      ((= strControl "edt_notclose") (setq bRes (/= intIsESC 1)))
    ); cond
    bRes
  ); c:textinput_textinput_OnCancelClose

  (defun c:textinput_textinput_edt_notclose_OnEditChanged (strNewValue /)
    (dcl_Grid_SetCellText textinput_textinput_grd_data 0 1 strNewValue)
  ); c:textinput_textinput_edt_notclose_OnEditChanged

  (defun c:textinput_textinput_edt_notclose_OnKillFocus (/)
    (if (= strControl "edt_notclose") (setq strControl nil))
  ); c:textinput_textinput_edt_notclose_OnKillFocus

  (defun c:textinput_textinput_edt_notclose_OnSetFocus (/)
    (if (/= strControl "edt_notclose") (setq strControl "edt_notclose"))
  ); c:textinput_textinput_edt_notclose_OnSetFocus

  (defun c:textinput_textinput_edt_close_OnEditChanged (strNewValue /)
    (dcl_Grid_SetCellText textinput_textinput_grd_data 1 1 strNewValue)
  ); c:textinput_textinput_edt_close_OnEditChanged

  (defun c:textinput_textinput_edt_close_OnKillFocus (/)
    (if (= strControl "edt_close") (setq strControl nil))
  ); c:textinput_textinput_edt_close_OnKillFocus

  (defun c:textinput_textinput_edt_close_OnSetFocus (/)
    (if (/= strControl "edt_close") (setq strControl "edt_close"))
  ); c:textinput_textinput_edt_close_OnSetFocus

  (defun c:textinput_textinput_grd_data_OnBeginLabelEdit (intRow intCol /)
    (setq lstLabelEdit (list intRow intCol (dcl_grid_getcelltext textinput_textinput_grd_data intRow intCol)))
  ); c:textinput_textinput_grd_data_OnBeginLabelEdit

  (defun c:textinput_textinput_grd_data_OnEndLabelEdit (intRow intCol / strText)
    (cond
      ((not lstLabelEdit) nil)
      ((or (/= intRow (car lstLabelEdit)) (/= intCol (cadr lstLabelEdit))) nil)
      ((not (setq strText (dcl_grid_getcelltext textinput_textinput_grd_data intRow intCol))) nil)
      ((= intRow 0) (dcl_control_settext textinput_textinput_edt_notclose strText))
      ((= intRow 1) (dcl_control_settext textinput_textinput_edt_close strText))
    ); cond
    (setq lstLabelEdit nil)
  ); c:textinput_textinput_grd_data_OnEndLabelEdit

  (defun c:textinput_textinput_grd_data_OnKillFocus (/)
    (if (= strControl "grd_data") (setq strControl nil))
  ); c:textinput_textinput_grd_data_OnKillFocus

  (defun c:textinput_textinput_grd_data_OnSetFocus (/)
    (if (/= strControl "grd_data") (setq strControl "grd_data"))
  ); c:textinput_textinput_grd_data_OnSetFocus

  (defun c:textinput_textinput_grd_data_OnSelChanged (intRow intCol /)
    (cond
      (lstLabelEdit nil)
      ((< intCol 1) (dcl_Grid_StartCellEdit textinput_textinput_grd_data intRow 1))
    ); cond
  ); c:textinput_textinput_grd_data_OnSelChanged


  (defun c:textinput_textinput_pb_close_OnClicked (/)
    (dcl_form_close textinput_textinput)
  ); c:textinput_textinput_pb_close_OnClicked

  (command "OPENDCL")
  (dcl_project_load "textinput")
  (dcl_form_show textinput_textinput)
  
  (princ)
); textinput