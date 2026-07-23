(defun c:slider ()
  (command "opendcl")
  (dcl_project_load "d:\\slider.odcl" T)
  (setq ***intLastPercent*** 0)
  (dcl_form_show slider_slider)
  (princ)
); slide

(defun update_slider (intPercent / lstPos intHeight intNewTop)
  (setq lstPos (dcl_Control_GetPos slider_slider_pic_slider))
  (setq intHeight (last lstPos))
  
  (cond
    ((not intPercent) (setq intPercent 0))
    ((minusp intPercent) (setq intNewTop (abs intPercent) intPercent (fix (* 100.0 (/ (float intNewTop) (float intHeight))))))
    (T (setq intNewTop (fix (* intHeight (* intPercent 0.01)))))
  ); cond
  
  (if (> (+ intNewTop 10) intHeight) (setq intNewTop (- intHeight 10)))

  ;; either as solid
  (dcl_PictureBox_DrawSolidRect slider_slider_pic_slider (list (list 0 0 (caddr lstPos) intHeight -16)))
  (dcl_PictureBox_DrawSolidRect slider_slider_pic_slider (list (list 0 intNewTop (caddr lstPos) 2 0)))
  (dcl_PictureBox_DrawSolidRect slider_slider_pic_slider (list (list 0 (+ intNewTop 2) (caddr lstPos) 6 171)))
  (dcl_PictureBox_DrawSolidRect slider_slider_pic_slider (list (list 0 (+ intNewTop 8) (caddr lstPos) 2 0)))

  (dcl_Control_SetText slider_slider_edt intPercent)

  ;; or as a picture, but it does not work, but why?
;;;  (dcl_PictureBox_PaintPicture slider_slider_pic_slider (list (list 0 intNewTop 100 T T)))
  
  (setq ***intLastPercent*** intPercent)
); update_slider

(defun c:slider_slider_OnSize (intNewWidth intNewHeight /)
  (update_slider ***intLastPercent***)
); c:slider_slider_OnSize

(defun c:slider_slider_pic_slider_OnMouseDown (intButton intFlags intX intY /)
  (princ (strcat "\nOnMouseDown: " (vl-prin1-to-string (list intButton intFlags intX intY)) "\r"))
  (update_slider (* intY -1))
); c:slider_slider_pic_slider_OnMouseDown

(defun c:slider_slider_pic_slider_OnMouseMove (intFlags intX intY /)
  (princ (strcat "\nOnMouseMove: " (vl-prin1-to-string (list intFlags intX intY)) "\r"))
  (if (and (= (logand intFlags 1) 1)
	   (>= intY 0)
	   (<= intY (dcl_Control_GetHeight slider_slider_pic_slider)))
    (update_slider (* intY -1))
  ); if
); c:slider_slider_pic_slider_OnMouseMove

(defun c:slider_slider_pic_slider_OnMouseWheel (intFlags intZDelta intX intY /)
  (princ "\nOnMouseWheel\r")
); c:slider_slider_pic_slider_OnMouseWheel

(defun c:slider_slider_pic_slider_OnPaint (isHasFocus /)
  (princ (strcat "\nOnPaint: " (itoa ***intLastPercent***) " %\r"))
  (update_slider ***intLastPercent***)
); c:slider_slider_pic_slider_OnPaint

(defun c:slider_slider_edt_OnEditChanged (strNewValue / intVal)
  (setq intVal (atoi strNewValue))
  (cond
    ((minusp intVal) (setq intVal 0))
    ((> intVal 100) (setq intVal 100))
  ); cond
  (update_slider intVal)
); c:slider_slider_edt_OnEditChanged
