(defun c:slider ()
  (command "opendcl")
  (setq ***intLastPercent*** 0)
  (setq ***intLastStyle*** 0)
  (dcl_project_load "slider" T)
  (dcl_form_show slider_slider)
  (princ)
); slide

(defun update_slider_and_text (intNewPercent)
  (if intNewPercent (setq ***intLastPercent*** intNewPercent))
  (dcl_control_settext slider_slider_edt_percent (update_slider))
); update_slider_and_text

(defun update_slider (/ lstPos intTop intPercent)
  (cond
    ((not (setq intPercent ***intLastPercent***)) nil)
    ((not (setq lstPos (dcl_Control_GetPos slider_slider_pic_slider))) nil)
    ((not (setq intTop (update_slider_gettop))) nil)
    ((not (update_slider_clean)) nil)
    ((or (not ***intLastStyle***) (zerop ***intLastStyle***))
     (dcl_PictureBox_PaintPicture slider_slider_pic_slider (list (list 0 intTop 100 T nil))))
    (T
     (dcl_PictureBox_DrawSolidRect slider_slider_pic_slider (list (list 0 intTop (caddr lstPos) 2 0)))
     (dcl_PictureBox_DrawSolidRect slider_slider_pic_slider (list (list 0 (+ intTop 2) (caddr lstPos) 8 171)))
     (dcl_PictureBox_DrawSolidRect slider_slider_pic_slider (list (list 0 (+ intTop 10) (caddr lstPos) 2 0))))
  ); cond
  ***intLastPercent***
); update_slider

(defun update_slider_gettop (/ intHeight intNewTop)
  (setq intHeight (last lstPos))
  
  (cond
    ((not intPercent) (setq intPercent 0))
    ((minusp intPercent) (setq intNewTop (abs intPercent)
                               intPercent (fix (* 100.0 (/ (float intNewTop) (float intHeight))))
                               ***intLastPercent*** intPercent))
    (T (setq intNewTop (atoi (rtos (* intHeight (* intPercent 0.01)) 2 0))))
  ); cond
  
  (if (>= (+ intNewTop 12) intHeight) (setq intNewTop (- intHeight 14)))
  intNewTop
); update_slider_gettop

(defun update_slider_clean ()
  (dcl_PictureBox_DrawSolidRect slider_slider_pic_slider (list (list 0 0 (caddr lstPos) (last lstPos) (dcl_Control_GetBackColor slider_slider_pic_slider))))
); update_slider_clean

(defun c:slider_slider_OnInitialize (/)
  (dcl_ComboBox_AddList slider_slider_cbb_style (list "ScrollBar" "SolidRectangle"))
  (dcl_ComboBox_AddList slider_slider_cbb_small (list "1" "2" "5"))
  (dcl_ComboBox_AddList slider_slider_cbb_large (list "5" "10" "20"))

  (dcl_ComboBox_SetCurSel slider_slider_cbb_style ***intLastStyle***)
  (dcl_ComboBox_SetCurSel slider_slider_cbb_small 0)
  (dcl_ComboBox_SetCurSel slider_slider_cbb_large 0)
); c:slider_slider_OnInitialize

(defun c:slider_slider_OnCancelClose (intIsESC /)
  (princ (strcat "\nOnCancelClose: " (vl-prin1-to-string intIsESC) " \r"))
  (or (not intIsESC) (/= intIsESC 1))
); c:slider_slider_OnCancelClose


(defun c:slider_slider_edt_percent_OnEditChanged (strNewValue / intVal)
  (setq intVal (atoi strNewValue))
  (cond
    ((minusp intVal) (setq ***intLastPercent*** 0))
    ((> intVal 100) (setq ***intLastPercent*** 100))
    (T (setq ***intLastPercent*** intVal))
  ); cond
  (update_slider)
  (if (/= ***intLastPercent*** intVal)
    (dcl_control_settext slider_slider_edt_percent ***intLastPercent***)
  ); if
); c:slider_slider_edt_percent_OnEditChanged

(defun c:slider_slider_cbb_style_OnSelChanged (intStyle strValue /)
  (setq ***intLastStyle*** intStyle)
  (update_slider)
); c:slider_slider_cbb_style_OnSelChanged

(defun c:slider_slider_pic_slider_OnPaint (isHasFocus /)
  (princ "\nOnPaint\r")
  (update_slider)
); c:slider_slider_pic_slider_OnPaint

(defun c:slider_slider_pic_slider_OnMouseEntered (/)
  (dcl_Control_SetFocus slider_slider_pic_slider)
); c:slider_slider_pic_slider_OnMouseEntered

(defun c:slider_slider_pic_slider_OnMouseDown (intButton intFlags intX intY /)
  (princ (strcat "\nOnMouseDown: " (vl-prin1-to-string (list intButton intFlags intX intY)) "\r"))
  (if (= intButton 1)
    (progn
      (setq ***intLastPercent*** (* -1 intY))
      (update_slider_and_text nil)
    ); progn
    (progn
      (dcl_ComboBox_SetCurSel slider_slider_cbb_style (setq ***intLastStyle*** (if (zerop ***intLastStyle***) 1 0)))
      (update_slider)
    ); progn
  ); if
); c:slider_slider_pic_slider_OnMouseDown

(defun c:slider_slider_pic_slider_OnMouseMove (intFlags intX intY /)
  (princ (strcat "\nOnMouseMove: " (vl-prin1-to-string (list intFlags intX intY)) "\r"))
  (if (and (= (logand intFlags 1) 1)
	   (>= intY 0)
	   (<= intY (dcl_Control_GetHeight slider_slider_pic_slider))
           (setq ***intLastPercent*** (* -1 intY)))
    (update_slider_and_text nil)
  ); if
); c:slider_slider_pic_slider_OnMouseMove

(defun c:slider_slider_pic_slider_OnMouseWheel (intFlags intZDelta intX intY /)
  (princ "\nOnMouseWheel\r")
); c:slider_slider_pic_slider_OnMouseWheel

(defun c:slider_slider_pic_slider_OnKeyDown (strCharacter intRepeatCount intFlags / intChar)
  (setq intChar (ascii strCharacter))
  (princ (strcat "\nOnKeyDown: " strCharacter " (" (itoa intChar) ")\r"))

  (if (or (zerop (setq intSmall (atoi (dcl_ComboBox_GetEBText slider_slider_cbb_small))))
          (> intSmall 20))
    (setq intSmall 1)
  ); if
  (if (or (zerop (setq intLarge (atoi (dcl_ComboBox_GetEBText slider_slider_cbb_large))))
          (> intLarge 50))
    (setq intLarge 5)
  ); if
  (if (>= intSmall intLarge)
    (setq intLarge (* 2 intLarge))
  ); if
  (if (/= (itoa intSmall) (dcl_ComboBox_GetEBText slider_slider_cbb_small))
    (dcl_control_settext slider_slider_cbb_small (itoa intSmall))
  ); if
  (if (/= (itoa intLarge) (dcl_ComboBox_GetEBText slider_slider_cbb_large))
    (dcl_control_settext slider_slider_cbb_large (itoa intLarge))
  ); if
  
  (cond
    ((= intChar 33) (princ "\nPgUp\r") (update_slider_and_text (if (minusp (- ***intLastPercent*** intLarge)) 0 (- ***intLastPercent*** intLarge))))
    ((= intChar 34) (princ "\nPgDown\r") (update_slider_and_text (if (> (+ ***intLastPercent*** intLarge) 100) 100 (+ ***intLastPercent*** intLarge))))
    ((= intChar 35) (princ "\nEnde\r") (update_slider_and_text 100))
    ((= intChar 36) (princ "\nPos1\r") (update_slider_and_text 0))
  ); cond
); c:slider_slider_pic_slider_OnKeyDown