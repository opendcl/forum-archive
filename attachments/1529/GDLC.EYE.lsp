(dcl_project_load "GDLCApp.odcl" T)

(defun c:test (/)

  ;; Events :				
  ;;					

  ;; controls events :	
  ;;			

  (defun c:GDLCApp_SpacioForm_OkTextButton_OnClicked (/)
    (dcl_Form_Close GDLCApp_SpacioForm)
    (alert "OK")
    (princ)
  )

  (defun c:GDLCApp_SpacioForm_ProjectComboBox_OnSelChanged
	 (ItemIndexOrCount Value /)


    (princ)

  )

  (defun c:GDLCApp_SpacioForm_VersionListView_OnClicked	(Row Column /)
    (princ)
  )


  (defun c:GDLCApp_SpacioForm_CancelTextButton_OnClicked (/)
    (dcl_Form_Close GDLCApp_SpacioForm)
    (princ)
  )



  ;; form events :	
  ;;			

  (defun c:GDLCApp_SpacioForm_OnInitialize (/)

    ;; filling the listview :

    (dcl_ListView_Clear GDLCApp_SpacioForm_VersionListView)
    (dcl_Control_SetListViewStyle
      GDLCApp_SpacioForm_VersionListView
      3
    )
    (dcl_ListView_AddColumns
      GDLCApp_SpacioForm_VersionListView
      (list
	(list "Version" 1 60)
	(list "Description" 0 200)
	(list "Date" 1 100)
      )
    )

    (dcl_Control_SetEditLabels
      GDLCApp_SpacioForm_VersionListView
      nil
    )
    (dcl_Control_SetGridLines
      GDLCApp_SpacioForm_VersionListView
      nil
    )
    (dcl_Control_SetMultipleSelection
      GDLCApp_SpacioForm_VersionListView
      nil
    )
    (dcl_Control_SetShowSelectAlways
      GDLCApp_SpacioForm_VersionListView
      T
    )
    (dcl_Control_SetFullRowSelect
      GDLCApp_SpacioForm_VersionListView
      T
    )

    (dcl_ListView_AddItem
      GDLCApp_SpacioForm_VersionListView

      "Data1"

      "Data2"

      "Data3"
    )


    (dcl_ListView_SetCurSel
      GDLCApp_SpacioForm_VersionListView
      0
    )

    ;; force repaint :

    (dcl_Control_Redraw GDLCApp_SpacioForm)
    (dcl_Control_Redraw GDLCApp_SpacioForm_VersionListView)

    ;; ending :
    (princ)
  )

  (defun c:GDLCApp_SpacioForm_OnCancel (/)
    (princ)
  )

  ;; Showing the form :			
  ;;					

  (dcl_Form_Show GDLCApp_SpacioForm)

  (princ)
)
(princ)
