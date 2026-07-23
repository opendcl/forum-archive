;;;							;
;;;	kbInsert v1.0					;
;;;	include files:					;
;;;							;
;;;							;
;;;							;

(vl-load-com)

(if (not (vl-bb-ref 'kbInsert))
  (vl-bb-set
    'kbInsert
    (dcl_project_import
      '("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"))))

;;;							;
;;;	Function Subs					;
;;;							;

;(vla-Get-ObjectName(vlax-ename->vla-object(car(entsel))))
(defun kb:CountBlocks( / blkname ret space)
  (setq blkname(kb:ReturnBlocksListBoxCurSel)
	ret 0)
  (if blkName
    (progn
      (setq space(kb:getactivespace))
      (vlax-for i space
	(if (= (vla-Get-ObjectName i)"AcDbBlockReference")
	  (if (= (vla-get-name i) blkName)
	    (setq ret(1+ ret)))
	  )
	)
      (dcl_messagebox (strcat "There are " (itoa ret) " of " blkname) "Count Blocks" 2 1)
      )
    (dcl_messagebox "Select a Block!" "Count Blocks" 2 1)
    )
  (princ ret)
  (princ)
  )

;;;							;
;;;	Control Subs					;
;;;							;

(defun kb:ReturnBlocksListBoxCurSel( / ret sel)
  (setq sel(dcl_ListBox_GetCurSel Blocks_BlockManager_BlocksListBox))
  (if sel 
(setq ret(dcl_ListBox_GetItemText Blocks_BlockManager_BlocksListBox sel))
    (dcl_messagebox "Select a Block!" "Insert" 2 1))
  ret)

;;;							;
;;;	Insert Block					;
;;;	called from form				;
(defun kb:InsertBlock(flag / blkName XValue OValue)
  (if flag
  (setq blkName (kb:ReturnBlocksListBoxCurSel)
	  Blocks_ImportManager_InsertBlockName blkName)
    (setq blkName(getfiled "Select a file" (getvar "dwgprefix") "dwg;dws;dxf" 0)))
  (if blkName
    (progn
      (setq
        XValue(dcl_Control_GetValue Blocks_BlockManager_explodeCheckBox)
        OValue(dcl_Control_GetValue Blocks_BlockManager_OriginCheckBox))
      ;(dcl_Form_Close Blocks_BlockManager)
  (kb:setclayer "0" t)
      (if(= OValue 1)
        (vl-cmdf "_insert" blkName "_scale" 1 "0,0,0" 0)
        (vl-cmdf "_insert" blkName "_scale" 1 pause 0))
      (if (= XValue 1)
        (vla-explode(vlax-ename->vla-object(entlast))))
      (kb:resetClayer)
      )
    )
)

;;;							;
;;;	Form Events					;
;;;							;

(defun c:Blocks_BlockManager_OnInitialize (/ BlockList)
  (dcl_Control_SetText Blocks_BlockManager_SearchTextBox "")
  (dcl_BlockView_Clear Blocks_BlockManager_BlockView)
  (dcl_ListBox_Clear Blocks_BlockManager_BlocksListBox)
  (setq BlockList(kb:ListBlocks))
  (if BlockList(dcl_ListBox_AddList Blocks_BlockManager_BlocksListBox BlockList))
  (if Blocks_ImportManager_InsertBlockName
      (progn
      (dcl_ListBox_SelectString Blocks_BlockManager_BlocksListBox Blocks_ImportManager_InsertBlockName)
      (dcl_BlockView_DisplayBlockToScale Blocks_BlockManager_BlockView Blocks_ImportManager_InsertBlockName)
      (setq Blocks_ImportManager_InsertBlockName nil)))
  )

(defun c:Blocks_BlockManager_OnDocActivated (/)
  (c:Blocks_BlockManager_OnInitialize)
)


;;;							;
;;;	Control Events					;
;;;							;

(defun c:Blocks_BlockManager_BlocksListBox_OnSelChanged (ItemIndexOrCount Value /)
  (dcl_Control_SetText Blocks_BlockManager_SearchTextBox "")
  (dcl_BlockView_DisplayBlockToScale Blocks_BlockManager_BlockView Value)
)

(defun c:Blocks_BlockManager_InsertButton_OnClicked (/)
  (kb:InsertBlock t)
)

(defun c:Blocks_BlockManager_BlocksListBox_OnDblClicked (/)
  (kb:InsertBlock t)
)


(defun c:Blocks_BlockManager_SwapButton_OnClicked (/ blkName)
  (setq blkName(kb:ReturnBlocksListBoxCurSel))
  (if blkName(kb:swap blkname))
)

(defun c:Blocks_BlockManager_DwgButton_OnClicked (/)
  (kb:InsertBlock nil)
)

(defun c:Blocks_BlockManager_FindButton_OnClicked (/ blkName)
  (setq blkName(kb:ReturnBlocksListBoxCurSel))
  (if blkName
  (kb:findblock blkname))
)

(defun c:Blocks_BlockManager_WhatButton_OnClicked (/ ss)
  (setq ss(ssget ":s" '((0 . "INSERT"))))
  (if ss
    (setq blkName(cdr(assoc 2(entget(ssname ss 0))))))
  (dcl_sendString "kbInsert ")
)

(defun c:Blocks_BlockManager_CountButton_OnClicked (/)
  (setq nest(dcl_messagebox "Count only Nested Blocks?" "Nested Blocks" 5 3))
  (cond((= nest 6)
	(kb:CountNestedBlocks))
       ((= nest 7)
	(kb:CountBlocks)))
)

(defun c:Blocks_BlockManager_SearchTextBox_OnEditChanged (NewValue / sel)
  (dcl_ListBox_SetCurSel Blocks_BlockManager_BlocksListBox
    (dcl_ListBox_FindString Blocks_BlockManager_BlocksListBox
      (dcl_Control_GetText Blocks_BlockManager_SearchTextBox)))

  (setq sel(dcl_ListBox_GetCurSel Blocks_BlockManager_BlocksListBox))
  (if sel 
  (dcl_BlockView_DisplayBlockToScale Blocks_BlockManager_BlockView
    (dcl_ListBox_GetItemText Blocks_BlockManager_BlocksListBox
      sel)))
)

(defun c:Blocks_BlockManager_RefreshButton_OnClicked (/)
  (c:Blocks_BlockManager_OnInitialize)
)

(defun c:Blocks_BlockManager_CloseButton_OnClicked (/)
  (dcl_Form_Close Blocks_BlockManager)
)


;;;							;
;;;		Command Interface			;
;;;							;
;;;pgp: kbBlockManager,		*kbBlockManager
(defun c:kbBlockManager	(/)
  (if (not (member "Blocks" (dcl_GetProjects)))
    (dcl_Project_load "Blocks")
    )
  (if dcl_HideErrorMsgBox
    (progn
      (dcl_Form_Show Blocks_BlockManager)
	(c:Blocks_BlockManager_OnInitialize)
      )
    (alert "The OpenDCL arx module did not load!")
    )
  (princ)
  (princ)
  )


;;;		Floating Form				;
;;;		Document Opened				;

(defun kb:Blocks_BlockManager_IsFloating  (/)
  (if dcl_HideErrorMsgBox
    (if (dcl_Form_IsActive Blocks_BlockManager) 
	     (c:kbBlockManager) 
	   )
  (alert "The OpenDCL arx module did not load!"))
  (princ)
  (princ))



(kb:Blocks_BlockManager_IsFloating)


(princ "\nBlock & Insert Tools loaded!")
(princ)