;;; ------------------------------------------------------------------------
;;;    Folder.LSP (BETA) v0.1
;;;
;;;    Copyright© October, 2010
;;;    Timothy G. Spangler
;;;
;;;    Permission to use, copy, modify, and distribute this software
;;;    for any purpose and without fee is hereby granted, provided
;;;    that the above copyright notice appears in all copies and
;;;    that both that copyright notice and the limited warranty and
;;;    restricted rights notice below appear in all supporting
;;;    documentation.
;;;
;;;		Written with OpenDCL Runtime [5.1.2.3]
;;;
;;;	Return:
;;;
;;;		String - Selected path
;;;
;;; ---Version 0.1 (BETA)---------------------------------------------------
;;;			10-10 = Started coding Everything is as expected.
;;;
;;; ---Need to be fixed-----------------------------------------------------
;;;
;;; ------------------------------------------------------------------------
(defun C:foo (/ Path)
;(defun DCL_GETFOLDER (/ Path)
	
	;; Load ActiveX COM
	(vl-load-com)
	
	;;; ------------ SUB TO CREATE A LIST OF DRIVES FOR MY COMPUTER
	(defun FOLDER_CREATE_MYCOMPUTER (/ wshFSO DrivesCol MyComp )		
		;; Create the File System Object
	  (setq wshFSO (vlax-create-object "Scripting.FileSystemObject"))
		;; Get the drives from the File System Object
		(setq DrivesCol (vlax-get-property wshFSO 'Drives))
		;; Create the list of properties
		(vlax-for Drive DrivesCol
			(setq MyComp	
				(cons 
					(list		
						(strcat (vlax-get-property Drive 'DriveLetter) ":\\")
						(nth 
							(vlax-get-property Drive 'DriveType)
							(list "Unknown Drive" "Removeable Media" "Local Disk" "Network Drive"	"CD Drive" "RAM Disk")
						)
					)
				MyComp)
			)
		)
		;; Release the drives collection
		(vlax-release-object DrivesCol)
		;; Release the file system
		(vlax-release-object wshFSO)
		;; Send to the caller
		(reverse MyComp)
	)
	;;; ------------ SUB TO POPULATE MY COMPUTER WITH ALL THE DRIVES
	(defun FOLDER_FILL_MYCOMPUTER (/ TmpList NewList DriveLetter FolderList) 
		;; Create My Computer Parent
		(dcl_Tree_AddParent TreeList
			(list
				(list "My Computer" "MyComputer" 4 4 4)
			)
		)
		;; Create My Computer Subtree
		(dcl_Tree_AddChild TreeList 
			(reverse
				(foreach Drive (FOLDER_CREATE_MYCOMPUTER)
					(cond
						;; Local Disk
						((= (cadr Drive) "Local Disk")
							(setq TmpList (list "MyComputer" (strcat (car Drive) " - " (cadr Drive))(car Drive) 7 7 7))
						)
						;; CD Drive
						((= (cadr Drive) "CD Drive")
							(setq TmpList (list "MyComputer" (strcat (car Drive) " - " (cadr Drive))(car Drive) 6 6 6))
						)
						;; Network Drive
						((= (cadr Drive) "Network Drive")
							(setq TmpList (list "MyComputer" (strcat (car Drive) " - " (cadr Drive))(car Drive) 8 8 8))
						)
						;; Removable Drive
						((= (cadr Drive) "Removeable Media")
							(setq TmpList (list "MyComputer" (strcat (car Drive) " - " (cadr Drive))(car Drive) 5 5 5))
						)
					)
					(setq NewList (cons TmpList NewList))
				)
			)
		)
		;; Populate the tree with My Computer
		(dcl_Tree_AddChild TreeList NewList)
	)
	;;; ------------ SUB TO POPULATE AN EXPANDING FOLDER
	(defun FOLDER_FILL_FOLDER (Folder / )

		(setq Child (dcl_tree_getfirstchilditem TreeList Folder))
		(while Child
			(foreach SubFolder (vl-directory-files Child "*" -1)
				(if 
					(and 
						(not (= SubFolder "."))
						(not (= SubFolder ".."))
						(not(dcl_Tree_GetItemLabel TreeList Item))
					)
					(dcl_tree_addchild TreeList
						Child
						SubFolder
						(strcat Child "\\" SubFolder)
						0
						1
						0
					)
				)
			)
			(setq	Child (dcl_tree_getnextsiblingitem TreeList	Child)	)
		)
	)	
	;;; -------------------------------------
	;;; ------------ FORM EVENTS ------------
	;;; -------------------------------------

	;;; ------------ FOLDER TREE WAS EXPANDED
	(defun c:TreeList_OnItemExpanded (Label Key /)
	  
		;; Fill the selected folder with subfolders
		(FOLDER_FILL_FOLDER Key)	
		;; Scroll to make the item visible
		(dcl_Tree_EnsureVisible TreeList
			(dcl_Tree_GetSelectedItem TreeList)
		)
	)
	;;; ------------ FOLDER TREE WAS DBLCLICKED
	(defun c:TreeList_OnDblClicked (/ )	  
		;; Get the selected path
		(setq Path (dcl_Tree_GetSelectedItem TreeList))
		;; Close the dialog
		(dcl_Form_Close DialogFolder)
	)
	;;; ------------ DIALOG BOX HAS CLOSED
	(defun c:DialogFolder_OnClose (UpperLeftX UpperLeftY /)
		;; Send the path to the caller
		Path
	)
	
	;; Demand load OpenDCL
	(vl-cmdf "OPENDCL")
	;; Load the project
	(dcl_Project_Load "Folder" T)	
	;; Show the form
	(dcl_Form_Show DialogFolder (car (dcl_GetMouseCoords))(cadr (dcl_GetMouseCoords)))
	;; Fill My computer
	(FOLDER_FILL_MYCOMPUTER)
	;; Expand My Computer
	(dcl_Tree_ExpandItem TreeList "MyComputer" 1)
	;; Select MyComputer
	(dcl_Tree_SelectItem TreeList "MyComputer")
)
(princ)