(defun c:tree ()
  (dcl_project_load "proj" T)
  (dcl_form_show proj_form)
  (princ)
); tree

(defun c:proj_form_OnInitialize (/)
  (dcl_Tree_AddParent proj_form_tree
    (list (list "Folder 1" "F1" 0 1 1)
	  (list "Folder 2" "F2" 0 1 1)
	  (list "Item 1" "I1" 2 2 2)
	  (list "Item 2" "I2" 2 2 2)
	  (list "Item 3" "I3" 2 2 2)))
  (dcl_Tree_AddChild proj_form_tree
    (list (list "F1" "SubItem 1" "I1-1" 2 2 2)
	  (list "F1" "SubItem 2" "I1-2" 2 2 2)
	  (list "F2" "SubItem 1" "I2-1" 2 2 2)
	  (list "F2" "SubItem 2" "I2-2" 2 2 2)))
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

(defun c:proj_form_tree_OnDragnDropFromControl (strProjectName strFormName strControlName uDropPoint /)
  (setq ***dragged_item*** nil)
); c:proj_form_tree_OnDragnDropFromControl