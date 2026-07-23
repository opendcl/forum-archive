;;; ===================================================================================================
;;;					   Blocklist-Sample					       
;;; ===================================================================================================










; *****************************************************************************************************
; Command:	blocklist
; Description:	(Re)Starting command
; Author:	Fred Tomke
; Start-Date:	2009-12-11
; Arguments:	none
; Globals:	none
; Notes:	blocklist.odcl and blocklist.lsp have to be placed in a AutoCAD-support folder
; Changes:	none


(defun c:blocklist ()
  (cond
    ((not (or dcl_getprojects
              (and (vl-cmdf "OPENDCL") dcl_getprojects)))
     (blocklist_message "Cannot load OpenDCL!"))

    ((not (or blocklist_blocklist
              (dcl_project_load "blocklist")))
     (blocklist_message "Cannot load OpenDCL-Project!"))

    ((not (dcl_form_IsActive blocklist_blocklist))
     (dcl_form_show blocklist_blocklist))

    ((not (dcl_Form_IsVisible blocklist_blocklist))
     (dcl_Form_Hide blocklist_blocklist nil) (blocklist_update))

    (T (blocklist_update))
  ); cond
  (princ)
); blocklist










;;; ===================================================================================================
;;;					      Modules					       	       
;;; ===================================================================================================










; *****************************************************************************************************
; Function:	blocklist_execute
; Description:	execute an event of the palette, if the palette is active
; Author:	Fred Tomke
; Start-Date:	2009-12-11
; Arguments:	oControl = form object as entity
;		symFunc = function to call
;		lstArg = list of function's arguments
; Ret. values:	not typed, returning value of the function
; Changes:	none


(defun blocklist_execute (oControl symFunc lstArg / uErg)
  (if (and oControl (dcl_Form_IsActive oControl))
    (if (dcl_Form_IsVisible oControl)
      (if symFunc (setq uErg (vl-catch-all-apply symFunc lstArg)))
      (dcl_Form_close oControl)
    ); if
  ); if
  uErg
); blocklist_execute










; *****************************************************************************************************
; Function:	blocklist_message
; Description:	shows messages in the commandline
; Author:	Fred Tomke
; Start-Date:	2009-12-11
; Arguments:	strMsg = message as string
; Ret. values:	not needed
; Changes:	none


(defun blocklist_message (strMsg)
  (if strMsg (princ (strcat "\n" strMsg "\r")))
); blocklist_message










; *****************************************************************************************************
; Function:	blocklist_message
; Description:	resets the blocklist
; Author:	Fred Tomke
; Start-Date:	2009-12-11
; Arguments:	none
; Ret. values:	not needed
; Changes:	none


(defun blocklist_update ()
  (dcl_BlockList_Reset blocklist_blocklist_lst_block)
  (dcl_BlockView_Clear blocklist_blocklist_prv_block)
); blocklist_update










; *****************************************************************************************************
; Function:	blocklist_getselectedblock
; Description:	returns the name of the currently selected block
; Author:	Fred Tomke
; Start-Date:	2009-12-11
; Arguments:	none
; Ret. values:	name of selected block as string
; Changes:	none


(defun blocklist_getselectedblock (/ intItem strBlockName)
  (if (and (setq intItem (dcl_BlockList_GetCurSel blocklist_blocklist_lst_block))
           (not (minusp intItem)))
    (setq strBlockName (dcl_BlockList_GetItemText blocklist_blocklist_lst_block intItem))
  ); if
  strBlockName
); blocklist_getselectedblock










; *****************************************************************************************************
; Function:	blocklist_insert
; Description:	inserts the given block at the given or picked point
; Author:	Fred Tomke
; Start-Date:	2009-12-11
; Arguments:	strBlock = blockname of current drawing as string
;		ptPoint = insertion point in WCS
; Ret. values:	newly inserted block reference object as VLA-Object
; Changes:	none


(defun blocklist_insert (strBlock ptPoint / oDoc strLayer oLayer oLayers oBlockRef)
  (if (or ptPoint
          (and (dcl_setcmdbarfocus)
               (setq ptPoint (vl-catch-all-apply 'getpoint (list "\nPick insertion point: ")))
               (not (vl-catch-all-error-p ptPoint))))
    (progn
      (setq oDoc (vla-get-ActiveDocument (vlax-get-acad-object)))
      (setq oLayers (vla-get-layers oDoc))

      (if (vl-catch-all-error-p (setq oLayer (vl-catch-all-apply 'vla-item (list oLayers "MyBlockLayer"))))
        (setq oLayer (vla-add oLayers "MyBlockLayer"))
      ); if
      
      (setq strLayer (vla-GetVariable oDoc "CLAYER"))
      (vla-put-ActiveLayer oDoc oLayer)
      (setq oBlockRef (vl-catch-all-apply 'vla-insertblock (list (blocklist_currentspace oDoc) (vlax-3d-point ptPoint) strBlock 1 1 1 0.0)))
      (vla-SetVariable oDoc "CLAYER" strLayer)
      (princ "\n")
    ); progn
  ); if
  oBlockRef
); blocklist_insert










; *****************************************************************************************************
; Function:	blocklist_currentspace
; Description:	returns the current AutoCAD-space object as VLA-Object
; Author:	Fred Tomke
; Start-Date:	2009-12-11
; Arguments:	oDoc = document object of current drawing as VLA-Object
; Ret. values:	space object as container block object as VLA-Object
; Changes:	none


(defun blocklist_currentspace (oDoc)
  (if (or (= (vla-get-ActiveSpace oDoc) 1)
          (= (vla-get-MSpace oDoc) :vlax-true))
    (vla-get-ModelSpace oDoc)
    (vla-get-PaperSpace oDoc)
  );if
); blocklist_currentspace










;;; ===================================================================================================
;;;					      Events					       	       
;;; ===================================================================================================










; *****************************************************************************************************
; Event:	c:blocklist_blocklist_OnInitialize
; Event desc.:	Called, when dcl_form_show is executed. Sets initial values to the form and its controls
; Author:	Fred Tomke
; Start-Date:	2009-12-11
; Arguments:	none
; Ret. values:	not needed
; Changes:	none

(defun c:blocklist_blocklist_OnInitialize (/)
  (blocklist_update)
  (dcl_Control_SetDragnDropAllowBegin blocklist_blocklist_lst_block (not (zerop (dcl_Control_GetValue blocklist_blocklist_chb_block))))
); c:blocklist_blocklist_OnInitialize










; *****************************************************************************************************
; Event:	c:blocklist_blocklist_OnEnteringNoDocState
; Event desc.:	Called, when the last document will be closed
; Author:	Fred Tomke
; Start-Date:	2009-12-11
; Arguments:	none
; Ret. values:	not needed
; Changes:	none

(defun c:blocklist_blocklist_OnEnteringNoDocState (/)
  (if (and blocklist_blocklist (dcl_form_IsActive blocklist_blocklist))
    (dcl_form_close blocklist_blocklist)
  ); if
); c:blocklist_blocklist_OnEnteringNoDocState










; *****************************************************************************************************
; Event:	c:blocklist_blocklist_OnDocActivated
; Event desc.:	Called, when the user switches between documents
; Author:	Fred Tomke
; Start-Date:	2009-12-11
; Arguments:	none
; Ret. values:	princ to avoid returning value T
; Changes:	none

(defun c:blocklist_blocklist_OnDocActivated (/)
  (dcl_BlockView_Clear blocklist_blocklist_prv_block)
  (princ)
); c:blocklist_blocklist_OnDocActivated










; *****************************************************************************************************
; Event:	c:blocklist_blocklist_OnMouseEntered
; Event desc.:	Called, when the mouse is moving over the form, KeepFocus shall be turned on to allow Drag&Drop
; Author:	Fred Tomke
; Start-Date:	2009-12-11
; Arguments:	none
; Ret. values:	not needed
; Changes:	none

(defun c:blocklist_blocklist_OnMouseEntered (/)
  (dcl_Control_SetKeepFocus blocklist_blocklist T)
); c:blocklist_blocklist_OnMouseEntered










; *****************************************************************************************************
; Event:	c:blocklist_blocklist_OnMouseMovedOff
; Event desc.:	Called, when the mouse was moved off the form, KeepFocus shall be turned off to allow AutoCollapse
; Author:	Fred Tomke
; Start-Date:	2009-12-11
; Arguments:	none
; Ret. values:	not needed
; Changes:	none

(defun c:blocklist_blocklist_OnMouseMovedOff (/)
  (dcl_Control_SetKeepFocus blocklist_blocklist nil)
); c:blocklist_blocklist_OnMouseMovedOff










; *****************************************************************************************************
; Event:	c:blocklist_blocklist_pb_block_OnClicked
; Event desc.:	Called, when the update-button was clicked
; Author:	Fred Tomke
; Start-Date:	2009-12-11
; Arguments:	none
; Ret. values:	not needed
; Changes:	none

(defun c:blocklist_blocklist_pb_block_OnClicked (/)
  (blocklist_update)
); c:blocklist_blocklist_pb_block_OnClicked










; *****************************************************************************************************
; Event:	c:blocklist_blocklist_chb_block_OnClicked
; Event desc.:	Called, when the toggle was switched
; Author:	Fred Tomke
; Start-Date:	2009-12-11
; Arguments:	intValue = current toggle state as integer
; Ret. values:	not needed
; Changes:	none

(defun c:blocklist_blocklist_chb_block_OnClicked (intValue /)
  (dcl_Control_SetDragnDropAllowBegin blocklist_blocklist_lst_block (not (zerop intValue)))
); c:blocklist_blocklist_chb_block_OnClicked










; *****************************************************************************************************
; Event:	c:blocklist_blocklist_lst_block_OnClicked
; Event desc.:	Called, when a block was selected in the blocklist
; Author:	Fred Tomke
; Start-Date:	2009-12-11
; Arguments:	intItem = index of clicked event as integer
; Ret. values:	not needed
; Changes:	none

(defun c:blocklist_blocklist_lst_block_OnClicked (intItem / strBlockName)
  (if (setq strBlockName (blocklist_getselectedblock))
    (dcl_BlockView_DisplayBlock blocklist_blocklist_prv_block strBlockName 0)
  ); if
); c:blocklist_blocklist_lst_block_OnClicked










; *****************************************************************************************************
; Event:	c:blocklist_blocklist_lst_block_OnDblClicked
; Event desc.:	Called, when a block was doubleclicked in the blocklist
; Author:	Fred Tomke
; Start-Date:	2009-12-11
; Arguments:	intItem = index of doubleclicked event as integer
; Ret. values:	not needed
; Changes:	none

(defun c:blocklist_blocklist_lst_block_OnDblClicked (intItem / strBlockName)
  (if (setq strBlockName (dcl_BlockList_GetItemText blocklist_blocklist_lst_block intItem))
    (blocklist_insert strBlockName nil)
  ); if
); c:blocklist_blocklist_lst_block_OnDblClicked










; *****************************************************************************************************
; Event:	c:blocklist_blocklist_lst_block_OnDragnDropToAutoCAD
; Event desc.:	Called, when a selected block will be dragged and dropped into AutoCAD
; Author:	Fred Tomke
; Start-Date:	2009-12-11
; Arguments:	ptDropPoint = droppoint in ucs as list of doubles
;		intViewport = viewport index as integer
; Ret. values:	not needed
; Changes:	none

(defun c:blocklist_blocklist_lst_block_OnDragnDropToAutoCAD (ptDropPoint intViewport / strBlockName)
  (if (setq strBlockName (blocklist_getselectedblock))
    (blocklist_insert strBlockName ptDropPoint)
  ); if
); c:blocklist_blocklist_lst_block_OnDragnDropToAutoCAD










; *****************************************************************************************************
; Event:	c:blocklist_blocklist_prv_block_OnDblClicked
; Event desc.:	Called, when the BlockView control will be doubleclicked
; Author:	Fred Tomke
; Start-Date:	2009-12-11
; Arguments:	none
; Ret. values:	not needed
; Changes:	none

(defun c:blocklist_blocklist_prv_block_OnDblClicked (/ strBlockName)
  (if (setq strBlockName (blocklist_getselectedblock))
    (blocklist_insert strBlockName nil)
  ); if
); c:blocklist_blocklist_prv_block_OnDblClicked










;;; ===================================================================================================
;;;					      Opening					       	       
;;; ===================================================================================================









(if (not vlax-get-acad-object) (vl-load-com))
(blocklist_execute blocklist_blocklist 'c:blocklist_blocklist_OnDocActivated nil)
(if (or (not blocklist_blocklist) (not (dcl_form_isactive blocklist_blocklist))) (princ "\nType BLOCKLIST to start...\r\n"))
(princ)
