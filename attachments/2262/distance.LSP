;; see also
;; https://www.theswamp.org/index.php?topic=52115.msg571356#new
;; added abs functions


(load "GrTextV1-1.lsp")

					;***

					;**************


(defun LM:displaygrtext_2d (pnt vec col xof yof / scl)
  (setq	scl (* 0.9 (/ (getvar 'viewsize) (cadr (getvar 'screensize))))
					; scaled it, halam
	pnt (trans pnt 1 2)
  )
  (grvecs (cons col vec)
	  (list
	    (list scl 0.0 0.0 (+ (car pnt) (* xof scl)))
	    (list 0.0 scl 0.0 (+ (cadr pnt) (* yof scl)))
	    (list 0.0 0.0 scl 0.0)
	    '(0.0 0.0 0.0 1.0)
	  )
  )
)






(defun c:dii (/	   x1	y1   z1	  x2   y2   z2	 p1   p2   d	ducs
	      dx   dy	dz   v	  dxw  dyw  dzw	 w    ax   vprim
	      vprimd	axy txtxoff txtyoff stringcolor
	     )
  (while (not p1)
    (setq p1 (getpoint "\nPick or specify start point : "))
  )
  (while (not p2)
    (setq p2 (getpoint p1 "\nPick or specify end point : "))
  )
  (setq d (distance p1 p2))
  (grdraw p1 p2 6 1)			; halam
  (setq dx (car (setq v (mapcar '- p2 p1))))
  (setq dy (cadr v))
  (setq ducs (sqrt (+ (* dx dx) (* dy dy)))) ; halam 
  (setq dz (caddr v))
  (setq dxw (car (setq w (mapcar '- (trans p2 1 0) (trans p1 1 0)))))
  (setq dyw (cadr w))
  (setq dzw (caddr w))
  (setq ax (cvunit (atan dy dx) "radians" "degrees"))
  (setq vprim (list (car v) (cadr v) 0.0))
  (setq vprimd (distance '(0.0 0.0 0.0) vprim))
  (setq axy (cvunit (atan (caddr v) vprimd) "radians" "degrees"))


  (prompt "\nDistance WCS : ")
  (princ (rtos d 2 3))
  (prompt "\n\nDX in UCS : ")
  (princ (rtos dx 2 3))
  (prompt "\nDY in UCS : ")
  (princ (rtos dy 2 3))
  (prompt "\nDZ in UCS : ")
  (princ (rtos dz 2 3))
  (prompt "\n\nDX in WCS : ")
  (princ (rtos dxw 2 3))
  (prompt "\nDY in WCS : ")
  (princ (rtos dyw 2 3))
  (prompt "\nDZ in WCS : ")
  (princ (rtos dzw 2 3))
  (prompt
    "\n\nAngle around Z axis from X axis as 0.0 degree reference : "
  )
  (princ (rtos ax 2 3))
  (prompt " deg")
  (prompt "\nAngle of picked points vector to XY plane : ")
  (princ (rtos axy 2 3))
  (prompt " deg")
  (prompt "\nDistance UCS : ")
  (princ (rtos ducs 2 3))


  (setq	x1 (car p1)			; halam
	y1 (cadr p1)			; halam
	z1 (caddr p1)
  )					; halam
  (setq	x2 (car p2)			; halam
	y2 (cadr p2)			; halam
	z2 (caddr p2)
  )					; halam
  (setq	stringid1 (strcat "ID pt1 : "
			  (rtos x1 2 3)
			  ","
			  (rtos y1 2 3)
			  ","
			  (rtos z1 2 3)
		  )
  )					; halam
  (setq	stringid2 (strcat "\nID pt2 : "
			  (rtos x2 2 3)
			  ","
			  (rtos y2 2 3)
			  ","
			  (rtos z2 2 3)
		  )
  )					; halam
  (setq string1 (strcat "\n\nDist UCS : " (rtos ducs 2 3)))
  (setq string2 (strcat "\nDX : " (rtos dx 2 3)))
  (setq string3 (strcat "\nDY : " (rtos dy 2 3)))
  (if (> dz 0)
    (setq string4 (strcat "\nDZ : " (rtos dz 2 3)))
    (setq string4 (strcat "\nDZ : " (rtos dz 2 3)))
  )
  (if (> (abs dz) 0)
    (setq stringcolor 1)
    (setq stringcolor 7)
  )
  (setq	string6
	 (strcat "\nAngle in UCS plane : " (rtos axy 2 3) " deg")
  )
  (setq string7 (strcat "\n"))
  (setq string8 (strcat "\nDist WCS : " (rtos d 2 3)))
  (setq string9 (strcat "\nDX : " (rtos dxw 2 3)))
  (setq string10 (strcat "\nDY : " (rtos dyw 2 3)))
  (setq string11 (strcat "\nDZ : " (rtos dzw 2 3)))
  (setq string12 (strcat "\nAngle : " (rtos ax 2 3) " deg"))

  (grtext -1 (strcat "Distance UCS : " (rtos ducs 2 3)))

  (setq	ViwSiz (/ (getvar "VIEWSIZE") 2.0)
	ViwCen (getvar "VIEWCTR")
	ViwDim (list
		 (* ViwSiz (apply '/ (getvar "SCREENSIZE")))
		 ViwSiz
	       )
  )
  (setq ll (mapcar '- ViwCen ViwDim))
  (setq ur (mapcar '+ ViwCen ViwDim))
  (setq ll-x (car ll))
  (setq ll-y (cadr ll))
  (setq ur-x (car ur))
  (setq ur-y (cadr ur))
  
;;;  (print ll-x)
;;;  (print ll-y)
;;;  (print ur-x)
;;;  (print ur-y)
  
 (if (< x2 (/ (+ ll-x ur-x) 2)) (setq posx 1) (setq posx 2))
 (if (< y2 (/ (+ ll-y ur-y) 2)) (setq posy 5) (setq posy 10))
; (setq posq (+ posx posy))  		       ; poitions => 11 tl 12 tr 7
 (setq perc_1 	(/ (- ur-x x2) (- ur-x ll-x))) ; <0.11 do offset 4 x mirror
 (setq perc_2 	(/ (- ur-y y2) (- ur-y ll-y))) ; >0.85 do offset 4 y mirror
 (if (< perc_1 0.11) (setq txtxoff -250) (setq txtxoff 2))
 (if (> perc_2 0.85) (setq txtyoff  90) (setq txtyoff 10)) 

  (setq	alertstring_no_dz
	 (strcat string1 string2 string3 string4 string12)
  )
  (setq	alertstring_dz
	 (strcat stringid1   stringid2	 string1     string8     string7 string2 
		 string3     string4	  string7 	string6     
		      string12
		)
  )
  (setq alertmode (getvar "vsfacestyle"))
  (setq tilemodemode (getvar "tilemode"))
  
  (if (> (abs dz) 0)
    (setq alertstring alertstring_dz)
    (setq alertstring alertstring_no_dz)
  )
  (if (> (abs dz) 0)
    (setq alertstring alertstring_dz)
    (setq alertstring alertstring_no_dz)
  )


  ;; Display GrText  -  Lee Mac
  ;; pnt  -  cursor point in UCS
  ;; vec  -  GrText vector list
  ;; col  -  Text Colour (ACI Colour)
  ;; xof  -  x-offset from cursor in pixels
  ;; yof  -  y-offset from cursor in pixels

(if (= tilemodemode 1) 
  (if (= alertmode 0)			; depending on vsfacestyle 0 = 2D wireframe  
    (LM:DisplayGrText_2d
      p2
      (LM:GrText (strcat alertstring))
      stringcolor
      txtxoff
      txtyoff
    )					; only 2D with GRtext
    (alert alertstring)			; else put it in a message
  )
  (alert alertstring)
  )
  
  (princ)
)

(defun C:D () (c:dii))			;halam

