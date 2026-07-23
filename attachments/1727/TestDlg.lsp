(dcl_project_load "TestDlg" T)

(defun c:TestGrid ()

  ; --------------------------------------------------------------------------
  (defun c:TestDlg_TestGrid_OnInitialize (/)
    (dcl_Grid_AddRow TestDlg_TestGrid_Grid1 "Cell 1")
  )

  ; --------------------------------------------------------------------------
  (defun c:TestDlg_TestGrid_btnClose_OnClicked (/)
    (dcl_Form_Close TestDlg_TestGrid)
  )

  ; --------------------------------------------------------------------------
  (defun c:TestDlg_TestGrid_Grid1_OnBeginLabelEdit (Row Column /)
    (dcl_Control_SetCaption TestDlg_TestGrid_lblEvent "OnBeginLabelEdit")
  )

  ; --------------------------------------------------------------------------
  (defun c:TestDlg_TestGrid_Grid1_OnEndLabelEdit (Row Column /)
    (dcl_Control_SetCaption TestDlg_TestGrid_lblEvent "OnEndLabelEdit")
  )

  ; --------------------------------------------------------------------------

  (dcl_Form_Show TestDlg_TestGrid)
)
