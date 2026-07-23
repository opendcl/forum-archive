; Note:
; The OLE value used by ODCL is different from the OLE value used by AutoCAD
; and BricsCAD (for example in entity lists). In the OLE value used by the
; CAD-programs the RGB-values are reversed.
(defun LIB_Odcl_Color_Rgb_To_Ole (rgbLst)
  (+
    (lsh (caddr rgbLst) 16)
    (lsh (cadr rgbLst) 8)
    (car rgbLst)
  )
)

(defun LIB_Sys_Color_Aci_To_String (aci)
  (cond
    ((<= 0 aci 7)
      (nth aci '("ByBlock" "Red" "Yellow" "Green" "Cyan" "Blue" "Magenta" "White"))
    )
    ((<= 8 aci 255)
      (itoa aci)
    )
    ((= aci 256)
      "ByLayer"
    )
  )
)

(defun LIB_Sys_Color_Rgb_To_String (rgbLst)
  (strcat "RGB:" (itoa (car rgbLst)) "," (itoa (cadr rgbLst)) "," (itoa (caddr rgbLst)))
)

; 'Safe' version of (nth) with reversed arguments.
(defun LIB_List_Nth (lst i)
  (if (and (not (minusp i)) (< i (vl-list-length lst)))
    (nth i lst)
  )
)

;;; 20130211B
;;; ======================================================================
;;; Function:      FlexColorDialog
;;; Purpose:       Display a flexible color dialog to get a color.
;;; Arguments:     colorList    - (list of ROW lists as (color [as ACI index or RGB list or nil for empty swatch] color ...) {nil [for empty row]} ...).
;;;                showTextP    - Boolean flag.
;;;                showTooltipP - Boolean flag.
;;; Return value:  Color as ACI index or RGB list or nil.
;;; Remarks:       Combining showTextP=T with showTooltipP=T doesn't make sense.
;;; Examples:      (FlexColorDialog '((1 2 3 4 5 6 7 8 9) (250 251 252 253 254 255 nil 0 256) ((11 186 247) (247 186 11))) nil T)
;;; ======================================================================
(defun FlexColorDialog
  (
    colorList
    showTextP
    showTooltipP
  /
    c:FlexColorDialog_Form1_OnInitialize
    c:FlexColorDialog_Form1_PictureBox1_OnMouseDown
    c:FlexColorDialog_Form1_PictureBox1_OnMouseMove
    c:FlexColorDialog_Form1_PictureBox1_OnPaint
    N_CoordsToColor
    N_CreateColorSwatchList
    N_DrawColorSwatch

    colorOut
    colorSwatchList ; Format: ((xLeft yTop color) (xLeft yTop color) ...).
    distBetween
    distOutside
    formX
    formY
    paintedP  ; Boolean to avoid unnecessary repainting of PictureBox1.
    sizeX     ; Size of color swatch.
    sizeY     ; Size of color swatch.
    textMaskY ; Height of solid rectangle to mask old text.
  )

  (progn ; BEGIN NESTED FUNCTIONS.

  (defun c:FlexColorDialog_Form1_OnInitialize ()
    (dcl_Control_SetTitleBarText FlexColorDialog_Form1 "Select a Color")
    (dcl_Form_Resize FlexColorDialog_Form1
      (setq formX
        (+
          (* (apply 'max (mapcar 'length colorList)) (+ distBetween sizeX))
          (- distBetween)
          distOutside
          distOutside
        )
      )
      (setq formY
        (+
          (* (length colorList) (+ distBetween sizeY))
          (- distBetween)
          distOutside
          distOutside
          (if showTextP (+ textMaskY distBetween) 0)
        )
      )
    )
    (setq colorSwatchList (N_CreateColorSwatchList colorList))
  )

  (defun c:FlexColorDialog_Form1_PictureBox1_OnMouseDown (button flags x y / row)
    (if (setq colorOut (N_CoordsToColor x y))
      (dcl_Form_Close FlexColorDialog_Form1)
    )
  )

  (defun c:FlexColorDialog_Form1_PictureBox1_OnMouseMove (flags x y / color str)
    (setq str
      (if (setq color (N_CoordsToColor x y))
        (if (listp color)
          (LIB_Sys_Color_Rgb_To_String color)
          (LIB_Sys_Color_Aci_To_String color)
        )
        ""
      )
    )
    (if showTextP
      (progn
        (dcl_PictureBox_DrawSolidRect
          FlexColorDialog_Form1_PictureBox1
          (list (list 0 (- formY textMaskY distOutside) formX textMaskY -16))
        )
        (dcl_PictureBox_DrawText FlexColorDialog_Form1_PictureBox1
          (list (list distOutside (- formY distOutside 3) 0 -24 str 3)) ; 3 = alignment BL.
        )
      )
    )
    (if showTooltipP
      (dcl_Control_SetToolTipMainText FlexColorDialog_Form1_PictureBox1 str)
      ;; Strangely enough the next line of code is required (tested with BricsCAD 13).
      ;; Without it, if the function (FlexColorDialog) is first called with
      ;; showTooltipP=T and then with showTooltipP=nil, the last tooltip from
      ;; the first function call will be shown during the second function call.
      (dcl_Control_SetToolTipMainText FlexColorDialog_Form1_PictureBox1 "")
    )
  )

  (defun c:FlexColorDialog_Form1_PictureBox1_OnPaint (hasFocus /)
    (if (not paintedP)
      (progn
        (mapcar
          '(lambda (a)
            (apply 'N_DrawColorSwatch a)
          )
          colorSwatchList
        )
        (dcl_PictureBox_StoreImage FlexColorDialog_Form1_PictureBox1)
        (setq paintedP T)
      )
    )
  )

  (defun N_CoordsToColor (x y / color iX iY minX minY)
    ;; The indices iX and iY are 0 for the area of the top-left color swatch
    ;; including the distBetween to the right and below the color swatch.
    (setq iX (/ (- x distOutside) (+ distBetween sizeX)))
    (setq iY (/ (- y distOutside) (+ distBetween sizeY)))
    (if
      (and
        ;; Check if the indices iX and iY match a color:
        (setq color (LIB_List_Nth (LIB_List_Nth colorList iY) iX))
        ;; And then do exact calculations to make sure that the actual
        ;; color swatch and not the distBetween area was clicked:
        (<
          (1- (setq minX (+ distOutside (* iX sizeX) (* iX distBetween))))
          x
          (+ minX sizeX)
        )
        (<
          (1- (setq minY (+ distOutside (* iY sizeY) (* iY distBetween))))
          y
          (+ minY sizeY)
        )
      )
      color
    )
  )

  (defun N_CreateColorSwatchList (colorList / iX iY)
    (setq iY -1)
    (apply
      'append
      (mapcar
        '(lambda (a)
          (setq iY (1+ iY))
          (setq iX -1)
          (vl-remove
            nil ; Remove the nils caused by 'nil' colors.
            (mapcar
              '(lambda (b)
                (setq iX (1+ iX))
                (if b ; Skip 'nil' colors.
                  (list
                    (+ distOutside (* iX sizeX) (* iX distBetween))
                    (+ distOutside (* iY sizeY) (* iY distBetween))
                    (if (listp b)
                      (LIB_Odcl_Color_Rgb_To_Ole b) ; The function (dcl_GetOLEColorValue) does not accepts an RGB-list in AC 2013?
                      b
                    )
                  )
                )
              )
              a
            )
          )
        )
        colorList
      )
    )
  )

  (defun N_DrawColorSwatch (x y color)
    (cond
      ((= color 0) ; ByBlock.
        (dcl_PictureBox_DrawSolidRect
          FlexColorDialog_Form1_PictureBox1
          (list
            (list x y sizeX sizeY 0)
            (list (+ x 1) (+ y 1) (- sizeX 2) (- sizeY 2) 7)
            (list (+ x 3) (+ y 3) (- sizeX 6) (- sizeY 6) 0)
            (list (+ x 5) (+ y 5) (- sizeX 10) (- sizeY 10) 7)
          )
        )
      )
      ((= color 256) ; ByLayer.
        (dcl_PictureBox_DrawSolidRect
          FlexColorDialog_Form1_PictureBox1
          (list
            (list x y sizeX sizeY 0)
            (list (+ x 1) (+ y 1) (- sizeX 2) (- sizeY 2) 7)
            (list (+ x 3) (+ y sizeY (- 5)) (- sizeX 6) 2 0)
          )
        )
        (if (>= sizeY 11)
          (dcl_PictureBox_DrawSolidRect
            FlexColorDialog_Form1_PictureBox1
            (list
              (list (+ x 3) (+ y sizeY (- 8)) (- sizeX 6) 2 0)
             )
          )
        )
      )
      (T
        (dcl_PictureBox_DrawSolidRect
          FlexColorDialog_Form1_PictureBox1
          (list
            (list x y sizeX sizeY 0)
            (list (+ x 1) (+ y 1) (- sizeX 2) (- sizeY 2) color)
          )
        )
      )
    )
  )

  ) ; END NESTED FUNCTIONS.

  (setq distBetween 4)  ; At least 1.
  (setq distOutside 4)  ; At least 1.
  (setq sizeX 14)       ; At least 10. The size includes a black outline.
  (setq sizeY 14)       ; At least 10. The size includes a black outline.
  (setq textMaskY 14)   ; Do not change.
  (setvar 'cmdecho 0)
  (command "OPENDCL")
  (setvar 'cmdecho 1)
  (dcl_Project_Load "FlexColorDialog")
  (dcl_Form_Show FlexColorDialog_Form1)
  colorOut
)
