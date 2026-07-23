(defun C:ODCL8UPDATE (/ odcl8-update in-files lsp-file odcl-project-key odcl-password)
	(command "_OPENDCL")
	(vl-load-com)

	(defun odcl8-update (lsp-file odcl-file odcl-project-key odcl-password /
											 lispfh 1line lisplines odclkey formkey formkeys controlkey oldpath newpath
											 get-keyname change-events tabstrip-p tabparent-p whitespace-p replace-str
											 controls events methods fso)

		; read the lisp file and store each line in lisplines
		(if (not (setq lispfh (open (setq lsp-file (findfile lsp-file)) "r"))) (exit))
		(while (setq 1line (read-line lispfh)) (setq lisplines (cons 1line lisplines)))
		(close lispfh)
		(setq lisplines (reverse lisplines))

		; read the odcl file and store each (old new) control path in controls and (old new) event names in events
		(defun get-keyname (control / varname)
			(cond
				( (and
						(member "VarName" (dcl-control-getproperties control))
						(setq varname (dcl-control-getvarname control))
						(/= "" varname)
					)
					varname
				)
				( (and
						(setq varname (dcl-control-getname control))
						(/= "" varname)
					)
					varname
				)
			)
		)
		(defun change-events (control oldprefix newprefix / eventprops controlprops oldname newname events)
			(setq eventprops
				'(
					"BeginLabelEdit"
					"ButtonClicked"
					"Cancel"
					"CancelClose"
					"Changed"
					"Clicked"
					"Close"
					"ColumnClick"
					"DblClicked"
					"DeleteItem"
					"DocActivated"
					"DocumentComplete"
					"DragnDropBegin"
					"DragnDropFromControl"
					"DragnDropFromOther"
					"DragnDropToAutoCAD"
					"DropDown"
					"EditChanged"
					"EndLabelEdit"
					"EnteringNoDocState"
					"FolderChanged"
					"GetDayState"
					"Help"
					"Initialize"
					"ItemExpanded"
					"ItemExpanding"
					"KeyDown"
					"KeyUp"
					"KillFocus"
					"MaxText"
					"MouseDblClick"
					"MouseDown"
					"MouseEntered"
					"MouseMove"
					"MouseMovedOff"
					"MouseUp"
					"MouseWheel"
					"Move"
					"NavigationComplete"
					"Ok"
					"OptionsApply"
					"OptionsCancel"
					"OptionsHelp"
					"OptionsOk"
					"Paint"
					"RightClick"
					"RightDblClick"
					"ReleasedCapture"
					"ReturnPressed"
					"Scroll"
					"Scrolled"
					"SelChanged"
					"SelChanging"
					"Select"
					"SetFocus"
					"Show"
					"Size"
					"SplitterMove"
					"Timer"
					"TypeChanged"
					"Update"
				)
			)
			(setq controlprops (dcl-control-getproperties control))
			(foreach event eventprops
				(if
					(and
						(member event controlprops)
						(setq oldname (dcl-control-getproperty control event))
						(= (strcase oldname) (strcase (strcat oldprefix event)))
					)
					(progn
						(setq newname (strcat newprefix event))
						(setq events (cons (cons oldname newname) events))
						(dcl-control-setproperty control event newname)
					)
				)
			)
			events
		)
		(defun tabstrip-p (control)
			(or (member "TabCaptionList" (dcl-control-getproperties control)))
		)
		(defun tabparent-p (form / controls cnt found)
			(setq controls (dcl-form-getcontrols form))
			(setq cnt (length controls))
			(while (and (not found) (>= (setq cnt (1- cnt)) 0))
				(setq found (tabstrip-p (nth cnt controls)))
			)
			found
		)
		(defun whitespace-p (in)
			(= "" (vl-string-trim "\t \n()'" in))
		)
		(defun replace-str (new old in standalone / pos)
			(cond
				( (setq pos (vl-string-search (strcase old) (strcase in)))
					(if (or (not standalone) (and (or (zerop pos) (whitespace-p (substr in pos 1))) (whitespace-p (substr in (+ pos 1 (strlen old)) 1))))
						(replace-str new old (strcat (substr in 1 pos) new (substr in (+ pos 1 (strlen old)))) standalone)
						(strcat (substr in 1 (1+ pos)) (replace-str new old (substr in (+ 2 pos)) standalone))
					)
				)
				( in
				)
			)
		)
		(setq methods
			'(
				("dcl_AxControl_" . "dcl-AxControl-")
				("dcl_AxObject_" . "dcl-AxObject-")
				("dcl_Animation_" . "dcl-Animation-")
				("dcl_Animate_" . "dcl-Animation-")
				("dcl_BinFile_" . "dcl-BinFile-")
				("dcl_BlockList_" . "dcl-BlockList-")
				("dcl_BlockView_" . "dcl-BlockView-")
				("dcl_Calendar_" . "dcl-Calendar-")
				("dcl_Month_" . "dcl-Calendar-")
				("dcl_ComboBox_" . "dcl-ComboBox-")
				("dcl_Control_" . "dcl-Control-")
				("dcl_DWGList_" . "dcl-DWGList-")
				("dcl_DWGPreview_" . "dcl-DWGPreview-")
				("dcl_FileExplorer_" . "dcl-FileExplorer-")
				("dcl_FileDlg_" . "dcl-FileExplorer-")
				("dcl_Form_" . "dcl-Form-")
				("dcl_ConfigTab_" . "dcl-Form-")
				("dcl_Grid_" . "dcl-Grid-")
				("dcl_Hatch_" . "dcl-Hatch-")
				("dcl_Html_" . "dcl-Html-")
				("dcl_ImageComboBox_" . "dcl-ImageComboBox-")
				("dcl_ListBox_" . "dcl-ListBox-")
				("dcl_ListView_" . "dcl-ListView-")
				("dcl_OptionList_" . "dcl-OptionList-")
				("dcl_PictureBox_" . "dcl-PictureBox-")
				("dcl_ProgressBar_" . "dcl-ProgressBar-")
				("dcl_Project_" . "dcl-Project-")
				("dcl_SlideView_" . "dcl-SlideView-")
				("dcl_TabStrip_" . "dcl-TabStrip-")
				("dcl_Tab_" . "dcl-TabStrip-")
				("dcl_TextBox_" . "dcl-TextBox-")
				("dcl_Tree_" . "dcl-Tree-")
				("(dcl_" . "(dcl-")
			)
		)

		(if (not (setq odclkey (dcl-project-load (setq odcl-file (findfile odcl-file)) T odcl-project-key))) (exit))
		(foreach form (dcl-Project-GetForms odclkey)
			(setq formkeys nil formkey (get-keyname form))
			(if formkey
			  (setq
					formkeys (list formkey)
					controls (cons (cons (setq oldpath (strcat odclkey "_" formkey)) (setq newpath (strcat odclkey "/" formkey))) controls)
					events (append events (change-events form (strcat "c:" oldpath "_On") (strcat "c:" newpath "#On")))
				)
				(foreach form (dcl-Project-GetForms odclkey) ;tab page, so need to try all forms that contain a tabstrip
					(if (tabparent-p form)
						(setq formkeys (cons (get-keyname form) formkeys))
					)
				)
			)
			(foreach formkey formkeys
				(foreach control (dcl-Form-GetControls form)
					(setq controlkey (get-keyname control))
					(setq controls
						(cons
							(cons
								(setq oldpath (strcat odclkey "_" formkey "_" controlkey))
								(setq newpath (strcat odclkey "/" formkey "/" controlkey))
							)
							controls
						)
					)
					(setq events (append events (change-events control (strcat "c:" oldpath "_On") (strcat "c:" newpath "#On"))))
				)
			)
		)

		; make backup copies of the original files
		(if (not (setq fso (vlax-create-object "Scripting.FileSystemObject"))) (exit))
		(vlax-invoke-method fso 'CopyFile odcl-file (strcat odcl-file ".7.odcl") :vlax-true)
		(vlax-invoke-method fso 'CopyFile lsp-file (strcat lsp-file ".7.lsp") :vlax-true)
		(vlax-release-object fso)

		(if (not (dcl-project-saveas odclkey odcl-file odcl-password)) (exit))

		(setq lisplines
			(mapcar
				(function
					(lambda (line)
						(foreach event events
							(setq line (replace-str (cdr event) (car event) line nil))
						)
						(foreach control controls
							(setq line (replace-str (cdr control) (car control) line T))
						)
						(foreach method methods
							(setq line (replace-str (cdr method) (car method) line nil))
						)
						line
					)
				)
				lisplines
			)
		)

		(setq lispfh (open lsp-file "w"))
		(foreach line lisplines
			(write-line line lispfh)
		)
		(close lispfh)
	)

	(if (setq in-files (dcl-SelectFiles '("ODCL Projects|*.odcl;*.odcl.lsp") "Select ODCL Projects To Update"))
		(foreach odcl-file in-files
			(setq lsp-file (strcat (vl-filename-directory odcl-file) "\\" (vl-filename-base odcl-file) ".lsp"))
			(if (findfile lsp-file) (odcl8-update lsp-file odcl-file nil nil))
		)
	)
	(princ)
)
