;;; ===================================================================================================
;;;					  RangeSelection-Sample					       
;;; ===================================================================================================










; *****************************************************************************************************
; Command:	RangeSelector
; Description:	(Re)Starting command
; Author:	Fred Tomke
; Start-Date:	2009-10-28
; Arguments:	none
; Globals:	***start*** 	= percentage start value as integer
;		***end*** 	= percentage end value as integer
;		***LastClickX*** = last click x-position in client coordinates as integer
; Notes:	rase.odcl has to be placed in a AutoCAD-support folder
; Changes:	none


(defun c:RangeSelector ()
  (setq ***start*** 0)
  (setq ***end*** 0)
  (setq ***LastClickX*** 0)
  (command "opendcl")
  (dcl_project_load "rase" T)
  (dcl_form_show rase_dlg)
  (princ)
); RangeSelector










;;; ===================================================================================================
;;;					      Modules					       	       
;;; ===================================================================================================










; *****************************************************************************************************
; Function:	update_rangeselector
; Description:	updates the selector position and the text values
; Author:	Fred Tomke
; Start-Date:	2009-10-28
; Arguments:	none
; Ret. values:	not needed
; Changes:	none


(defun update_rangeselector (/ lstPos intStart intEnd)
  (cond
    ((not rase_dlg_sel) nil) ;; called before form is visible
    ((not (setq lstPos (dcl_Control_GetPos rase_dlg_sel))) nil)
    ((or (null ***start***) (null ***end***)
         (and (zerop ***start***) (zerop ***end***)))
     (update_rangeselector_clean))
    (T (setq intStart (update_rangeselector_percenttox ***start***))
     (setq intEnd (update_rangeselector_percenttox ***end***))
     (dcl_PictureBox_DrawSolidRect rase_dlg_sel (list (list 0 0 (caddr lstPos) (last lstPos) (dcl_Control_GetBackColor rase_dlg_sel))
                                                      (list intStart 5 (- intEnd intStart) 10 161)))
     (dcl_PictureBox_DrawLine rase_dlg_sel (list (list 0 0 0 (last lstPos) -18)
                                                 (list (1- (caddr lstPos)) 0 (1- (caddr lstPos)) (last lstPos) -18)

                                                 (list (- intStart 2) 0 (+ intStart 2) 0 -19)
                                                 (list (- intStart 2) 0 intStart 5 -19)
                                                 (list (+ intStart 2) 0 intStart 5 -19)

                                                 (list (- intStart 2) 20 (+ intStart 2) 20 -19)
                                                 (list (- intStart 2) 20 intStart 15 -19)
                                                 (list (+ intStart 2) 20 intStart 15 -19)

                                                 (list (- intEnd 2) 0 (+ intEnd 2) 0 -19)
                                                 (list (- intEnd 2) 0 intEnd 5 -19)
                                                 (list (+ intEnd 2) 0 intEnd 5 -19)

                                                 (list (- intEnd 2) 20 (+ intEnd 2) 20 -19)
                                                 (list (- intEnd 2) 20 intEnd 15 -19)
                                                 (list (+ intEnd 2) 20 intEnd 15 -19)

                                                 ))



                                                 
     (dcl_PictureBox_DrawText rase_dlg_sel (list (list intStart 25 -19 -16 (strcat (itoa ***start***) " %") 0)
                                                 (list intEnd 25 -19 -16 (strcat (itoa ***end***) " %") 2)))
     )
  ); cond
); update_rangeselector










; *****************************************************************************************************
; Function:	update_rangeselector_clean
; Description:	Cleans the picturebox and draws standard text if no values were set before
; Author:	Fred Tomke
; Start-Date:	2009-10-28
; Arguments:	none
; Ret. values:	not needed
; Changes:	none


(defun update_rangeselector_clean ()
  (dcl_PictureBox_DrawSolidRect rase_dlg_sel (list (list 0 0 (caddr lstPos) (last lstPos) (dcl_Control_GetBackColor rase_dlg_sel))))
  (dcl_PictureBox_DrawText rase_dlg_sel (list (list (fix (* 0.5 (dcl_Control_GetWidth rase_dlg_sel))) 10 -19 -16 "Please click and drag here!" 1)))
); update_rangeselector_clean










; *****************************************************************************************************
; Function:	update_rangeselector_percenttox
; Description:	Converts the percentage value into mouse x-position value
; Author:	Fred Tomke
; Start-Date:	2009-10-28
; Arguments:	intPercent = percentage value as integer
; Ret. values:	mouse position in client coordinates as integer
; Changes:	none


(defun update_rangeselector_percenttox (intPercent)
  (fix (* intPercent 0.01 (caddr lstPos)))
); update_rangeselector_percenttox










; *****************************************************************************************************
; Function:	update_rangeselector_xtopercent
; Description:	Converts the position value into percentage value
; Author:	Fred Tomke
; Start-Date:	2009-10-28
; Arguments:	intX = mouse position in client coordinates as integer
; Ret. values:	percentage value as integer
; Changes:	none


(defun update_rangeselector_xtopercent (intX)
  (fix (* 100.0 (/ (float intX) (dcl_Control_GetWidth rase_dlg_sel))))
); update_rangeselector_xtopercent










; *****************************************************************************************************
; Function:	update_rangeselector_setvalue
; Description:	generates the new values for start and end percentage value and calls the update function
; Author:	Fred Tomke
; Start-Date:	2009-10-28
; Arguments:	intX = last click or mousemove position in client coordinates (negative if from OnMouseDown) as integer
; Ret. values:	not needed
; Changes:	none


(defun update_rangeselector_setvalue (intX / intPercent isClick intQuarter intLastPercent intNewStart intNewEnd)
  (setq isClick (minusp intX))
  (setq intPercent (update_rangeselector_xtopercent (abs intX)))
  (setq intQuarter (fix (/ (abs (- ***end*** ***start***)) 4.0)))
  
  (cond
    ((or (< intPercent ***start***)
         (<= intPercent (+ ***start*** intQuarter)))
     (setq ***start*** intPercent)
     (update_rangeselector))

    ((or (> intPercent ***end***)
         (> intPercent (- ***end*** intQuarter)))
     (setq ***end*** intPercent)
     (update_rangeselector))

    ((and (not isClick)
          (> intPercent (+ ***start*** intQuarter))
          (< intPercent (- ***end*** intQuarter))
          (/= intPercent (setq intLastPercent (update_rangeselector_xtopercent (abs ***LastClickX***))))
          (setq intNewStart (+ ***start*** (- intPercent intLastPercent)))
          (>= intNewStart 0)
          (setq intNewEnd (+ ***end*** (- intPercent intLastPercent)))
          (<= intNewEnd 100))
     
     (setq ***start*** intNewStart)
     (setq ***end*** intNewEnd)
     (setq ***LastClickX*** (abs intX))
     (update_rangeselector))
 
  ); cond
); update_rangeselector_setvalue










;;; ===================================================================================================
;;;					      Events					       	       
;;; ===================================================================================================










; *****************************************************************************************************
; Event:	c:rase_dlg_sel_OnPaint
; Event desc.:	Called, whenever the picturebox has to be repaint
; Author:	Fred Tomke
; Start-Date:	2009-10-28
; Arguments:	isHasFocus = boole, T id picturebox has focus
; Ret. values:	not needed
; Notes:	Will also be called at dcl_form_show before any value is set
; Changes:	none


(defun c:rase_dlg_sel_OnPaint (isHasFocus /)
;;;  (princ "\nOnPaint\r")
  (update_rangeselector)
); c:rase_dlg_sel_OnPaint










; *****************************************************************************************************
; Event:	c:rase_dlg_sel_OnMouseEntered
; Event desc.:	Called, when the mouse flies over the picturebox.
; Author:	Fred Tomke
; Start-Date:	2009-10-28
; Arguments:	none
; Ret. values:	not needed
; Notes:	To make sure that picturebox has focus for OnKeyPressed event and mousewheel
; Changes:	none


(defun c:rase_dlg_sel_OnMouseEntered (/)
  (dcl_Control_SetFocus rase_dlg_sel)
); c:rase_dlg_sel_OnMouseEntered










; *****************************************************************************************************
; Event:	c:rase_dlg_sel_OnMouseDown
; Event desc.:	Called, when a mouse button was pressed over the control.
; Author:	Fred Tomke
; Start-Date:	2009-10-28
; Arguments:	intButton = button as integer
;		intFlags = sum of bitflags as integer
;		intX = client x coordinate of mouseposition as integer
;		intY = client y coordinate of mouseposition as integer
; Ret. values:	not needed
; Changes:	none


(defun c:rase_dlg_sel_OnMouseDown (intButton intFlags intX intY / intPercent)
;;;  (princ (strcat "\nOnMouseDown: " (vl-prin1-to-string (list intButton intFlags intX intY)) "\r"))
  (if (and (= intButton 1)
           (not (minusp intX))
           (<= intX (dcl_Control_GetWidth rase_dlg_sel))
           (setq ***LastClickX*** intX))
    (update_rangeselector_setvalue (- intX))
  ); if
); c:rase_dlg_sel_OnMouseDown










; *****************************************************************************************************
; Event:	c:rase_dlg_sel_OnMouseMove
; Event desc.:	Called, when the user moves the mouse over the control
; Author:	Fred Tomke
; Start-Date:	2009-10-28
; Arguments:	intFlags = sum of bitflags as integer
;		intX = client x coordinate of mouseposition as integer
;		intY = client y coordinate of mouseposition as integer
; Ret. values:	not needed
; Changes:	none


(defun c:rase_dlg_sel_OnMouseMove (intFlags intX intY / intPercent)
;;;  (princ (strcat "\nOnMouseMove: " (vl-prin1-to-string (list intFlags intX intY)) "\r"))
  (if (and (= (logand intFlags 1) 1)
           (not (minusp intX))
           (<= intX (dcl_Control_GetWidth rase_dlg_sel)))
    (update_rangeselector_setvalue intX)
  ); if
); c:rase_dlg_sel_OnMouseMove
