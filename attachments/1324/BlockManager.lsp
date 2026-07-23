;;; ------------------------------------------------------------------------
;;;    BlockManager.LSP (BETA) v0.1
;;;
;;;    Copyright© December, 2008
;;;    Timothy G. Spangler
;;;
;;;    Permission to use, copy, modify, and distribute this software
;;;    for any purpose and without fee is hereby granted, provided
;;;    that the above copyright notice appears in all copies and
;;;    that both that copyright notice and the limited warranty and
;;;    restricted rights notice below appear in all supporting
;;;    documentation.
;;;
;;;		Credit to jbuzbee - for the following functions:
;;;				BLOCK_FILE_TIME, BLOCK_OpenDbx, BLOCK_ClosDbx, BLOCK_ImportDbx, BLOCK_DBXBlocks
;;;
;;;		Written with OpenDCL Runtime [5.1.2.3]
;;;
;;; ------------------------------------------------------------------------
(defun C:SBM (/)

	;; Load ActiveX COM
	(vl-load-com)
	;; Demand load OpenDCL
	(command "OPENDCL")
	(BLOCK_PROJECT)
	;; Load the project
	;(BLOCK_LOAD_PROJECT "BlockManager.odcl")
	(dcl_project_import SBM_Project nil nil)
	;; Start the project
	(BLOCK_START)
)
;;; ------------ START THE PROGRAM AND SHOW THE PALETTE
(defun BLOCK_START (/)

	;; Set the master key variable
	(setq SBM_MasterKey "HKEY_CURRENT_USER\\Software\\TheSwamp\\Block Manager")
	;; Check for the exsistance of the registry tree and the version
	(if 
		(or
			(null (BLOCK_CHECK_REG SBM_MasterKey "Name"))
			(/= (vl-registry-read SBM_MasterKey "Version") "0.1 (Beta)")
		)
		;; Create the tree
		(BLOCK_CREATE_REG SBM_MasterKey)
	)	
	;; Read the tree set the reg tree to a variable
	(setq SBM_RegList (BLOCK_READ_REG SBM_MasterKey))
	;; Get the current library type
	(setq SBM_LibType (cdr (assoc "LibType" SBM_RegList)))
	;; Check the current library type
	(cond
		((= SBM_LibType "Folder")
			;; Check the current directory for a value
			(if (= (setq SBM_Directory (cdr (assoc "CurFolder" SBM_RegList))) "nil")
				(progn
					;; Get the current directory
					(BLOCK_SET_CURRENT_FOLDER)
					;; Create the directory folder
					(vl-registry-write SBM_MasterKey "CurFolder" SBM_Directory)
				)
			)
		)
		((= SBM_LibType "Drawing")
			;;Check the current library for a value
			(if (= (setq SBM_Directory (cdr (assoc "CurDrawing" SBM_RegList))) "nil")
				(progn
					;; Get the current directory
					(BLOCK_SET_CURRENT_FOLDER)
					;; Create the directory container
					(vl-registry-write SBM_MasterKey "CurDrawing" SBM_Directory)
				)
			)
		)
		(T
			;; Show the select type form
			(dcl_Form_Show TYP_LIB)
		)
	)	
	;; Set the layer for inert
	(setq SBM_Layer (getvar "CLAYER"))
	;; Get scale to insert blocks
	(setq SBM_Scale (getvar "DIMSCALE"))	
	;; Get the Palette Name
	(setq SBM_PaletteName (cdr (assoc "Name" SBM_RegList)))
	;; Get the Palette Version
	(setq SBM_PaletteVersion (cdr (assoc "Version" SBM_RegList)))
	;; Get the palett position
	(setq SBM_PaletteX (cdr (assoc "PositionX" SBM_RegList)))
	(setq SBM_PaletteY (cdr (assoc "PositionY" SBM_RegList)))
	;; Show the palette
	(setq SBM_FormStatus (dcl_Form_Show BLOCK_PALETTE))
	;; Silent Exit
	(princ)
)
;;; ------------ REGISTRY CHECKING TO SEE IF KEY AND VALUE EXSIST
(defun BLOCK_CHECK_REG (RegKey ValueName / RegCheck)

	;; Create directory structure
	(if (vl-registry-read RegKey ValueName); check for base directory
		(setq RegCheck T)
		(setq RegCheck nil)
	)
	RegCheck
)
;;; ------------ SUB TO GET A LIST OF ALL REGISTRY KEYS AND VALUES
(defun BLOCK_READ_REG (SBM_MasterKey / RegKeyList RegListTemp Value)

	;; List all reg keys
	(setq RegKeyList(vl-registry-descendents SBM_MasterKey "*"))
	;; Create assoc list from keys and values
	(setq RegListTemp'())
	(foreach Key RegKeyList
		(setq Value (vl-registry-read SBM_MasterKey Key))
		(setq RegListTemp (cons (cons Key Value) RegListTemp))
	)
	;; Send list to the caller
	RegListTemp
)
;;; ------------ REGISTRY SET UP SUB - CREATES MAIN KEY AND CHILDREN
(defun BLOCK_CREATE_REG (SBM_MasterKey /)
	
	;; Create the master hive
	(vl-registry-write SBM_MasterKey)
	;; Create the Name
	(vl-registry-write SBM_MasterKey "Name" "Theswamp Block Manager")
	;; Create the Version
	(vl-registry-write SBM_MasterKey "Version" "0.1 (Beta)")
	;; Create the Height
	(vl-registry-write SBM_MasterKey "Height" "600")
	;; Create the Width
	(vl-registry-write SBM_MasterKey "Width" "240")
	;; Create the PositionY
	(vl-registry-write SBM_MasterKey "PositionY" "240")
	;; Create the PositionX
	(vl-registry-write SBM_MasterKey "PositionX" "240")
	;; Create the Docked state
	(vl-registry-write SBM_MasterKey "Docked" "nil")
	;; Create the Directory Folder
	(vl-registry-write SBM_MasterKey "LibType" "nil")
	;; Create the Directory Folder
	(vl-registry-write SBM_MasterKey "CurFolder" "nil")
	;; Create the Directory Drawing
	(vl-registry-write SBM_MasterKey "CurDrawing" "nil")
	;; Create the Favorites Folder
	(vl-registry-write SBM_MasterKey "FavFolder" "")
	;; Create the Favorites Drawing
	(vl-registry-write SBM_MasterKey "FavDrawing" "")	
	;; Send the status
	(princ "\n	Registry Entries Created...\n")
)	
;;; ------------ LOAD THE OPENDCL PROJECT
(defun BLOCK_LOAD_PROJECT (Project / ODCLFunction)

	(cond
		;; Search the support paths for the .ODCL file & load it.
		((if (setq ODCLFunction (findfile Project))
			(dcl_PROJECT_LOAD ODCLFunction )
		))
		;; The Projectect failed to load, so report or log the error exit now (or take corrective action and try again)
		(T (alert (strcat "\"" Project "\" failed to load, you may need to add it to an Acad support path for it to load correctly!"))
			(exit)
		)
	)
)
;;; ------------ GET A LSIT OF SUBFOLDERS IN THE GIVEN DIRECTORY
(defun BLOCK_GET_SUBFOLDER (BlockDirectory / TempList BlockLibraryList)

	;; Get list of directories
	(if (setq BlockLibraryList(vl-directory-files  BlockDirectory nil -1))
		(progn
			(foreach X BlockLibraryList
				(if (and (/= X ".")(/= X ".."))
					(setq TempList (cons X TempList))
				)
			)
		)
		;; If not then poulate
	)
	(setq BlockLibraryList (reverse TempList))
)
;;; ------------ SETS THE DEFAULT DIRECTORY USING FILE OPEN DIALOG
(defun BLOCK_SET_CURRENT_FOLDER (/)
	
	;; Set the directory to the selected directory
	(if (not (setq SBM_Directory (dcl_SelectFolder "Select Block Library Location" "C:\\" nil 64)))
		(if (= SBM_LibType "Folder")
			(setq SBM_Directory (cdr (assoc "CurFolder" SBM_RegList)))
			(setq SBM_Directory (cdr (assoc "CurDrawing" SBM_RegList)))
		)
	)
)
;;; ------------ GETS A LIST OF DRAWINGS IN A GIVEN DIRECTORY
(defun BLOCK_GET_DWG_LIST (tmpDirectory / TempList)
	
	;; Set a list
	(setq TempList (vl-directory-files tmpDirectory "*.dwg")) 
	;; Send the list ot the caller
	TempList
)
;;; ------------ OPEN A DBXDOCUMENT
(defun BLOCK_OpenDbx (dbxDrawingName / Application Document dbxDocument dbxOpen)
	
	(setq Application (vlax-get-acad-object))
	(setq Document (vla-get-activedocument Application))
	(if (/= dbxDrawingName (vla-get-fullname Document))
		(progn 
			(cond 
				((= (substr (getvar "ACADVER") 1 5) "15.06")
					(setq dbxDocument (vla-GetInterfaceObject Application "ObjectDBX.AxDbDocument"))
					(setq dbxOpen (vl-catch-all-apply 'vla-open (list dbxDocument dbxDrawingName)))
				)
				(T
					(setq dbxDocument (vla-GetInterfaceObject Application (strcat "ObjectDBX.AxDbDocument." (substr (getvar "acadver") 1 2))))
					(setq dbxOpen (vl-catch-all-apply 'vla-open (list dbxDocument dbxDrawingName)))
				)
			)
			(if (vl-catch-all-error-p dbxOpen)
				(setq dbxDocument nil)
			)
		)
	)
	(vlax-release-object Application)
	(vlax-release-object Document)
	dbxDocument
)
;;; ------------ CLOSE DBXDOCUMENT
(defun BLOCK_CloseDbx (dbxDocument / dbxDocument)
	
	(if (= (type dbxDocument) 'VLA-OBJECT)
		(progn 
			(vlax-release-object dbxDocument)
			(setq dbxDocument nil)
		)
	)
)
;;; ------------ IMPORT A BLOCK FROM A DBX DOCUMENT
(defun BLOCK_ImportDbx  (dbxDrawing dbxBlock / dbxDocument bb dbb NewBlock)
	
	(if dbxDrawing
		(setq dbxDocument (BLOCK_OpenDbx dbxDrawing))
	)
	(if dbxDocument
		(progn
			(setq bb (vla-get-blocks dbxDocument))
			(setq dbb (vla-get-blocks (vla-get-activedocument (vlax-get-acad-object))))
			(if (not (vl-catch-all-error-p (vl-catch-all-apply 'vla-item (list bb dbxBlock))))
				(setq NewBlock 
					(vl-catch-all-apply
						'vla-CopyObjects
							(list dbxDocument
								(vlax-safearray-fill
									(vlax-make-safearray vlax-vbObject '(0 . 0))
									(list (vla-item bb dbxBlock))
								)
								dbb
							)
					)
				)
			)
		)
	)
	(if dbxDocument
		(BLOCK_CloseDbx dbxDocument)
	)
	NewBlock
)
;;; ------------ GET LIST OF BLOCK IN A DRAWING
(defun BLOCK_DBXBlocks (dbxDrawing / dbxDocument Result)

	(if dbxDrawing
		(setq dbxDocument (BLOCK_OpenDbx dbxDrawing))
	)
	(if dbxDocument
		(progn 
			(vlax-for X (vla-get-blocks dbxDocument)
				(if 
					(and 
						(= (vlax-get X 'isxref) 0)
						(not (vl-string-search (chr 42) (vla-get-name X)))
						(not (vl-string-search (chr 124) (vla-get-name X)))
					)
					(setq Result (append Result (list (vla-get-name X))))
				)
			)
		)
	)
	(if dbxDocument
		(BLOCK_CloseDbx dbxDocument)
	)
	Result
)
;;; ------------ CREATE A LSIT OF LAYERS IN THE CURRENT DRAWING
(defun BLOCK_LAYER_LIST (/ LayerList NextLayer )
	
	;; Start the list
	(setq LayerList '())
	(setq NextLayer (tblnext "LAYER" T))
	;; Step through the layers and add each one to the list
	(while NextLayer
		(setq LayerList (append LayerList(list (cdr (assoc 2 NextLayer)))))
		(setq NextLayer (tblnext "LAYER"))
	)
	;; Send the list to the caller
	LayerList
)
;;; ------------ BLOCK UPDATES PALLET WITH NEW INFORMATION
(defun BLOCK_PALETTE_UPDATE (Update /)

	;; Set the current library type - Folder / Drawing
	(dcl_Control_SetCaption BLOCK_TYPE_LABEL SBM_LibType)
	;; Show directory - Add a space to the begining
	(dcl_Control_SetCaption BLOCK_DIRECTORY (strcat "  " SBM_Directory))
	;; Check for library type - set palette
	(cond
		;; Library type - Folder
		((= SBM_LibType "Folder")
			;; Change the button picture to reflect the library
			(dcl_Control_SetPicture BLOCK_TYPE 102)
			;; Set the background color
			(dcl_Control_SetBackColor BLOCK_LIST 13828095)
			;; Set the block library sub folder list
			(dcl_Control_SetList BLOCK_LIB_LIST (BLOCK_GET_SUBFOLDER SBM_Directory))			
			;; If the library variable is nil
			(if (null SBM_Library)
				(progn
					;; Set the first item in the block list
					(dcl_ComboBox_SetCurSel BLOCK_LIB_LIST 0)
					;; Set library variable
					(setq SBM_Library (dcl_ComboBox_GetEBText BLOCK_LIB_LIST))
				)
				;; Set the list to the variable
				(dcl_ComboBox_SelectString BLOCK_LIB_LIST SBM_Library 0)
			)
			;; Load the block in to the listbox
			(if Update
				(dcl_Control_SetList BLOCK_LIST
					(BLOCK_GET_DWG_LIST (strcat SBM_Directory "\\" SBM_Library))
				)
			)
			;; If the block variable is nil
			(if (null SBM_Block)
				(progn
					;; Set the first item in the block list
					(dcl_ListBox_SetCurSel BLOCK_LIST 0)
					;; Set the block to the first item
					(setq SBM_Block (dcl_ListBox_GetItemText BLOCK_LIST 0))
				)
				;; Set the list to the variable
				(dcl_ListBox_SelectString BLOCK_LIST SBM_Block 0)
			)
			;; Set the block view to the first block
			(dcl_BlockView_DisplayDwg BLOCK_PREVIEW
				(strcat SBM_Directory "\\" SBM_Library "\\" SBM_Block)
			)
		)
		;; Library type - Drawing
		((= SBM_LibType "Drawing")
			;; Change the button picture to reflect the library
			(dcl_Control_SetPicture BLOCK_TYPE 103)
			;; Set the background color
			(dcl_Control_SetBackColor BLOCK_LIST 16770764)
			;; Get list of drawings in the directory - populate lib listbox
			(dcl_Control_SetList BLOCK_LIB_LIST (BLOCK_GET_DWG_LIST SBM_Directory))				
			;; If the library variable is nil
			(if (null SBM_Library)
				(progn
					;; Set the first item in the block list
					(dcl_ComboBox_SetCurSel BLOCK_LIB_LIST 0)
					;; Set library variable
					(setq SBM_Library (dcl_ComboBox_GetEBText BLOCK_LIB_LIST))			
				)
				;; Set the list to the variable
				(dcl_ComboBox_SelectString BLOCK_LIB_LIST SBM_Library 0)	
			)				
			;; Load the blocks into the listbox
			(if Update
				(dcl_Control_SetList BLOCK_LIST
					(BLOCK_DBXBlocks (strcat SBM_Directory "\\" SBM_Library))
				)
			)
			;; Preload the library drawing
			(dcl_BlockView_PreLoadDwg BLOCK_PREVIEW (strcat SBM_Directory "\\" SBM_Library))			
			;; If the block variable is nil
			(if (null SBM_Block)
				(progn					
					;; Set the first item in the block list
					(dcl_ListBox_SetCurSel BLOCK_LIST 0)
					;; Set the block to the first item
					(setq SBM_Block (dcl_ListBox_GetItemText BLOCK_LIST 0))
				)
				;; Set the list to the variable
				(dcl_ListBox_SelectString BLOCK_LIST SBM_Block 0)
			)				
			;; Show the block preview
			(dcl_BlockView_DisplayBlock BLOCK_PREVIEW SBM_Block)
			;; Quiet Exit
			(princ)
		)
	)
	;; Get layer list - update layer dropdown
	(dcl_Control_SetList BLOCK_LAYER (BLOCK_LAYER_LIST))
	;; Set the layer to the current
	(dcl_ComboBox_SelectString BLOCK_LAYER SBM_Layer 0)
	;; Silent Exit
	(princ)
)
;;; ------------ UPDATE THE REGISTRY WITH THE CURRENT DIRECTORY
(defun BLOCK_WRITE_DIRECTORY (/)

	(if (= SBM_LibType "Folder")
		;; Write the current directory folder to the registry
		(vl-registry-write SBM_MasterKey "CurFolder" SBM_Directory)
		;; Write the current directory drawing to the registry
		(vl-registry-write SBM_MasterKey "CurDrawing" SBM_Directory)
	)
	;; Silent Exit
	(princ)
)
;;; ------------ SUB TO GET THE DATE AND TIME OF A SUPPLIED FILE
(defun BLOCK_FILE_TIME (FileName / tmpTime tmpHour AmPm tmpMinutes FileTime)
	
	;; Get the file time
	(setq tmpTime (vl-file-systime FileName))
	;; If it has time
	(if tmpTime
		(progn 
			;; Set AM / PM
			(if (> (nth 4 tmpTime) 12)
				(progn
					(setq tmpHour (itoa (- (nth 4 tmpTime) 12)))
					(setq AmPm "PM")
				)
				(progn			
					(setq tmpHour (itoa (nth 4 tmpTime)))
					(setq AmPm "AM")
				)
			)
			;; Set the minutes
			(if (< (nth 5 tmpTime) 10)
				(setq tmpMinutes (strcat "0" (itoa (nth 5 tmpTime))))
				(setq tmpMinutes (itoa (nth 5 tmpTime)))
			)
			;; Set the date and time
			(setq FileTime
				(strcat (itoa (nth 3 tmpTime))
					"/"
					(itoa (nth 1 tmpTime))
					"/"
					(itoa (nth 0 tmpTime))
					" "
					tmpHour
					":"
					tmpMinutes
					" "
					AmPm
				)
			)
		)	
	)
	FileTime
)
;;; ------------ LIST TO STRING SUB
(defun BLOCK_LIST->STR (Lst Del / NewTmpLst)
	
	;; Check the list for <nil> string
	(setq Lst (vl-remove "<No Favorites Set>" Lst))
	;; Create Temp string
	(setq NewTmpLst "")
	;; Step through the list and create a string with the del
	(foreach Element Lst
		(setq NewTmpLst (strcat NewTmpLst Del Element))
	)
	;; Delete temp string
	(setq NewTmpLst (substr NewTmpLst 2))
	;; Send the new list to the caller
	NewTmpLst
)
;;; ------------ STRING TO LIST SUB
(defun BLOCK_STR->LIST (Stg Del / CurChr PosCnt TmpLst TmpStr NewTmpLst)

	(setq PosCnt 1)
	(setq TmpStr "")
	
	(repeat (1+ (strlen Stg))
		(setq CurChr (substr Stg PosCnt 1))
		(if (= CurChr Del)
			(progn
				(setq TmpLst (cons TmpStr TmpLst))
				(setq TmpStr "")
			)
			(setq TmpStr (strcat TmpStr CurChr))
		)
		(setq PosCnt (1+ PosCnt))
	)
	(if (/= TmpStr "")
		(setq TmpLst (cons TmpStr TmpLst))
	)
	(setq NewTmpLst (reverse TmpLst))
	NewTmpLst
)
;;; ------------ INITIALIZE THE PALETTE
(defun c:BLOCK_PALETTE_OnInitialize (/)

	;; Update palette
	(BLOCK_PALETTE_UPDATE T)
)
;;; ------------ AUTOCAD IS CLOSING - LETS GET OUT OF HERE
(defun c:BLOCK_PALETTE_OnEnteringNoDocState (/)

	;; Close the palette
	(c:CLOSE_BUTTON_OnClicked)
	;;Silent Exit
	(princ)
)
;;; ------------ THE MOUSE ENTERED THE PALETTE
(defun c:BLOCK_PALETTE_OnMouseEntered (/)
	
	;; Get layer list - update layer dropdown
	(dcl_Control_SetList BLOCK_LAYER (BLOCK_LAYER_LIST))
	;; Set the layer to the current
	(dcl_ComboBox_SelectString BLOCK_LAYER SBM_Layer 0)
	;; Silent Exit
	(princ)
)
;;; ------------ BLOCK LIBRARY BUTTON CLICKED
(defun c:BLOCK_LIBRARY_OnClicked (/)

	;; Set the current folder / drawing
	(BLOCK_SET_CURRENT_FOLDER)
	;; Write the new directory
	(BLOCK_WRITE_DIRECTORY)
	;; Reset the library and block varaibles
	(setq SBM_Library nil)
	(setq SBM_Block nil)
	;; Update palette
	(BLOCK_PALETTE_UPDATE T)
)
;;; ------------ BLOCK LIBRARY TYPE BUTTON CLICKED
(defun c:BLOCK_TYPE_OnClicked (/)
  
	;; Write the current directory
	(BLOCK_WRITE_DIRECTORY)
	;; Reset the directory
	(setq SBM_Directory "nil")
	;; Set the current library type - Folder / Drawing
	(dcl_Control_SetCaption BLOCK_TYPE_LABEL "NO TYPE")
	;; Show directory - Add a space to the begining
	(dcl_Control_SetCaption BLOCK_DIRECTORY "NO LIBRARY SELECTED")
	;; Clear the Library
	(dcl_ComboBox_Clear BLOCK_LIB_LIST)
	;; Clear the block list
	(dcl_ListBox_Clear BLOCK_LIST)
	;; Clear the block preview
	(dcl_BlockView_Clear BLOCK_PREVIEW)
	;; Set the current library type to drawing
	(if (= SBM_LibType "Folder")
		(progn
			;; Change the button picture to reflect the library
			(dcl_Control_SetPicture BLOCK_TYPE 103)
			;; Set the background color
			(dcl_Control_SetBackColor BLOCK_LIST 16770764)
			;; Set the library type
			(setq SBM_LibType "Drawing")
			;; Check to see if there is a current directory
			(if (= (setq SBM_Directory (vl-registry-read SBM_MasterKey "CurDrawing")) "nil")
				;; Get the current directory
				(BLOCK_SET_CURRENT_FOLDER)
			)			
		)
		(progn
			;; Change the button picture to reflect the library
			(dcl_Control_SetPicture BLOCK_TYPE 102)
			;; Set the background color
			(dcl_Control_SetBackColor BLOCK_LIST 13828095)
			;; Set the library type
			(setq SBM_LibType "Folder")
			;; Check to see if there is a current directory
			(if (= (setq SBM_Directory (vl-registry-read SBM_MasterKey "CurFolder")) "nil")
				;; Get the current directory
				(BLOCK_SET_CURRENT_FOLDER)
			)			
		)
	)
	;; Write the library type to the reg
	(vl-registry-write SBM_MasterKey "LibType" SBM_LibType	)
	(setq SBM_Library nil)
	(setq SBM_Block nil)
	;; Update palette
	(BLOCK_PALETTE_UPDATE T)
)
;;; ------------ BLOCK LIBRARY TYPE CAPTION CLICKED
(defun c:BLOCK_TYPE_LABEL_OnClicked (/)
	(c:BLOCK_TYPE_OnClicked)
)
;;; ------------ BLOCK FAVORITES BUTTON CLICKED
(defun c:BLOCK_FAVS_OnClicked (/)
	
	(setq FavsStatus (dcl_Form_Show FAVS))
  ;; Silent Exit
	(princ)
)
;;; ------------ BLOCK EDIT BUTTON CLICKED
(defun c:BLOCK_EDIT_OnClicked (/)
	
	;; Set env to SDI 1
	(if (= (getvar "SDI") 0)
		;; Open a new session of autocad
		(if (= SBM_LibType "Folder")
			(vla-activate (vla-open (vla-get-documents (vlax-get-acad-object)) 
				(strcat SBM_Directory "\\" SBM_Library "\\" SBM_Block))
			)
			(vla-activate (vla-open (vla-get-documents (vlax-get-acad-object)) 
				(strcat SBM_Directory "\\" SBM_Library))
			)
		)
		;; Alert the user
		(dcl_MessageBox "You must be in Single Document Mode\r\n to open the selected drawing
			\n Type \"SDI\" and change value to 0" 
			"Open Error" 2 1
		)
	)
	;; Silent Exit
	(princ)
)
;;; ------------ BLOCK LIBRARY LIST CHANGED
(defun c:BLOCK_LIB_LIST_OnSelChanged (ItemIndexOrCount Value /)

	;; Set the SBM_Library to the selected library
	(setq SBM_Library Value)
	(setq SBM_Block nil)
	;; Update palette
	(BLOCK_PALETTE_UPDATE T)
)
;;; ------------ BLOCK CHANGED
(defun c:BLOCK_LIST_OnSelChanged (ItemIndexOrCount Value /)

	;; Set the block view to the first block
	(setq SBM_Block Value)
	;; Update palette
	(BLOCK_PALETTE_UPDATE nil)
)
;;; ------------ BLOCK LIST DOUBLE CLICKED - SHOW FILE PROPERTIES
(defun c:BLOCK_LIST_OnDblClicked (/)
  
	;; Shoe the information
	(setq BlockInfoShow (dcl_Form_Show BLOCK_INFO))
	;; Silent Exit
	(princ)
)
;;; ------------ BLOCK PREVIEW DOUBLE CLICKED
(defun c:BLOCK_PREVIEW_OnDblClicked (/ TmpEnt tmpScale)

	;; Get the insertion scale
	(if (null (setq tmpScale (getreal "\n Specify scale factor: <1>")))
		(setq tmpScale 1)
	)
	;; Insert the selected block
	(if (= SBM_LibType "Folder")
		;; Insert the block
		(command ".-insert" (strcat SBM_Directory "\\" SBM_Library "\\" SBM_Block) "scale" tmpScale PAUSE PAUSE)
		(progn	
			;; Import the block from the container
			(BLOCK_ImportDbx (strcat SBM_Directory "\\" SBM_Library) SBM_Block)
			;; Insert the block
			(command ".-insert" SBM_Block "scale" tmpScale PAUSE PAUSE)
		)
	)
	;; Get the block
	(setq TmpEnt (entget(entlast)))
	;; Change the layer
	(setq TmpEnt (subst (cons 8 SBM_Layer)(assoc 8 TmpEnt) TmpEnt)) 
	(entmod TmpEnt)
	;; Send status
	(princ (strcat "\n " SBM_Block " was inserted...."))
	;; Silent Exit
	(princ)
)
;;; ------------ LAYER DROPDOWN CHANGED
(defun c:BLOCK_LAYER_OnSelChanged (ItemIndexOrCount Value /)
	
	;; Set the layer for insert
	(setq SBM_Layer (dcl_ComboBox_GetEBText BLOCK_LAYER))
	;; Silent Exit
	(princ)
)
;;; ------------ INSERT BUTTON SELECTED
(defun c:INSERT_BUTTON_OnClicked (/)
  ;; Insert button was clicked
  (c:BLOCK_PREVIEW_OnDblClicked)
)
;;; ------------ CLOSE BUTTON SELECTED
(defun c:CLOSE_BUTTON_OnClicked (/)
	
	;; Check the state of the palette
	(if (dcl_Form_IsFloating BLOCK_PALETTE)		
		;; Create the Docked state
		(vl-registry-write SBM_MasterKey "Docked" "nil")
		;; Create the Docked state
		(vl-registry-write SBM_MasterKey "Docked" "T")
	)
	;; Close the palette
	(dcl_Form_Close BLOCK_PALETTE)
	;; Unload the project
	(dcl_Project_Unload "BlockManager" T)

)
;;; ------------ PALETTE CLOSED
(defun c:BLOCK_PALETTE_OnClose (UpperLeftX UpperLeftY /)
		
	;; Create the PositionY
	(vl-registry-write SBM_MasterKey "PositionY" (rtos UpperLeftY 2 0))
	;; Create the PositionX
	(vl-registry-write SBM_MasterKey "PositionX" (rtos UpperLeftX 2 0))
	;; Not so silent exit
	(princ "\n\n	See Ya!\n")
	(princ)
)
;;; ------------ SWAMP LOGO DOUBLE CLICKED
(defun c:BLOCK_BERT_OnDblClicked (/)

	(dcl_NavigateToURL "http://www.theswamp.org//")
	;; Silent Exit
	(princ "\n Headed to theswamp......")
	(princ)
)

;;; -------------------------------------------------------------------------------------------

;;; ------------ BLOCK INFO FORM INITIALIZED
(defun c:BLOCK_INFO_OnInitialize (/)
  
  ;; Center the form on the display
  (dcl_Form_Center BLOCK_INFO)
  
  (if (= SBM_LibType "Folder")
		(progn
			;;	Return file size
			(setq FileSize (strcat (itoa (/ 
				(vl-file-size (strcat SBM_Directory "\\" SBM_Library "\\" SBM_Block)) 1000)) " KB")
			)
			;;	Return file systime
			(setq FileTime (BLOCK_FILE_TIME (strcat SBM_Directory "\\" SBM_Library "\\" SBM_Block)))
			;; Populate the block name
			(dcl_Control_SetCaption BLOCK_BLOCK SBM_Block)			
		)
		(progn
			;;	Return file size
			(setq FileSize (strcat (itoa (/ 
				(vl-file-size (strcat SBM_Directory "\\" SBM_Library)) 1000)) " KB")
			)
			;;	Return file systime
			(setq FileTime (BLOCK_FILE_TIME (strcat SBM_Directory "\\" SBM_Library)))
			;; Populate the block name
			(dcl_Control_SetCaption BLOCK_BLOCK SBM_Library)		
		)
	)
	;; Populate the directory
	(dcl_Control_SetCaption BLOCK_DIR_TEXT SBM_Directory)
	;; Populate the library
	(dcl_Control_SetCaption BLOCK_LIB_TEXT SBM_Library)
	;; Populate the file size
	(dcl_Control_SetCaption BLOCK_SIZ_TEXT FileSize)
	;; Populate the time modified
	(dcl_Control_SetCaption BLOCK_MOD_TEXT FileTime)
)
;;; ------------ BLOCK INFO FORM CLOSED
(defun c:BLOCK_INFO_CLOSE_OnClicked (/)
	
	;; Close the form
	(dcl_Form_Close BLOCK_INFO BlockInfoShow)
  ;; Clear variables
  (setq FileSize nil)
  (setq FileTime nil)
  ;; Silent Exit
  (princ)
)
;;; ------------ BLOCK FAVS FORM
(defun c:FAVS_OnInitialize (/)
	
	(setq SBM_Favorites nil)
	;; Show directory - Add a space to the begining
	(dcl_Control_SetCaption FAVS_DIR (strcat "" SBM_Directory))
	;; Check for library type
	(if (= SBM_LibType "Folder")
		(progn
			;; Set the background color
			(dcl_Control_SetBackColor FAVS_LIST 13828095)
			(setq SBM_Favorites (cdr (assoc "FavFolder" SBM_RegList)))
			(if (= SBM_Favorites "")
				;; If there are no favs set the list
				(setq SBM_Favorites (list "<No Favorites Set>"))
				;; If there are favs create the list
				(setq SBM_Favorites (BLOCK_STR->LIST SBM_Favorites ","))
			)
		)
		(progn
			;; Set the background color
			(dcl_Control_SetBackColor FAVS_LIST 16770764)
			(setq SBM_Favorites (cdr (assoc "FavDrawing" SBM_RegList)))
			(if (= SBM_Favorites "")
				;; If there are no favs set the list
				(setq SBM_Favorites (list "<No Favorites Set>"))
				;; If there are favs create the list
				(setq SBM_Favorites (BLOCK_STR->LIST SBM_Favorites ","))
			)
		)
	)
	;; Load the list into the listbox
	(dcl_Control_SetList FAVS_LIST SBM_Favorites)
	;; Set the first favorite current
	(dcl_ListBox_SetCurSel FAVS_LIST 0)
	;; Silent Exit
	(princ)
)
;;; ------------ BLOCK FAVS LIST WAS DBL CLICKED
(defun c:FAVS_LIST_OnDblClicked (/)
	(c:FAVS_LOAD_OnClicked)
)
;;; ------------ BLOCK FAVS ADD BUTTON WAS CLICKED
(defun c:FAVS_ADD_OnClicked (/ tmpFav)
  
  ;; Get the selected favorite
  (setq tmpFav SBM_Directory)
  ;; Check to see it it is the list already
  (if (member tmpFav SBM_Favorites)
		(dcl_MessageBox "The Library that you are trying \r\n to add is already a favorite" "Already Exsists" 2 1)
		(setq SBM_Favorites (vl-remove "<No Favorites Set>" (append (list tmpFav) SBM_Favorites)))
	)
	;; Write the favorites to the reg
	(if (= SBM_LibType "Folder")
		;; Create the folder favorites
		(vl-registry-write SBM_MasterKey "FavFolder" (BLOCK_LIST->STR SBM_Favorites ","))
		;; Create the drawing favorites
		(vl-registry-write SBM_MasterKey "FavDrawing" (BLOCK_LIST->STR SBM_Favorites ","))
	)
	;; Reload the registry tree
	(setq SBM_RegList (BLOCK_READ_REG SBM_MasterKey))
	;; Reload the form
	(c:FAVS_OnInitialize)
)
;;; ------------ BLOCK FAVS DELETE BUTTON WAS CLICKED
(defun c:FAVS_DELETE_OnClicked (/ tmpFav)

	;; Get the current seletion
	(setq tmpFav (dcl_ListBox_GetItemText FAVS_LIST (dcl_ListBox_GetCurSel FAVS_LIST)))
	;; Remove it from the list
	(setq SBM_Favorites (vl-remove tmpFav SBM_Favorites))
	;; Write the favorites to the reg
	(if (= SBM_LibType "Folder")
		;; Create the folder favorites
		(vl-registry-write SBM_MasterKey "FavFolder" (BLOCK_LIST->STR SBM_Favorites ","))
		;; Create the drawing favorites
		(vl-registry-write SBM_MasterKey "FavDrawing" (BLOCK_LIST->STR SBM_Favorites ","))
	)
	;; Reload the registry tree
	(setq SBM_RegList (BLOCK_READ_REG SBM_MasterKey))
	;; Reload the form
	(c:FAVS_OnInitialize)
)
;;; ------------ BLOCK FAVS LOAD BUTTON WAS CLICKED
(defun c:FAVS_LOAD_OnClicked (/ tmpFav)
	
	;; Get the current seletion
	(setq tmpFav (dcl_ListBox_GetItemText FAVS_LIST (dcl_ListBox_GetCurSel FAVS_LIST)))
	;; Set it the the directory
	(setq SBM_Directory tmpFav)
	;; Close the form
	(c:FAVS_EXIT_OnClicked)
	;; Clear the library and block
	(setq SBM_Library nil)
	(setq SBM_Block nil)
	;; Write the directory to the reg
	(BLOCK_WRITE_DIRECTORY)
	;; Update palette
	(BLOCK_PALETTE_UPDATE T)
)
;;; ------------ BLOCK FAVS EXIT BUTTON WAS CLICKED
(defun c:FAVS_EXIT_OnClicked (/ FavsStatus)
  ;; Close the favorites form
  (dcl_Form_Close FAVS)
)
;;; ------------ LIBRARY TYPE SELECTION BOX INITIALIZED
(defun c:TYP_LIB_OnInitialize (/)

	;; Set the list of types
	(dcl_Control_SetList TYP_LIST (list "Folder" "Drawing"))
	;; Select the first item in the list	
	(dcl_ListBox_SetCurSel TYP_LIST 0)
	;; Get the first selected item
	(setq SBM_LibType (dcl_ListBox_GetItemText TYP_LIST (dcl_ListBox_GetCurSel TYP_LIST)))
	;; Silent Exit
	(princ)
)
;;; ------------ LIBRARY TYPE SELECTION CHANGED
(defun c:TYP_LIST_OnSelChanged (ItemIndexOrCount Value /)

  ;; Get the selected item
	(setq SBM_LibType (dcl_ListBox_GetItemText TYP_LIST (dcl_ListBox_GetCurSel TYP_LIST)))
	;; Silent Exit
	(princ)
)
;;; ------------ LIBRARY TYPE WAS DBL CLICKED
(defun c:TYP_LIST_OnDblClicked (/)

	;; Get the selected item
	(setq SBM_LibType (dcl_ListBox_GetItemText TYP_LIST (dcl_ListBox_GetCurSel TYP_LIST)))
	;; Close the palette uning the OK button
	(c:TYP_ACCEPT_OnClicked)
	;; Silent Exit
	(princ)
)
;;; ------------ LIBRARY TYPE WAS DBL CLICKED
(defun c:TYP_ACCEPT_OnClicked (/)

	;; Create the Directory Folder
	(vl-registry-write SBM_MasterKey "LibType" SBM_LibType)
	;; Close the form
	(dcl_Form_Close TYP_LIB)
	;; Update palette
	(BLOCK_START)
)
;;; ------------ PROJECT CODE
(defun BLOCK_PROJECT (/)
(setq SBM_Project '("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"
"KvEXby1XOfY0iEzZgHnZipQg"))
)
;;;
;;; ------------ COMMAND LINE LOAD SEQUENCE --------------------------------------------
(princ "\nTheSwamp Block Manager v0.1 (BETA)© \n Timothy Spangler, \n February, 2010....loaded.")
(print)
(princ "Type \"SBM\" to start")
(princ)
(C:SBM)