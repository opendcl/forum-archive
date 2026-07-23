(defun c:layerorder ()
  (cond
    ((not (or dcl_project_load (and (vl-cmdf "OPENDCL") dcl_project_load)))
     (princ "\nCannot load OpenDCL!\r"))
    ((not (or (member "layerorder" (dcl_getprojects))
	      (dcl_project_load "layerorder")))
     (princ "\nCannot load OpenDCL-projectfile!\r"))
    ((not (dcl_Form_IsActive layerorder_layerorder))
     (dcl_Form_Show layerorder_layerorder))
    (T (layerorder_layerorder_update))
  ); cond
  (princ)
); c:layerorder

(defun layerorder_layerorder_info (strMsg)
  (if (and layerorder_layerorder_edt_info strMsg)
    (progn
      (dcl_control_settext layerorder_layerorder_edt_info (strcat (dcl_control_gettext layerorder_layerorder_edt_info) "\r\n" strMsg))
      (dcl_TextBox_LineScroll layerorder_layerorder_edt_info (dcl_TextBox_GetLineCount layerorder_layerorder_edt_info))
    ); progn
  ); if
); layerorder_layerorder_info

(defun layerorder_layerorder_update (/ lstLayer oLayer intLen intItem intRow)
  (if layerorder_layerorder_lst_layer
    (progn
      ;; old layers
      (repeat (setq intLen (dcl_ListView_GetCount layerorder_layerorder_lst_layer))
	(setq intItem (dcl_ListView_GetItemData layerorder_layerorder_lst_layer (setq intLen (1- intlen))))
	(setq lstLayer (cons (cons intItem intLen) lstLayer))
      ); repeat

      ; new layers
      (vlax-for oLayer (vla-get-layers (vla-get-activedocument (vlax-get-acad-object)))
	(setq intItem (vla-get-objectID oLayer))
	(if (setq lstItem (assoc intItem lstLayer))
	  (dcl_ListView_SetItemText layerorder_layerorder_lst_layer (cdr lstItem) 0 (vla-get-name oLayer))
	  (if (setq intRow (dcl_ListView_AddItem layerorder_layerorder_lst_layer (list 0 (vla-get-name oLayer))))
	    (dcl_ListView_SetItemData layerorder_layerorder_lst_layer intRow intItem)
	  ); if
	); if
      ); vlax-for
    ); progn
  ); if
); layerorder_layerorder_update

(defun c:layerorder_layerorder_OnInitialize (/)
  (dcl_ListView_AddColumns layerorder_layerorder_lst_layer (list (list "Layer" 0 100 0)))
  (dcl_control_settext layerorder_layerorder_edt_info "")
  (dcl_Control_SetVisible layerorder_layerorder_pgb nil)
  (layerorder_layerorder_update)
); c:layerorder_layerorder_OnInitialize


(defun c:layerorder_layerorder_OnSize (intNewWidth intNewHeight /)
  (if layerorder_layerorder_lst_layer
    (dcl_ListView_SetColumnWidth layerorder_layerorder_lst_layer 0 (- intNewWidth 38))
  ); if
); c:layerorder_layerorder_OnSize


(defun c:layerorder_layerorder_OnMouseEntered (/)
  (layerorder_layerorder_info "OnMouseEntered")
  (layerorder_layerorder_update)
); c:layerorder_layerorder_OnMouseEntered


(defun c:layerorder_layerorder_OnDocActivated (/)
  (layerorder_layerorder_info "OnDocActivated")
  (layerorder_layerorder_update)
); c:layerorder_layerorder_OnDocActivated


(defun c:layerorder_layerorder_OnEnteringNoDocState (/)
  (if (and layerorder_layerorder (dcl_Form_IsActive layerorder_layerorder))
    (dcl_Form_close layerorder_layerorder)
  ); if
); c:layerorder_layerorder_OnEnteringNoDocState


(defun c:layerorder_layerorder_lst_layer_OnDblClicked (intRow intColumn /)
  (layerorder_layerorder_info "OnDblClicked")
); c:layerorder_layerorder_lst_layer_OnDblClicked


(defun c:layerorder_layerorder_lst_layer_OnKeyDown (strCharacter intRepeatCount intFlags /)
  (layerorder_layerorder_info "OnKeyDown")
); c:layerorder_layerorder_lst_layer_OnKeyDown


(defun c:layerorder_layerorder_lst_layer_OnKeyUp (strCharacter intRepeatCount intFlags /)
  (layerorder_layerorder_info "OnKeyUp")
); c:layerorder_layerorder_lst_layer_OnKeyUp


(defun c:layerorder_layerorder_lst_layer_OnDragnDropBegin (/)
  (layerorder_layerorder_info "OnDragnDropBegin")
  1
); c:layerorder_layerorder_lst_layer_OnDragnDropBegin


(defun c:layerorder_layerorder_lst_layer_OnDragnDropFromControl (strProjectName strFormName strControlName uDropPoint /)
  (layerorder_layerorder_info "OnDragnDropFromControl")
); c:layerorder_layerorder_lst_layer_OnDragnDropFromControl

(vl-load-com)
(princ "\nLayerorder sample: type LAYERORDER to start!\r")
(princ)