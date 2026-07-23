(defun c:blocklist ()
  (cond
    ((not BlockList_blocklist)
     (dcl_project_load "BlockList")
     (dcl_Form_Show BlockList_blocklist))

    ((and (dcl_Form_IsActive BlockList_blocklist)
	  (not (dcl_Form_IsVisible BlockList_blocklist)))
     (dcl_Form_Hide BlockList_blocklist nil))

    ((not (dcl_Form_IsActive BlockList_blocklist))
     (dcl_Form_Show BlockList_blocklist))
  ); cond
  (princ)
); c:blocklist

(defun c:BlockList_blocklist_OnInitialize (/)
  (dcl_control_setcaption BlockList_blocklist_txt_file "Click the button to select DWG")
  (dcl_BlockList_Reset BlockList_blocklist_lst_blocks)
); c:BlockList_blocklist_OnInitialize

(defun c:BlockList_blocklist_OnEnteringNoDocState (/)
  (dcl_Form_Close BlockList_blocklist)
); c:BlockList_blocklist_OnEnteringNoDocState

(defun c:BlockList_blocklist_pb_file_OnClicked (/ strFile)
  (vl-load-com)
  (if (and (setq strFile (vl-catch-all-apply 'getfiled (list "Select drawing" (getvar "DWGPREFIX") "dwg" 0)))
	   (not (vl-catch-all-error-p strFile)))
    (progn
      (dcl_BlockList_Reset BlockList_blocklist_lst_blocks)
      (dcl_BlockList_LoadDwg BlockList_blocklist_lst_blocks strFile)
      (dcl_control_setcaption BlockList_blocklist_txt_file (strcat "Current DWG: " (vl-filename-base strFile) ".dwg"))
    ); progn
  ); if
); c:BlockList_blocklist_pb_file_OnClicked