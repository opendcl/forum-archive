(defun c:gridclicks (/ s_file)
  (command "_opendcl")
  (if
    (and
      dcl-Project-Load
      (setq s_file (findfile "grid.odcl"))
    )
    (progn
      (dcl-Project-Load s_file t)
      (dcl-Form-Show grid/form1)
    )
  )
  (princ)
)

(defun c:grid/Form1#OnInitialize (/ i_row i_count i_column)
  (dcl-Grid-AddColumns grid/Form1/Grid1 (list (list "column1" 1)(list "column2" 1))) ;justification is centered but it appears to be ignored
  (setq i_row -1 i_count 10)
  (repeat i_count
    (setq i_column -1 i_row (1+ i_row))
    (dcl-Grid-AddRow
      grid/Form1/Grid1
      (strcat "data (" (itoa i_row) "," (itoa (setq i_column (1+ i_column))) ")")
      (strcat "data (" (itoa i_row) "," (itoa (setq i_column (1+ i_column))) ")")
    )
  )
  (setq global_i_mousebutton 0)
  nil
)

(defun c:grid/Form1/Grid1#OnMouseUp (i_Button i_Flags i_X i_Y /)
  (princ (strcat "\n" (itoa (setq global_i_mousebutton (1+ global_i_mousebutton))) ". OnMouseUp, Button: " (itoa i_button) ", Flags: " (itoa i_flags)))
  nil
)

(defun c:grid/Form1/Grid1#OnMouseDown (i_Button i_Flags i_X i_Y /)
  (princ (strcat "\n" (itoa (setq global_i_mousebutton (1+ global_i_mousebutton))) ". OnMouseDown, Button: " (itoa i_button) ", Flags: " (itoa i_flags)))
  nil
)