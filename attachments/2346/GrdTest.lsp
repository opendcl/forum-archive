(setvar 'cmdecho 0)
(vl-cmdf "_Opendcl")
(setvar 'cmdecho 1)

; Test data:
; BricsCAD 16.2.15
; OpenDCL  8.1.3.1
(defun c:GrdTest  ( / c:GrdTest/Form#OnCancelClose
                      c:GrdTest/Form#OnInitialize
                      c:GrdTest/Form#OnTimer
                      c:GrdTest/Form/BtnOk#OnClicked
                      c:GrdTest/Form/ChkAddRows#OnClicked
                      c:GrdTest/Form/Grd#OnBeginLabelEdit
                      c:GrdTest/Form/Grd#OnKillFocus
                      c:GrdTest/Form/Grd#OnSelChanged
                      c:GrdTest/Form/Grd#OnSetFocus
                      N_NextCell

                      addRowsP
                      grdHasFocusP
                  )

  (defun c:GrdTest/Form#OnCancelClose (reason)
    (if (zerop reason)
      (progn
        (if grdHasFocusP
          (N_NextCell)
        )
        T ; Prevent closing.
      )
    )
  )

  (defun c:GrdTest/Form#OnInitialize ()
    (setq addRowsP nil)
    (dcl-Control-SetValue GrdTest/Form/ChkAddRows 0)
    (dcl-Grid-AddColumns GrdTest/Form/Grd '(("" 2 30) ("A" 0 60) ("B" 0 60)))
    (dcl-Control-SetColumnStyleList GrdTest/Form/Grd '(0 6 6))
    (mapcar
      '(lambda (num) (dcl-Grid-AddRow GrdTest/Form/Grd (list (itoa num))))
      '(1 2 3 4)
    )
    (setq grdHasFocusP T)
    (dcl-Form-StartTimer GrdTest/Form 0)
  )
  
  (defun c:GrdTest/Form#OnTimer ()
    (dcl-Grid-StartCellEdit GrdTest/Form/Grd 0 1)
  )

  (defun c:GrdTest/Form/BtnOk#OnClicked ()
    (dcl-Form-Close GrdTest/Form)
  )

  (defun c:GrdTest/Form/ChkAddRows#OnClicked (value)
    (setq addRowsP (= value 1))
  )

  (defun c:GrdTest/Form/Grd#OnBeginLabelEdit (row column) ; Added because OnSetFocus never fires.
    (print "OnBeginLabelEdit")
    (setq grdHasFocusP T)
  )

  (defun c:GrdTest/Form/Grd#OnKillFocus ()
    (print "OnKillFocus")
    (setq grdHasFocusP nil)
  )

  (defun c:GrdTest/Form/Grd#OnSelChanged (row column) ; Added because OnSetFocus never fires.
    (print "OnSelChanged")
    (setq grdHasFocusP T)
  )

  (defun c:GrdTest/Form/Grd#OnSetFocus () ; Never fires.
    (print "OnSetFocus")
    (setq grdHasFocusP T)
  )

  (defun N_NextCell ( / colCnt cur rowCnt)
    (setq colCnt 3) ; Includes index column.
    (setq rowCnt (dcl-Grid-GetRowCount GrdTest/Form/Grd))
    (setq cur (dcl-Grid-GetCurCell GrdTest/Form/Grd)) ; Format: (row col).
    (if
      (and
        addRowsP
        (= (car cur) (1- rowCnt))
        (= (cadr cur) (1- colCnt))
      )
      (dcl-Grid-AddRow GrdTest/Form/Grd (list (itoa (setq rowCnt (1+ rowCnt)))))
    )
    (if
      (and
        (/= (car cur) -1)
        (/= (cadr cur) -1)
      )
      (dcl-Grid-StartCellEdit
        GrdTest/Form/Grd
        (if (= (cadr cur) (1- colCnt))
          (rem (1+ (car cur)) rowCnt)
          (car cur)
        )
        (if (= (cadr cur) (1- colCnt))
          1
          (1+ (rem (cadr cur) colCnt))
        )
      )
    )
  )

  (dcl-Project-Load "GrdTest" T)
  (dcl-Form-Show GrdTest/Form)
  (princ)
)
