(defun c:Test ()
  (vl-load-com)
  (command "OPENDCL")
  (Setq temp_folder "c:\\temp")
  (dcl_Project_Load "QLook.odcl" T)
  (Dcl_Form_Show QLook_QLook)
)



(defun c:QLook_QLook_OnInitialize (/ dwg_list)
  (Dcl_ListView_Clear QLook_QLook_ListView1)
  (Dcl_ListView_AddColumns QLook_QLook_ListView1 (list (list "Drawings   " 0 600)))
  (setq dwg_list (vl-directory-files temp_folder "*.dwg" 1))
  (if (/= dwg_list nil) (foreach N DWg_List 
                      (Dcl_ListView_AddItem QLook_QLook_ListView1 0 (strcat temp_folder "\\" N))
                      )
 )
)



(defun c:QLook_QLook_DwgPreview1_OnDblClicked ( / rvalue)
  (Setq rValue (Dcl_DwgPreview_GetDwgName QLook_QLook_DwgPreview1))
  (Dcl_Form_Close QLook_QLook)

  (vla-activate (vla-open (vla-get-documents (vlax-get-acad-object)) rvalue))
)

(defun c:QLook_QLook_TextButton1_OnClicked (/)
  (Dcl_Form_Close QLook_QLook)
)



(defun c:QLook_QLook_ListView1_OnClicked (Row Column /)
  (Setq sSelText (Dcl_ListView_GetItemText QLook_QLook_ListView1 Row Column))
  (Dcl_DwgPreview_LoadDwg QLook_QLook_DwgPreview1 sSelText)
)

