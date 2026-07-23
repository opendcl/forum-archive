(defun c:lvdrag (/

		 oDoc
		 oText
		 oLayer
		 oBlock
		 lstDrag
		 oLayers
		 oBlocks
		 intDrag
		 strLayer
		 strBlock
		 lstProps
		 oOldLayer
		 varOrigin
		 setActive
		 lstColumns
		 
		 ok
		 event
		 filllist
		 isSelected
		 clean_block
		 update_lists
		 update_block

		 c:lvdrag_form_OnInitialize
		 c:lvdrag_form_OnCancelClose
		 c:lvdrag_form_lst_prop_OnDblClicked
		 c:lvdrag_form_lst_prop_OnMouseMove
		 c:lvdrag_form_lst_prop_OnDragnDropBegin
		 c:lvdrag_form_lst_prop_OnDragOverFromControl
		 c:lvdrag_form_lst_prop_OnDragnDropFromControl
		 c:lvdrag_form_lst_desc_OnDblClicked
		 c:lvdrag_form_lst_desc_OnDragnDropBegin
		 c:lvdrag_form_lst_desc_OnDragOverFromControl
		 c:lvdrag_form_lst_desc_OnDragnDropFromControl
		 c:lvdrag_form_lst_desc_OnMouseMove
		 )


  ;; =========================== Common functions
  
  (defun ok (fun arg / err)
    (if (vl-catch-all-error-p (setq err (vl-catch-all-apply fun arg)))
      nil
      err
    ); if
  ); ok

  (defun event (strLine)
    (dcl_Control_SetText lvdrag_form_edt_events (vl-string-trim "\r\n" (strcat (dcl_Control_GetText lvdrag_form_edt_events) "\r\n" strLine)))
    (dcl_TextBox_LineScroll lvdrag_form_edt_events (dcl_TextBox_GetLineCount lvdrag_form_edt_events))
  ); strLine

  (defun clean_block (/ oObj)
    (vlax-for oObj oBlock (ok 'vla-erase (list oObj)))
  ); clean_obj

  (defun isSelected (lstItem) (member (car lstItem) lstProps))

  (defun filllist (oControl lstList)
    (if lstList
      (dcl_listview_filllist oControl (mapcar 'list (mapcar 'car lstList) (mapcar 'cadr lstList)))
      (dcl_listview_clear oControl)
    ); if
  ); filllist

  (defun update_lists (intUpd)
    (if (= (logand intUpd 1) 1)
      (filllist lvdrag_form_lst_prop (vl-remove-if 'isSelected lstAllProps))
    ); if
    (if (= (logand intUpd 2) 2)
      (filllist lvdrag_form_lst_desc (mapcar '(lambda (strProp) (assoc strProp lstAllProps)) lstProps))
    ); if
  ); update_lists

  (defun update_block (/ strText strProp lstItem)
    (setq strText "{")
    (foreach strProp lstProps
      (setq lstItem (assoc strProp lstAllProps))
      (setq strText (strcat strText "\\fArial|b1|i0|c0|p34;" (cadr lstItem) ":\\fArial|b0|i0|c0|p34;\t" (last lstItem) "\\P"))
    ); foreach
    (ok 'vla-put-TextString (list oText (strcat (vl-string-trim "\\P" strText) "}")))
    (ok 'vla-update (list oBlock))
    (dcl_BlockView_RefreshBlock lvdrag_form_bv_prev)
    (dcl_BlockView_DisplayBlock lvdrag_form_bv_prev strBlock 0 1.0)
  ); update_block
  
  ;; =========================== Set variables
  
  (defun c:lvdrag_form_OnInitialize (/)
    (dcl_Control_SetProperty lvdrag_form_lst_prop "MouseMove" "")
    (dcl_Control_SetProperty lvdrag_form_lst_desc "MouseMove" "")
    (dcl_ListView_AddColumns lvdrag_form_lst_prop lstColumns)
    (dcl_ListView_AddColumns lvdrag_form_lst_desc lstColumns)
    (dcl_BlockView_DisplayBlock lvdrag_form_bv_prev strBlock 0 1.0)
    (update_lists 3)
    (update_block)
    (dcl_Control_SetText lvdrag_form_edt_events "")
  ); c:lvdrag_form_OnInitialize

  (defun c:lvdrag_form_OnCancelClose (intIsESC /)
    (event "OnCancelClose")
    (/= intIsESC 1)
  ); c:lvdrag_form_OnCancelClose

  (defun c:lvdrag_form_lst_prop_OnDblClicked (intRow intColumn / strProp)
    (setq lstDrag nil)
    (event (strcat "lst_prop_OnDblClicked" (vl-prin1-to-string (list intRow intColumn))))
    (if (and intRow (>= intRow 0)
	     (setq strProp (dcl_ListView_GetItemText lvdrag_form_lst_prop intRow 0))
	     (not (member strProp lstProps)))
      (progn
	(setq lstProps (reverse (cons strProp (reverse lstProps))))
	(update_lists 3)
	(update_block)
      ); progn
    ); if
    (dcl_Control_SetProperty lvdrag_form_lst_prop "MouseMove" "")
  ); c:lvdrag_form_lst_prop_OnDblClicked

  (defun c:lvdrag_form_lst_prop_OnMouseMove (intFlags intX intY /)
    (event (strcat "lst_prop_OnMouseMove" (vl-prin1-to-string (list intFlags intX intY))))
    (if (and lstDrag (= intFlags 1)) (c:lvdrag_form_lst_prop_OnDblClicked (car lstDrag) 0))
    (dcl_Control_SetProperty lvdrag_form_lst_prop "MouseMove" "")
  ); c:lvdrag_form_lst_prop_OnMouseMove

  (defun c:lvdrag_form_lst_prop_OnDragnDropBegin (/ intRow strProp)
    (event "lst_prop_OnDragnDropBegin")
    (if (and (setq intRow (dcl_ListView_GetCurSel lvdrag_form_lst_prop))
	     (not (minusp intRow))
	     (setq strProp (dcl_ListView_GetItemText lvdrag_form_lst_prop intRow 0))
	     (not (member strProp lstProps))
	     (setq lstDrag (list intRow strProp)))
      (progn
;;;	(dcl_Control_SetProperty lvdrag_form_lst_prop "MouseMove" "c:lvdrag_form_lst_prop_OnMouseMove")
	2
      ); progn
      0
    ); if
  ); c:lvdrag_form_lst_prop_OnDragnDropBegin

  (defun c:lvdrag_form_lst_prop_OnDragOverFromControl (strProjectName strFormName strControlName uDropPoint /)
    (event (strcat "lst_prop_OnDragOverFromControl" (vl-prin1-to-string (list strProjectName strFormName strControlName uDropPoint))))
    (if (and (= strProjectName "lvdrag")
	     (= strFormName "form")
	     (= strControlName "lst_desc")
	     lstDrag)
      2
      0
    ); if
  ); c:lvdrag_form_lst_prop_OnDragOverFromControl

  (defun c:lvdrag_form_lst_prop_OnDragnDropFromControl (strProjectName strFormName strControlName uDropPoint / strProp)
    (event (strcat "lst_prop_OnDragnDropFromControl" (vl-prin1-to-string (list strProjectName strFormName strControlName uDropPoint))))
    (if (and (= strProjectName "lvdrag")
	     (= strFormName "form")
	     (= strControlName "lst_desc")
	     lstDrag
	     (setq strProp (cadr lstDrag)))
      (progn
	(setq lstProps (vl-remove strProp lstProps))
	(update_lists 1)
	(update_block)
      ); progn
    ); if
    (dcl_Control_SetProperty lvdrag_form_lst_prop "MouseMove" "")
    (setq lstDrag nil)
  ); c:lvdrag_form_lst_prop_OnDragnDropFromControl

  (defun c:lvdrag_form_lst_desc_OnDblClicked (intRow intColumn / strProp)
    (setq lstDrag nil)
    (event (strcat "lst_desc_OnDblClicked" (vl-prin1-to-string (list intRow intColumn))))
    (if (and intRow (>= intRow 0)
	     (setq strProp (dcl_ListView_GetItemText lvdrag_form_lst_desc intRow 0))
	     (member strProp lstProps))
      (progn
	(setq lstProps (vl-remove strProp lstProps))
	(update_lists 3)
	(update_block)
      ); progn
    ); if
  ); c:lvdrag_form_lst_desc_OnDblClicked

  (defun c:lvdrag_form_lst_desc_OnDragnDropBegin (/ intRow strProp)
    (event "lst_desc_OnDragnDropBegin")
    (if (and (setq intRow (dcl_ListView_GetCurSel lvdrag_form_lst_desc))
	     (not (minusp intRow))
	     (setq strProp (dcl_ListView_GetItemText lvdrag_form_lst_desc intRow 0))
	     (member strProp lstProps)
	     (setq lstDrag (list intRow strProp)))
      (progn
;;;	(dcl_Control_SetProperty lvdrag_form_lst_desc "MouseMove" "c:lvdrag_form_lst_desc_OnMouseMove")
	2
      ); progn
      0
    ); if
  ); c:lvdrag_form_lst_desc_OnDragnDropBegin

  (defun c:lvdrag_form_lst_desc_OnDragOverFromControl (strProjectName strFormName strControlName uDropPoint /)
    (event (strcat "lst_desc_OnDragOverFromControl" (vl-prin1-to-string (list strProjectName strFormName strControlName uDropPoint))))
    (cond
      ((/= strProjectName "lvdrag") 0)
      ((/= strFormName "form") 0)
      ((not lstDrag) 0)
      ((and (= strControlName "lst_prop")
	    (not (member (cadr lstDrag) lstProps))) 2)
      ((= strControlName "lst_prop") 0)
      ((and (not (setq uDropPoint (car (dcl_ListView_HitPointTest lvdrag_form_lst_desc (fix (car uDropPoint)) (fix (cadr uDropPoint))))))
	    (< (car lstDrag) (dcl_ListView_GetCount lvdrag_form_lst_desc))) 2)
      ((/= (car lstDrag) uDropPoint) 2)
      (T 0)
    ); cond
  ); c:lvdrag_form_lst_desc_OnDragOverFromControl

  (defun c:lvdrag_form_lst_desc_OnDragnDropFromControl (strProjectName strFormName strControlName uDropPoint /)
    (event (strcat "lst_desc_OnDragnDropFromControl" (vl-prin1-to-string (list strProjectName strFormName strControlName uDropPoint))))
    (cond
      ((/= strProjectName "lvdrag") nil)
      ((/= strFormName "form") nil)
      ((not lstDrag) nil)
      ((= strControlName "lst_prop")
       (cond
	 ((not (setq uDropPoint (car (dcl_ListView_HitPointTest lvdrag_form_lst_desc (fix (car uDropPoint)) (fix (cadr uDropPoint))))))
	  (setq lstProps (reverse (cons (cadr lstDrag) (reverse lstProps))))
	  (dcl_messagebox (strcat "AddItem: " (cadr lstDrag)) "Drop")
	  (dcl_ListView_AddItem lvdrag_form_lst_desc (list (cadr lstDrag) (cadr (assoc (cadr lstDrag) lstAllProps))))
	  (update_block))
	 ((zerop uDropPoint)
	  (setq lstProps (cons (cadr lstDrag) lstProps))
	  (dcl_messagebox (strcat "InsertItem: " (cadr lstDrag)) "Drop")
	  (dcl_ListView_InsertItem lvdrag_form_lst_desc uDropPoint (list (cadr lstDrag) (cadr (assoc (cadr lstDrag) lstAllProps))))
	  (update_block))
	 ((setq strProp (nth uDropPoint lstProps))
	  (setq lstProps (append (reverse (cdr (member strProp (reverse lstProps))))
				 (list (cadr lstDrag))
				 (member strProp lstProps)))
	  (dcl_messagebox (strcat "InsertItem: " (cadr lstDrag)) "Drop")
	  (dcl_ListView_InsertItem lvdrag_form_lst_desc uDropPoint (list (cadr lstDrag) (cadr (assoc (cadr lstDrag) lstAllProps))))
	  (update_block))
       )); cond
      ((and (not (setq uDropPoint (car (dcl_ListView_HitPointTest lvdrag_form_lst_desc (fix (car uDropPoint)) (fix (cadr uDropPoint))))))
	    (< (car lstDrag) (dcl_ListView_GetCount lvdrag_form_lst_desc)))
       (setq lstProps (reverse (cons (cadr lstDrag) (reverse (vl-remove (cadr lstDrag) lstProps)))))
       (dcl_messagebox (strcat "AddItem: " (cadr lstDrag)) "Drop")
       (dcl_ListView_AddItem lvdrag_form_lst_desc (list (cadr lstDrag) (cadr (assoc (cadr lstDrag) lstAllProps)))))
      ((/= (car lstDrag) uDropPoint)
       (setq lstProps (vl-remove (cadr lstDrag) lstProps))
       (setq strProp (nth uDropPoint lstProps))
       (setq lstProps (append (reverse (cdr (member strProp (reverse lstProps))))
				 (list (cadr lstDrag))
				 (member strProp lstProps)))
       (dcl_messagebox (strcat "InsertItem: " (cadr lstDrag)) "Drop")
       (dcl_ListView_InsertItem lvdrag_form_lst_desc uDropPoint (list (cadr lstDrag) (cadr (assoc (cadr lstDrag) lstAllProps)))))
    ); cond
    (dcl_messagebox "Finished" "Drop")
    (setq lstDrag nil)
  ); c:lvdrag_form_lst_desc_OnDragnDropFromControl

  (defun c:lvdrag_form_lst_desc_OnMouseMove (intFlags intX intY /)
    (event (strcat "lst_desc_OnMouseMove" (vl-prin1-to-string (list intFlags intX intY))))
    (if (and lstDrag (= intFlags 1))
      (c:lvdrag_form_lst_desc_OnDblClicked (car lstDrag) 0)
      (progn
	(update_lists 2)
	(update_block)
      ); progn
    ); if
    (dcl_Control_SetProperty lvdrag_form_lst_desc "MouseMove" "")
  ); c:lvdrag_form_lst_desc_OnMouseMove


  ;; =========================== Set variables
  
  (if (not vla-get-activedocument) (vl-load-com))  
  (setq oDoc (vla-get-activedocument (vlax-get-acad-object)))
  (setq oBlocks (vla-get-blocks oDoc))
  (setq oLayers (vla-get-layers oDoc))
  (setq oOldLayer (vla-get-ActiveLayer oDoc))
  (setq strLayer "$PREVIEW_LAYER")
  (setq strBlock "$PREVIEW_BLOCK")
  (setq varOrigin (vlax-3d-point (list 0.0 0.0 0.0)))
  (setq lstColumns (list (list "Property" 0 100) (list "Description" 0 200)))
  (setq lstAllProps (list (list "ARE" "Area" "100.0")
			  (list "COL" "Color" "255,255,255")
			  (list "CTR" "Center" "(123 234 567)")
			  (list "LAY" "Layer" "granit_array")
			  (list "LEN" "Length" "123.0")
			  (list "PTS" "Number of points" "22")
			  (list "VAL" "valid geometry" "valid")))
  (setq lstProps (list "LAY" "ARE"))

  ;; =========================== Create temporary layer

  (if (setq oLayer (ok 'vla-item (list oLayers strLayer)))
    (progn
      (ok 'vla-put-freeze (list oLayer :vlax-false))
      (ok 'vla-put-lock (list oLayer :vlax-false))
      (ok 'vla-put-layeron (list oLayer :vlax-true))
    ); progn
    (setq oLayer (vla-add oLayers strLayer))
  ); if

  (if (setq setActive (not (equal oOldLayer oLayer)))
    (vla-put-ActiveLayer oDoc oLayer)
  ); if
  
  ;; =========================== Create temporary block

  (if (setq oBlock (ok 'vla-item (list oBlocks "$PREVIEW_BLOCK")))
    (clean_block)
    (setq oBlock (vla-add oBlocks varOrigin "$PREVIEW_BLOCK"))
  ); if
  (setq oText (vla-AddMText oBlock varOrigin (* 20.0 (getvar "TEXTSIZE")) "{\\fArial;abc}"))
    
  (command "_OPENDCL")
  (dcl_project_load "lvdrag" T)
  (dcl_form_show lvdrag_form)

  (if setActive
    (progn
      (vla-put-ActiveLayer oDoc oOldLayer)
      (ok 'vla-delete (list oBlock))
      (ok 'vla-delete (list oLayer))
    ); progn
  ); if
  (princ)
); lvdrag