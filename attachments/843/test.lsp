(defun c:test ()
  (dcl_project_load "D:/Test" T)
  (dcl_form_show Test_Form1)
  (dcl_form_show Test_Form2)
     (setq #click 0)
  (princ)
)

(defun c:Test_Form1_OnInitialize (/)
     (defun c:Test_Form1_TREE_OnClicked (/)
	  (setq #click (1+ #click))
	  (dcl_Control_SetKeepFocus Test_Form1 nil)
	  
	  (dcl_Control_SetCaption Test_Form1_MES (strcat "Click nbr: " (itoa #click) " (Left)\nKeepFocus is set to :" (VL-PRINC-TO-STRING (dcl_Control_GetKeepFocus Test_Form1))))
	  (prompt "\nTry to cliq on a menu button ....")
	  )

  (defun c:Test_Form1_TREE_OnRightClick (/)
       (setq #click (1+ #click))
    ;(dcl_Control_SetKeepFocus Test_Form1 T)
    ;(prompt (strcat "\ndcl_Control_GetKeepFocus:" (VL-PRINC-TO-STRING(dcl_Control_GetKeepFocus Test_Form1))))
    (dcl_Control_SetFocus Test_Form1_TREE)
        (dcl_Control_SetEventInvoke Test_Form1_TREE 1); Asynchronous
    (prompt (strcat "\ndcl_Control_GetEventInvoke:" (VL-PRINC-TO-STRING(dcl_Control_GetEventInvoke Test_Form1_TREE))))

       	(dcl_Control_SetCaption Test_Form1_MES (strcat "Click nbr: " (itoa #click) " (Right)\nKeepFocus is set to :" (VL-PRINC-TO-STRING (dcl_Control_GetKeepFocus Test_Form1))))	  
    ;(setq #entsel(entsel "\nSelect an entity:"))
    ;(setq #ent (car #entsel))
    ;(setq #entget (entget #ent))
    ;(setq @$handle (cdr (assoc 5 #entget)))
    ;(@gpe:anim:zoom:symbole @$handle 50 0.2)
    ;(dcl_SendString (@gpe:anim:zoom:symbole @$handle 50 0.2))
    
       ;(dcl_Control_SetEventInvoke Test_Form1_TREE 0); Asynchronous
       ;(prompt (strcat "\ndcl_Control_GetEventInvoke:" (VL-PRINC-TO-STRING(dcl_Control_GetEventInvoke Test_Form1_TREE))))
       ;(dcl_Control_SetKeepFocus Test_Form1 nil)
       ;(prompt (strcat "\ndcl_Control_GetKeepFocus:" (VL-PRINC-TO-STRING(dcl_Control_GetKeepFocus Test_Form1))))
    
       (prompt "\nTry to cliq on a menu button ....")
       )

       (defun c:Test_Form1_TREE_OnBeginLabelEdit (/)
	  (prompt "\nc:Test_Form1_TREE_OnBeginLabelEdit ....")
       )
       (defun c:Test_Form1_TREE_OnEndLabelEdit (/)
	  (prompt "\nc:Test_Form1_TREE_OnEndLabelEdit ....")
       )

     (defun c:Test_Form1_HIDE_OnClicked (/)
	  (dcl_Form_Hide Test_Form2 T)
	  )
     (defun c:Test_Form1_SHOW_OnClicked (/)
	  (dcl_Form_Hide Test_Form2 nil)
	  )
     (defun c:Test_Form2_HIDE2_OnClicked (/)
	  (dcl_Form_Hide Test_Form1 T)
	  )
     (defun c:Test_Form2_SHOW2_OnClicked (/)
	  (dcl_Form_Hide Test_Form1 nil)
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




