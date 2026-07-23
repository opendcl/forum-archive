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



(defun c:BDuct (/ ControlList ControlList PictureTemp ListTemp)
  (dcl-Project-Load "D:\\My Drive\\002 - Work\\002 - IT\\001 - Programming\\006 - OpenDCL\\001 - BDuct\\BDuct.odcl" T)
  (dcl-Form-Show BDuct/BDuct)
  (setq ControlList (dcl-Form-GetControls BDuct/BDuct)        
        #PictureList '()
  )  
  (foreach x ControlList    
    (setq PropertyList (dcl-Control-GetProperties x))    
    (if (member "Picture" PropertyList) 
      (progn
        (setq PictureTemp (BDG_GetPicture x))
        (if PictureTemp
          (progn
            (setq #PictureList (cons (list x PictureTemp) #PictureList))            
          )
        )
      )
    )
  )
  (setq #Distance (distof "8'-0\"")
        #Selected nil
  )
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

(defun BDG_GetBoolean (ControlName / Value)
  (setq Value (dcl-Control-GetValue ControlName))  
  (if (= Value 0)
    nil
    T
  )
)

(defun BDG_GetOption (ControlName /)
  (dcl-OptionList-GetButtonCaption ControlName (dcl-OptionList-GetCurSel ControlName))
)

(if (not #Clear) (setq #Clear T))
(if (not #Text) (setq #Text T))

(defun BDG_ElbowCheck (/)
    (setq #Elbows (BDG_GetOption BDuct/BDuct/Elbows))
    (if (= #Shape "Round")
      (progn
        (dcl-OptionList-SetCurSel BDuct/BDuct/Elbows 0)
        (dcl-Control-SetButtonCaptionList BDuct/BDuct/Elbows (list "Round"))
        (dcl-Control-SetVisible BDuct/BDuct/Elbows_Vannes nil)
        (dcl-Control-SetVisible BDuct/BDuct/Label9 nil)
        (dcl-Control-SetVisible BDuct/BDuct/Elbows_Radius nil)
      )
      (progn
        (dcl-Control-SetButtonCaptionList BDuct/BDuct/Elbows (list "Square" "Round"))
        (if (= #Elbows "Round")
          (progn
            (dcl-Control-SetVisible BDuct/BDuct/Elbows_Vannes nil)
          (dcl-Control-SetVisible BDuct/BDuct/Label9 T)
          (dcl-Control-SetVisible BDuct/BDuct/Elbows_Radius T)
          )
          (progn
            (dcl-Control-SetVisible BDuct/BDuct/Elbows_Vannes T)
          (dcl-Control-SetVisible BDuct/BDuct/Label9 nil)
          (dcl-Control-SetVisible BDuct/BDuct/Elbows_Radius nil)
          )
        )
      )
    )
    (if (/= #Elbows (BDG_GetOption BDuct/BDuct/Elbows))
      (progn
        (BDG_ElbowCheck)
      )
    )    
)


(defun BDG_SetUI (/ ControlList ControlList PictureTemp Picture_Temp)
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
  ;#Duct_Option - Normal, Break, Cap, Grille, None
  ;#Elbows - Square, Round
  ;#Damper - Manual Damper, CSFD
  ;#Ins_Pic - 0 - None, -1 - Internal, -2 - External, -3 - Both
  ;#Shape_Pic - 0 - Round, -53 - Rect
  ;#Elevation - Distance
  ;#Direction - Up, Down, Same
  
  (if (not #Ins_Pic) (setq #Ins_Pic 0))
  (if (not #Shape_Pic) (setq #Shape_Pic 0))
  
  (if (not #Shape) (setq #Shape "Round"))
  (if (not #Insulation) (setq #Insulation "External"))
  
  (if (not #Width) (setq #Width 6))
  (if (not #Height) (setq #Height 12))
  
  (if (not #Text_Height) (setq #Text_Height 5))
  (if (not #Elevation) (setq #Elevation 96))
   
  
  (if (BDG_GetBoolean BDuct/BDuct/Insulation_External)
    (progn  
      (if (BDG_GetBoolean BDuct/BDuct/Insulation_Internal)
        (progn
          (setq #Insulation "Both"
                #Ins_Pic -3
          )
        )
        (progn
          (setq #Insulation "External"
                #Ins_Pic -2
          )
        )
      )
    )
    (progn
      (if (BDG_GetBoolean BDuct/BDuct/Insulation_Internal)
        (progn
          (setq #Insulation "Internal"
                #Ins_Pic -1
          )
        )
        (progn
          (setq #Insulation ""
                #Ins_Pic 0
          )
        )
      )
    )
  )
  (if (or (= #Insulation "Both") (= #Insulation "Internal"))
    (dcl-Control-SetVisible BDuct/BDuct/Insulation_Clear T)
    (dcl-Control-SetVisible BDuct/BDuct/Insulation_Clear nil)
  )
  
  (setq Text (BDG_GetBoolean BDuct/BDuct/Duct_Text))
  (dcl-Control-SetVisible BDuct/BDuct/Duct_Text_Size_Label Text)
  (dcl-Control-SetVisible BDuct/BDuct/Duct_Text_Size Text)
  
  (setq #Duct_Option (BDG_GetOption BDuct/BDuct/Duct_End))
  (BDG_ElbowCheck)
  (setq #Damper (BDG_GetOption BDuct/BDuct/Duct_Device))    
   
  (cond
    ((= #Shape "Round")
     (setq #Shape_Pic 0)
      (BDG_SetPicture BDuct/BDuct/Duct_Round 338)
      (BDG_SetPicture BDuct/BDuct/Duct_Rect 337)
      (dcl-Control-SetVisible BDuct/BDuct/Duct_Height nil)
      (dcl-Control-SetVisible BDuct/BDuct/Label1 nil)
      (dcl-Control-SetVisible BDuct/BDuct/Flex T)
      (dcl-Control-SetVisible BDuct/BDuct/Label12 T)
    )
    ((= #Shape "Rect")
      (setq #Shape_Pic -53)
      (BDG_SetPicture BDuct/BDuct/Duct_Round 336)
      (BDG_SetPicture BDuct/BDuct/Duct_Rect 339)
      (dcl-Control-SetVisible BDuct/BDuct/Duct_Height T)
      (dcl-Control-SetVisible BDuct/BDuct/Label1 T)
      (dcl-Control-SetVisible BDuct/BDuct/Flex nil)
     (dcl-Control-SetVisible BDuct/BDuct/Label12 nil)
    )
  )
    (setq ControlList (dcl-Form-GetControls BDuct/BDuct))  
    (foreach x ControlList   
      (setq PropertyList (dcl-Control-GetProperties x))    
      (if (member "Picture" PropertyList)
        (progn          
            (progn
              (setq PictureTemp (assoc x #PictureList))              
              (if PictureTemp
                (progn                  
                  (setq PictureTemp (cadr PictureTemp))
                  (if PictureTemp
                    (progn
                      (if (and (< PictureTemp 336) (> PictureTemp 99))
                        (progn
                          (if (and (or (= PictureTemp 168) (= PictureTemp 181)) (= #Shape "Rect"))
                            (BDG_SetPicture x (- (+ (+ PictureTemp #Ins_Pic) #Shape_Pic) 12))
                            (BDG_SetPicture x (+ (+ PictureTemp #Ins_Pic) #Shape_Pic))
                          )                         
                        )
                      )
                      (setq PictureTemp (BDG_GetPicture x))
                      (If (= (dcl-Control-GetName x) "Flex")
                        (BDG_SetPicture x 340)
                      )                      
                      (cond
                        ((< PictureTemp 218)
                          (dcl-Control-SetMouseOverPicture x (+ PictureTemp 118))
                        )
                        ((= PictureTemp 340)
                          (dcl-Control-SetMouseOverPicture x 341)
                        )
                        ((= PictureTemp 336);Round
                        (dcl-Control-SetMouseOverPicture x 338)
                        )
                        ((= PictureTemp 337);Rect
                        (dcl-Control-SetMouseOverPicture x 339)
                        )
                      )
                    )
                  )
                )           
              )
            )
        )        
      )
    )
  (if #Selected
    (progn      
      (setq Picture_Temp (dcl-Control-GetMouseOverPicture #Selected))
      (if Picture_Temp
        (progn          
          (BDG_SetPicture #Selected Picture_Temp)
        )
      )
    )
  )
)


;UI Events
(defun c:BDuct/BDuct/Insulation_External#OnClicked (Value /)
  (BDG_SetUI)
)

(defun c:BDuct/BDuct/Insulation_Internal#OnClicked (Value /)
  (BDG_SetUI)
)

(defun c:BDuct/BDuct/Insulation_Clear#OnClicked (Value /)
  (BDG_SetUI)
)


(defun c:BDuct/BDuct/Duct_Rect#OnClicked (/)  
  (setq #Shape "Rect")
  (BDG_SetUI)
)

(defun c:BDuct/BDuct/Duct_Round#OnClicked (/)  
  (setq #Shape "Round")
  (BDG_SetUI)
)

(defun c:BDuct/BDuct/Duct_End#OnSelChanged (ItemIndexOrCount Value /)
  (BDG_SetUI)
)

(defun c:BDuct/BDuct/Elbows#OnSelChanged (ItemIndexOrCount Value /)  
  (BDG_SetUI)
)

(defun c:BDuct/BDuct/Duct_Elevation#OnSetFocus (/)
  (if (not #PreviousElevation)
    (setq #PreviousElevation (distof (dcl-Control-GetText BDuct/BDuct/Duct_Elevation)))
    (progn
      (if (/= (distof (dcl-Control-GetText BDuct/BDuct/Duct_Elevation)) #PreviousElevation)  
        (setq #PreviousElevation (distof (dcl-Control-GetText BDuct/BDuct/Duct_Elevation)))
      )
    )
  )
)

(defun BDG_ElevationChange (NewValue /)  
  (setq #Elevation (distof NewValue))
  (cond
    ((= #Elevation #PreviousElevation)      
     (setq #Direction "Same")
    )
    ((< #Elevation #PreviousElevation)      
      (setq #Direction "Down")
    )
    ((> #Elevation #PreviousElevation)      
      (setq #Direction "Up")
    )
  )
  (BDG_SetUI)
)

(defun c:BDuct/BDuct/Duct_Elevation#OnKillFocus (/)
  (BDG_ElevationChange (dcl-Control-GetText BDuct/BDuct/Duct_Elevation))
)

(defun c:BDuct/BDuct/Duct_Elevation#OnReturnPressed (/)
  (BDG_ElevationChange (dcl-Control-GetText BDuct/BDuct/Duct_Elevation))
)

(defun BDG_SelectButton (ControlName / Picture_Temp)
  ;#Selected
  (setq #Selected nil)  
  (setq Picture_Temp (dcl-Control-GetMouseOverPicture ControlName))  
  (if Picture_Temp
    (progn
      (setq #Selected ControlName)   
    )
  )
  (BDG_SetUI)  
)

(defun c:BDuct/BDuct/Duct#OnClicked (/)
  (BDG_SelectButton BDuct/BDuct/Duct)
)

(defun c:BDuct/BDuct/Up_Down#OnClicked (/)
  (BDG_SelectButton BDuct/BDuct/Up_Down)
)

(defun c:BDuct/BDuct/Flex#OnClicked (/)
  (BDG_SelectButton BDuct/BDuct/Flex)
)

(defun c:BDuct/BDuct/Connector_Canvas#OnClicked (/)
  (BDG_SelectButton BDuct/BDuct/Connector_Canvas)
)

(defun c:BDuct/BDuct/Connector_Taper#OnClicked (/)
  (BDG_SelectButton BDuct/BDuct/Connector_Taper)
)

(defun c:BDuct/BDuct/Connector_Transition#OnClicked (/)
  (BDG_SelectButton BDuct/BDuct/Connector_Transition)
)

(defun c:BDuct/BDuct/Takeoff_Concentric#OnClicked (/)
  (BDG_SelectButton BDuct/BDuct/Takeoff_Concentric)
)

(defun c:BDuct/BDuct/Takeoff_Side#OnClicked (/)
  (BDG_SelectButton BDuct/BDuct/Takeoff_Side)
)

(defun c:BDuct/BDuct/Takeoff_Angle#OnClicked (/)
  (BDG_SelectButton BDuct/BDuct/Takeoff_Angle)
  (setq #Shape "ROUND")
  (BDG_Draw)
  ;(BDG_Draw (strcat #Shape "_TAKEOFF_ANGLE") (getpoint "\nPick Point: "))
)

(defun BDG_Draw (/ *StopLoop* Input Code Data)
  (setq InsPt (getpoint "\nPick Point: "))
  (if InsPt
    (progn
      (while (not *StopLoop*)    
        (setq Input (grread T 4 4)
              Code (car Input)
              Data (cadr Input)
        )
        (redraw)
        (cond
          ((= Code 5)
            (setq Pt1 (trans InsPt 1 0)
                  Pt2 (trans Data 1 0)
            )       
            (grdraw Pt1 Pt2 3 1)
          )
        )
      )
    )
  )
)