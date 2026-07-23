(dcl_project_load "D:/Test" T)
(defun c:Test_Form1_OnInitialize (/)
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
(defun c:Test_Form1_clear:go_OnClicked (/)
  (dcl_Control_SetText Test_Form1_echo:box "")
)


(defun c:Test_Form1_TREE_OnClicked (/)
  (dcl_Control_SetText Test_Form1_echo:box
    (strcat
      (dcl_Control_GetText Test_Form1_echo:box)
      "Event : OnClicked ...."
      "\r\n"
      "  Current item : " (dcl_Tree_GetSelectedItem Test_Form1_TREE)
      "\r\n"
      )
    )
)


(defun c:Test_Form1_TREE_OnDeleteItem (Label Key /)
  (dcl_Control_SetText Test_Form1_echo:box
    (strcat
      (dcl_Control_GetText Test_Form1_echo:box)
      "Event : OnDeleteItem ...."
      "\r\n"
      "    key :" Key
      "\r\n"
      "  Current item : " (dcl_Tree_GetSelectedItem Test_Form1_TREE)
      "\r\n"
      )
    )
)

(defun c:Test_Form1_TREE_OnDragnDropBegin (/)
  (dcl_Control_SetText Test_Form1_echo:box
    (strcat
      (dcl_Control_GetText Test_Form1_echo:box)
      "Event : OnDragnDropBegin ...."
      "\r\n"
      "  Current item : " (dcl_Tree_GetSelectedItem Test_Form1_TREE)
      "\r\n"
      )
    )
)

(defun c:Test_Form1_TREE_OnDragnDropFromControl (ProjectName FormName ControlName DropPoint /)
  (dcl_Control_SetText Test_Form1_echo:box
    (strcat
      (dcl_Control_GetText Test_Form1_echo:box)
      "Event : OnDragnDropFromControl ...."
      "\r\n"
      "    DropPoint :" DropPoint
      "\r\n"
      "  Current item : " (dcl_Tree_GetSelectedItem Test_Form1_TREE)
      "\r\n"
      )
    )
)

(defun c:Test_Form1_TREE_OnDragnDropFromOther (DropPoint /)
  (dcl_Control_SetText Test_Form1_echo:box
    (strcat
      (dcl_Control_GetText Test_Form1_echo:box)
      "Event : OnDragnDropFromOther ...."
      "\r\n"
      "  Current item : " (dcl_Tree_GetSelectedItem Test_Form1_TREE)
      "\r\n"
      )
    )
)

(defun c:Test_Form1_TREE_OnDragnDropToAutoCAD (DropPoint Viewport /)
  (dcl_Control_SetText Test_Form1_echo:box
    (strcat
      (dcl_Control_GetText Test_Form1_echo:box)
      "Event : OnDragnDropToAutoCAD ...."
      "\r\n"
      "  Current item : " (dcl_Tree_GetSelectedItem Test_Form1_TREE)
      "\r\n"
      )
    )
  (dcl_DelayedInvoke 10 "Delayed_OnDragnDropToAutoCAD")
  )
(defun Delayed_OnDragnDropToAutoCAD (/)
   (dcl_Control_SetText Test_Form1_echo:box
    (strcat
      (dcl_Control_GetText Test_Form1_echo:box)
      "Function : Delayed_OnDragnDropToAutoCAD ...."
      "\r\n"
      "  Current item : " (dcl_Tree_GetSelectedItem Test_Form1_TREE)
      "\r\n"
      )
    )
  )


(defun c:Test_Form1_TREE_OnSelChanged (Label Key /)
  (dcl_Control_SetText Test_Form1_echo:box
    (strcat
      (dcl_Control_GetText Test_Form1_echo:box)
      "Event : OnSelChanged ...."
      "\r\n"
      "    key :" Key
      "\r\n"
      "  Current item : " (dcl_Tree_GetSelectedItem Test_Form1_TREE)
      "\r\n"
      )
    )
)















; Not used
(defun c:Test_Form1_TREE_OnBeginLabelEdit (/)
  (dcl_Control_SetText Test_Form1_echo:box
    (strcat
      (dcl_Control_GetText Test_Form1_echo:box)
      "Event : OnBeginLabelEdit ...."
      "\r\n"
      )
    )
  )
; Not used
(defun c:Test_Form1_TREE_OnEndLabelEdit (/)
  (dcl_Control_SetText Test_Form1_echo:box
    (strcat
      (dcl_Control_GetText Test_Form1_echo:box)
      "Event : OnEndLabelEdit ...."
      "\r\n"
      )
    )
  )




(dcl_Control_SetTitleBarText Test_Form1 (strcat "Palette & OpenDCL V" (dcl_GetVersionEx)))
(dcl_Form_Show Test_Form1)
;(dcl_Form_Close Test_Form1)