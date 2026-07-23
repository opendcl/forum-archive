(defun c:colors(/ lstColors setcolor selcolor colorname convert
		  c:colors/colors#OnInitialize
		  c:colors/colors/col1
		  c:colors/colors/col2
		  c:colors/colors/col3
		  c:colors/colors/col4
                  c:colors/colors/pbAccept#OnClicked
                  c:colors/colors/pbCancel#OnClicked
	       )
  (command "_opendcl")
  (dcl-project-load "D:/Service/Support/OpenDCL/150412/colors.odcl")

  (setq lstColors (list (list (cons 62 1))(list (cons 62 2))(list (cons 62 3))(list (cons 62 4))))

  (defun colorname (lstColor / intColor strColor lstRgb)
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

  (defun setcolor (index color / ctrlCol ctrlTxt)
    (setq ctrlCol (strcat "col" (itoa index)))
    (cond
      ((assoc 430 color)
       (dcl_Control_SetBackColor "colors" "colors"  ctrlCol (convert (cdr (assoc 420 color)))))
      ((assoc 420 color)
       (dcl_Control_SetBackColor "colors" "colors"  ctrlCol (convert (cdr (assoc 420 color)))))
      ((assoc 62 color)
       (dcl_Control_SetBackColor "colors" "colors"  ctrlCol (cdr (assoc 62 color))))
      (T (dcl_Control_SetBackColor "colors" "colors"  ctrlCol -16))
    ); cond
    (dcl_control_setcaption "colors" "colors"  (strcat "txt" (itoa index)) (colorname color))
  ); setcolor

  (defun selcolor (index / lstNew i tmp)
    (if (setq lstNew (acad_truecolordlg (last (nth (1- index) lstColors)) T))
      (progn
	(setq i 1 tmp '())
	(while (<= i (length lstColors))
	  (setq tmp (cons (if (= i index) lstNew (nth (1- i) lstColors)) tmp))
	  (setq i (1+ i))
	); while
	(setq lstColors (reverse tmp))
	(setcolor index lstNew)
      ); progn
    ); if
  ); selcolor

  (defun c:colors/colors#OnInitialize (/ i c)
    (setq i 1)
    (foreach c lstColors (setcolor i c) (setq i (1+ i)))
  ); c:colors/colors#OnInitialize

  (defun c:colors/colors/col1 () (selcolor 1))
  (defun c:colors/colors/col2 () (selcolor 2))
  (defun c:colors/colors/col3 () (selcolor 3))
  (defun c:colors/colors/col4 () (selcolor 4))

  (defun c:colors/colors/pbAccept#OnClicked (/) (dcl-form-close colors/colors 1))
  (defun c:colors/colors/pbCancel#OnClicked (/) (dcl-form-close colors/colors 2))

  (if (= (dcl-form-show colors/colors) 1)
    (progn
      (princ (strcat "Colors: " (vl-prin1-to-string lstColors)))
    ); progn
  ); if

  (princ)
); c:colors