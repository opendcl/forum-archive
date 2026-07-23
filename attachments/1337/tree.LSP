(defun c:tree ()
  (dcl_project_load "proj" T)
  (dcl_form_show proj_form)
  (princ)
); tree

(defun c:proj_form_OnInitialize (/)
  (dcl_Tree_AddParent proj_form_tree
    (list (list "Item 1" "I1" 2 2 2)
	  (list "Item 2" "I2" 2 2 2)
	  (list "Item 3" "I3" 2 2 2)
	  (list "Item 4" "I4" 2 2 2)
	  (list "Item 5" "I5" 2 2 2)))
); c:proj_form_OnInitialize

(defun c:proj_form_tree_OnDragnDropBegin (/ intRet strKey)
  (if (and (setq strKey (dcl_Tree_GetSelectedItem proj_form_tree))
	   (= (type strKey) 'STR))
    (setq ***dragged_item*** strKey
	  intRet 2)
    (setq ***dragged_item*** nil
	  intRet 0)
  ); if
  intRet
); c:proj_form_tree_OnDragnDropBegin

(defun c:proj_form_tree_OnDragOverFromControl (strProjectName strFormName strControlName uDropPoint / intRet)
  (if (and ***dragged_item***
	   (or (and (numberp uDropPoint) (zerop uDropPoint)) ;; old value for empty space
	       (= (type uDropPoint) 'ENAME)		;; new value for empty space
	       (/= uDropPoint ***dragged_item***)))	;; source and destination must not be the same
    (setq intRet 2)
    (setq intRet 0)
  ); if
  intRet
); c:proj_form_tree_OnDragOverFromControl

(defun c:proj_form_tree_OnDragnDropFromControl (strProjectName strFormName strControlName uDropPoint / lstData)
  (cond
    ((not ***dragged_item***) nil)
    ((not (setq	lstData (cons (dcl_Tree_GetItemLabel proj_form_tree ***dragged_item***)
			      (dcl_Tree_GetItemImages proj_form_tree ***dragged_item***)))) nil)
    ((and (= (type uDropPoint) 'STR)
	  (dcl_Tree_GetItem proj_form_tree uDropPoint))
     (dcl_messagebox "You've droppped the item onto an other item.\nAt first I have to delete the old item." "Step 1")
     (dcl_Tree_DeleteItem proj_form_tree ***dragged_item***)
     (dcl_messagebox "Now I add the deleted item at the droppoint." "Step 2")
     (dcl_Tree_AddSibling proj_form_tree uDropPoint T (car lstData) ***dragged_item*** (cadr lstData) (caddr lstData) (cadddr lstData))
     (dcl_messagebox "Now I leave the event - will you still find the reinserted item?" "Step 3")
     )
    (T
     (dcl_messagebox "You've droppped the item into empty space.\nAt first I have to delete the old item." "Step 1")
     (dcl_Tree_DeleteItem proj_form_tree ***dragged_item***)
     (dcl_messagebox "Now I add the deleted item as a parent." "Step 2")
     (dcl_Tree_AddParent proj_form_tree (list (list (car lstData) ***dragged_item*** (cadr lstData) (caddr lstData) (cadddr lstData))))
     (dcl_messagebox "Now I leave the event - will you still find the reinserted item?" "Step 3")
     )
  ); cond
  (setq ***dragged_item*** nil)
); c:proj_form_tree_OnDragnDropFromControl