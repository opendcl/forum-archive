(defun SQLite_Viewer_Dialog_ListView_Fill (control headerList dataList)
  (repeat (dcl-ListView-GetColumnCount control)
    (dcl-ListView-DeleteColumn control 0)
  )
  (dcl-Control-SetColumnHeader control T)
  (dcl-ListView-AddColumns control (mapcar 'list headerList))
  (dcl-Control-SetGridLines control (and dataList))
  (dcl-ListView-FillList control dataList)
)

(defun SQLite_Viewer_Exit ()
  (dcl-Form-Close SQLite_Viewer/Main 0)
)

(defun c:SQLite_Viewer/Main#OnInitialize ()
  (SQLite_Viewer_Dialog_ListView_Fill
    SQLite_Viewer/Main/ListView_Table
    '("AAA" "BBB" "CCC" "DDD")
    '(
      ("111" "222" "333" "444")
      ("111" "222" "333" "444")
      ("111" "222" "333" "444")
    )
  )
)

(defun c:SQLite_Viewer/Main#OnCancelClose (reason)
  nil
)

(defun c:SQLite_Viewer/Main/Button_Exit#OnClicked ()
  (SQLite_Viewer_Exit)
)

(defun c:SQLite_Viewer ()
  (dcl-Project-Load "SQLite_Viewer" T)
  (dcl-Form-Show SQLite_Viewer/Main)
  (princ)
)
