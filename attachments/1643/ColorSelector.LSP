(defun c:ColorSelector (/ c:ColorSelector_dlg_OnInitialize
			  c:ColorSelector_dlg_OnCancelClose
                          c:ColorSelector_dlg_color
			  c:ColorSelector_dlg_pb_cancel
			  c:ColorSelector_dlg_pb_accept
			  lstColor show convert colorname)

  (dcl_project_load "ColorSelector")

  (defun show ()
    (cond
      ((assoc 430 lstColor)
       (dcl_Control_SetBackColor ColorSelector_dlg_pic_color (convert (cdr (assoc 420 lstColor)))))
      ((assoc 420 lstColor)
       (dcl_Control_SetBackColor ColorSelector_dlg_pic_color (convert (cdr (assoc 420 lstColor)))))
      ((assoc 62 lstColor)
       (dcl_Control_SetBackColor ColorSelector_dlg_pic_color (cdr (assoc 62 lstColor))))
      (T (dcl_Control_SetBackColor ColorSelector_dlg_pic_color -16))
    ); cond
    (dcl_control_setcaption ColorSelector_dlg_txt_color (colorname))
  ); show

  (defun colorname (/ intColor strColor lstRgb)
    (setq strColor "")
    (cond
      ((setq strColor (cdr (assoc 430 lstColor))) strColor)
      
      ((setq intColor (cdr (assoc 420 lstColor)))
       (setq lstRgb (reverse (list (lsh (lsh intColor 24) -24) (lsh (lsh intColor 16) -24) (lsh intColor -16))))
       (setq strColor (strcat "Color: " (itoa (car lstRgb)) "," (itoa (cadr lstRgb)) "," (itoa (caddr lstRgb)))))
      
      ((setq strColor (cdr (assoc (setq intColor (cdr (assoc 62 lstColor)))
				  '((0 . "ByBlock") (1 . "Red") (2 . "Yellow") (3 . "Green") (4 . "Cyan")
				    (5 . "Blue") (6 . "Magenta") (7 . "Black") (256 . "ByLayer")))))
       strColor)
      
      ((and intColor (> intColor 7) (< intColor 256))
       (setq strColor (strcat "Color " (itoa intColor))))
    ); cond

    strColor
  ); colorname

  (defun convert (intAcadRgb / lstRgb)
    (setq lstRgb (reverse (list (lsh (lsh intAcadRgb 24) -24) (lsh (lsh intAcadRgb 16) -24) (lsh intAcadRgb -16))))
    (+ (lsh (caddr lstRgb) 16) (lsh (cadr lstRgb) 8) (car lstRgb))
  ); convert

  (defun c:ColorSelector_dlg_OnInitialize (/)
    (show)
  ); c:ColorSelector_dlg_OnInitialize

  (defun c:ColorSelector_dlg_OnCancelClose (intIsESC /)
    (/= intIsESC 1)
  ); c:ColorSelector_dlg_OnCancelClose

  (defun c:ColorSelector_dlg_color (/ lstNew)
    (if (setq lstNew (acad_truecolordlg (last lstColor) T))
      (progn
	(setq lstColor lstNew)
	(show)
      ); progn
    ); if
  ); c:ColorSelector_dlg_color

  (defun c:ColorSelector_dlg_pb_cancel (/)
    (dcl_form_close ColorSelector_dlg 2)
  ); c:ColorSelector_dlg_pb_cancel

  (defun c:ColorSelector_dlg_pb_accept (/)
    (dcl_form_close ColorSelector_dlg 1)
  ); c:ColorSelector_dlg_pb_accept

  (setq lstColor (list (cons 62 7)))

  (if (= (dcl_form_show ColorSelector_dlg) 1)
    (alert (strcat "Thank you for picking color \"" (colorname) "\", " (getvar "LOGINNAME") "!"))
  ); if

  (princ)
); c:ColorSelector