
;;; Tap Index Color = DXF group code 62 	-> (62 . ColorIndex)				
;;; Tap True Color  = DXF group code 420	-> (420 . TrueColor)
;;; Tap Color Books = DXF group code 430	-> (430 . "colorbook$colorname")

;;; INDEX COLORS (MEEST GEBRUIKT):
;;; Top Palet worden de 250 kleuren 10 tot en met 249 weergegeven. 
;;; Midden Palet worden de 9 kleuren 1 tot en met 9 weergegeven; deze kleuren hebben namen en nummers.
;;; Onder Palet worden de 6 kleuren 250 tot en met 255 weergegeven; dit zijn grijstinten.

;;; INPUT VOORBEELD COMMAND LINE :
;;; Input command : (acad_truecolordlg '(62 . 1)) Returns : kleur red in Midden Palet - Index Color
;;; Input command : (acad_truecolordlg '(62 . 160)) Returns : kleur blauw Top Palet - Index Color
;;; Open the color selection dialog to the True Color tab with a green default selection and 
;;; with the By Layer and By Block buttons disabled : 
;;; Command: (acad_truecolordlg '(420 . 2686760) nil)
;;; Open the color selection dialog to the Color Books tab and accept the mustard default selection : 
;;; (acad_truecolordlg '(430 . "RAL CLASSIC$RAL 1003"))

;;; Displays the AutoCAD color selection dialog box with tabs for index color, true color, and color books :
;;; (acad_truecolordlg color [allowbylayer] [currentlayercolor])


	(command "OPENDCL") 
	(vl-load-com)
	
	(defun wx (/ )
		(dcl_project_load "ColorSelector")
		(dcl-Form-Show ColorSelector/dlg)
	(princ)
	)

	; COLORBUTTONS :
	; -------------------------------------------------------------
	(defun c:ColorSelector/dlg/pic_color1#OnClicked (/ lstNew)
		(if (setq lstNew (acad_truecolordlg (last lstColor) T)) 
			(progn
				(setq lstColor lstNew)
				(show)
			)
		)
	)
	(defun c:ColorSelector/dlg/pic_color2#OnClicked (/ lstNew)
		(if (setq lstNew (acad_truecolordlg (last lstColor) T)) 
			(progn
				(setq lstColor lstNew)
				(show)
			)
		)
	)
	(defun c:ColorSelector/dlg/pic_color3#OnClicked (/ lstNew)
		(if (setq lstNew (acad_truecolordlg (last lstColor) T)) 
			(progn
				(setq lstColor lstNew)
				(show)
			)
		)
	)
	(defun c:ColorSelector/dlg/pic_color4#OnClicked (/ lstNew)
		(if (setq lstNew (acad_truecolordlg (last lstColor) T)) 
			(progn
				(setq lstColor lstNew)
				(show)
			)
		)
	)
	; -------------------------------------------------------------
	(defun c:ColorSelector/dlg#OnInitialize (/)
		; DEFAUTLS COLORS:
		(setq lstColor (list (cons 420 14532130))) 	
		(setq lstColor2 (list (cons 62 1)))
		(setq lstColor3 (list (cons 62 4)))
		(setq lstColor4 (list (cons 420 12882491)))
		(show)										
	)
	
	; -------------------------------------------------------------
	(defun convert (intAcadRgb / lstRgb)
		(setq lstRgb (reverse (list (lsh (lsh intAcadRgb 24) -24) (lsh (lsh intAcadRgb 16) -24) (lsh intAcadRgb -16))))
		(+ (lsh (caddr lstRgb) 16) (lsh (cadr lstRgb) 8) (car lstRgb))
	); convert
	
	; -------------------------------------------------------------
	(defun show ()
		(cond
			; als DXF group code 430."colorbook$colorname is :
			((assoc 430 lstColor)(dcl-Control-SetBackColor ColorSelector/dlg/pic_color1 (convert (cdr (assoc 420 lstColor)))))
			; als het DXF group code 420.TrueColor is :
			((assoc 420 lstColor)(dcl-Control-SetBackColor ColorSelector/dlg/pic_color1 (convert (cdr (assoc 420 lstColor)))))
			; als het DXF group code 62.ColorIndex is :
			((assoc 62 lstColor)(dcl-Control-SetBackColor ColorSelector/dlg/pic_color1 (cdr (assoc 62 lstColor))))
			; T = will be executed if all the prior conditions are false :
			(T (dcl-Control-SetBackColor ColorSelector/dlg/pic_color1 -16))  
		)
		(dcl_control_setcaption ColorSelector_dlg_txt_color1 (colorname)) 	; De kleurnaam ook invullen in txt_color
	)
	
	(defun c:ColorSelector/dlg/pb_cancel#OnClicked (/)
		(dcl-Form-Close ColorSelector/dlg)
		(princ)
	)

	
	; -------------------------------------------------------------
	(defun colorname (/ intColor strColor lstRgb)
		(setq strColor "")													; De String Color naam leeg maken
		(cond
			((setq strColor (cdr (assoc 430 lstColor))) strColor) 			            
			((setq intColor (cdr (assoc 420 lstColor)))
			 (setq lstRgb (reverse (list (lsh (lsh intColor 24) -24) (lsh (lsh intColor 16) -24) (lsh intColor -16))))
			 (setq strColor (strcat "Color: " (itoa (car lstRgb)) "," (itoa (cadr lstRgb)) "," (itoa (caddr lstRgb)))))
			((setq strColor (cdr (assoc (setq intColor (cdr (assoc 62 lstColor)))
				'((0 . "ByBlock") (1 . "Red") (2 . "Yellow") (3 . "Green") (4 . "Cyan")
				(5 . "Blue") (6 . "Magenta") (7 . "Black") (256 . "ByLayer")))))
				strColor
			)
			((and intColor (> intColor 7) (< intColor 256))
				(setq strColor (strcat "Color " (itoa intColor)))
			)
		)
		strColor															; Var String Color
		(princ "\nString Color = ")(princ (strcat strColor)) 				; Show String Color
		(princ "\nInteger Color = ")(princ (strcat (rtos intColor)))		; Show Integer intColor
	)
	
	; -------------------------------------------------------------

(princ "Automatic Run...")
(wx)
(princ)








