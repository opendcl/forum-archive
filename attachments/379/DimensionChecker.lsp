;;--------------- Dimension Checker -----------------
;; Date:    20 April 2008
;; Purpose: Check DIMENSION objects  for text overrides
;; Author:  Herman Mayfarth
;;---------------------------------------------------
;; This file contains the dialog code for ODCL project
;;---------------------------------------------------
;;autoloader for odcl runtime
(OR dcl_GETVERSIONEX
    (   (lambda ( / proc_arch arxname arxpath )

            ;;  Determine the appropriate arx module for
            ;;  the processor and the AutoCAD version.

            (setq arxname
                (strcat "OpenDCL"
                    (if
                        (and
                            (setq proc_arch (getenv "PROCESSOR_ARCHITECTURE"))
                            (< 1 (strlen proc_arch))
                            (eq "64" (substr proc_arch (1- (strlen proc_arch))))
                        )
                        ".x64."
                        "."
                    )
                    (substr (getvar "acadver") 1 2)
                    ".arx"
                )
            )
            ;;  Alert the user of a failure to:
            ;;      (A) Find the arxfile, or
            ;;      (B) Load the arxfile.
            ;;          and return nil.
            ;;  Otherwise just quietly return t.

            (cond
                (   (null (setq arxpath (findfile arxname)))
                    (alert (strcat "Couldn't find " arxname "." "\nDialogs Unavailable"))
                )
                (   (null (arxload arxpath 'nil))
                    (alert (strcat "Failed to load " arxname "."  "\nDialogs Unavailable"))
                )
                (   t   )
            )
        )
    )
)
;;;end runtime autoloader
;;initializations
;;load Active X
(vl-load-com)
;;assign active document to a symbol
(setq *ACAD* (vlax-get-acad-object))
(setq *THISDWG* (vla-get-activedocument (vlax-get-acad-object)))
;;globals
(setq blink# 3)
(setq duration 250)
;;functions
(defun sing_pl (# noun )
  (if (= # 1) noun
      (strcat noun "s"))
);sing_pl
;;blink an object on/off a specified number of times
;;accepts an ename or vla-object
(defun blink (obj times milliseconds / *error* flip-vis oldecho oldvis)
  (defun *error* (msg / )
   (vla-put-visible obj oldvis)
   (setvar "CMDECHO" oldecho)
  )
  (defun flip-vis (obj / )
    (if (eq :vlax-true (vla-get-visible obj))
      (vla-put-visible obj :vlax-false)
      (vla-put-visible obj :vlax-true))
  )
  (if (eq (type obj) 'ENAME) (setq obj (vlax-ename->vla-object obj)))
  (setq oldecho (getvar "CMDECHO")
        oldvis (vla-get-visible obj))
  (setvar "CMDECHO" 0)
  (repeat (* 2 times)
    (progn
      (flip-vis obj)
      (command "delay" milliseconds)
    )
  )
  (setvar "CMDECHO" oldecho)
  (princ)
);blink
;;zoom to an object
;;accept ename or vla-object
(defun zoom-to (obj / lowleft upright)
  (if (eq (type obj) 'ENAME) (setq obj (vlax-ename->vla-object obj)))
  (vla-getboundingbox obj 'lowleft 'upright)
  (vlax-invoke-method (vlax-get-acad-object) 'zoomwindow lowleft upright)
);zoom-to
;;callbacks for palette controls
(defun C:DimensionChecker_Palette_FindOverrides_OnClicked ()
;;get all DIMENSIONS with overridden text strings
(setq ss (ssget "X" '((0 . "DIMENSION") (1 . "~*<>*") (-4 . "<OR") (1 . "~") (-4 . "OR>"))))
(if ss (setq count (sslength ss))
       (setq count 0))
;;report number in dialog
(dcl_Control_SetCaption DimensionChecker_Palette_Report1
  (strcat "Checker found "(itoa count)))
(dcl_Control_SetCaption DimensionChecker_Palette_Report2
  (strcat (sing_pl count "dimension") " with text overrides."))
);defun
(defun C:DimensionChecker_Palette_ZoomExtents_OnClicked ()
  (vlax-invoke *ACAD* 'ZoomExtents)
);defun
(defun C:DimensionChecker_Palette_BlinkAll_OnClicked ()
  ;(alert "Function Called")
  (and ss
    (setq i 0)
    (repeat (sslength ss)
      (blink (ssname ss i) blink# duration)
      (setq i (1+ i))
    );repeat
  );and
);defun
(defun C:DimensionChecker_Palette_ZoomToPick_OnClicked ( / obj)
  (if (setq obj (car (entsel "\nPick Object")))
    (zoom-to obj))
);defun
(defun C:DimensionChecker_Palette_DimsOff_OnClicked ( / i ss)
   (and
      (= 0 (getvar "CMDACTIVE"))
      (setq ss (ssget "X" '((0 . "DIMENSION"))))
      (setq i 0)
      (repeat (sslength ss)
        (vlax-put (vlax-ename->vla-object (ssname ss i)) 'Visible 0)
        (setq i (1+ i))
      );repeat
      (princ "\nAll DIMENSION Objects Are Now Invisible.")
      (princ "\nClick \"Turn On All Dimensions\" to Restore Visibility!")
    );and
    (princ)
);defun
(defun C:DimensionChecker_Palette_DimsOn_OnClicked ()
  (and
    (= 0 (getvar "CMDACTIVE"))
    (setq ss (ssget "X" '((0 . "DIMENSION"))))
    (setq i 0)
    (repeat (sslength ss)
      (vlax-put (vlax-ename->vla-object (ssname ss i)) 'Visible 1)
      (setq i (1+ i))
    );repeat
  );and
  (princ)
);defun
;;------------------------ end callbacks ----------------------------------
;;load the odcl project
(dcl_Project_Load "DimensionChecker.odcl" T);reload flag
(defun C:Checker ()
  (dcl_Form_Show DimensionChecker_Palette 200 200)
  (princ)
)

;;load prompts
;(princ \n "Dimension Checker V1.0")
;(princ)
