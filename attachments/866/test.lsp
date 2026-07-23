(defun c:test ()
  (dcl_project_load "D:/Test" T)
  (dcl_Form_Show Test_Form1 400 400)
)

(defun c:Test_Form1_OnInitialize (/)
     
       (defun c:Test_Form1_TREE_OnBeginLabelEdit (/)
	  (prompt "\nc:Test_Form1_TREE_OnBeginLabelEdit ....")
       )
       (defun c:Test_Form1_TREE_OnEndLabelEdit (/)
	  (prompt "\nc:Test_Form1_TREE_OnEndLabelEdit ....")
       )
    

  
   (defun c:Test_Form1_BUT1_OnClicked (/)
     (dcl_Tree_Clear Test_Form1_TREE)
     (setq #cpt 0)
     (setq #cptc 11)
	(repeat 10
	     (dcl_Tree_AddParent Test_Form1_TREE
		  (list (list (strcat "Node" (itoa #cpt)) (strcat "Node" (itoa #cpt))))
		  )
	     (setq #cpt (1+ #cpt))
	     )
	)
  (defun c:Test_Form1_BUT2_OnClicked (/)
	(repeat 10
	     (dcl_Tree_AddChild Test_Form1_TREE
		  (list (list (dcl_Tree_GetSelectedItem Test_Form1_TREE) (strcat "Node" (itoa #cptc)) (strcat "Node" (itoa #cptc))))
		  )
	     (setq #cptc (1+ #cptc))
	     )
    )

  
(defun c:Test_Form1_TREE_OnDragnDropBegin (/)
  (prompt (strcat "\nAction:" "c:Test_Form1_TREE_OnDragnDropBegin"))
)
(defun c:Test_Form1_TREE_OnDragnDropFromControl (ProjectName FormName ControlName DropPoint /)
  (prompt (strcat "\nAction:" "c:Test_Form1_TREE_OnDragnDropFromControl" " " ProjectName " " FormName " " ControlName))
)
(defun c:Test_Form1_TREE_OnDragnDropFromOther (DropPoint /)
  (setq ssDragnDropSelectionSet (ssget "_P")) ; Get selected entities
  (prompt (strcat "\nAction:" "c:Test_Form1_TREE_OnDragnDropFromOther"))
)
(defun c:Test_Form1_TREE_OnDragnDropToAutoCAD (DropPoint Viewport /)
  (prompt (strcat "\nAction:" "c:Test_Form1_TREE_OnDragnDropToAutoCAD"))
)
(defun c:Test_Form1_TREE_OnClicked (/)
  (alert (strcat "c:Test_Form1_TREE_OnClicked is call\nItem clicked : " (dcl_Tree_GetSelectedItem Test_Form1_TREE))) 
)
(defun c:Test_Form1_TREE_OnDragnDropFromControl (ProjectName FormName ControlName DropPoint /)
  (alert (strcat "c:Test_Form1_TREE_OnDragnDropFromControl is call\nItem droped : " DropPoint))
)


)




