;|

Fixes:
Take off the numerical filter on the text height boxes
add a numerical verifier in the on kill focus function.



|;




(defun c:QT ( / )
   ;;redefine error call
  (setq	olderr	*error*
	*error*	clerr
  ) ;_ end setq

   ;; verifies registration, Preloaded with Utilities.lsp
   ;;(ru:VerifyRegistration)

   ;; verify and set global for landq Dictionary
   (sf:verify_Dict)

   (OR (dcl_PROJECT_LOAD "TextInsertion" T) (EXIT))
   (dcl_Form_Show TextInsert_Form1)

   (setq *error* olderr)
   (PRINC)
   
) ;_end defun





;| TO DO'S
	ON INITIALIZE WE NEED TO RETRIEVE THE HEADER / NORMAL / SUBSCRIPT SETTING
		STORE IN REGISTRY

	

|;

(defun c:TextInsertion_Form1_OnInitialize (/ vStyleList vActiveStyle vStyleName)
     
   ;;Tab Settings Setup
   ;;
   ;;get text format heights from registry
   ;; if not in registry, create here, and save to registry

   ;; global variable setup for all functions in this routine, will be cleared at close of dialog
   (setq gRegLoc "HKEY_CURRENT_USER\\SOFTWARE\\LandQ\\USERPREFS\\")




   ;;							
   ;; Add default text heights if not already setup   	
   ;;							
   (if (not (vl-registry-read gRegLoc "TextHeaderSize"))
      (vl-registry-write gRegLoc "TextHeaderSize" "0.15")
   ) ;_end if

   (if (not (vl-registry-read gRegLoc "TextNormalSize"))
      (vl-registry-write gRegLoc "TextNormalSize" "0.09375")
   ) ;_end if

   (if (not (vl-registry-read gRegLoc "TextSubscriptSize"))
      (vl-registry-write gRegLoc "TextSubscriptSize" "0.06")
   ) ;_end if
   
   (if (not (vl-registry-read gRegLoc "TextLayerSetting"))
      (vl-registry-write gRegLoc "TextLayerSetting" (vl-prin1-to-string (list (cons "layername" "-Current Layer-"))))
   ) ;_end if

   ;; ensure saved text layer is exists
   (qt:verifyTextLayer)

       
  

   ;;set all text boxes to text heights in registry
   (dcl_Control_SetText TextInsert_Form1_txtBoxHeader (vl-registry-read gRegLoc "TextHeaderSize"))
   (dcl_Control_SetText TextInsert_Form1_txtBoxNormal (vl-registry-read gRegLoc "TextNormalSize"))
   (dcl_Control_SetText TextInsert_Form1_txtBoxSubscript (vl-registry-read gRegLoc "TextSubscriptSize"))

   ;;(dcl_TextBox_SetFilter TextInsert_Form1_txtBoxHeader ".1234567890")
   ;;(dcl_TextBox_SetFilter TextInsert_Form1_txtBoxNormal ".1234567890")
   ;;(dcl_TextBox_SetFilter TextInsert_Form1_txtBoxSubscript ".1234567890")

     
    ;;add list to dropdown component
   (dcl_ComboBox_AddList TextInsert_Form1_ComboBox1 (qt:getStyleList))
 
   ;; Get the active Text Style
   (setq vActiveStyle (vla-get-name (vla-get-activetextstyle gActiveDoc)))

   (dcl_ComboBox_SelectString TextInsert_Form1_ComboBox1 vActiveStyle)


   ;;(dcl_Control_SetCaption TextInsert_Form1_label2 (sf:GetScaleName))
   (dcl_Control_SetCaption TextInsert_Form1_label2 (getvar "CANNOSCALE"))
  
) ;_ end of defun



;; Dropdown Select Change Function
(defun c:TextInsertion_Form1_ComboBox1_OnSelChanged (nSelection sSelText /)
  ;; set active text style to the one chosen
   (vla-put-activetextstyle gActiveDoc (vla-item (vla-get-TextStyles gActiveDoc) sSelText))

) ;_ end of defun



;;
;; Main Tab 'Import Text Style Function'
;;
(defun c:TextInsertion_Form1_btnImport_OnClicked (/ dbxDoc)

   (setq dbxDoc (vla-getinterfaceobject gAcadObject (gut:getDocVersion)))
   (vla-open dbxDoc (findfile "Layers_Master.dwg")) ;_open file

   ;;Transfer TextStyles
   ;;gfunc:transfer is borrowed from the copystandards.lsp
   (gfunc:transfer dbxDoc (vla-get-textstyles dbxDoc) (vla-get-textstyles gActiveDoc))

   (vlax-release-object dbxDoc)

   ;;clear the combobox so we can add updated list below
   (dcl_ComboBox_Clear TextInsert_Form1_ComboBox1)

   

    ;;update list to dropdown component
   (dcl_ComboBox_AddList TextInsert_Form1_ComboBox1 (qt:getStyleList))
 
   ;; Get the active Text Style
   (setq vActiveStyle (vla-get-name (vla-get-activetextstyle gActiveDoc)))

   (dcl_ComboBox_SelectString TextInsert_Form1_ComboBox1 vActiveStyle)

   (princ) ;_end clean

) ;_end defun



(defun c:TextInsertion_Form1_TabControl1_OnSelChanging (nSelIndex / vLayerList)
   ;; get drawing list of layers
   (if (= nSelIndex 0)
      (progn
	 
	 (setq vLayerList (gut:getLayerList))

	 ;; append to overall layer list
	 (if (not (member (qt:getLayerName) vLayerList))
	    (setq vLayerList (append vLayerList (list (qt:getLayerName))))
	 ) ;_end if

	 ;;sort layerlist
	 (setq vLayerList (vl-sort vLayerList '<))
	 
	 (setq vLayerList (append (list "-Current Layer-") vLayerList))
	 
	 ;_first clear combobox of any existing items
	 (dcl_ComboBox_Clear TextInsertion_Form1_ComboBox2)

	 ;_add new items to combobox
	 (dcl_ComboBox_AddList TextInsertion_Form1_ComboBox2 vLayerList)

	 ;; set text for combobox
	 ;;(dcl_ComboBox_SelectString (dxf "layername" (read (vl-registry-read gRegLoc "TextLayerSetting"))))
	 (dcl_ComboBox_SelectString TextInsertion_Form1_ComboBox2 (dxf "layername" (read (vl-registry-read gRegLoc "TextLayerSetting"))))
	) ;_end progn
   ) ;_end if


) ;_ end of defun






;;                                                               
;; Main Tab Text Button Insertion Functions                      
;;


(defun c:TextInsertion_Form1_gBtnHeader_OnClicked ( /)
   (qt:AddText "Header")
) ;_ end of defun


(defun c:TextInsertion_Form1_gBtnNormal_OnClicked ( /)
   (qt:AddText "Normal")
) ;_ end of defun


(defun c:TextInsertion_Form1_gBtnSubscript_OnClicked ( /)
   (qt:AddText "Subscript")
) ;_ end of defun


;;                                                               
;; End Main Tab Button Functions                                 
;;                                                               
 


;;								
;;Begin Config Tab Text Box Functions				
;; All functions below have a numeric filter set withing opendcl
;;    text box properties



(defun c:TextInsertion_Form1_txtBoxHeader_OnKillFocus ( / vText)
   (setq vText (dcl_control_gettext TextInsert_Form1_txtBoxHeader))
   (vl-registry-write gRegLoc "TextHeaderSize" vText)
) ;_ end of defun


(defun c:TextInsertion_Form1_TxtBoxNormal_OnKillFocus ( / vText)
   (setq vText (dcl_control_gettext TextInsert_Form1_txtBoxNormal))
   (vl-registry-write gRegLoc "TextNormalSize" vText)
) ;_ end of defun



(defun c:TextInsertion_Form1_TxtBoxSubscript_OnKillFocus ( / vText)
   (setq vText (dcl_control_gettext TextInsert_Form1_txtBoxSubscript))
   (vl-registry-write gRegLoc "TextSubscriptSize" vText)
) ;_ end of defun


;;                                                  	
;; End Config Tab Text Box Functions			
;;            						




(defun qt:GetStyleList	(/ vStyleName vStyleList)
   ;;get list of loaded text styles
   (vlax-map-collection
      (vla-get-textstyles gActiveDoc)
      '(lambda (x)
	  (setq vStyleName (vla-get-name x))
	  (if (and (/= vStyleName "")
		   (not (vl-string-search "|" vStyleName))
	      ) ;_ end of and
	     (setq vStyleList (cons vStyleName vStyleList))
	  ) ;_end if
       ) ;_ end of lambda
   ) ;_ end of vlax-map-collection

   ;; return the sorted list
   (vl-sort vStyleList '<)

) ;_end defun



;; get the layer style from the dialog box and add it to the registry
(defun c:TextInsertion_Form1_ComboBox2_OnSelChanged (nSelection sSelText / vLayerObj vLayerProps)
   ;;here we will get the layer name the user selects
   ;; lets get all the layer properties, then we can recreate the layer from scratch
   ;; and not have to depend on importing from the see layermaster file.

   (if (not (equal sSelText "-Current Layer-"))
      (progn
	 (if (setq vLayerObj (gut:Exist gDocLayers sSelText))
	    (progn
	       (setq vLayerProps
		       (list
			  (cons "layername" (vla-get-name vLayerObj))
			  (cons "color" (vla-get-color vLayerObj))
			  (cons "linetype" (vla-get-linetype vLayerObj))
			  (cons "lineweight" (vla-get-lineweight vLayerObj))
			  (cons "plotstylename" (vla-get-plotstylename vLayerObj))
		       ) ;_ end of list
	       ) ;_ end of setq

	       ;; Now we write this information to the registry
	       (vl-registry-write gRegLoc "TextLayerSetting" (vl-prin1-to-string vLayerProps))
	       
	    ) ;_end progn
	 ) ;_end if
 
      ) ;_end progn
   ) ;_end if


) ;_ end of defun

;; gets / creates LandQ Dictionary
(defun sf:verify_Dict ()
   (if (not (setq gLandQDict (gut:getDict gActiveDoc "DictLandQ")))
      (progn
	 (setq gLandQDict (gut:createdict gActiveDoc "DictLandQ"))
	 (gut:addXRecord gActiveDoc gLandQDict "ScaleInfo"
	    (gut:DotList '("SCALENAME" "SCALEVALUE") '("Full Scale" 1.0))
	 ) ;_ end of gut:addXRecord

	 ;; set default dimscale to mirror scale settings
	 (vla-setvariable gActiveDoc "DIMSCALE" 1.0)
      ) ;_end progn
   ) ;_ end of if
) ;_end defun




;; create layer if it does not exist
(defun qt:VerifyTextLayer (/ vLayerName vLayerObj vLayerProps)

   (setq vLayerName (qt:getLayerName))

   ;; NEED TO FIX HERE

   (if (and vLayerName
	    (not (gut:Exist gDocLayers vLayerName))
       ) ;_ end of and

      ;;(if (and (not (or nil (= vLayerName "-Current Layer-")))
      ;;(not (gut:Exist gDocLayers vLayerName))
      ;;);_end and
      (progn
	 (vla-add gDocLayers vLayerName)
	 (setq vLayerObj (vla-item gDocLayers vLayerName))
	 (setq vLayerProps (read (vl-registry-read gRegLoc "TextLayerSetting")))
	 (vla-put-color vLayerObj (dxf "COLOR" vLayerProps))
	 (vla-put-linetype vLayerObj (dxf "LINETYPE" vLayerProps))

	 ;; if we are in a named plot style drawing
	 (if (= 0 (getvar "pstylemode"))
	    (progn
	       ;; we need to verify the plotstyle name exists, if it doesn't we must create it.
	       (cl:plotStyleChecker (dxf "PLOTSTYLENAME" vLayerProps))
	       (vla-put-lineweight vLayerObj (dxf "LINEWEIGHT" vLayerProps))
	       (vla-put-plotstylename vLayerObj (dxf "PLOTSTYLENAME" vLayerProps))
	    ) ;_end progn
	 ) ;_end if
      ) ;_ end of progn
   ) ;_ end of if

) ;_end defun









;; shortcut for getting the saved user set layer name
(defun qt:getlayername ()
   (dxf "layername" (read (vl-registry-read gRegLoc "TextLayerSetting")))
) ;_end defun






(defun qt:AddText (xOption / vHeight vTxtStyleObj vPt vCurrLayer vTextEnt)

   ;; HERE WE NEED TO VERIFY THERE IS A SCALE FACTOR SET
   (sf:ScaleCheck)


   ;; get text height from registry
   (cond
      ((= xOption "Header")
       (setq vHeight (distof (vl-registry-read gRegLoc "TextHeaderSize") 2))
      )
      ((= xOption "Normal")
       (setq vHeight (distof (vl-registry-read gRegLoc "TextNormalSize") 2))
      )
      ((= xOption "Subscript")
       (setq vHeight (distof (vl-registry-read gRegLoc "TextSubscriptSize") 2))
      )
      (t nil)
   ) ;_ end of cond



   ;;verify text default height is set to 0
   (setq vTxtStyleObj (vla-get-activetextstyle gActiveDoc))
   (if (/= (vla-get-height vTxtStyleObj) 0.0)
      (vla-put-height vTxtStyleObj 0.0)
   ) ;_ end of if

   ;; put layer of text object active from user defined layer setting
   ;; get user selected layer
   (if (not (equal "-Current Layer-" (qt:getLayerName)))
      (progn
	 (setq vCurrLayer (vla-get-name (vla-get-activelayer gActiveDoc)))
	 (vla-put-activelayer gActiveDoc (vla-item gDocLayers (qt:getLayerName)))
      ) ;_end progn
   ) ;_end if

   (dcl_Form_Close TextInsert_Form1)

   ;; If textstyle is not annotative, convert scale to usable form
   (if (not (qt:istextstyle_annotative (getvar "textstyle")))
      (setq vHeight (* vHeight (/ 1 (getvar "cannoscalevalue"))))
   ) ;_end if
   

   ;;confirm current Active Text Style is Annotative
   ;;(if (not (qt:istextstyle_annotative (getvar "textstyle")))
      ;;(qt:setTxtAnnotative (getvar "textstyle"))
   ;;) ;_end if

   (setq vPt (getpoint "\nIndicate Start Point : "))
   (command "_.dtext" vPt vHeight 0)

   ;;(vla-put-activelayer gActiveDoc (vla-item gDocLayers vCurrLayer))


) ;_ end of defun



;;Form Close Function
(defun c:TextInsertion_Form1_btnClose_OnClicked ( /)
   (setq gRegLoc nil) ;_set global registry locater to nil
   (dcl_Form_Close TextInsert_Form1) ;_close the form
) ;_ end of defun


(defun qt:is_annotative	(ent / xdata)
   (setq xdata (cadr (assoc -3 (entget ent '("AcadAnnotative")))))
   (and xdata (= (cdr (nth 4 xdata)) 1)) ; returns T or nil
) ;_ end of defun



(defun qt:isTextstyle_Annotative (style / ent xdata)
   (if (setq ent (tblobjname "style" style)) ; style exists
      (setq xdata (cadr (assoc -3 (entget ent '("AcadAnnotative")))))
   ) ;_ end of if
   (and xdata (= (cdr (nth 4 xdata)) 1)) ; returns T or nil
) ;_ end of defun














;; Set text style to annotative
(defun qt:setTxtAnnotative (Name / *text* app xd1 xd2 rt1 rt2)
   (setq *text*	(vla-get-textstyles gActiveDoc))
   (vlax-for itm *text*
      (setq *textstl* (cons (vla-get-name itm) *textstl*))
   ) ;_ end of vlax-for
   (if (member Name *textstl*)
      (progn
	 (setq obj (vla-item *text* Name)
	       app "AcadAnnotative"
	 ) ;_ end of setq
	 (regapp app)
	 (setq xd1 (vlax-make-safearray vlax-vbInteger '(0 . 5)))
	 (vlax-safearray-fill
	    xd1
	    (list 1001 1000 1002 1070 1070 1002)
	 ) ;_ end of vlax-safearray-fill
	 (setq xd2 (vlax-make-safearray vlax-vbVariant '(0 . 5)))
	 (vlax-safearray-fill
	    xd2
	    (list "AcadAnnotative"
		  "AnnotativeData"
		  "{"
		  (vlax-make-variant 1 vlax-vbInteger)
		  (vlax-make-variant 1 vlax-vbInteger)
		  "}"
	    ) ;_ end of list
	 ) ;_ end of vlax-safearray-fill
	 (vla-setxdata obj xd1 xd2)
	 (vla-getxdata obj app 'rt1 'rt2)
	 (mapcar
	    (function (lambda
			 (x y)
			   (cons x y)
		      ) ;_ end of lambda
	    ) ;_ end of function
	    (vlax-safearray->list rt1)
	    (mapcar 'vlax-variant-value (vlax-safearray->list rt2))
	 ) ;_ end of mapcar
      ) ;_ end of progn
   ) ;_ end of if

   (princ)
) ;_ end of defun




;;;
;;; INTERNAL ERROR HANDLER 
;;;
(defun clerr (s) ;_ If an error (such as CTRL-C) occurs while this command is active...
   (if (/= s "Function cancelled")
      (princ (strcat "\nError: " s))
   ) ;_ end if
   (setq gRegLoc nil)
   (setq *error* olderr) ;_else statement
   (princ)
) ;_ end defun



(princ)


;|«Visual LISP© Format Options»
(120 3 40 2 T "end of " 100 9 0 0 2 T T nil T)
;*** DO NOT add text below the comment! ***|;
