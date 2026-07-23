(defun c:test ()
  (dcl_project_load "D:/Test" T)
  (dcl_Form_Show Test_Form1)
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
	(repeat 15
	  (dcl_Tree_AddParent Test_Form1_TREE
		  (list (list (setq $parent (strcat "Node" (itoa #cpt))) (strcat "Node" (itoa #cpt))))
		  )
	  (repeat 5
	    (setq #cpt (1+ #cpt))
	    (dcl_Tree_AddChild Test_Form1_TREE
		  (list (list $parent (setq $child (strcat "Node" (itoa #cpt))) (strcat "Node" (itoa #cpt))))
		  )
	    (repeat 5
	      (setq #cpt (1+ #cpt))
	      (dcl_Tree_AddChild Test_Form1_TREE
		(list (list $child (strcat "Node" (itoa #cpt)) (strcat "Node" (itoa #cpt))))
		)
	      )
	    )
	     (setq #cpt (1+ #cpt))
	     )
	)
  (defun c:Test_Form1_BUT2_OnClicked (/)
	(repeat 10
	     (dcl_Tree_AddChild Test_Form1_TREE
		  (list (list (dcl_Tree_GetSelectedItem Test_Form1_TREE) (strcat "Node" (itoa #cpt)) (strcat "Node" (itoa #cpt))))
		  )
	     (setq #cpt (1+ #cpt))
	     )
    )
  (defun c:Test_Form1_echo:clicked_OnClicked (Value /)
   (if (= Value 1) (alert "Sound every click in tree !"))
    )


  


(defun c:Test_Form1_TREE_OnDragnDropFromOther (DropPoint /)
  (setq ssDragnDropSelectionSet (ssget "_P")) ; Get selected entities
  (prompt (strcat "\nAction:" "c:Test_Form1_TREE_OnDragnDropFromOther"))
)
  
(defun c:Test_Form1_TREE_OnDragnDropToAutoCAD (DropPoint Viewport /)
  (alert (strcat "\nc:Test_Form1_TREE_OnDragnDropToAutoCAD" "\nDropPoint:" droppoint "\nGetselectitem:"(dcl_Tree_GetSelectedItem Test_Form1_TREE) ))
)

(defun c:Test_Form1_TREE_OnClicked (/)
  (alert (strcat "\n c:Test_Form1_TREE_OnClicked\n" (dcl_Tree_GetSelectedItem Test_Form1_TREE)))
)
(defun c:Test_Form1_TREE_OnDragnDropFromControl (ProjectName FormName ControlName DropPoint /)
  (alert (strcat "\nAction:" "\nc:Test_Form1_TREE_OnDragnDropFromControl" "\n DropPoint:" DropPoint))
)

(defun c:Test_Form1_TextBox1_OnEditChanged (NewValue /)
  (dcl_MessageBox "To Do: code must be added to event handler\r\nc:Test_Form1_TextBox1_OnEditChanged" "To do")
)

(defun c:Test_Form1_TREE_OnSelChanged (Label Key /)
  (alert (strcat "\n c:Test_Form1_TREE_OnSelChanged\nLabel: " Label "\n Key: " key))
)
(defun c:Test_Form1_TREE_OnDeleteItem (Label Key /)
  (alert (strcat "\n c:Test_Form1_TREE_OnDeleteItem\nLabel: " Label "\n Key: " key))
)
(defun c:Test_Form1_TREE_OnDragnDropBegin (/)
  (alert (strcat "\nAction:" "\n c:Test_Form1_TREE_OnDragnDropBegin" "\nGetselectitem:"(dcl_Tree_GetSelectedItem Test_Form1_TREE) ) )
)
(defun c:Test_Form1_TREE_OnDragnDropFromControl (ProjectName FormName ControlName DropPoint /)
  (alert (strcat "\nAction:" "\nc:Test_Form1_TREE_OnDragnDropFromControl" "\n DropPoint:" DropPoint))
)

)




