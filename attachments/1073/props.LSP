(defun c:props ()
  (command "_opendcl")
  (dcl_project_load "props")
  (if (not (dcl_Form_IsActive props_lst)) (dcl_form_show props_lst))
  (princ)
); propps


(defun c:props_lst_OnDocActivated (/)
  (dcl_form_close props_lst)
); c:props_lst_OnDocActivated


(defun c:props_lst_OnEnteringNoDocState (/)
  (dcl_form_close props_lst)
); c:props_lst_OnEnteringNoDocState


(defun c:props_lst_OnInitialize (/ intRow)
  (if (setq intRow (dcl_Grid_AddString props_lst_grd "Draw Punch"))
    (progn
      (dcl_Grid_SetCellStyle props_lst_grd intRow 1 18)
      (dcl_Grid_SetCellDropList props_lst_grd intRow 1 (list "No punch" "Soldify punch" "Soldify Dayton punches" "Modify headed punch"))
      (dcl_Grid_SetCellText props_lst_grd intRow 1 "No punch")
    ); progn
  ); if

  (if (setq intRow (dcl_Grid_AddString props_lst_grd "Draw Retainer"))
    (progn
      (dcl_Grid_SetCellStyle props_lst_grd intRow 1 18)
      (dcl_Grid_SetCellDropList props_lst_grd intRow 1 (list "No retainer" "Soldify retainer"))
      (dcl_Grid_SetCellText props_lst_grd intRow 1 "No retainer")
    ); progn
  ); if

  (if (setq intRow (dcl_Grid_AddString props_lst_grd "Backing plate"))
    (progn
      (dcl_Grid_SetCellStyle props_lst_grd intRow 1 1)
      (dcl_Grid_SetCellText props_lst_grd intRow 1 "Make backing plate")
      (dcl_Grid_SetCellStyle props_lst_grd intRow 1 1)
    ); progn
  ); if

  (if (setq intRow (dcl_Grid_AddString props_lst_grd "Stock guides"))
    (progn
      (dcl_Grid_SetCellStyle props_lst_grd intRow 1 1)
      (dcl_Grid_SetCellText props_lst_grd intRow 1 "Draw stock guides")
      (dcl_Grid_SetCellStyle props_lst_grd intRow 1 1)
    ); progn
  ); if
  (setq lstCellContent nil)
); c:props_lst_OnInitialize


(defun c:props_lst_OnSize (intNewWidth intNewHeight /)
  (setq intNewWidth (fix (* (- intNewWidth 38) 0.5)))
  (dcl_Grid_SetColumnWidth props_lst_grd 0 intNewWidth)
  (dcl_Grid_SetColumnWidth props_lst_grd 1 intNewWidth)
); c:props_lst_OnSize


(defun c:props_lst_grd_OnBeginLabelEdit (intRow intCol /)
  (setq lstCellContent (list intRow intCol
			     (dcl_Grid_GetCellText props_lst_grd intRow intCol)
			     (dcl_Grid_GetCellCheckState props_lst_grd intRow intCol)))
); c:props_lst_grd_OnBeginLabelEdit


(defun c:props_lst_grd_OnButtonClicked (intRow intColumn /)
  (setq lstCellContent nil)
); c:props_lst_grd_OnButtonClicked


(defun c:props_lst_grd_OnEndLabelEdit (intRow intColumn /)
  (setq lstCellContent nil)
); c:props_lst_grd_OnEndLabelEdit


(defun c:props_lst_grd_OnSelChanged (intRow intColumn /)
  (setq lstCellContent nil)
); c:props_lst_grd_OnSelChanged

