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
(defun c:Test_Form1_TREE_OnBeginLabelEdit (/)
	  (prompt "\nc:Test_Form1_TREE_OnBeginLabelEdit ....")
       )
(defun c:Test_Form1_TREE_OnEndLabelEdit (/)
	  (prompt "\nc:Test_Form1_TREE_OnEndLabelEdit ....")
       )
(defun c:Test_Form1_echo:clicked_OnClicked (Value /)
   (if (= Value 1) (alert "Sound every click in tree !"))
    )

(defun c:Test_Form1_TREE_OnDragnDropFromOther (DropPoint /)
  (prompt (strcat "\nAction:" "c:Test_Form1_TREE_OnDragnDropFromOther"))
)

(defun c:Test_Form1_TREE_OnDragnDropToAutoCAD (DropPoint Viewport /)
  (Prompt(strcat "\n OnDragnDropToAutoCAD" "\nDropPoint:" (VL-PRIN1-TO-STRING DropPoint) "\nGetselectitem:" (dcl_Tree_GetSelectedItem Test_Form1_TREE) ))
  (setq a DropPoint b Viewport)
  (dcl_DelayedInvoke 10 "Delayed_OnDragnDropToAutoCAD")
  )
(defun Delayed_OnDragnDropToAutoCAD (/)
   (Prompt(strcat "\n D:OnDragnDropToAutoCAD" "\nDropPoint:" (VL-PRIN1-TO-STRING a) "\nGetselectitem:" (dcl_Tree_GetSelectedItem Test_Form1_TREE) ))
  (dcl_SendString "(command \"_circle\" (list (car a)(cadr a)(caddr a))  \"2.5\")" )
  )



(defun c:Test_Form1_TREE_OnDragnDropFromControl (ProjectName FormName ControlName DropPoint /)
  (prompt(strcat "\nAction:" "\nc:Test_Form1_TREE_OnDragnDropFromControl" "\n DropPoint:" DropPoint))
)

(defun c:Test_Form1_TREE_OnSelChanged (Label Key /)
  (Prompt (strcat "\n c:Test_Form1_TREE_OnSelChanged\nLabel: " Label "\n Key: " key))
)
(defun c:Test_Form1_TREE_OnDeleteItem (Label Key /)
  (Prompt (strcat "\n c:Test_Form1_TREE_OnDeleteItem\nLabel: " Label "\n Key: " key))
)
(defun c:Test_Form1_TREE_OnDragnDropBegin (/)
  (Prompt (strcat "\nAction:" "\n c:Test_Form1_TREE_OnDragnDropBegin" "\nGetselectitem:"(dcl_Tree_GetSelectedItem Test_Form1_TREE) ) )
)


(defun c:Test_Form1_TREE_OnClicked (/)
  (Prompt (strcat "\n c:Test_Form1_TREE_OnClicked\n" (VL-PRINC-TO-STRING(dcl_Tree_GetSelectedItem Test_Form1_TREE))))
)

(defun c:Test_Form1_TREE_OnMouseMove (Flags X Y /)
  ;(Prompt (strcat "\n c:Test_Form1_TREE_OnMouseMove X:" (itoa X) " Y:" (itoa Y)  ))
  (setq a X b Y)
)
(dcl_Control_SetTitleBarText Test_Form1 (strcat "Palette & OpenDCL V" (dcl_GetVersionEx)))
(dcl_Form_Show Test_Form1)
;(dcl_Form_Close Test_Form1)