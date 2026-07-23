(vl-load-com) ; For AutoCAD.

(setvar 'cmdecho 0)
(vl-cmdf "_Opendcl")
(setvar 'cmdecho 1)

(defun GridFill (headerList DataList)
  (dcl-Control-SetColumnHeader SQLite_Viewer/Main/Grid_Table T)
  (dcl-Control-SetGridLines SQLite_Viewer/Main/Grid_Table T)
  (dcl-Control-SetColumnCaptionList SQLite_Viewer/Main/Grid_Table headerList)
  (dcl-Grid-FillList SQLite_Viewer/Main/Grid_Table DataList)
)

(defun c:SQLite_Viewer/Main#OnInitialize ()
  (GridFill
    '("A" "B" "C" "D" "E")
    '(
      ("1" "2" "3" "4" "5")
      ("6" "7" "8" "9" "10")
      ("11" "12" "13" "14" "15")
    )
  )
  ; (dcl-Control-SetColumnAlignmentList SQLite_Viewer/Main/Grid_Table '(0 0 0 0 0))
)

(defun c:SQLite_Viewer/Main#OnCancelClose (reason)
  (dcl-MessageBox "To Do: code must be added to event handler\r\nc:SQLite_Viewer/Main#OnCancelClose" "To do")
  nil
)

(defun c:SQLite_Viewer/Main/Button_Open#OnClicked ()
  (dcl-MessageBox "To Do: code must be added to event handler\r\nc:SQLite_Viewer/Main/Button_Open#OnClicked" "To do")
)

(defun c:SQLite_Viewer/Main/Button_Exit#OnClicked ()
  (dcl-Form-Close SQLite_Viewer/Main 0)
)

(defun c:SQLite_Viewer/Main/Combo_SelectTable#OnSelChanged (itemIndexOrCount value)
  (dcl-MessageBox "To Do: code must be added to event handler\r\nc:SQLite_Viewer/Main/Combo_SelectTable#OnSelChanged" "To do")
)

(defun c:SQLite_Viewer ( / return)
  (dcl-Project-Load "SQLite_Viewer" T)
  (setq return (dcl-Form-Show SQLite_Viewer/Main))
)