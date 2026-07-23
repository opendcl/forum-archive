
; Interface Functions
(defun c:BEI_Cloud_OnInitialize ( /)
	(bei_civil)
)

(defun c:BEI_Cloud_OnMouseEntered ( /)
	(bei_civil)
)

(defun c:BEI_Cloud_OnClose ( /)

     (princ "\n")

)

(defun c:CLOUD_Help_OnClicked ( /)
	(dos_htmlbox Lispver "H:\\0ACAD Support\\AutoCAD\\Help\\Manuals\\BEI Standards\\rcloud.html" 1080 800)	
)





(defun c:Cloud_TB_OnClicked ( /)
	(setq PFolder (getvar "dwgprefix"))
	(setq Disc (strcase "Mechanical"))
	(setq Tst_Str (strcase (substr PFolder (- (strlen PFolder) (strlen Disc)) (strlen Disc))))	
	(if (=  Tst_Str Disc)
		(progn
			(setq PFolder (substr PFolder 1 (- (strlen PFolder) (+ (strlen Disc) 1))))
		)		
	)
	(setq Disc "Electrical\\")
	(setq Tst_Str (strcase (substr PFolder (- (strlen PFolder) (strlen Disc)) (strlen Disc))))	
	(if (=  Tst_Str Disc)
		(progn
			(setq PFolder (substr PFolder 1 (- (strlen PFolder) (+ (strlen Disc) 1))))
		)		
	)
	(setq Disc "Plumbing\\")
	(setq Tst_Str (strcase (substr PFolder (- (strlen PFolder) (strlen Disc)) (strlen Disc))))	
	(if (=  Tst_Str Disc)
		(progn
			(setq PFolder (substr PFolder 1 (- (strlen PFolder) (+ (strlen Disc) 1))))
		)		
	)
	(setq Disc "Civil\\")
	(setq Tst_Str (strcase (substr PFolder (- (strlen PFolder) (strlen Disc)) (strlen Disc))))	
	(if (=  Tst_Str Disc)
		(progn
			(setq PFolder (substr PFolder 1 (- (strlen PFolder) (+ (strlen Disc) 1))))
		)		
	)
	(setq Disc "Structural\\")
	(setq Tst_Str (strcase (substr PFolder (- (strlen PFolder) (strlen Disc)) (strlen Disc))))	
	(if (=  Tst_Str Disc)
		(progn
			(setq PFolder (substr PFolder 1 (- (strlen PFolder) (+ (strlen Disc) 1))))
		)		
	)
	(setq DInfo (strcat PFolder "Deta_Info.dwg"))
	(if (dos_filep DInfo)
		(progn
			(setq CMW (dcl_month_getcursel CLOUD_RevDate))
			(setq yr (rtos (nth 0 CMW) 2 0))
			(setq mo (rtos (nth 1 CMW) 2 0))
			(setq day (rtos (nth 2 CMW) 2 0))
			(if (= (strlen mo) 1)
				(setq mo (strcat "0" mo))
			)
			(if (= (strlen day) 1)
				(setq day (strcat "0" day))
			)
			(setq rdate (strcat mo "/" day "/" yr))
			(vl-cmdf "._-insert" DInfo "0,0,0" "1" "" "0" (dcl_control_gettext Cloud_Delta) rdate (dcl_control_gettext CLOUD_RevDesc))
		)
		(progn
			(dcl_control_setvisible CLOUD_DeltaCreate T)
			(dcl_control_setvisible CLOUD_Delta100 T)
			(dcl_control_setvisible txt100 T)
			(dcl_control_setvisible Delta_TextHeight T)
			(dcl_control_setvisible Cloud_DeltaPoints T)
			(dcl_control_setvisible CreateDate T)
			(dcl_control_setvisible txtcdate100 T)
			(dcl_control_setvisible CLOUD_DateTextHeight T)
			(dcl_control_setvisible Desc101 T)
			(dcl_control_setvisible desctxt101 T)
			(dcl_control_setvisible CLOUD_Desc_TextHeight T)
			(dcl_control_setvisible Desc_SetPoints T)
			(dcl_control_setvisible CLOUD_Preview T)
			(dcl_control_setvisible CLOUD_Create T)
			(dcl_control_setvisible CLOUD_SetDatePoint T)			
			;(dcl_control_setvisible Rotation T)
			(dcl_MessageBox (strcat DInfo " does not exist - Please use the optiions below to create the Delta Information Block.") "RTOOLS - 0.1 - Alpha")	
		)
	)
     

)


(defun c:CLOUD_Delta_Font_OnClicked ( /)

     (dcl_MessageBox "To Do: code must be added to event handler\r\nc:CLOUD_Delta_Font_OnClicked" "To do")

)





(defun c:Cloud_DeltaPoints_OnClicked ( /)
	(setq Delta_IPt (getpoint "\nPlease select the center point for the delta: "))
	(setq Delta_TPt (getpoint Delta_IPt "\nPlease select the top point for the delta: "))     
	(dcl_control_setcaption CLOUD_DeltaPoints "Change Points")	
)





(defun c:CLOUD_Date_Font_OnClicked ( /)

     (dcl_MessageBox "To Do: code must be added to event handler\r\nc:CLOUD_Date_Font_OnClicked" "To do")

)





(defun c:CLOUD_SetDatePoint_OnClicked ( /)
	(setq Date_IPt (getpoint "\nPlease select the insertion point for the text for the date: "))
	(dcl_control_setcaption CLOUD_SetDatePoint "Change Points")	
)





(defun c:CLOUD_DescFont_OnClicked ( /)

     (dcl_MessageBox "To Do: code must be added to event handler\r\nc:CLOUD_DescFont_OnClicked" "To do")

)





(defun c:RTOOLS_BEI_Cloud_TextButton5_OnClicked ( /) ;Decription Height
	(setq Desc_IPt (getpoint "\nPlease select the insertion point for the text for the description: "))	
)





(defun c:CLOUD_Preview_OnClicked ( /)
	;(setq rot (dcl_control_gettext Rotation))
	(if (not rot) (setq rot (getangle "\nSelect the orientation for the text: ")))
	(if (= (dcl_control_getcaption CLOUD_Preview) "New Preview")		
		(vl-cmdf "._erase" Delta Delta_Text Date_Text Desc_Text "")
		(dcl_control_setcaption CLOUD_Preview "New Preview")
	)	
	(vl-cmdf "._polygon" "3" Delta_IPt "i" Delta_TPt)
	(setq Delta (entlast))
	(command "._-attdef" "" "TB_Delta" "Delta #" "." "S" "TABLE_HEADING" "J" "MC" Delta_IPt (dcl_control_gettext Delta_TextHeight) rot)
	(setq Delta_Text (entlast))
	(command "._-attdef" "" "TB_Date" "Revision Date" "." "S" "TABLE_HEADING" "J" "ML" Date_IPt (dcl_control_gettext CLOUD_DateTextHeight) rot)
	(setq Date_Text (entlast))
	(command "._-attdef" "" "TB_Desc" "Delta Description" "." "S" "TABLE_HEADING" "J" "ML" Desc_IPt (dcl_control_gettext CLOUD_Desc_TextHeight) rot)
	(setq Desc_Text (entlast))
	(dcl_control_setenabled CLOUD_Create T)
	(dcl_MessageBox "Please make any changes that are needed, then click \"Create Delta Block\" to create the Delta Information Block. Please note that you may either use the interface to move objects, or you may manually move them yourself, but if you create any new objects, they will not be included in the final block. Also note that if you delete anything, it may result in an error." "RTOOLS - 0.1 - Alpha")
)





(defun c:CLOUD_Create_OnClicked ( /)	
	(dcl_control_setenabled CLOUD_Create nil)
	(dcl_control_setcaption CLOUD_Preview "Preview")
	(dcl_control_setvisible CLOUD_DeltaCreate nil)
	(dcl_control_setvisible CLOUD_Delta100 nil)
	(dcl_control_setvisible txt100 nil)
	(dcl_control_setvisible Delta_TextHeight nil)
	(dcl_control_setvisible Cloud_DeltaPoints nil)
	(dcl_control_setvisible CreateDate nil)
	(dcl_control_setvisible txtcdate100 nil)
	(dcl_control_setvisible CLOUD_DateTextHeight nil)
	(dcl_control_setvisible Desc101 nil)
	(dcl_control_setvisible desctxt101 nil)
	(dcl_control_setvisible CLOUD_Desc_TextHeight nil)
	(dcl_control_setvisible Desc_SetPoints nil)
	(dcl_control_setvisible CLOUD_Preview nil)
	(dcl_control_setvisible CLOUD_Create nil)
	(dcl_control_setvisible CLOUD_SetDatePoint nil)
	(dcl_control_setcaption CLOUD_DeltaPoints "Set Points")
	(dcl_control_setcaption CLOUD_SetDatePoint "Set Points")
	(dcl_control_setcaption Desc_SetPoints "Set Points")
	(command "._-wblock" DInfo "" "0,0,0" Delta Delta_Text Date_Text Desc_Text "")
	(c:Cloud_TB_OnClicked)
)

(defun c:Browse_OnClicked ( /)
	(dcl_control_settext CLOUD_ArchFolder (dos_getdir LISPVer "h:\\Projects\\" "Select the project folder to archive:" T))
	(dcl_control_settext CLOUD_CopyToFolder (dcl_control_gettext CLOUD_ArchFolder))    
)

(defun c:CLOUD_Arch_OnClicked ( /)
(setq today (dcl_Month_GetToday CLOUD_RevDate))
(setq yr (rtos (nth 0 today) 2 0))
(setq mo1 (rtos (nth 1 today) 2 0))
(setq day (rtos (nth 2 today) 2 0))
 
(if (= (strlen day) 1)
  (progn
    (setq day (strcat "0" day))
    )
  )

(if (= (strlen mo1) 1)
  (progn
    (setq mo1 (strcat "0" mo1))
    )
  )
  
;;START REVISE_4
  (setq date1 (strcat yr "-" mo1 "-" day));Strings together date.<CHANGE DAY TO DAY_S>
;;STOP REVISE_4 
  (setq folder nil)
  (setq folder (dcl_control_gettext CLOUD_ArchFolder))
  (if (= folder nil)
    (progn
      (dos_traywnd LispVer "Command has been canceled!" 300 100)      
      (exit)
      )
    )
  (if (and (/= folder nil))
      (progn
		  (If (/= (dos_dirp (strcat folder "Archived")) T)
		    (progn
		  	(dos_mkdir (strcat folder "Archived"))
		      )
		    )		  
		  (If (= (dos_dirp (strcat folder "Archived\\" date1 "\\")) T)
		    (progn
		      (setq nn 2)
		      (setq Y "True")
		      (while (= Y "True")
			(progn
			  (if (/= (dos_dirp (strcat folder "Archived\\" date1 "\\" (rtos nn 2 0) "\\")) T)
			    (progn
			 	(dos_mkdir (strcat folder "Archived\\" date1 "\\" (rtos nn 2 0) "\\"))
			      (setq newdir (strcat folder "Archived\\" date1 "\\" (rtos nn 2 0) "\\"))
			      (setq Y "False")
			      )
			    )
			  (setq nn (+ nn 1))
		      )
			)
		    
		    )
		      
		  )
		  (If (/= (dos_dirp (strcat folder "Archived\\" date1 "\\")) T)
		    (progn
				(dos_mkdir (strcat folder "Archived\\" date1 "\\"))
		        (setq newdir (strcat folder "Archived\\" date1 "\\"))
		      )
		    )
			(setq CMW (dcl_month_getcursel CLOUD_RevDate))
		  (setq yr (rtos (nth 0 CMW) 2 0))
			(setq mo (rtos (nth 1 CMW) 2 0))
			(setq day (rtos (nth 2 CMW) 2 0))
			(if (= (strlen mo) 1)
				(setq mo (strcat "0" mo))
			)
			(if (= (strlen day) 1)
				(setq day (strcat "0" day))
			)
			(setq radate (strcat mo "/" day "/" yr))
		  (setq l1 (open (strcat folder "\\Archive Information.txt") "a"))
		  (princ "\n******************************************************************************************\n" l1)
		  (princ "Date Archived: ")
		  (princ date1 l1)
		  (princ "\nProject Number: " l1)
		  (princ (JN2 folder) l1)
		  (princ "\nFolder Archived: " l1)
		  (princ folder l1)
		  (princ "\nNew Delta Number: " l1)
		  (princ (dcl_control_gettext Cloud_Delta) l1)
		  (princ "\nDelta Date: ")
		  (princ radate l1)
		  (princ "\nDescription: ")
		  (princ (dcl_control_gettext CLOUD_RevDesc) l1)
		  (princ "\n******************************************************************************************" l1)
		  (close l1)
		  (bei_cp folder newdir)
		  (dos_traywnd LispVer (strcat "Archiving of " folder " is complete!") 300 100)
		  )
		  )
  )

 (defun bei_cp (pth npth)
   (setq bei_tree (dos_dirtree pth))   
   (setq bei_rpt (length bei_tree))
   (dos_getprogress "Archiving" pth bei_rpt T)
   (setq bei_ct 0)
   (while (and (dos_getprogress) (< bei_ct bei_rpt))
     (progn
       (setq bei_tst (nth bei_ct bei_tree))          
       (if (not (wcmatch (dos_strcase bei_tst) "*ARCHIVED*"))
	 (progn	   	   
	   (dos_getprogress -1)   	   
	   (setq bei_tmp (dos_strreplace bei_tst pth "" T))	   
	   (setq bei_dst (strcat npth bei_tmp))
	   (setq bei_tmpdir (dos_mkdir bei_dst))
	   (setq bei_cp (dos_copy (strcat bei_tst "\\*.*") bei_dst))	     	   
	   )
	 )
       (setq bei_ct (+ bei_ct 1))
   )
     )   
   (dos_getprogress T)   

)



(defun c:CLOUD_Rect_OnClicked ()
	(bei_ds)
	(PROMPT "\nMake a rectangle around the area where you want a revcloud:  ")
	(SETQ P1 (GETPOINT "\nFirst point of rectangle: "))
 	(SETQ P2 (GETCORNER P1 "\nSecond point of rectangle: "))
	(setq bei_command "._rectang")
  	(command "._rectang" P1 P2)	
 	(setq l2 (entlast))
	(beidelta)
	(bei_cend)
)

(defun c:CLOUD_ConvOB_OnClicked ( /)
	(bei_ds)
	(setq l2 (entsel "\nSelect the entity that you wish to turn into a Revision Cloud: "))
   	(if (NULL l2); Make sure an object was selected
      	(while (NULL l2)
        	(princ "\nYou did not select an object, please try again or press ^C to quit: ")
         	(setq l2 (entsel))
      	); While
	)
	(beidelta)	
	(bei_cend)
)

(defun c:CLOUD_DrawOB_OnClicked ( /)
	(bei_ds)
	(setq pt1 (getpoint "\nPlease select the first point for the object: "))
	(setq origpt1 pt1)
	(command "._pline" pt1)
	(while pt1
		(initget "Close _Close")
		(setq pt1 (getpoint "\nPlease select the next point for the object (Close): "))
		(command pt1)
	)
	(setq l2 (entlast))   	
	(beidelta)
	(bei_cend)
)

(defun c:BrowseClean_OnClicked ( /)
	(dcl_control_settext CLOUD_BackFolder (dos_getdir LISPVer "h:\\Projects\\" "Select the folder with the backgrounds that need to be cleaned up:" T))
)

(defun c:BrowseCopy_OnClicked ( /)
    (dcl_control_settext CLOUD_ArchFolder (dos_getdir LISPVer "h:\\Projects\\" "Select the folder to copy the backgrounds to:" T))
	(dcl_control_settext CLOUD_CopyToFolder (dcl_control_gettext CLOUD_ArchFolder))
)


(defun c:CLOUD_cleannow_OnClicked ( /)
	(setq acadObject (vlax-get-acad-object))
	(setq acadDocuments (vla-get-documents acadObject))
	(setq acadCount (vlax-get-property acadDocuments 'Count))		
	(setq AcadPth (findfile "acad.exe"))	
	(if (dos_filep (strcat (dos_specialdir 5) "bsr.scr")) (dos_delete (STRCAT (dos_specialdir 5) "bsr.scr")))					
	(setq scr (open (STRCAT (dos_specialdir 5) "bsr.scr") "W"))
	(princ "\nrtools_bsr" scr)
	(princ "\n" scr)
	(close scr)
	(setq images (dos_dir (strcat (dcl_control_gettext CLOUD_BackFolder) "*.dwg") 1))
	(setq pth (dcl_control_gettext CLOUD_BackFolder))
	(setq rpt (length images))
	(setq a 1)
	(while (< a rpt)
		(progn
			(dos_waitcursor T)
			(setq img (nth a images))
			(setq a (+ a 1))
			(setq A1 (strcat AcadPth " \"" pth img "\" /nologo /nossm /b \"" (dos_specialdir 5) "bsr.scr" "\""))
			(dos_exewait A1 3)
		)
	)
	(dos_waitcursor)
	(c:CLOUD_Arch_OnClicked)
	(dos_copy (strcat (dcl_control_gettext CLOUD_BackFolder) "\\*.*") (dcl_control_gettext CLOUD_CopyToFolder))
)
;End of interface functions

;Supporting Functions
(DEFUN JN2 (JN100)
  ;(SETQ JN100 (GETVAR "DWGPREFIX"))
  (SETQ JNLEN (DOS_STRLENGTH JN100))
  (SETQ JJ100 1)
  (SETQ NN NIL)
  (SETQ SN 1)  
  (WHILE (<= JJ100 JNLEN)
    (IF (< (DOS_STRLENGTH NN) 10)
      (PROGN
    (SETQ JJT (DOS_STRMID JN100 JJ100 1))    
    (IF (= (DOS_STRISCHAR JJT 4) T)
      (PROGN
	
	
	(IF (= SN 3)
	  (PROGN
	    (SETQ NN (STRCAT NN (DOS_STRMID JN100 JJ100 3)))
	    (SETQ SN (+ SN 1))
	    (SETQ END (+ JJ100 3))
	    )
	  )
	(IF (= SN 2)
	  (PROGN
	    (SETQ NN (STRCAT NN (DOS_STRMID JN100 JJ100 2) "-"))
	    (SETQ JJ100 (DOS_STRFIND JN100 "-" JJ100))
	    (SETQ SN (+ SN 1))
	    )
	  )
	(IF (= SN 1)
	  (PROGN
	    (SETQ NN (STRCAT (DOS_STRMID JN100 JJ100 3) "-"))
	    (SETQ JJ100 (DOS_STRFIND JN100 "\\" JJ100))
	    (SETQ SN (+ SN 1))
	    )
	  )
	
	)
      )
    )
      )    
    (SETQ JJ100 (+ JJ100 1))    
    )

  
  (IF (OR (= (DOS_STRMID JN100 END 1) "C") (= (DOS_STRMID JN100 END 1) "c"))
    (PROGN
      (SETQ NN (STRCAT NN "C"))
      )
    )
  (IF (OR (= NN NIL) (< (DOS_STRLENGTH NN) 10))
    (PROGN
      (SETQ NN JN100)
      )
    )
    NN
  )



(defun bei_civil ()
	(if (= (strcase (substr (getvar "DWGNAME") 1 1)) (strcase "C"))
		(progn			
			(dcl_control_setenabled CLOUD_MinArcLen T)
			(dcl_control_setenabled CLOUD_MaxArcLen T)
		)
		(progn						
			(dcl_control_setenabled CLOUD_MinArcLen nil)
			(dcl_control_setenabled CLOUD_MaxArcLen nil)
		)
	)
)

(defun bei_cend ()
	(COMMAND "._REVCLOUD" "A" (dcl_control_gettext CLOUD_MinArcLen) (dcl_control_gettext CLOUD_MaxArcLen) "Object" l2 "" )   
	(setq el (entlast))
	(vl-cmdf "._chprop" el "" "la" CloudLayer "")
	(command "pedit" el "width" ds2 "" )
)

(defun bei_ds ()
	(if (or (= (getvar "tilemode") 1) (/= (getvar "cvport") 1))
		(progn
			(setq ds (getvar "dimscale" ))
	    )
	)
	(if (and (= (getvar "tilemode") 0) (= (getvar "cvport") 1))
		(progn			
			(setq ds 1.1)
		)
	)
    (setq dmna (/ ds 2))
    (setq dmns (rtos dmna))
	(dcl_control_settext CLOUD_MinArcLen (rtos (* ds 0.35)))
	(dcl_control_settext CLOUD_MaxArcLen (rtos (* ds 0.35)))	
	(setq ds2 (/ ds 48))
)


(defun bei_layer ()
	(setq delta2 (dcl_control_gettext Cloud_Delta))
	(setq DeltaLayer (strcat "DELTA-" delta2))
	(setq CloudLayer (strcat "CLOUD-" delta2))
	(IF (= (GETVAR "PSTYLEMODE") 0)
		(PROGN ; If this is a drawing that uses named based plotting, then set the layers accordingly
			(command ".-layer" "NEW" DeltaLayer "Color" "7" DeltaLayer "Lweight" "Default" DeltaLayer "PS" "Black" DeltaLayer "" ); Create the delta layer
			(if (AND (= (dos_strmatch (getvar "dwgprefix") "*151*") T) (= (dos_strmatch (getvar "dwgprefix") "*04-001*") T))
				(command ".-layer" "NEW" CloudLayer "Color" "8" CloudLayer "Lweight" "0.005" CloudLayer "PS" "BLACK" CloudLayer "" ); If this is Bridge Street, then make the clouds black.
				(command ".-layer" "NEW" CloudLayer "Color" "8" CloudLayer "Lweight" "0.005" CloudLayer "PS" "CLOUD" CloudLayer "" ); If it is not, then make the clouds shaded
			)	
			
	    )
		(progn ; If this is a drawing that uses color based plotting, then set the layers accordingly
			(command ".-layer" "NEW" DeltaLayer "Color" "7" DeltaLayer "Lweight" "Default" DeltaLayer "" ); Create the delta layer
			(command ".-layer" "NEW" CloudLayer "Color" "8" CloudLayer "Lweight" "0.005" CloudLayer "" ); Create the Cloud layer			
		)
	)
)

(defun beidelta ()
	(bei_layer)
	(command "._-layer" "m" DeltaLayer "")   
	(setq ip (getpoint (strcat "\nPlease select a point to insert the delta symbol at (Press enter or pick a blank spot for none): ")))      
	(setq ip2 (osnap ip "_nea"))
	(if ip2
		(progn
			(command "attreq" "1")
			(if (or (= (getvar "tilemode") 1) (/= (getvar "cvport") 1))
				(progn
					(setq a324 (strcat "@" (rtos (* 0.25362901 (getvar "dimscale"))) "<90"))	    
					(command "polygon" "3" ip2 "I" a324)
					(setq dtemp (entlast))
					(command "._trim" dtemp "" ip2 "")
					(command "._erase" dtemp "")
					(command ".-insert" "BEIDelta-Rev1" ip2 (getvar "dimscale") (getvar "dimscale") "0" Delta)
				)
			)
			(if (and (= (getvar "tilemode") 0) (= (getvar "cvport") 1))
				(progn	    
					(command "polygon" "3" ip2 "I" "@0.25362901<90")
					(setq dtemp (entlast))
					(command "._trim" dtemp "" ip2 "")  
					(command "._erase" dtemp "")
					(command ".-insert" "BEIDelta-Rev2" ip2 "1" "1" "0" Delta)	    
				)
			)
		)
	)   
)

(defun c:rtools_bsr ()
	(if (= 1 (getvar "pstylemode"))
		(progn
			(command "tilemode" "1")
			(SETQ DDD (GETVAR "FILEDIA"))
			(command "filedia" "0")
			(command "convertpstyles" "blkacad2000-b.stb")
			(SETVAR "FILEDIA" DDD)
		);end progn
	);end if
	(setvar "setbylayermode" 113)
	(command "setbylayer" "all" "" "yes" "yes")
	(command "-plot" "yes" "model" "PDF995" "" "inches" "landscape" "n" "extents" "fit" "CENTER" "YES" "blkacad2000.stb" "" "" "n" "y" "n")
	(COMMAND "-LAYER" "COLOR" "8" "*" "")
	(COMMAND "-LAYER" "PSTYLE" "SHADED" "*" "")
	(command "filedia" "1")
	(setq ss (ssget "X" (list (cons 8 "BEI Plot Stamp"))))
	(command "._erase" SS "")
	(command "-purge" "a" "*" "n")
	(command "-purge" "a" "*" "n")
	(command "audit" "y")
	(command "-purge" "a" "*" "n")
	(command "-purge" "a" "*" "n")
	(command "-purge" "r" "*" "n")
	(command "zoom" "e")
	(command "._qsave")
	(command "._quit")
)

;End of supporting functions

;Main Function
(defun C:RTOOLS () ; This loads the project as a dockable window.
   (or LoadRunTime (load "_OpenDclUtils.lsp") (exit)) 
  (LoadRunTime)
  (LoadODCLProj "rtools.odcl")
  (dcl_Form_Show BEI_Cloud)
  (vl-cmdf "._redefine" "revcloud")
)
;End of main function

