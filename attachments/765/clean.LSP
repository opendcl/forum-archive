;; =============================================================================================================================
;; 							Main-Command								
;; =============================================================================================================================



(defun c:dwgcleanup ()
  (if (vl-bb-ref '***clean_properties***)
    (princ "\nThis program must not be called from a script!\n")
    (progn
      (if (not dcl_getversionex) (command "OPENDCL"))
      (if (not (member "clean" (dcl_getprojects))) (dcl_project_load "clean"))

      (cond
	((not (dcl_Form_IsActive clean_main)) (dcl_Form_Show clean_main))
	((not (dcl_Form_IsVisible clean_main)) (dcl_Form_Hide clean_main nil))
	(T (c:clean_main_OnInitialize))
      ); cond
    ); progn
  ); if
  (princ)
); c:dwgcleanup



(defun c:dwgcleanup_intern (/ lstProps oAcad oDoc)
  (if (setq lstProps (vl-bb-ref '***clean_properties***))
    (progn
      (setq oAcad (vlax-get-acad-object))
      (setq oDoc (vla-get-ActiveDocument oAcad))
      (setq oLayers (vla-get-Layers oDoc))
      (setq oLayer (vla-item oLayers "0"))
      
      (if (cdr (assoc "LA0" lstProps))
	(progn
	  (if (= (vla-get-freeze oLayer) :vlax-true)
	    (progn
	      (vla-put-freeze oLayer :vlax-false)
	      (vla-put-ActiveLayer oDoc oLayer)
	      (clean_add_info "Layer 0 was frozen and is active now")
	    ); progn
	    (if (not (equal (vla-get-ActiveLayer oDoc) oLayer))
	      (progn
		(vla-put-ActiveLayer oDoc oLayer)
		(clean_add_info "Layer 0 is active now")
	      ); progn
	    ); if
	  ); if
	  (if (= (vla-get-LayerOn oLayer) :vlax-false)
	    (progn
	      (vla-put-LayerOn oLayer :vlax-true)
	      (clean_add_info "Layer 0 is on now")
	    ); progn
	  ); if
	); progn
      ); if

      (if (and (cdr (assoc "MOD" lstProps)) (/= (getvar "CTAB") "Model"))
	(progn
	  (clean_add_info "Changing to modelspace...")
	  (vla-put-ActiveSpace oDoc 1)
	); progn
      ); if

      (if (cdr (assoc "ZOE" lstProps))
	(progn
	  (clean_add_info "Zooming to extents...")
	  (vla-zoomextents oAcad)
	); progn
      ); if

      (mapcar 'vlax-release-object (list oLayer oLayers oDoc oAcad))
    ); progn
    (dcl_messagebox (strcat "This command can only be executed by script, " (getvar "LOGINNAME") "!") "Internally cleaning function" 2 4)
  ); if
  (princ)
); c:dwgcleanup_intern



;; =============================================================================================================================
;; 							Dialog-Events								
;; =============================================================================================================================



(defun c:clean_main_OnInitialize (/ strTask intRow lstVer reaVer)
  (princ "\nOnInitialize\n")
  (clean_reset_variables)
  (dcl_Control_SetText clean_main_edt_source "")
  (dcl_Control_SetText clean_main_edt_dest "")
  (dcl_Control_SetValue clean_main_prg_files 0)
  (dcl_ListBox_Clear clean_main_lst_files)
  (dcl_Control_SetCaption clean_main_txt_nofiles "Please select a folder with drawings at first!")
  (dcl_Control_SetVisible clean_main_txt_nofiles T)
  (dcl_Control_SetCaption clean_main_txt_info "Task parameters:")
  (dcl_Control_SetText clean_main_edt_info "")
  (dcl_Control_SetVisible clean_main_edt_info nil)
  (dcl_Control_SetVisible clean_main_grd_task T)
  (dcl_Grid_Clear clean_main_grd_task)
  (foreach strTask (list "Open drawing|with RECOVER" "Change to model| " "Layer 0 is current| " "ZoomExtents| " "Purge all| ")
    (if (setq intRow (dcl_Grid_AddString clean_main_grd_task strTask "|"))
      (dcl_Grid_SetCellStyle clean_main_grd_task intRow 1 1)
    ); if
  ); foreach
  (if (setq intRow (dcl_Grid_AddString clean_main_grd_task "Filename suffix|_backup" "|"))
    (dcl_Grid_SetCellStyle clean_main_grd_task intRow 1 42)
  ); if
  (if (setq intRow (dcl_Grid_AddString clean_main_grd_task "Save as|in current release" "|"))
    (progn
      (dcl_Grid_SetCellStyle clean_main_grd_task intRow 1 18)
      (setq reaVer (atoi (substr (getvar "ACADVER") 1 2)))
      (setq lstVer (vl-remove-if '(lambda (x) (> (car x) reaVer))
		     (list (list 0 "" "in current release")
			   (list 18 "2010" "as DWG 2010")
			   (list 17 "2007" "as DWG 2007")
			   (list 16 "2004" "as DWG 2004")
			   (list 15 "2000" "as DWG 2000")
			   (list 14 "R14" "as DWG R14"))))
      (dcl_Grid_SetCellDropList clean_main_grd_task intRow 1 (mapcar 'last lstVer))
      (vl-bb-set '***clean_dwg_releases*** lstVer)
    ); progn
  ); if
  (dcl_Control_SetKeepFocus clean_main nil)
); c:clean_main_OnInitialize

(defun c:clean_main_OnMouseMovedOff (/)
  (princ "\nOnMouseMovedOff\n")
  (if (not (vl-bb-ref '***clean_labeledit***))
    (if (dcl_Control_GetKeepFocus clean_main) (dcl_Control_SetKeepFocus clean_main nil))
  ); if
); c:clean_main_OnMouseMovedOff

(defun c:clean_main_OnSize (intNewWidth intNewHeight / intWidth)
  (princ "\nOnSize\n")
  (clean_cancel_labeledit)
  (setq intWidth (fix (* 0.5 (- (dcl_Control_GetWidth clean_main_grd_task) 22))))
  (dcl_Grid_SetColumnWidth clean_main_grd_task 0 intWidth)
  (dcl_Grid_SetColumnWidth clean_main_grd_task 1 intWidth)
); c:clean_main_OnSize

(defun c:clean_main_spl_hor_OnSplitterMove (intLeft intTop intWidth intHeight)
  (princ "\nOnSplitterMove\n")
  ;; Will also be called at creation time at dcl_form_show if the controls aren't still created
  (if (and clean_main_txt_info (dcl_Control_GetVisible clean_main_txt_info)) (dcl_Control_Redraw clean_main_txt_info))
  (if (and clean_main_grd_task (dcl_Control_GetVisible clean_main_grd_task)) (dcl_Control_Redraw clean_main_grd_task))
  (if (and clean_main_edt_info (dcl_Control_GetVisible clean_main_edt_info)) (dcl_Control_Redraw clean_main_edt_info))
); c:clean_main_spl_hor_OnSplitterMove

(defun c:clean_main_OnDocActivated (/ lstFiles lstVars lstVar strScript)
  (princ "\nOnDocActivated\n")
  (cond
    ((and (vl-bb-ref '***clean_systemvars***)
	  (setq lstFiles (cdr (vl-bb-ref '***clean_files***))))
     (vl-bb-set '***clean_files*** lstFiles)
     (dcl_Control_SetValue clean_main_prg_files (1+ (dcl_Control_GetValue clean_main_prg_files)))
     (clean_add_info (strcat "\r\n" (vl-filename-base (caar lstFiles)) (vl-filename-extension (caar lstFiles))))
     (if (setq strScript (clean_create_script (car lstFiles)))
       (dcl_sendstring (strcat "_script \"" strScript "\"\n"))
     ))

    ((setq lstVars (vl-bb-ref '***clean_systemvars***))
     (dcl_Control_SetValue clean_main_prg_files (1+ (dcl_Control_GetValue clean_main_prg_files)))
     (clean_add_info "\r\nI reset systemvariables...")
     (foreach lstVar lstVars
       (setvar (car lstVar) (cdr lstVar))
     ); foreach
     (vl-bb-set '***clean_systemvars*** nil)
     (vl-bb-set '***clean_properties*** nil)
     (dcl_Control_SetCaption clean_main_pb_clean "Clean it up now!")
     (dcl_Control_SetCaption clean_main_txt_info "Task parameters:")
     (dcl_Control_SetText clean_main_edt_info "")
     (dcl_Control_SetVisible clean_main_edt_info nil)
     (dcl_Control_SetVisible clean_main_grd_task T)
     (dcl_Control_SetValue clean_main_prg_files 0))
  ); cond
); c:clean_main_OnDocActivated

(defun c:clean_main_OnEnteringNoDocState (/)
  (princ "\nOnEnteringNoDocState\n")
  (dcl_Form_close clean_main)
); c:clean_main_OnEnteringNoDocState

(defun c:clean_main_OnClose ()
  (princ "\nOnClose\n")
  (clean_reset_variables)
); c:clean_main_OnClose

(defun c:clean_main_pb_source (/ strPath strNewPath)
  (clean_cancel_labeledit)
  (if (not (or (and (setq strPath (dcl_Control_GetText clean_main_edt_source))
		    (/= (setq strPath (vl-string-trim " " strPath)) ""))
	       (and (setq strPath (vl-registry-read "HKEY_CURRENT_USER\\Software\\OpenDCL\\CleanUpSample" "SourceFolder"))
		    (clean_find_path strPath))))
    (setq strPath (getvar "DWGPREFIX"))
  ); if
  (if (setq strNewPath (dcl_browsefolder (strcat "Source folder with drawings to clean up\r\nCurrent: " strPath) strPath "" 11))
    (progn
      (dcl_Control_SetText clean_main_edt_source (vl-bb-set '***clean_source_folder*** (setq strNewPath (clean_check_path strNewPath))))
      (vl-registry-write "HKEY_CURRENT_USER\\Software\\OpenDCL\\CleanUpSample" "SourceFolder" strNewPath)
      (setq strNewPath (strcat strNewPath "dwgcleanup\\"))
      (if (not (vl-bb-ref '***clean_dest_folder***)) (dcl_Control_SetText clean_main_edt_dest (vl-bb-set '***clean_dest_folder*** strNewPath)))
      (clean_fill_list)
    ); progn
  ); if
); c:clean_main_pb_source

(defun c:clean_main_edt_source_OnSetFocus (/)
  (clean_cancel_labeledit)
  (clean_activate_keepfocus)
); c:clean_main_edt_source_OnSetFocus

(defun c:clean_main_edt_source (/ strPath lstFiles)
  (clean_cancel_labeledit)
  (cond
    ((and (setq strPath (dcl_Control_GetText clean_main_edt_source))
	  (/= (setq strPath (vl-string-trim " " strPath)) "")
	  (vl-file-directory-p strPath)
	  (clean_find_path strPath))
     (vl-bb-set '***clean_source_folder*** (setq strPath (clean_check_path strPath)))
     (vl-registry-write "HKEY_CURRENT_USER\\Software\\OpenDCL\\CleanUpSample" "SourceFolder" strPath)
     (clean_fill_list))

    ((setq strPath (vl-bb-ref '***clean_source_folder***))
     (dcl_Control_SetText clean_main_edt_source strPath))
  ); cond
); c:clean_main_edt_source

(defun c:clean_main_pb_dest (/ strPath strNewPath)
  (clean_cancel_labeledit)
  (if (not (or (and (setq strPath (dcl_Control_GetText clean_main_edt_dest))
		    (/= (setq strPath (vl-string-trim " " strPath)) ""))
	       (and (setq strPath (vl-registry-read "HKEY_CURRENT_USER\\Software\\OpenDCL\\CleanUpSample" "DestinationFolder"))
		    (clean_find_path strPath))))
    (setq strPath (getvar "DWGPREFIX"))
  ); if
  (if (setq strNewPath (dcl_browsefolder (strcat "Destination folder to save the cleaned files to\r\nCurrent: " strPath) strPath "" 75))
    (progn
      (dcl_Control_SetText clean_main_edt_dest (vl-bb-set '***clean_dest_folder*** (setq strNewPath (clean_check_path strNewPath))))
      (vl-registry-write "HKEY_CURRENT_USER\\Software\\OpenDCL\\CleanUpSample" "DestinationFolder" strNewPath)
    ); progn
  ); if
); c:clean_main_pb_dest

(defun c:clean_main_edt_dest_OnSetFocus (/)
  (clean_cancel_labeledit)
  (clean_activate_keepfocus)
); c:clean_main_edt_dest_OnSetFocus

(defun c:clean_main_edt_dest (/ strPath)
  (clean_cancel_labeledit)
  (cond
    ((and (setq strPath (dcl_Control_GetText clean_main_edt_dest))
	  (/= (setq strPath (vl-string-trim " " strPath)) "")
	  (vl-file-directory-p strPath))
     (vl-bb-set '***clean_dest_folder*** (setq strPath (clean_check_path strPath)))
     (vl-registry-write "HKEY_CURRENT_USER\\Software\\OpenDCL\\CleanUpSample" "DestinationFolder" strPath))
    ((setq strPath (vl-bb-ref '***clean_dest_folder***))
     (dcl_Control_SetText clean_main_edt_dest strPath))
  ); cond
); c:clean_main_edt_dest

(defun c:clean_main_lst_files_OnSetFocus (/)
  (clean_cancel_labeledit)
  (clean_activate_keepfocus)
); c:clean_main_lst_files_OnSetFocus

(defun c:clean_main_lst_files_OnDblClicked (/ intFile strFile strPath strDest strFileComplete)
  (clean_cancel_labeledit)
  (cond
    ((not (setq intFile (car (dcl_ListBox_GetSelectedNths clean_main_lst_files))))
     (dcl_messagebox (strcat "You haven't selected a file yet, " (getvar "LOGINNAME") "!") "File not selected" 2 4))

    ((not (setq strFile (dcl_ListBox_GetText clean_main_lst_files intFile))) nil)

    ((not (setq strPath (vl-bb-ref '***clean_source_folder***)))
     (dcl_messagebox (strcat "You haven't selected a source path yet, " (getvar "LOGINNAME") "!") "Source path not selected" 2 4))

    ((not (setq strDest (vl-bb-ref '***clean_dest_folder***)))
     (dcl_messagebox (strcat "You haven't selected a destination path yet, " (getvar "LOGINNAME") "!") "Destination path not selected" 2 4))

    ((not (findfile (setq strFileComplete (strcat strPath strFile))))
     (dcl_messagebox (strcat "I cannot find the file \"" strFileComplete "\", " (getvar "LOGINNAME") "!") "File not found" 2 4))

    (T (clean_run_script (list strFile)))
  );cond
); c:clean_main_lst_files_OnDblClicked

(defun c:clean_main_pb_clean (/ lstFiles strPath strDest strFileComplete isSelection)
  (clean_cancel_labeledit)
  (cond
    ((vl-bb-ref '***clean_systemvars***)
     (vl-bb-set '***clean_files*** nil)
     (dcl_Control_SetCaption clean_main_pb_clean "Cancelling ..."))
    ((not (or (and (setq lstFiles (dcl_ListBox_GetSelectedItems clean_main_lst_files))
		   (/= lstFiles -1)
		   (setq isSelection T))
	      (setq lstFiles (dcl_Control_GetList clean_main_lst_files))))
     (dcl_messagebox (strcat "You haven't selected a file yet, " (getvar "LOGINNAME") "!") "File not selected" 2 4))

    ((not (setq strPath (vl-bb-ref '***clean_source_folder***)))
     (dcl_messagebox (strcat "You haven't selected a source path yet, " (getvar "LOGINNAME") "!") "Source path not selected" 2 4))

    ((not (setq strDest (vl-bb-ref '***clean_dest_folder***)))
     (dcl_messagebox (strcat "You haven't selected a destination path yet, " (getvar "LOGINNAME") "!") "Destination path not selected" 2 4))

    ((= (dcl_messagebox (strcat "Shall I start cleaning progress for " (if isSelection "the selected" "all") " files, " (getvar "LOGINNAME") "?") "Start progress" 5 3) 6)
     (clean_run_script lstFiles))
  );cond
); c:clean_main_pb_clean

(defun c:clean_main_grd_task_OnSetFocus (/)
  (clean_activate_keepfocus)
); c:clean_main_grd_task_OnSetFocus

(defun c:clean_main_grd_task_OnBeginLabelEdit (intRow intColumn /)
  (vl-bb-set '***clean_labeledit*** T)
); c:clean_main_grd_task_OnBeginLabelEdit

(defun c:clean_main_grd_task_OnEndLabelEdit (intRow intColumn /)
  (vl-bb-set '***clean_labeledit*** nil)
); c:clean_main_grd_task_OnEndLabelEdit




;; =============================================================================================================================
;; 							Sub-Functions								
;; =============================================================================================================================



(defun clean_reset_variables ()
  (vl-bb-set '***clean_files*** nil)
  (vl-bb-set '***clean_source_folder*** nil)
  (vl-bb-set '***clean_dest_folder*** nil)
  (vl-bb-set '***clean_systemvars*** nil)
  (vl-bb-set '***clean_dwg_releases*** nil)
  (vl-bb-set '***clean_properties*** nil)
  (vl-bb-set '***clean_labeledit*** nil)
); clean_reset_variables

(defun clean_activate_keepfocus ()
  (if (not (dcl_Control_GetKeepFocus clean_main)) (dcl_Control_SetKeepFocus clean_main T))
); clean_activate_keepfocus

(defun clean_cancel_labeledit ()
  (if (vl-bb-ref '***clean_labeledit***) (dcl_Grid_CancelCellEdit clean_main_grd_task))
); clean_cancel_labeledit

(defun clean_check_path (strPath)
  (if (/= (substr strPath (strlen strPath)) "\\")
    (setq strPath (strcat strPath "\\"))
  ); if
  strPath
); clean_check_path

(defun clean_find_path (strPath)
  (if (and (> (strlen strPath) 3)
	   (= (substr strPath (strlen strPath)) "\\"))
    (findfile (substr strPath 1 (1- (strlen strPath))))
    (findfile strPath)
  ); if
); clean_find_path

(defun clean_create_path (strPath / oFSObject oFolder)
  (if (not (and (vl-file-directory-p strPath) (clean_find_path strPath)))
    (progn
      (setq oFSObject (vlax-create-object "Scripting.FileSystemObject"))
      (if (vl-catch-all-error-p (setq oFolder (vl-catch-all-apply 'vlax-invoke-method (list oFSObject 'GetFolder strPath))))
	(if (vl-catch-all-error-p (setq oFolder (vl-catch-all-apply 'vlax-invoke-method (list oFSObject 'CreateFolder strPath))))
	  (progn
	    (princ (strcat "\n" (vl-catch-all-error-message oFolder)))
	    (setq oFolder nil)
	    (setq strPath nil)
	  ); progn
	  (vlax-release-object oFolder)
	); if
	(vlax-release-object oFolder)
      ); if
      (vlax-release-object oFSObject)
    ); progn
  ); if
  strPath
); clean_create_path

(defun clean_fill_list (/ strPath)
  (dcl_ListBox_Clear clean_main_lst_files)
  (if (and (setq strPath (vl-bb-ref '***clean_source_folder***))
	   (setq lstFiles (vl-directory-files strPath "*.dwg" 1)))
    (progn
      (dcl_Control_SetVisible clean_main_txt_nofiles nil)
      (dcl_ListBox_AddList clean_main_lst_files lstFiles)
    ); progn
    (progn
      (dcl_Control_SetCaption clean_main_txt_nofiles "There are no drawings in the selected folder!")
      (dcl_Control_SetVisible clean_main_txt_nofiles T)
    ); progn
  ); if
); clean_fill_list

(defun clean_add_info (strText)
  (dcl_Control_SetText clean_main_edt_info (strcat (dcl_Control_GetText clean_main_edt_info) "\r\n" strText))
  (dcl_TextBox_LineScroll clean_main_edt_info (dcl_TextBox_GetLineCount clean_main_edt_info))
); clean_add_info

(defun clean_run_script (lstFiles / strScript isRecover isPurge strSuffix lstVer strVer strPath strDest strTemp isZoom isModel isLayer0)
  (setq isRecover (= (dcl_Grid_GetCellCheckState clean_main_grd_task 0 1) 1)
	isModel (= (dcl_Grid_GetCellCheckState clean_main_grd_task 1 1) 1)
	isLayer0 (= (dcl_Grid_GetCellCheckState clean_main_grd_task 2 1) 1)
	isZoom (= (dcl_Grid_GetCellCheckState clean_main_grd_task 3 1) 1)
	isPurge (= (dcl_Grid_GetCellCheckState clean_main_grd_task 4 1) 1)
	strSuffix (dcl_Grid_GetCellText clean_main_grd_task 5 1)
	lstVer (vl-bb-ref '***clean_dwg_releases***)
	lstVer (mapcar 'cons (mapcar 'last lstVer) (mapcar 'cadr lstVer))
	strVer (dcl_Grid_GetCellText clean_main_grd_task 6 1)
	strVer (cdr (assoc strVer lstVer))
	strVer (if strVer strVer (cadr (assoc (atoi (substr (getvar "ACADVER") 1 2)) (vl-bb-ref '***clean_dwg_releases***)))))
  (if (and (setq strPath (vl-bb-ref '***clean_source_folder***))
	   (clean_find_path strPath)
	   (setq strDest (vl-bb-ref '***clean_dest_folder***))
	   (clean_create_path strDest)
	   (setq lstFiles (vl-remove nil (mapcar '(lambda (strFile) (findfile (strcat strPath strFile))) lstFiles))))
    (if (and (setq lstFiles (mapcar 'cons lstFiles (mapcar '(lambda (strFile) (strcat strDest (vl-filename-base strFile) strSuffix ".dwg")) lstFiles)))
	     (setq strTemp (strcat (clean_check_path (getenv "TEMP")) "dwgcleanup.scr"))
	     (vl-bb-set '***clean_properties***
	       (list (cons "SCR" strTemp) (cons "VER" strVer) (cons "REC" isRecover) (cons "PUR" isPurge)
		     (cons "MOD" isModel) (cons "ZOE" isZoom) (cons "LA0" isLayer0)))
	     (setq strScript (clean_create_script (car lstFiles))))
      (progn
	(vl-bb-set '***clean_files*** lstFiles)
	(dcl_Control_SetMaxValue clean_main_prg_files (length lstFiles))
	(dcl_Control_SetValue clean_main_prg_files 0)
	(dcl_Control_SetCaption clean_main_pb_clean "Stop it now!")
	(dcl_Control_SetCaption clean_main_txt_info "Current progress:")
	(dcl_Control_SetText clean_main_edt_info (strcat "Start progress:\r\n \r\n" (vl-filename-base (caar lstFiles)) (vl-filename-extension (caar lstFiles))))
	(dcl_Control_SetVisible clean_main_edt_info T)
	(dcl_Control_SetVisible clean_main_grd_task nil)
	
	(vl-bb-set '***clean_systemvars*** (list (cons "CMDECHO" (getvar "CMDECHO"))
						 (cons "CMDDIA" (getvar "CMDDIA"))
						 (cons "FILEDIA" (getvar "FILEDIA"))))
	(setvar "FILEDIA" 0)
	(setvar "CMDDIA" 0)
	(setvar "CMDECHO" 0)
	(dcl_sendstring (strcat "_script \"" strScript "\"\n"))
      ); progn
    ); if
    (dcl_messagebox (strcat "Cleaning has stopped because none of the " (itoa (length lstFiles)) " exist, " (getvar "LOGINNAME") "!") "File not found" 2 4)
  ); if
); clean_run_script

(defun clean_create_script (lstFile / strTemp filTemp lstProps)
  (setq lstProps (vl-bb-ref '***clean_properties***))
  (if (setq filTemp (open (setq strTemp (cdr (assoc "SCR" lstProps))) "w"))
    (progn
      (write-line (if (cdr (assoc "REC" lstProps)) "_recover" "_open") filTemp)
      (write-line (car lstFile) filTemp)
      (if (cdr (assoc "REC" lstProps)) (write-line "" filTemp))
      (write-line "dwgcleanup_intern" filTemp)
      (if (cdr (assoc "PUR" lstProps)) (write-line "_purge _all * _N" filTemp))
      (write-line (strcat "_saveas " (cdr (assoc "VER" lstProps))) filTemp)
      (write-line (cdr lstFile) filTemp)
      (if (findfile (cdr lstFile)) (write-line "_y" filTemp))
      (write-line "_close" filTemp)
      (close filTemp)
    ); progn
    (setq strTemp nil)
  ); if
  strTemp
); clean_create_script

(vl-load-com)
(if (not (vl-bb-ref '***clean_properties***))
  (princ "\nRun DWGCLEANUP to start\n")
); if
(princ)