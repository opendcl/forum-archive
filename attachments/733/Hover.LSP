(defun c:hover (/ hover weiter lstControls c:gis_sc_overlay_OnInitialize c:gis_sc_overlay_pic_Off
	         c:gis_sc_overlay_pic_Off2 c:gis_sc_overlay_pb_cancel
	         c:gis_sc_overlay_pic_1 c:gis_sc_overlay_pic_2 c:gis_sc_overlay_pic_3
	         c:gis_sc_overlay_pic_4 c:gis_sc_overlay_pic_5 c:gis_sc_overlay_pic_6
	         c:gis_sc_overlay_pic_1_Hover c:gis_sc_overlay_pic_2_Hover c:gis_sc_overlay_pic_3_Hover
	         c:gis_sc_overlay_pic_4_Hover c:gis_sc_overlay_pic_5_Hover c:gis_sc_overlay_pic_6_Hover
	         c:gis_sc_overlay_pic_1_Enter c:gis_sc_overlay_pic_2_Enter c:gis_sc_overlay_pic_3_Enter
	         c:gis_sc_overlay_pic_4_Enter c:gis_sc_overlay_pic_5_Enter c:gis_sc_overlay_pic_6_Enter
	         )

  (dcl_project_load "gis")
  
  (defun c:gis_sc_overlay_OnInitialize ( /)

    (hover nil)
  ); c:gis_sc_overlay_OnInitialize

  (defun hover (intMethod / oControl intCnt)
    (repeat (setq intCnt 6)
      (setq oControl (eval (read (strcat "gis_sc_overlay_pic_" (itoa intCnt)))))
      (if (= intCnt intMethod)
	(if (not (dcl_Control_GetVisible oControl))
	  (progn
	    (dcl_Control_SetVisible oControl T)
	    (dcl_PictureBox_Refresh (eval (read (strcat "gis_sc_overlay_pic_" (itoa intCnt)))))
	    (dcl_Control_Redraw (eval (read (strcat "gis_sc_overlay_txt_" (itoa intCnt)))))
	    (dcl_PictureBox_Refresh (eval (read (strcat "gis_sc_overlay_pic_e" (itoa intCnt)))))
	    (dcl_PictureBox_Refresh (eval (read (strcat "gis_sc_overlay_pic_p" (itoa intCnt)))))
	    (dcl_PictureBox_Refresh (eval (read (strcat "gis_sc_overlay_pic_a" (itoa intCnt)))))
	  ); progn
	); if
	(if (dcl_Control_GetVisible oControl)
	  (progn
	    (dcl_Control_SetVisible oControl nil)
	    (dcl_PictureBox_Refresh (eval (read (strcat "gis_sc_overlay_pic_" (itoa intCnt)))))
	    (dcl_Control_Redraw (eval (read (strcat "gis_sc_overlay_txt_" (itoa intCnt)))))
	    (dcl_PictureBox_Refresh (eval (read (strcat "gis_sc_overlay_pic_e" (itoa intCnt)))))
	    (dcl_PictureBox_Refresh (eval (read (strcat "gis_sc_overlay_pic_p" (itoa intCnt)))))
	    (dcl_PictureBox_Refresh (eval (read (strcat "gis_sc_overlay_pic_a" (itoa intCnt)))))
	  ); progn
	); if
      ); if
      (setq intCnt (1- intCnt))
    ); repeat
  ); hover

  (defun c:gis_sc_overlay_pic_1 ( /)
    (setq weiter "gis_1")
    (dcl_form_close gis_sc_overlay)
  ); c:gis_sc_overlay_pic_1

  (defun c:gis_sc_overlay_pic_2 ( /)
    (setq weiter "gis_2")
    (dcl_form_close gis_sc_overlay)
  ); c:gis_sc_overlay_pic_2

  (defun c:gis_sc_overlay_pic_3 ( /)
    (setq weiter "gis_3")
    (dcl_form_close gis_sc_overlay)
  ); c:gis_sc_overlay_pic_3

  (defun c:gis_sc_overlay_pic_4 ( /)
    (setq weiter "gis_4")
    (dcl_form_close gis_sc_overlay)
  ); c:gis_sc_overlay_pic_4

  (defun c:gis_sc_overlay_pic_5 ( /)
    (setq weiter "gis_5")
    (dcl_form_close gis_sc_overlay)
  ); c:gis_sc_overlay_pic_5

  (defun c:gis_sc_overlay_pic_6 ( /)
    (setq weiter "gis_6")
    (dcl_form_close gis_sc_overlay)
  ); c:gis_sc_overlay_pic_6

  (defun c:gis_sc_overlay_pb_cancel ( /)
    (setq weiter nil)
    (dcl_form_close gis_sc_overlay)
  ); c:gis_sc_overlay_pb_cancel

  (defun c:gis_sc_overlay_pic_1_Hover (intFlags intX intY /) (hover 1))
  (defun c:gis_sc_overlay_pic_2_Hover (intFlags intX intY /) (hover 2))
  (defun c:gis_sc_overlay_pic_3_Hover (intFlags intX intY /) (hover 3))
  (defun c:gis_sc_overlay_pic_4_Hover (intFlags intX intY /) (hover 4))
  (defun c:gis_sc_overlay_pic_5_Hover (intFlags intX intY /) (hover 5))
  (defun c:gis_sc_overlay_pic_6_Hover (intFlags intX intY /) (hover 6))
  
  (defun c:gis_sc_overlay_pic_1_Enter () (hover 1))
  (defun c:gis_sc_overlay_pic_2_Enter () (hover 2))
  (defun c:gis_sc_overlay_pic_3_Enter () (hover 3))
  (defun c:gis_sc_overlay_pic_4_Enter () (hover 4))
  (defun c:gis_sc_overlay_pic_5_Enter () (hover 5))
  (defun c:gis_sc_overlay_pic_6_Enter () (hover 6))

  (defun c:gis_sc_overlay_pic_Off () (hover nil))
  (defun c:gis_sc_overlay_pic_Off2 (intFlags intX intY /) (hover nil))
  
  (dcl_form_show gis_sc_overlay)
  (princ)
); hover