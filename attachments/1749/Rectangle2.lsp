(defun c:Rectangle (/ cmdecho )

  (defun *error* (msg)
    (while (< 0 (getvar "cmdactive"))
      (command)
    )
    ;; do error stuff
    (if (dcl_form_isactive faultdrop_FaultBox)
      (dcl_form_close faultdrop_FaultBox)
    )
    (princ
      (strcat "\nApplication Error: " (itoa (getvar "errno")) " :- " msg)
    )
    (princ)
  )

  (defun check ()
    (if (and (/= side2 "")
             (/= side1 "")
             (/= linetype$ "")
        )
      (dcl_Control_SetEnabled rectangle2_Rectangle_btnOK T)
    )
  )

  (defun c:rectangle2_Rectangle_OnInitialize (/)
    (dcl_Control_SetText rectangle2_Rectangle_ebHeight (rtos side2 2))
    (dcl_Control_SetText rectangle2_Rectangle_ebWidth (rtos side1 2))
  )

  (defun c:rectangle2_Rectangle_ebHeight_OnEditChanged (NewValue /)
    (set_height NewValue)
  )

  (defun set_height (value / )
    (setq side2 (atof value))
    (check)
  )

  (defun c:rectangle2_Rectangle_ebWidth_OnEditChanged (NewValue /)
    (set_width NewValue)
  )

  (defun set_width (value / )
    (setq side1 (atof value))
    (check)
  )

  (defun c:rectangle2_Rectangle_Linetype_OnSelChanged (ItemIndexOrCount Value /)
    (set_linetype Value)
  )

  (defun set_linetype (value / )
    (setq linetype$ value)
    (check)
  )

  (defun c:rectangle2_Rectangle_btnOK_OnClicked (/)
    (dcl_Form_Close rectangle2_Rectangle 1)                                    ; return 1 to signal completion
  )

  (defun c:rectangle2_Rectangle_btnCancel_OnClicked (/)
    (dcl_Form_Close rectangle2_Rectangle 200)                                  ; return 200 to signal cancellation
  )

  (defun c:rectangle2_Rectangle_OnClose (UpperLeftX UpperLeftY /)
    (dcl_Form_Close rectangle2_Rectangle)                                      ; automatically returns 2
  )

  (defun DrawRectangle (dr_width dr_height / p1 p2 p3 p4)
    (setq p1 ptStart
          p2 (polar p1 ang dr_width)
          p3 (polar p2 (+ ang (/ pi 2)) dr_height)
          p4 (polar p3 (+ ang pi) dr_width)
    )
    (command "_line" p1 p2 p3 p4 p1 "")
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (setq cmdecho (getvar "CMDECHO"))                                            ; Ensure OpenDCL Runtime is (quietly) loaded
  (setvar "CMDECHO" 0)
  (command "_OPENDCL")
  (setvar "CMDECHO" cmdecho)
  (setq side1 800.0)
  (setq side2 400.0)
  (setq linetype$ "")
  (setq ptStart (vl-catch-all-apply 'getpoint (list "\nStart point: ")))
  (setq ang     (vl-catch-all-apply 'getangle (list ptStart "\nDirection angle: ")))
  (DrawRectangle side1 side2)
  (dcl_Project_Load "Rectangle2.odcl" T)                                       ; Load the project
  (setq odcl_return (dcl_Form_Show rectangle2_Rectangle))                      ; Show the main form
  (if (= odcl_return 1)
    (DrawRectangle side1 side2)
  )
  (princ "\nType Rectangle")
  (princ)
)