;;K60017h.lsp
;;K60017h.odcl
;|
KWBrown 20091229
for OpenDCL 6.0.0.17 testing
to demonstrate painting of DwgPreview control

|;
;; Initial folder for DirectoryPicker

(setq g:K60017h_RootFolder "J:\\Blocks")


(defun c:DOIT (/) (c:K60017h))

;;;---------------------------------------------------------------------------
;;;
(defun c:K60017h (/)
  ;; Codehimbelonga kdub@opendcl.com
  (vl-load-com)
  (command "._OPENDCL")
  (dcl_project_load "K60017h.odcl" t)
  (if (not (dcl_form_isactive K60017h_F))
    (dcl_form_show K60017h_F)
  )
  (princ)
)
(princ "\n K60017h to run.")
(princ)

;;;---------------------------------------------------------------------------
;;;
(defun c:K60017h_F_OnInitialize (/ ParentID Folders)
  (dcl_control_settext K60017h_F_RootFolder g:K60017h_RootFolder)
  ;;
  (setq ParentID (dcl_tree_addparent K60017h_F_Tree g:K60017h_RootFolder 0 -1 1))
  (if (= ".." (cadr (setq Folders (vl-directory-files g:K60017h_RootFolder NIL -1))))
    (setq Folders (cddr Folders))
  )
  ;;
  (foreach folder Folders
    (dcl_tree_addchild
      K60017h_F_Tree
      (list (list ParentID folder (strcat g:K60017h_RootFolder "\\" folder) 2 3))
    )
  )
  (dcl_tree_expanditem K60017h_F_Tree ParentID 1)
  ;;
  (dcl_tree_selectitem K60017h_F_Tree
                       (dcl_tree_getfirstchilditem K60017h_F_Tree ParentID)
  )
)
;;;---------------------------------------------------------------------------
;;;
(defun c:K60017h_F_Tree_OnSelChanged (Label Key / SubFiles SubFolders subList)
  ;;
  ;| Description:
 


  |;
  (dcl_listbox_clear K60017h_F_ListBox)
  ;;
  ;;(or (= (type Key) 'str) (setq Key g:K60017h_RootFolder))
  (if (= (type Key) 'str)
    (progn
      (setq g:SelectedFolder key
            SubFiles         (vl-directory-files g:SelectedFolder "*.DWG" 1)
      )
      (if (= ".." (cadr (setq SubFolders (vl-directory-files g:SelectedFolder NIL -1))))
        (setq SubFolders (cddr SubFolders))
      )
    )
  )
  ;;
  (if SubFolders
    (progn (setq subList '())
           (foreach folder SubFolders
             (setq subList (cons (list g:SelectedFolder
                                       folder
                                       (strcat g:SelectedFolder "\\" folder)
                                       2
                                       3
                                 )
                                 subList
                           )
             )
           )
           (dcl_tree_addchild K60017h_F_Tree (reverse subList))
    )
  )
  ;;
  (if subFiles
    (progn (setq subList '())
           (foreach file subFiles (setq subList (cons file subList)))
           (dcl_listbox_clear K60017h_F_ListBox)
           (dcl_listbox_addlist K60017h_F_ListBox (reverse subList))
           ;;
           (dcl_listbox_setcursel K60017h_F_ListBox 0)
           (dcl_dwgpreview_loaddwg
             K60017h_F_DwgPreview
             (strcat g:SelectedFolder "\\" (dcl_listbox_getitemtext K60017h_F_ListBox 0))
           )
           ;; (dcl_Control_Redraw K60017h_F_DwgPreview) ;; <-- redraw added for workaround : kdub 20091228  
      )
  )
)

;;;---------------------------------------------------------------------------
;;;
(defun c:K60017h_F_ListBox_OnSelChanged (ItemIndexOrCount Value /)
  (dcl_dwgpreview_loaddwg K60017h_F_DwgPreview (strcat g:SelectedFolder "\\" Value))
  ;;
  ;; (dcl_Control_Redraw K60017h_F_DwgPreview) ;; <-- redraw added for workaround : kdub 20091228  
)

;;;---------------------------------------------------------------------------
;;;
(defun c:K60017h_F_RootSelect_OnClicked (/ root)
  (if (setq Root (dcl_selectfolder "Select Root Folder" g:K60017h_RootFolder nil))
    (progn (setq g:K60017h_RootFolder root
                 g:InsertData nil
           )
           (dcl_tree_clear K60017h_F_Tree)
           (dcl_listbox_clear K60017h_F_ListBox)
           (dcl_dwgpreview_clear K60017h_F_DwgPreview)
           (c:K60017h_F_OnInitialize)
    )
  )
)
;;;---------------------------------------------------------------------------
;;;
(defun c:K60017h_DoAllTheWildStuff (/)
  (dcl_MessageBox "To Do: code must be added to event handler\r\nc:K60017h_DoAllTheWildStuff" "K60017h : To do")
)





;;;---------------------------------------------------------------------------
;;;

(princ)
 ;|«Visual LISP© Format Options»
(90 2 70 2 nil "end of " 90 60 1 0 0 nil nil nil T)
;*** DO NOT add text below the comment! ***|;
