;;; ===================================================================================================
;;;					   Slider-Sample					       
;;; ===================================================================================================










; *****************************************************************************************************
; Command:	slider
; Description:	(Re)Starting command
; Author:	Fred Tomke
; Start-Date:	2009-10-27
; Arguments:	none
; Globals:	***intLastPercent*** 	= percentage value as integer
;		***intLastTop*** 	= last top value of scroll button as integer
;		***intLastStyle*** 	= last scrollbar style as integer
;		***intLastStyleHeight*** = last style depended height as integer
;		***intLastBorder***	= last scrollbar borderstyle as integer
;		***do_event_log***	= boole, T if event log is activated
; Notes:	slider.odcl has to be placed in a AutoCAD-support folder
; Changes:	none


(defun c:slider ()
  (command "opendcl")
  (setq ***intLastPercent*** 0)
  (setq ***intLastTop*** 0)
  (setq ***intLastStyle*** 0)
  (setq ***intLastStyleHeight*** 12)
  (setq ***intLastBorder*** 2)
  (setq ***do_event_log*** nil)
  (dcl_project_load "slider" T)
  (dcl_form_show slider_slider)
  (princ)
); slider










;;; ===================================================================================================
;;;					      Modules					       	       
;;; ===================================================================================================










; *****************************************************************************************************
; Function:	update_slider_and_text
; Description:	updates the scrollbar position and the textbox value
; Author:	Fred Tomke
; Start-Date:	2009-10-27
; Arguments:	intNewPercent = new percentage value as integer | new top value as negative integer | nil for update only with last value
; Ret. values:	not needed
; Changes:	none


(defun update_slider_and_text (intNewPercent)
  (if intNewPercent (setq ***intLastPercent*** intNewPercent))
  (dcl_control_settext slider_slider_edt_percent (update_slider))
); update_slider_and_text










; *****************************************************************************************************
; Function:	update_slider
; Description:	updates the scrollbar position
; Author:	Fred Tomke
; Start-Date:	2009-10-27
; Arguments:	none
; Ret. values:	new percentage value as integer
; Changes:	none


(defun update_slider (/ lstPos intPercent lstLines intLeft)
  (cond
    ((not (setq intPercent ***intLastPercent***)) nil)
    ((not (setq lstPos (dcl_Control_GetPos slider_slider_pic_slider))) nil)
    ((not (setq ***intLastTop*** (update_slider_gettop))) nil)
    
    ((or (not ***intLastStyle***) (zerop ***intLastStyle***))
     (update_slider_clean)
     (dcl_PictureBox_PaintPicture slider_slider_pic_slider (list (list 0 ***intLastTop*** 100 T nil))))
    
    ((= ***intLastStyle*** 1)
     (dcl_PictureBox_DrawSolidRect slider_slider_pic_slider
                                   (list (list 0 0 (caddr lstPos) (last lstPos) (dcl_Control_GetBackColor slider_slider_pic_slider))
                                         (list 0 ***intLastTop*** (caddr lstPos) 2 0)
                                         (list 0 (+ ***intLastTop*** 2) (caddr lstPos) 8 171)
                                         (list 0 (+ ***intLastTop*** 10) (caddr lstPos) 2 0)
                                         )))
    ((= ***intLastStyle*** 2)
     (dcl_PictureBox_DrawSolidRect slider_slider_pic_slider
                                   (list (list 0 0 (caddr lstPos) ***intLastTop*** 171)
                                         (list 0 ***intLastTop*** (caddr lstPos) (last lstPos) (dcl_Control_GetBackColor slider_slider_pic_slider))
                                         )))

    ((= ***intLastStyle*** 3)
     (update_slider_clean)
     (repeat (1+ (setq intLen (1- (caddr lstPos))))
       (setq lstLines (cons (list 0 0 (setq intLen (1- intLen)) (last lstPos) 163) lstLines))
     ); repeat
     (dcl_PictureBox_DrawLine slider_slider_pic_slider lstLines)
     (dcl_PictureBox_DrawSolidRect slider_slider_pic_slider (list (list 0 (1- ***intLastTop***) (caddr lstPos) 3 0))))

    ((= ***intLastStyle*** 4)
     (setq intLeft (1- (fix (* 0.5 (caddr lstPos)))))
     (dcl_PictureBox_DrawSolidRect slider_slider_pic_slider
                                   (list (list 0 0 (caddr lstPos) (last lstPos) (dcl_Control_GetBackColor slider_slider_pic_slider))
                                         (list intLeft 0 1 (last lstPos) 8)))
     (setq intLeft (fix (* 0.5 (- (caddr lstPos) ***intLastStyleHeight*** ***intLastBorder***))))
     (dcl_PictureBox_PaintPicture slider_slider_pic_slider (list (list intLeft ***intLastTop*** 101 T nil))))
    
  ); cond
  ***intLastPercent***
); update_slider










; *****************************************************************************************************
; Function:	update_slider_gettop
; Description:	converts the percentage value into y-coordinate for the scrollbar button
; Author:	Fred Tomke
; Start-Date:	2009-10-27
; Arguments:	none
; Ret. values:	new y-coordinate as integer
; Changes:	none


(defun update_slider_gettop (/ intHeight intNewTop intBorder)
  (setq intHeight (last lstPos))
  
  (cond
    ((not intPercent) (setq intPercent 0))
    ((minusp intPercent) (setq intNewTop (abs intPercent)
                               intPercent (fix (* 100.0 (/ (float intNewTop) (float intHeight))))
                               ***intLastPercent*** intPercent))
    (T (setq intNewTop (atoi (rtos (* intHeight (* intPercent 0.01)) 2 0))))
  ); cond

  (cond
    ((= ***intLastBorder*** 0) (setq intBorder 0))
    ((= ***intLastBorder*** 1) (setq intBorder 4))
    ((= ***intLastBorder*** 2) (setq intBorder 2))
  ); cond

  ;; corrects the Top value for the case the button would disappear below the button
  (if (>= (+ intNewTop ***intLastStyleHeight*** intBorder) intHeight)
    (setq intNewTop (- intHeight (+ ***intLastStyleHeight*** intBorder)))
  ); if
  
  intNewTop
); update_slider_gettop










; *****************************************************************************************************
; Function:	update_slider_clean
; Description:	Cleans the scrollbar from its contents
; Author:	Fred Tomke
; Start-Date:	2009-10-27
; Arguments:	none
; Ret. values:	not needed
; Changes:	none


(defun update_slider_clean ()
  (dcl_PictureBox_DrawSolidRect slider_slider_pic_slider (list (list 0 0 (caddr lstPos) (last lstPos) (dcl_Control_GetBackColor slider_slider_pic_slider))))
); update_slider_clean










; *****************************************************************************************************
; Function:	update_slider_read_increment
; Description:	Reads and checks the increment values from the comboboxes and sets variables
; Author:	Fred Tomke
; Start-Date:	2009-10-27
; Arguments:	none
; Ret. values:	not needed
; Changes:	none


(defun update_slider_read_increment ()
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
); update_slider_read_increment










; *****************************************************************************************************
; Function:	update_slider_message
; Description:	Appends an additional line at the end of the log
; Author:	Fred Tomke
; Start-Date:	2009-10-27
; Arguments:	strLine = additional line as string
; Ret. values:	not needed
; Changes:	none


(defun update_slider_message (strLine)
  (if ***do_event_log***
    (progn
      (dcl_control_settext slider_slider_edt_info (strcat (dcl_control_gettext slider_slider_edt_info) "\r\n" strLine))
      (dcl_TextBox_LineScroll slider_slider_edt_info (dcl_TextBox_GetLineCount slider_slider_edt_info))
    ); progn
  ); if
); update_slider_message










;;; ===================================================================================================
;;;					      Events					       	       
;;; ===================================================================================================










; *****************************************************************************************************
; Event:	c:slider_slider_OnInitialize
; Event desc.:	Called, when dcl_form_show is executed. Sets initial values to the form and its controls
; Author:	Fred Tomke
; Start-Date:	2009-10-27
; Arguments:	none
; Ret. values:	not needed
; Changes:	none


(defun c:slider_slider_OnInitialize (/)

  (mapcar 'dcl_combobox_clear (list slider_slider_cbb_style slider_slider_cbb_border slider_slider_cbb_small slider_slider_cbb_large))
  
  (dcl_ComboBox_AddList slider_slider_cbb_style (list "ScrollBar" "SolidRectangle" "SolidFilling" "SolidTriangle" "Bullet"))
  (dcl_ComboBox_AddList slider_slider_cbb_border (list "None" "Client" "Static"))
  (dcl_ComboBox_AddList slider_slider_cbb_small (list "1" "2" "5"))
  (dcl_ComboBox_AddList slider_slider_cbb_large (list "5" "10" "20"))

  (dcl_Control_SetBorderStyle slider_slider_pic_slider ***intLastBorder***)
  (dcl_ComboBox_SetCurSel slider_slider_cbb_style ***intLastStyle***)
  (dcl_ComboBox_SetCurSel slider_slider_cbb_small 0)
  (dcl_ComboBox_SetCurSel slider_slider_cbb_large 0)
  (dcl_ComboBox_SetCurSel slider_slider_cbb_border ***intLastBorder***)

  (dcl_Control_SetValue slider_slider_chb_event (if ***do_event_log*** 1 0))
); c:slider_slider_OnInitialize










; *****************************************************************************************************
; Event:	c:slider_slider_OnCancelClose
; Event desc.:	Called, when Return was pressed in the textbox or the user has pressed ESC or he is closing the form.
; Author:	Fred Tomke
; Start-Date:	2009-10-27
; Arguments:	intIsESC = reason of closing as integer; 0, when Return was pressed in the textbox
; Ret. values:	boole, T to prevent the form from closing
; Changes:	none


(defun c:slider_slider_OnCancelClose (intIsESC /)
  (update_slider_message (strcat "OnCancelClose: " (vl-prin1-to-string intIsESC)))
  (/= intIsESC 1)
); c:slider_slider_OnCancelClose










; *****************************************************************************************************
; Event:	c:slider_slider_edt_percent_OnEditChanged
; Event desc.:	Called, when the textbox content was changed
; Author:	Fred Tomke
; Start-Date:	2009-10-27
; Arguments:	strNewValue = new textbox content as string
; Ret. values:	not needed
; Changes:	none


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










; *****************************************************************************************************
; Event:	c:slider_slider_cbb_style_OnSelChanged
; Event desc.:	Called, when the user changes the scrollbar style
; Author:	Fred Tomke
; Start-Date:	2009-10-27
; Arguments:	intStyle = index of selected item
;		strValue = text value of selected item
; Ret. values:	not needed
; Changes:	none


(defun c:slider_slider_cbb_style_OnSelChanged (intStyle strValue /)
  (setq ***intLastStyle*** intStyle)
  (cond
    ((member intStyle '(0 1)) (setq ***intLastStyleHeight*** 12))
    ((= intStyle 4) (setq ***intLastStyleHeight*** 16))
    (T (setq ***intLastStyleHeight*** 0))
  ); cond
  (update_slider)
); c:slider_slider_cbb_style_OnSelChanged










; *****************************************************************************************************
; Event:	c:slider_slider_cbb_border_OnSelChanged
; Event desc.:	Called, when the user changes the borderstyle style
; Author:	Fred Tomke
; Start-Date:	2009-10-27
; Arguments:	intBorder = index of selected borderstyle
;		strValue = text value of selected item
; Ret. values:	not needed
; Changes:	none


(defun c:slider_slider_cbb_border_OnSelChanged (intBorder strValue /)
  (dcl_Control_SetBorderStyle slider_slider_pic_slider (setq ***intLastBorder*** intBorder))
); c:slider_slider_cbb_border_OnSelChanged










; *****************************************************************************************************
; Event:	c:slider_slider_chb_event_OnClicked
; Event desc.:	Activates the eventlog
; Author:	Fred Tomke
; Start-Date:	2009-10-27
; Arguments:	intValue = toggle state as integer
; Ret. values:	not needed
; Changes:	none


(defun c:slider_slider_chb_event_OnClicked (intValue /)
  (setq ***do_event_log*** (= intValue 1))
); c:slider_slider_chb_event_OnClicked










; *****************************************************************************************************
; Event:	c:slider_slider_pic_slider_OnPaint
; Event desc.:	Called, whenever the picturebox has to be repaint
; Author:	Fred Tomke
; Start-Date:	2009-10-27
; Arguments:	isHasFocus = boole, T id picturebox has focus
; Ret. values:	not needed
; Changes:	none


(defun c:slider_slider_pic_slider_OnPaint (isHasFocus /)
  (update_slider_message "OnPaint")
  (update_slider)
); c:slider_slider_pic_slider_OnPaint










; *****************************************************************************************************
; Event:	c:slider_slider_pic_slider_OnMouseEntered
; Event desc.:	Called, when the mouse flies over the picturebox.
; Author:	Fred Tomke
; Start-Date:	2009-10-27
; Arguments:	none
; Ret. values:	not needed
; Notes:	To make sure that picturebox has focus for OnKeyPressed event and mousewheel
; Changes:	none


(defun c:slider_slider_pic_slider_OnMouseEntered (/)
  (dcl_Control_SetFocus slider_slider_pic_slider)
); c:slider_slider_pic_slider_OnMouseEntered










; *****************************************************************************************************
; Event:	c:slider_slider_pic_slider_OnMouseDown
; Event desc.:	Called, when the user presses a mousebutton on the control
; Author:	Fred Tomke
; Start-Date:	2009-10-27
; Arguments:	intButton = button as integer
;		intFlags = sum of bitflags as integer
;		intX = client x coordinate of mouseposition as integer
;		intY = client y coordinate of mouseposition as integer
; Ret. values:	not needed
; Notes:	Left mousebutton over the scrollbar button = large step up
;		Left mousebutton below the scrollbar button = large step down
;		Left mousebutton on the scrollbar button = move directly to destination
;		Right mousebutton anywhere = move directly to destination
; Changes:	none


(defun c:slider_slider_pic_slider_OnMouseDown (intButton intFlags intX intY / intPercent intSmall intLarge)
  (update_slider_message (strcat "OnMouseDown: " (vl-prin1-to-string (list intButton intFlags intX intY))))
  (update_slider_read_increment)
  (if (= intButton 1)
    (cond
      ((and (>= intY ***intLastTop***) (<= intY (+ ***intLastTop*** ***intLastStyleHeight***)))
       (setq ***intLastPercent*** (* -1 intY))
       (update_slider_and_text nil))

      ((< intY ***intLastTop***)
       (setq intPercent (- ***intLastPercent*** intLarge))
       (if (minusp intPercent) (setq intPercent 0))
       (update_slider_and_text intPercent))

      ((> intY (+ ***intLastTop*** ***intLastStyleHeight***))
       (setq intPercent (+ ***intLastPercent*** intLarge))
       (if (> intPercent 100) (setq intPercent 100))
       (update_slider_and_text intPercent))
    ); cond
    (progn
      (setq ***intLastPercent*** (* -1 intY))
      (update_slider_and_text nil)
    ); progn
  ); if
); c:slider_slider_pic_slider_OnMouseDown










; *****************************************************************************************************
; Event:	c:slider_slider_pic_slider_OnMouseMove
; Event desc.:	Called, when the user moves the mouse over the control.
; Author:	Fred Tomke
; Start-Date:	2009-10-27
; Arguments:	intFlags = sum of bitflags as integer
;		intX = client x coordinate of mouseposition as integer
;		intY = client y coordinate of mouseposition as integer
; Ret. values:	not needed
; Notes:	Triggers the moving of the scrollbar button.
;		Don't move too fast! If the mouse coordinates are too far away from the scrollbar button, moving will stop!
; Changes:	none


(defun c:slider_slider_pic_slider_OnMouseMove (intFlags intX intY /)
  (update_slider_message (strcat "OnMouseMove: " (vl-prin1-to-string (list intFlags intX intY))))
  (if (and (= (logand intFlags 1) 1)
	   (>= intY 0)
	   (<= intY (dcl_Control_GetHeight slider_slider_pic_slider))
           (or (member ***intLastStyle*** '(2 3))
               (and (>= intY (- ***intLastTop*** ***intLastStyleHeight***))
                    (<= intY (+ ***intLastTop*** ***intLastStyleHeight***))))
           (setq ***intLastPercent*** (* -1 intY)))
    (update_slider_and_text nil)
  ); if
); c:slider_slider_pic_slider_OnMouseMove










; *****************************************************************************************************
; Event:	c:slider_slider_pic_slider_OnMouseWheel
; Event desc.:	Called, when the user has scrolled the mousewheel
; Author:	Fred Tomke
; Start-Date:	2009-10-27
; Arguments:	intFlags = sum of bitflags as integer
;		intZDelta = number of lines which are scrolled, negative, when down
;		intX = client x coordinate of mouseposition as integer
;		intY = client y coordinate of mouseposition as integer
; Ret. values:	not needed
; Notes:	Scrolling down = small step down
;		Scrolling up = small step up
;		Pressing Shift-Key while scrolling uses large step instead of small steps
;		The increment values are read at runtime of this event.
; Changes:	none


(defun c:slider_slider_pic_slider_OnMouseWheel (intFlags intZDelta intX intY / intPercent intSmall intLarge)
  (update_slider_message (strcat "OnMouseWheel: " (vl-prin1-to-string (list intFlags intZDelta intX intY))))
  (update_slider_read_increment)
  (if (minusp intZDelta)
    (if (zerop (logand intFlags 4))
      (setq intPercent (+ ***intLastPercent*** intSmall))
      (setq intPercent (+ ***intLastPercent*** intLarge))
    ); if
    (if (zerop (logand intFlags 4))
      (setq intPercent (- ***intLastPercent*** intSmall))
      (setq intPercent (- ***intLastPercent*** intLarge))
    ); if
  ); if

  (cond
    ((minusp intPercent) (setq intPercent 0))
    ((> intPercent 100) (setq intPercent 100))
  ); cond

  (update_slider_and_text intPercent)
  
); c:slider_slider_pic_slider_OnMouseWheel










; *****************************************************************************************************
; Event:	c:slider_slider_pic_slider_OnKeyDown
; Event desc.:	Called, when a key was pressed when picturebox has focus
; Author:	Fred Tomke
; Start-Date:	2009-10-27
; Arguments:	strCharacter = character as string
;		intRepeatCount = number of repeating as integer
;		intFlags = sum of bitflags as integer
; Ret. values:	not needed
; Notes:	PgUp = large step up
;		PgDown = large step down
;		Ende = bottom
;		Pos1 = top
;		Left or Up = small step up
;		Right or Down = small step down
;		The increment values are read at runtime of this event.
; Changes:	none


(defun c:slider_slider_pic_slider_OnKeyDown (strCharacter intRepeatCount intFlags / intChar intSmall intLarge)
  (setq intChar (ascii strCharacter))
  (update_slider_message (strcat "OnKeyDown: " strCharacter " (" (itoa intChar) ")"))

  (update_slider_read_increment)

  (cond
    ((= intChar 33) (update_slider_message "PgUp") (update_slider_and_text (if (minusp (- ***intLastPercent*** intLarge)) 0 (- ***intLastPercent*** intLarge))))
    ((= intChar 34) (update_slider_message "PgDown") (update_slider_and_text (if (> (+ ***intLastPercent*** intLarge) 100) 100 (+ ***intLastPercent*** intLarge))))
    ((= intChar 35) (update_slider_message "Ende") (update_slider_and_text 100))
    ((= intChar 36) (update_slider_message "Pos1") (update_slider_and_text 0))
    ((or (= intChar 37) (= intChar 38)) (update_slider_message "ArrowUpOrLeft") (update_slider_and_text (if (minusp (- ***intLastPercent*** intSmall)) 0 (- ***intLastPercent*** intSmall))))
    ((or (= intChar 39) (= intChar 40)) (update_slider_message "ArrowDownOrRight") (update_slider_and_text (if (> (+ ***intLastPercent*** intSmall) 100) 100 (+ ***intLastPercent*** intSmall))))
  ); cond
); c:slider_slider_pic_slider_OnKeyDown