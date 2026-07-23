(defun ls:opendcl:insertblock (/ oProjet )
;;shortcut list
(setq oShortcut
  (list
    (list "1" "C:\\Users\\salon\\Desktop")
    (list "2" "D:\\Programmes\\laplante_saucier-Bricscad\\BLOCK")
    (list "3" "D:\\Programmes\\laplante_saucier-Bricscad\\LSP_BLK")
  )
)
    

;; Main program
(defun LoadBlockPreview (/ cmdecho)

	;; Ensure OpenDCL Runtime is (quietly) loaded
	(setq cmdecho (getvar "CMDECHO"))
	(setvar "CMDECHO" 0)
	(command "_OPENDCL")
	(setvar "CMDECHO" cmdecho)

	;; Load the project
	(setq oProjet(dcl-Project-Load (findfile "LS-BlockPreview.odcl")))
  
	;; Show the main form
	(dcl-Form-Show LS-BlockPreview/BlockPreview)
	(princ)
)

;|«OpenDCL Event Handlers»|;

(defun c:LS-BlockPreview/BlockPreview#OnInitialize (/)
;; addshortcut
  (dcl-Control-SetList LS-BlockPreview/BlockPreview/shortcut (mapcar '(lambda (x) (car x)) oShortcut))
  (dcl-Control-ZOrder LS-BlockPreview/BlockPreview/Insert 1)
  (dcl-BlockView-LoadDwg LS-BlockPreview/BlockPreview/BlockView "")
)

(defun c:DwgPreview_Cancel_Clicked (/)
	(dcl-Project-Unload "LS-BlockPreview" T)
)

(defun c:DwgPreview_Browse_Clicked (/)
  (dcl-ListBox-Dir LS-BlockPreview/BlockPreview/DWGList (setq oBlockPreviewFolder(dcl-SelectFolder "Dossier")) "*.dwg")
)

(defun c:LS-BlockPreview/BlockPreview/Insert#OnClicked (/)
(insertblock)
)

(defun c:LS-BlockPreview/BlockPreview/DWGList#OnSelChanged (ItemIndexOrCount Value /)
  (dcl-BlockView-LoadDwg LS-BlockPreview/BlockPreview/BlockView (setq oBlockPreviewFile(strcat oBlockPreviewFolder "\\" Value)));_ load the DWG
  (dcl-BlockView-Zoom LS-BlockPreview/BlockPreview/BlockView 0.95)
)

(defun c:LS-BlockPreview/BlockPreview/DWGList#OnDblClicked (/)
(insertblock)
)

(defun c:LS-BlockPreview/BlockPreview/shortcut#OnSelChanged (ItemIndexOrCount Value /)
(dcl-ListBox-Dir LS-BlockPreview/BlockPreview/DWGList (setq oBlockPreviewFolder (cadr(nth (dcl-ListBox-GetCurSel LS-BlockPreview/BlockPreview/shortcut) oShortcut))) "*.dwg")
)

(defun insertblock ()
(dcl-Project-Unload "LS-BlockPreview" T)
(command "_INSERT" oBlockPreviewFile "s" (if (= (dcl-Control-GetValue LS-BlockPreview/BlockPreview/BoutonOption1) 1) 1 (getvar "dimscale")))
)
(LoadBlockPreview)
(princ)
)

