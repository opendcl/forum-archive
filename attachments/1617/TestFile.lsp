
;;;											
;;;											
;;;   TESTFile										
;;;   											
;;;											
;;;			     								
;;;		            	    Temp File						
;;;			     								

;;;			     								
;;;		       	    Setting some global variables				
;;;			     								

(princ)

;;;			     								
;;;			     	Defining Functions					
;;;			    								

(princ)

;;;			     								
;;;			     	Defining Commands					
;;;			    								

;;;----  c:TestMe						 			
;;;											

(defun c:TestMe	(/)


  ;; Events :				
  ;;					

  ;; controls events :	
  ;;			

  (princ)

  ;; form events :	
  ;;			


  (defun c:GDLCApp_SpaceForm_OnMouseEntered (/)
    (dcl_Control_SetFocus GDLCApp_SpaceForm)
  )

  (defun c:GDLCApp_SpaceForm_OnMouseMovedOff (/)
    (dcl_setcmdbarfocus)
  )

  (defun c:GDLCApp_SpaceForm_OnInitialize (/ i)

    ;; ListView :
    (dcl_ListView_Clear GDLCApp_SpaceForm_SpaceListView)
    (dcl_Control_SetShowSelectAlways
      GDLCApp_SpaceForm_SpaceListView
    T
    )
    (setq i 0)
    (repeat 10
      (dcl_ListView_AddItem
	GDLCApp_SpaceForm_SpaceListView
	i
	(strcat "item" (rtos i 2 0))
      )
      (setq i (1+ i))
    )

    (dcl_Control_SetEditLabels
      GDLCApp_SpaceForm_SpaceListView
      nil
    )
    (dcl_Control_SetFullRowSelect
      GDLCApp_SpaceForm_SpaceListView
      T
    )
    (dcl_Control_SetMultipleSelection
      GDLCApp_SpaceForm_SpaceListView
      nil
    )

    ;; listbox :
    (dcl_ListBox_Clear GDLCApp_SpaceForm_SpaceListBox)

    (setq i 0)
    (repeat 10
      (dcl_ListBox_AddString
	GDLCApp_SpaceForm_SpaceListBox
	(strcat "item" (rtos i 2 0))
      )
      (setq i (1+ i))
    )

    ;; CmdBarFocus :
    (dcl_setcmdbarfocus)

  )

  (defun c:GDLCApp_SpaceForm_OnCancel (/)
    (if	(dcl_Form_IsActive GDLCApp_SpaceForm)
      (dcl_Form_Close GDLCApp_SpaceForm)
    )
  )
  

  ;; Loading/Showing the form :		
  ;;					
  (if (setq DlgFile
	     (findfile
	       "c:\\GDLCApp.odcl"
	     )
      )
    (dcl_project_load DlgFile T)
    (progn
      (princ "Unable to locate dialog file.")
      (exit)
    )
  )
  (dcl_Form_Show GDLCApp_SpaceForm 40 120)
  (dcl_setcmdbarfocus)

  ;; user interaction :			
  ;;					

  (setq pt (getpoint "\nSpecify a point :"))

  ;; ending :

  (if (dcl_Form_IsActive GDLCApp_SpaceForm)
    (dcl_Form_Close GDLCApp_SpaceForm)
  )

  (princ)
)
(princ)


;;;---- End of File									

