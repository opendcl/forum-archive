(defun c:test ( / hover intForm
	          c:gis1_sc_overlay_OnInitialize
	          c:gis1_sc_overlay_pic_Off
	          c:gis1_sc_overlay_pb_cancel
	          
	          c:gis1_sc_overlay_pic_1
	          c:gis1_sc_overlay_pic_2
	          c:gis1_sc_overlay_pic_3
	          c:gis1_sc_overlay_pic_4
	          c:gis1_sc_overlay_pic_5
	          c:gis1_sc_overlay_pic_6

	          c:gis1_sc_overlay_pic_1_OnPaint
	          c:gis1_sc_overlay_pic_2_OnPaint
	          c:gis1_sc_overlay_pic_3_OnPaint
	          c:gis1_sc_overlay_pic_4_OnPaint
	          c:gis1_sc_overlay_pic_5_OnPaint
	          c:gis1_sc_overlay_pic_6_OnPaint

	          c:gis1_sc_overlay_pic_1_OnMouseEntered
	          c:gis1_sc_overlay_pic_2_OnMouseEntered
	          c:gis1_sc_overlay_pic_3_OnMouseEntered
	          c:gis1_sc_overlay_pic_4_OnMouseEntered
	          c:gis1_sc_overlay_pic_5_OnMouseEntered
	          c:gis1_sc_overlay_pic_6_OnMouseEntered
	          )

  (34:DCL_PROJECT "gis1" T)

  (defun hover (intMethode / intItem oControl)
    (foreach intItem (vl-remove intMethode '(1 2 3 4 5 6))
      (setq oControl (eval (read (strcat "gis1_sc_overlay_pic_" (itoa intItem)))))
      (if (/= (dcl_Control_GetBackColor oControl) -24)
	(progn
	  (dcl_Control_SetBackColor oControl -24)
	); progn
      ); if
    ); foreach
    
    (if (and intMethode (setq oControl (eval (read (strcat "gis1_sc_overlay_pic_" (itoa intMethode)))))
	     (/= (dcl_Control_GetBackColor oControl) 12040191))
      (progn
	(dcl_Control_SetBackColor oControl 12040191)
      ); progn
    ); if
  ); hover

  (defun c:gis1_sc_overlay_OnInitialize ( /)
    (hover nil)
  ); c:gis1_sc_overlay_OnInitialize

  (defun c:gis1_sc_overlay_pic_1 (/) (dcl_form_close gis1_sc_overlay 11))
  (defun c:gis1_sc_overlay_pic_2 (/) (dcl_form_close gis1_sc_overlay 12))
  (defun c:gis1_sc_overlay_pic_3 (/) (dcl_form_close gis1_sc_overlay 13))
  (defun c:gis1_sc_overlay_pic_4 (/) (dcl_form_close gis1_sc_overlay 14))
  (defun c:gis1_sc_overlay_pic_5 (/) (dcl_form_close gis1_sc_overlay 15))
  (defun c:gis1_sc_overlay_pic_6 (/) (dcl_form_close gis1_sc_overlay 16))


  (defun c:gis1_sc_overlay_pic_1_OnPaint (isHasFocus /)
    (dcl_PictureBox_DrawWrappedText gis1_sc_overlay_pic_1 (list (list 4 8 184 -19 -24 "Alle ausgewählten Flächen werden miteinander vereint. Dabei entstehen auch Inseln durch Lücken." 0)))
    (dcl_PictureBox_PaintPicture gis1_sc_overlay_pic_1 (list (list 196 8 101 T T) (list 260 16 110 T T) (list 308 8 102 T T)))
  ); c:gis1_sc_overlay_pic_1_OnPaint

  (defun c:gis1_sc_overlay_pic_2_OnPaint (isHasFocus /)
    (dcl_PictureBox_DrawWrappedText gis1_sc_overlay_pic_2 (list (list 4 8 184 -19 -24 "Die Flächen des zweiten Auswahl- satzes werden von den Flächen des ersten Auswahlsatzes subtrahiert." 0)))
    (dcl_PictureBox_PaintPicture gis1_sc_overlay_pic_2 (list (list 196 8 101 T T) (list 260 16 110 T T) (list 308 8 103 T T)))
  ); c:gis1_sc_overlay_pic_2_OnPaint

  (defun c:gis1_sc_overlay_pic_3_OnPaint (isHasFocus /)
    (dcl_PictureBox_DrawWrappedText gis1_sc_overlay_pic_3 (list (list 4 8 184 -19 -24 "Exklusiv-ODER-Verknüpfung: Es werden genau die Teillächen zurückgegeben, die von keiner anderen Fläche überlagert werden." 0)))
    (dcl_PictureBox_PaintPicture gis1_sc_overlay_pic_3 (list (list 196 8 101 T T) (list 260 16 110 T T) (list 308 8 104 T T)))
  ); c:gis1_sc_overlay_pic_3_OnPaint

  (defun c:gis1_sc_overlay_pic_4_OnPaint (isHasFocus /)
    (dcl_PictureBox_DrawWrappedText gis1_sc_overlay_pic_4 (list (list 4 8 184 -19 -24 "UND-Verknüpfung: Es werden genau die Teilflächen zurückgegeben, die von mindestens einer anderen Fläche überlappt werden." 0)))
    (dcl_PictureBox_PaintPicture gis1_sc_overlay_pic_4 (list (list 196 8 101 T T) (list 260 16 110 T T) (list 308 8 105 T T)))
  ); c:gis1_sc_overlay_pic_4_OnPaint

  (defun c:gis1_sc_overlay_pic_5_OnPaint (isHasFocus /)
    (dcl_PictureBox_DrawWrappedText gis1_sc_overlay_pic_5 (list (list 4 8 184 -19 -24 "Die Pufferzonen von punktförmigen, linearen und flächenhaften Objekten werden miteinander vereint." 0)))
    (dcl_PictureBox_PaintPicture gis1_sc_overlay_pic_5 (list (list 196 8 106 T T) (list 260 16 110 T T) (list 308 8 107 T T)))
  ); c:gis1_sc_overlay_pic_5_OnPaint

  (defun c:gis1_sc_overlay_pic_6_OnPaint (isHasFocus /)
    (dcl_PictureBox_DrawWrappedText gis1_sc_overlay_pic_6 (list (list 4 8 184 -19 -24 "Die gewählten Polygone werden durch den Satz gewählter Teilungslinien zertrennt." 0)))
    (dcl_PictureBox_PaintPicture gis1_sc_overlay_pic_6 (list (list 196 8 108 T T) (list 260 16 110 T T) (list 308 8 109 T T)))
  ); c:gis1_sc_overlay_pic_6_OnPaint

  (defun c:gis1_sc_overlay_pic_1_OnMouseEntered () (hover 1))

  (defun c:gis1_sc_overlay_pic_2_OnMouseEntered () (hover 2))

  (defun c:gis1_sc_overlay_pic_3_OnMouseEntered () (hover 3))

  (defun c:gis1_sc_overlay_pic_4_OnMouseEntered () (hover 4))

  (defun c:gis1_sc_overlay_pic_5_OnMouseEntered () (hover 5))

  (defun c:gis1_sc_overlay_pic_6_OnMouseEntered () (hover 6))

  (defun c:gis1_sc_overlay_pic_Off (/)
    (hover nil)
  ); c:gis1_sc_overlay_pic_Off

  (defun c:gis1_sc_overlay_pb_cancel ( /)
    (dcl_form_close gis1_sc_overlay 2)
  ); c:gis1_sc_overlay_pb_cancel

  (if (> (setq intForm (dcl_form_show gis1_sc_overlay)) 10)
    (cond
      ((= intForm 11) (alert "Methode 1"))
      ((= intForm 12) (alert "Methode 2"))
      ((= intForm 13) (alert "Methode 3"))
      ((= intForm 14) (alert "Methode 4"))
      ((= intForm 15) (alert "Methode 5"))
      ((= intForm 16) (alert "Methode 6"))
    ); cond
  ); if

  (princ)
); test
