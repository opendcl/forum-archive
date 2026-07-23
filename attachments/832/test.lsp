(defun c:test ()
  (dcl_project_load "D:/Test" T)
  (dcl_form_show Test_Form1)
  (princ)
)

(defun c:Test_Form1_OnInitialize (/)
     (defun c:Test_Form1_TREE_OnClicked (/)
	  (dcl_Control_SetKeepFocus Test_Form1 nil)
	  (prompt (strcat "\nKeepFocus is set to :" (VL-PRINC-TO-STRING (dcl_Control_GetKeepFocus Test_Form1))))
	  (prompt "\nTry to cliq on a menu button ....")
	  )

  (defun c:Test_Form1_TREE_OnRightClick (/)
	  (dcl_Control_SetKeepFocus Test_Form1 T)
	  (prompt (strcat "\nKeepFocus is set to :" (VL-PRINC-TO-STRING (dcl_Control_GetKeepFocus Test_Form1))))
	  (prompt "\nTry to cliq on a menu button ....")
       )

       (defun c:Test_Form1_TREE_OnBeginLabelEdit (/)
	  (prompt "\nc:Test_Form1_TREE_OnBeginLabelEdit ....")
       )
       (defun c:Test_Form1_TREE_OnEndLabelEdit (/)
	  (prompt "\nc:Test_Form1_TREE_OnEndLabelEdit ....")
       )
     
     
   (defun c:Test_Form1_BUT1_OnClicked (/)
	(dcl_Tree_Clear Test_Form1_TREE)
	(setq #cpt 0)
	(repeat 150
	     (dcl_Tree_AddParent Test_Form1_TREE
		  (list (list (strcat "Node" (itoa #cpt)) (strcat "Node" (itoa #cpt))))
		  )
	     (setq #cpt (1+ #cpt))
	     )
	)


)




