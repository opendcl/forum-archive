;;; ManualLoading.lsp
;;; For OpenDCL Ver 4.0
;;; Edit kwb 20070225 GMT00:00:00
;;; Edit orw 20070518 GMT07:30:xx :: added 64 bit arx file selection
;;;                                       returns "OpenDCL.x64.17.ARX"
;;; Last Edit kwb as suggested by MichaelP 20070608 GMT00:30:xx
;;;                :: change location of dcl_GETVERSIONEX test.
;;

;; This code block loads the OpenDCL.##.arx files if not already loaded
;; Note, Loader will return T if loaded or nil otherwise.
;;
;; If the OpenDCL.##.arx is loaded at startup or demand loaded
;; this routine need never run.
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
            ;;
            ;;      (A) Find the arxfile, or
            ;;      (B) Load the arxfile.
            ;;
            ;;      and return nil.
            ;;
            ;;  Otherwise just quietly return t.
           
            (cond
                (   (null (setq arxpath (findfile arxname)))
                    (princ (strcat "Couldn't find " arxname ".\nYou may need to add it to an Acad support path"))
                )
                (   (null (arxload arxpath 'nil))
                    (princ (strcat "Failed to load " arxname "."))
                )
                (   t   )
            )
        )
    )
)



(defun c:BDuct (/)
  (dcl-Project-Load "D:\\My Drive\\002 - Work\\002 - IT\\001 - Programming\\006 - OpenDCL\\001 - BDuct\\BDuct.odcl" T)
  (dcl-Form-Show BDuct/BDuct)
  (BDG_SetUI)
)




(defun BDG_SetVisibility (ControlName NewValue /)  
  (if (/= (dcl-Control-GetVisible ControlName) newValue)
    (dcl-Control-SetVisible ControlName newValue)
  )
)

(defun BDG_SetPicture (ControlName NewValue /)  
  (if (/= (dcl-Control-GetPicture ControlName) newValue)
    (dcl-Control-SetPicture ControlName newValue)
  )
)

(defun BDG_GetPicture (ControlName /)  
  (dcl-Control-GetPicture ControlName)   
)

(defun BDG_SetUI (/)
  ;Variables:
  ;#Shape - Round or Rect
  ;#Insulation - External, Internal or Both
  ;#Clear - T or nil
  ;#Width - Distance
  ;#Height - Distance
  ;#Text - T or nil
  ;#Text_Height - Distance
  ;#Elevation - Distance
  ;#Selected - Control Name
  (if (not #Shape) (setq #Shape "Round"))
  (if (not #Insulation) (setq #Insulation "External"))
  (if (not #Clear) (setq #Clear T))
  (if (not #Width) (setq #Width 6))
  (if (not #Height) (setq #Height 12))
  (if (not #Text) (setq #Text T))
  (if (not #Text_Height) (setq #Text_Height 5))
  (if (not #Elevation) (setq #Elevation 96))
  
  (cond
    ((= #Shape "Round")
      (BDG_SetPicture BDuct/BDuct/Duct_Round 338)
      (BDG_SetPicture BDuct/BDuct/Duct_Rect 337)
    )
    ((= #Shape "Rect")
      (BDG_SetPicture BDuct/BDuct/Duct_Round 336)
      (BDG_SetPicture BDuct/BDuct/Duct_Rect 339)
    )
  )
)

;Click Events
(defun c:BDuct/BDuct/Duct_Rect#OnClicked (/)
  (alert "Rect")
  (setq #Shape "Rect")
  (BDG_SetUI)
)

(defun c:BDuct/BDuct/Duct_Round#OnClicked (/)
  (alert "Round")
  (setq #Shape "Round")
  (BDG_SetUI)
)

