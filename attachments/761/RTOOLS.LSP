; Interface Functions
(defun c:Cloud_Delta_OnEditChanged (sText /)
     (setq Delta_Changed T)
)

(defun c:CLOUD_RevDate_OnSelChanged ( /)
     (setq Date_Changed T)
)

(defun c:CLOUD_RevDesc_OnEditChanged (sText /)
     (setq Date_Canged T)
)

(defun c:CLOUD_MinArcLen_OnMouseMove (nFlags nX nY /)
     (bei_civil)
)

(defun c:CLOUD_MaxArcLen_OnMouseMove (nFlags nX nY /)
    (bei_civil)
)

(defun c:BEI_Cloud_OnClose ( /)
     (dcl_Project_UnLoad "rtools.odcl")
)

(defun c:CLOUD_Help_OnClicked ( /)
	(dos_htmlbox Lispver "H:\\0ACAD Support\\AutoCAD\\Help\\Manuals\\BEI Standards\\rcloud.html" 1080 800)	
)

(defun c:Cloud_TB_OnClicked ( /)
	(setq PFolder (getvar "dwgprefix"))
	(setq PFolder (fixfolder PFolder))
	(setq DInfo (strcat PFolder "Delta_Info.dwg"))
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
			(dcl_MessageBox (strcat DInfo " does not exist - Please use the optiions below to create the Delta Information Block.") "RTOOLS - 0.1 - Alpha")	
		)
	)    
)

(defun c:Cloud_DeltaPoints_OnClicked ( /)
	(setq Delta_IPt (getpoint "\nPlease select the center point for the delta: "))
	(setq Delta_TPt (getpoint Delta_IPt "\nPlease select the top point for the delta: "))     
	(dcl_control_setcaption CLOUD_DeltaPoints "Change Points")	
)

(defun c:CLOUD_SetDatePoint_OnClicked ( /)
	(setq Date_IPt (getpoint "\nPlease select the insertion point for the text for the date: "))
	(dcl_control_setcaption CLOUD_SetDatePoint "Change Points")	
)

(defun c:RTOOLS_BEI_Cloud_TextButton5_OnClicked ( /) ;Decription Height
	(setq Desc_IPt (getpoint "\nPlease select the insertion point for the text for the description: "))	
)

(defun c:CLOUD_Preview_OnClicked ( /)
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

(defun c:CLOUD_Rect_OnClicked ()
	(bei_ds)
	(PROMPT "\nMake a rectangle around the area where you want a revcloud:  ")
	(SETQ P1 (GETPOINT "\nFirst point of rectangle: "))
 	(SETQ P2 (GETCORNER P1 "\nSecond point of rectangle: "))
	(setq bei_command "._rectang")
  	(command "._rectang" P1 P2)	
 	(setq l2 (entlast))
	(bei_cend)
	(beidelta)	
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
	(bei_cend)
	(beidelta)	
)

(defun c:CLOUD_DrawOB_OnClicked ( /)
	(bei_ds)
	(setq pt1 nil)
	(setq pt1 (getpoint "\nPlease select the first point for the object: "))	
	(command "._pline" pt1)
	(while pt1		
		(setq pt1 (getpoint pt1 "\nPlease select the next point for the object (Note: Object will automatically be closed upon completion): "))
		(if pt1 (command pt1))
	)
	(command "c")
	(setq l2 (entlast))   	
	(bei_cend)
	(beidelta)	
)

(defun c:BrowseClean_OnClicked ( /)	
	(dcl_ListBox_Clear RTOOLS_BEI_Cloud_File_List)	
	(setq Folder (dos_getdir "" "h:\\BEI-TEMP\\" "Select the folder with the backgrounds that need to be cleaned up:" T))
	(if (/= Folder nil)
		(progn
			(dcl_control_settext CLOUD_BackFolder Folder)
			(c:CLOUD_BackFolder_OnEditChanged (dcl_control_gettext CLOUD_BackFolder))
		)
		(dcl_control_settext CLOUD_BackFolder "")
	)
)
(defun c:CLOUD_BackFolder_OnEditChanged (NewValue /)
	(dcl_ListBox_Clear RTOOLS_BEI_Cloud_File_List)
	(setq images (dos_dir (strcat (dcl_control_gettext CLOUD_BackFolder) "*.dwg") 1))
	(setq pth (dcl_control_gettext CLOUD_BackFolder))
	(setq rpt (length images))
	(setq a 0)		
	(while (/= rpt a)		
		(setq FileString (strcat pth (nth a images)))
		(setq a (+ a 1))
		(dcl_ListBox_AddString RTOOLS_BEI_Cloud_File_List FileString)							
	)
)
(defun c:RTOOLS_BEI_Cloud_LogMeIn_OnClicked (/)
	(dcl_Form_Show RTOOLS_HTMLFORM)
	(dcl_Html_Navigate RTOOLS_HTMLFORM_Html1 "http://www.logmein.com")	
)

(defun c:RTOOLS_HTMLFORM_Close_OnClicked (/)
  (dcl_Form_Close RTOOLS_HTMLFORM)
)
(defun c:RTOOLS_BEI_Cloud_BEITools_OnClicked (/)
  (dos_execute "H:\\0ACAD Support\\AutoCAD\\Customization\\External Programs\\Breen Engineering Tools.exe")
)

(defun c:BrowseCopy_OnClicked ( /)  
	(setq Folder (dos_getdir "" "h:\\Projects\\" "Select the folder to copy the backgrounds to:" T))
	(if (/= Folder nil)
		(dcl_control_settext CLOUD_CopyToFolder Folder)
		(dcl_control_settext CLOUD_CopyToFolder "")
	)
)


(defun c:CLOUD_cleannow_OnClicked ( /)
	(if (or (= (dcl_Control_GetText CLOUD_BackFolder) nil) (= (dcl_Control_GetText CLOUD_BackFolder) ""))
		(progn
			(dos_msgbox "You must select a folder that contains the files to backup!" "RTOOLS - Batch Cleanup Process" 1 5)
			(exit)
		)
	)
	(if (or (= (dcl_Control_GetText CLOUD_CopyToFolder) nil) (= (dcl_Control_GetText CLOUD_CopyToFolder) ""))
		(progn
			(dos_msgbox "You must select a folder tto copy the cleaned up files to!" "RTOOLS - Batch Cleanup Process" 1 5)
			(exit)
		)
	)
	(if (= (dcl_ListBox_GetCount RTOOLS_BEI_Cloud_File_List) 0)
		(progn
			(dos_msgbox (strcat "The folder: " (dcl_Control_GetText CLOUD_BackFolder) " has no AutoCAD drawings, you need to select a folder with AutoCAD Drawings!") "RTOOLS - Batch Cleanup Process" 1 5)
			(exit)
		)
	)
	(dcl_Control_SetMaxValue RTOOLS_BEI_Cloud_ProgressBar1 (+ (dcl_ListBox_GetCount RTOOLS_BEI_Cloud_File_List) 2))
	(dcl_Control_SetValue RTOOLS_BEI_Cloud_ProgressBar1 1)
	(dcl_Control_SetList RTOOLS_BEI_Cloud_HiddenCompleteList (dcl_Control_GetList RTOOLS_BEI_Cloud_File_List))
	(setvar "SDI" 1)	
	(dcl_Control_SetValue RTOOLS_BEI_Cloud_XREFS1 1)
	(dcl_Control_SetCaption RTOOLS_BEI_Cloud_XREFS1 "All x-refs have been repathed successfully")
	(dcl_Control_SetToolTipTitle RTOOLS_BEI_Cloud_XREFS1 "All x-refs have been repathed successfully")
	(dcl_Control_SetToolTipMainText RTOOLS_BEI_Cloud_XREFS1 "There is no need to run reference manager! 8-)")
	(c:BEI_Cloud_OnDocActivated)	
)

(defun c:CombineClouds_OnClicked ( /)
     (dcl_MessageBox "To Do: code must be added to event handler\r\nc:CombineClouds_OnClicked" "To do")
)

(defun c:AddCloud_OnClicked ( /)
    (bei_ds)
	(setq pt1 nil)
	(setq ob1 (entsel "\nPlease select the cloud to extend from (NOTE: The extension will begin from where your pick): "))	
	(setq pt1 (osnap (cadr ob1) "_NEA"))
	(setq pt2 pt1)	
	(command "._pline" pt2)
	(setq secondpt nil)
	(while pt1		
		(setq pt1 (getpoint pt1 "\nPlease select the next point for the object (Note: Last point must be on the existing cloud): "))
		(if pt1 (command pt1))
		(if (not secondpt)
			(setq secondpt pt1)
		)
		(if pt1 (setq lastpt pt1))
	)
	(command "")
	(setq l2 (entlast))   		
	(command "._break" ob1 "F" pt2 lastpt)	
	(bei_cend)
	(vl-cmdf "._pedit" ob1 "J" "all" "" "")
)


(defun c:AddDelta_OnClicked ( /)
    (beidelta)
)
(defun c:RTOOLS_BEI_Cloud_RemoveClouds_OnClicked ( /)
	(if (tblsearch "layer" "CLOUD")
		(progn
			(command "._LAYDEL" "N" "CLOUD" "" "y")
		)
    )
	
	(setq E (entnext))
		(while E
			(setq c (cdr (assoc 2 (entget E))))
			(if c
				(progn
					(if (wcmatch (strcase c) (strcase "*DELTA*"))
						(progn
							(entdel E)                    
						)
					)
				)
			)
			(setq E (entnext E))
		)
)

(defun c:BEI_Cloud_OnClose ( /)
     (Setq rValue2 (dcl_Project_UnLoad "RTOOLS"))
)

(defun c:RTOOLS_BEI_Cloud_CleanMe_OnClicked ( /)
     (rtools_bsr)
)

(defun c:FreezeFire_OnClicked ( /)
	(command "._-laydel" "n" "A-Wall-2x6" "" "y")
)

(defun c:CLOUD_T24_Folder_OnEditChanged (sText /)
	(princ "\n")
)

(defun c:BrowseT24_OnClicked ( /)
(dcl_control_settext CLOUD_T24_Folder (dos_getfiled "Select the Title 24 PDF" "h:\\Projects\\" "*.PDF"))
(setq xa (open (strcat (dos_specialdir 5) "t24temp.bat") "w"))
(princ (strcat "\"H:\\0ACAD Support\\AutoCAD\\Customization\\External Programs\\PDF Info\\pdftools.exe\" -i \"" (dcl_control_gettext CLOUD_T24_Folder) "\" >\"" (dos_specialdir 5) "t24temp.dat\"") xa)
(close xa)
(dos_exewait (strcat (dos_specialdir 5) "t24temp.bat") 3)

(if (setq fil (open (strcat (dos_specialdir 5) "t24temp.dat") "r"))
	(Progn      
		(while (setq lineone (read-line fil))           
			(if (/= lineone nil)
				(progn
					(if (wcmatch lineone "*PDF PageCount*")
						(progn
							(setq x1 (dos_strmid lineone 17))
							(dcl_control_settext RTOOLS_BEI_Cloud_PDFPgCt x1)
						)
					)
				)
			)
		)
	)
)
(close fil)
		 (dcl_ListBox_Clear RTOOLS_BEI_Cloud_ListBox1)
	     (setq X1 1)
	 (while (<= X1 (atof (dcl_control_gettext RTOOLS_BEI_Cloud_PDFPgCt)))
		(dcl_ListBox_AddString RTOOLS_BEI_Cloud_ListBox1 (rtos X1 2 0))
		(setq X1 (+ X1 1))
	 )
)

(defun c:BEI_Cloud_OnClicked ( /)
	(c:AddDelta_OnClicked)		     
)
(defun c:RTOOLS_BEI_Cloud_MPDF_OnClicked ( /)
	(setq oldclayer (getvar "clayer"))
	(setvar "clayer" "Text")
	(setq A100 (dcl_ListBox_GetSelectedItems RTOOLS_BEI_Cloud_ListBox1))
	(setq A101 (length A100))
	(setq A102 0)
	(setq ins (getpoint "\nPlease select the upper left corner for the first PDF Page: "))
	(setq ins (polar ins (dtr 270) 10.582))
	(setq ins (polar ins (dtr 180) 0.43))
	(setq originalins ins)
	(setq oldins ins)
	(setq HA 1)
	(setq HR 1)	
	(setq TS (atof (dcl_Control_GetText RTOOLS_BEI_Cloud_NOSR)))
	(command "._-layout" "_rename" "" "MECHANICAL TITLE 24 COMPLIANCE FORMS - SHEET 1")
	(setq LastNo 1)
	(if (> TS 1)
		(progn
			(command "._-layout" "_copy" "" "MECHANICAL TITLE 24 COMPLIANCE FORMS - SHEET 2")
			(setq LastNo 2)
		)
	)
	(setq PDFs nil)
	(setq PDFs (ssadd))
	(while (< A102 A101)		
		(command "._-pdfattach" (dcl_control_gettext CLOUD_T24_Folder) (nth A102 A100) ins "1" "0")
		(ssadd (entlast) PDFs)
		(setq clip1 (polar ins 0 0.430))
		(setq clip1 (polar clip1 (dtr 90) 0.682))
		(setq clip2 (polar clip1 0 7.70))
		(setq clip2 (polar clip2 (dtr 90) 9.90))
		(command "._pdfclip" (entlast) "N" "R" clip1 clip2)
	    (setq A102 (+ A102 1))
		(setq HA (+ HA 1))
		(if (= HA (+ (atof (dcl_control_Gettext RTOOLS_BEI_Cloud_TextBox1)) 1))
			(progn
				(setq ins (polar oldins (dtr 270) 10.15))
				(setq oldins ins)
				(setq HA 1)
				(setq HR (+ HR 1))
				(if (= HR (+ (atof (dcl_control_Gettext RTOOLS_BEI_Cloud_Rows)) 1))
					(progn
						(setq ins originalins)
						(setq oldins ins)						
						(scT24)
						(command "._layout" "set" (strcat "MECHANICAL TITLE 24 COMPLIANCE FORMS - SHEET " (rtos LastNo 2 0)))
						(if (> TS LastNo)
							(progn
								(setq LastNo (+ LastNo 1))
								(command "._-layout" "_copy" "" (strcat "MECHANICAL TITLE 24 COMPLIANCE FORMS - SHEET " (rtos LastNo 2 0)))								
							)
						)
					)
				)
			)
			(setq ins (polar ins 0 7.89))
		)	
	)
	(scT24)
	(setvar "clayer" oldclayer)
	(princ)
)
(defun c:RTOOLS_BEI_Cloud_Calculate_OnClicked (/)
	(setq UL (getpoint "\nSelect the upper left corner of the area to place the Title 24 Forms in: ")
		  BR (getcorner UL "\nSelect the lower left corner of the area to place the Title 24 Forms in: "))
	(T24ShtCalc)	
	(princ)
)
(defun c:RTOOLS_BEI_Cloud_S2F_OnClicked (Value /)
	(if (or (= UL nil) (= BR nil))
		(c:RTOOLS_BEI_Cloud_Calculate_OnClicked)
		(T24ShtCalc)
	)
)
(defun c:RTOOLS_BEI_Cloud_ListBox1_OnSelChanged (ItemIndex Value /)
	(nop)
)
(defun c:RTOOLS_BEI_Cloud_Rows_OnEditChanged (NewValue /)
	(nop)
)
(defun c:RTOOLS_BEI_Cloud_TextBox1_OnEditChanged (NewValue /)
	(nop)
)

(defun c:RTOOLS_BEI_Cloud_FTP_OnClicked (/)
  (dos_execute "H:\\0ACAD Support\\AutoCAD\\Customization\\External Programs\\FileZilla\\FileZillaPortable\\FileZillaPortable.exe")
)


(defun c:RTOOLS_BEI_Cloud_SendLargeFiles_OnSelChanged (ItemIndex Value /)
	(dcl_Form_Show RTOOLS_HTMLFORM)
	(dcl_Html_Navigate RTOOLS_HTMLFORM_Html1 (dcl_Control_GetText RTOOLS_BEI_Cloud_SendLargeFiles))
)
;End of interface functions

;Supporting Functions
(defun T24ShtCalc ()
	(setq $x$ (abs (- (car UL) (car BR)))
          $y$ (abs (- (cadr UL) (cadr BR)))
		  sccol (fix (/ $x$ 6.312))
		  scrow (fix (/ $y$ 8.12))				
		  col (fix (/ $x$ 7.89))
		  row (fix (/ $y$ 10.1500))
		  scbycol nil
		  scbyrow nil)
	(if (= (dcl_Control_GetValue RTOOLS_BEI_Cloud_S2F) 1)
		(progn	  
			(if (> sccol col)
				(setq scbycol T)
			)
			(if (and (= scbycol nil) (> scrow row))
				(setq scbyrow T)
			)
			(setq col sccol
				  row scrow)
		)
	)
	(dcl_Control_SetText RTOOLS_BEI_Cloud_Rows (rtos row 2 0))
	(dcl_Control_SetText RTOOLS_BEI_Cloud_TextBox1 (rtos col 2 0))
	(nop)
)

(defun sct24 ()
	(if (= (dcl_Control_GetValue RTOOLS_BEI_Cloud_S2F) 1)
		(progn
			(setq scpt (polar originalins (dtr 90) 10.582)
				  scpt (polar scpt 0 0.43))
			(if scbyrow
				(command "._scale" PDFs "" scpt "reference" scpt (polar scpt (dtr 270) (- (* (atof (dcl_Control_GetText RTOOLS_BEI_Cloud_Rows)) 10.15) 0.25)) (abs (- (cadr UL) (cadr BR))))
			)
			(if scbycol
				(command "._scale" PDFs "" scpt "reference" scpt (polar scpt 0 (- (* (atof (dcl_Control_GetText RTOOLS_BEI_Cloud_TextBox1)) 7.89) 0.25)) (abs (- (car UL) (car BR))))
			)
			(setq PDFs nil)
			(setq PDFs (ssadd))
		)
	)
)

(defun nop ()
	(if (/= (dcl_ListBox_GetSelCount RTOOLS_BEI_Cloud_ListBox1) 0)
		(progn
			(setq pgpsht (* (atof (dcl_Control_GetText RTOOLS_BEI_Cloud_Rows)) (atof (dcl_Control_GetText RTOOLS_BEI_Cloud_TextBox1)))
			      shts (/ (dcl_ListBox_GetSelCount RTOOLS_BEI_Cloud_ListBox1) pgpsht))
			(if (/= (fix shts) shts)
				(progn
					(if (= (rtos (fix shts) 2 0) (rtos shts 2 0))						
							(setq shts (+ shts 1))
							(setq shts (atof (rtos shts 2 0)))
					)
				)
			)
			
			(dcl_Control_SetText RTOOLS_BEI_Cloud_NOSR (rtos (fix shts) 2 0))
		)
	)
)

;XREF Tools
(defun bsr_xreftoattach (namelst / uncommonblock uncommonblockclip a curlaystate cpath delme fdelme) ; xref to overlay
  (setq SKIPPED nil); Modified by Chris Wade to accomodate if the x-refs cannot be found.
  (if (= (type namelst) 'STR) (setq namelst (list namelst)))
  (if (not namelst) (setq namelst (getxreflst)))
  (setq count 0)
  (while (or (findfile (strcat "ub" (itoa count) ".dwg")) (tblsearch "BLOCK" "ub" (itoa count))) (setq count (1+ count)))
  (setq uncommonblock (strcat "ub" (itoa count) ".dwg"))
  (command "point" "0,0" "wblock" (setq fdelme (strcat (getvar "dwgprefix") uncommonblock)) "" "0,0" (entlast) "")
  (setq uncommonblockclip (substr uncommonblock 1 (- (strlen uncommonblock) 4)))
  (command "undo" "begin")
  (command "._-layer" "a" "save" "BEI" "" "" "")
  (COMMAND ".-LAYER" "UNLOCK" "*" "")
  (foreach a namelst 
	(setq cpath (xrefpath a))	
	(command "xref" "attach" (findfile uncommonblock) "0,0" "" "" "")
	(setq delme (ssget "x" (list (cons 2 uncommonblockclip))))
	(command "xref" "path" uncommonblockclip cpath)   
	(redefxrefs a uncommonblockclip)
	(command "xref" "detach" a)
	(if (tblsearch "BLOCK" a);Modified by Chris Wade - to Accomodate if a block somehow already exists with the same name as the filename that is to be attached
		(progn
			(setq ST1 "-OLD")
			(if (tblsearch "BLOCK" (strcat a ST1))
				(progn
					(setq XA100 1)
					(while (tblsearch "BLOCK" (strcat a ST1))
						(setq OLDST1 ST1)
						(setq ST1 (strcat ST1 "-" (rtos XA100 2 0)))
						(if (tblsearch "BLOCK" (strcat a ST1))
							(progn
								(setq ST1 OLDST1)
								(setq XA100 (+ XA100 1))
							)
						)
					)
				)
			)
			(command "rename" "block" a (strcat a ST1))
		)
	);End of additional code
	(command "rename" "block" uncommonblockclip a)
    (if delme (command "erase" delme ""))
  ) ; foreach
  (command "._-layer" "a" "restore" "BEI" "" "" "")
  (command "._-layer" "a" "delete" "BEI" "" "" "")
  (command "._-xref" "d" "ub*")
  (command "undo" "e")
  (vl-file-delete (strcat fdelme))
  (if SKIPPED ; Modified by Chris Wade to accomodate if the x-refs cannot be found.
	;(princ "\nSome xrefs were skipped because they could not be found, you will need to change them manually."); Modified by Chris Wade to accomodate if the x-refs cannot be found.
	(progn
		(dcl_Control_SetValue RTOOLS_BEI_Cloud_Overlay2Attach 0)
		(dcl_Control_SetCaption RTOOLS_BEI_Cloud_Overlay2Attach "Some not changed from overlay to attach")
		(if (= (dcl_Control_GetValue RTOOLS_BEI_Cloud_XrefDialog) 1)
			(progn
				(initdia)
				(command "._classicxref")
			)
		)
	)
  ); Modified by Chris Wade to accomodate if the x-refs cannot be found.
  (princ)
) ; xreftoattach


;Routines used for xreftoattach
(defun getxreflst (/ roughxrlst a cur xrlst)
  (setq roughxrlst (findxref))
  (foreach a roughxrlst
    (setq cur (cdr (assoc 2 a)))	
	(setq xrlst (append xrlst (list cur)))
  ) ; foreach
  xrlst
) ; getxreflst

;; The following code was written by R. Robert Bell, RobertB@MWEngineers.com
(defun findxref ( / tblitem xreflist)
 (vl-Load-Com)
 (vlax-For aBlk  (vla-Get-Blocks (vla-Get-ActiveDocument (vlax-Get-Acad-Object)))
  (cond ((= (vla-Get-IsXref aBlk) :vlax-True)
         (setq xRefs (cons (vla-Get-Name aBlk) xRefs)))))
 (foreach blkN  xRefs 
	(IF (/= (FINDFILE (strcat (getvar "dwgprefix") blkN ".dwg")) NIL); Modified by Chris Wade to accomodate if the x-refs cannot be found.
		(PROGN ; Modified by Chris Wade to accomodate if the x-refs cannot be found.
		  (setq ss (ssget "X" (list (cons 0 "Insert") (cons 2 blkN))))   
		  (cond (ss (setq xreflist (append xreflist (list (entget (ssname ss 0))))))) 
		  (princ (strcat "\nXREF: " (strcat blkN ".dwg") " was added to the list of xrefs.")); Modified by Chris Wade to accomodate if the x-refs cannot be found.
		); Modified by Chris Wade to accomodate if the x-refs cannot be found.
		(progn
			(princ (strcat "\nXREF: " (strcat blkN ".dwg") " could not be found - **** SKIPPING THIS XREF ****")); Modified by Chris Wade to accomodate if the x-refs cannot be found.
			(setq SKIPPED T)
		)
	); Modified by Chris Wade to accomodate if the x-refs cannot be found.
)
  xreflist
)
;---------------------------------------------------------------------------
(defun redefxrefs (old new / ss count cur)
  (setq ss (ssget "x" (list (cons 0 "INSERT") (cons 2 old))))
  (setq count (sslength ss))  
  (while (>= (setq count (1- count)) 0)
    (setq cur (ssname ss count))
    (entmod (subst (cons 2 new) (cons 2 old) (entget cur)))
  ) ; while
  (sslength ss)
) ; redefxrefs

(defun xrefpath (a ) ; xref path from xref name
  (setq e (tblobjname "BLOCK" a))
  (cdr (assoc 1 (entget e)))
) ; xrefpath



(defun c:RelativeXrefs ( / *error* doc blocks cnt datalst strlst str 
                           xpath xname reportlst nestcnt PathList
                           XrefsData XrefSearch)

  (defun *error* (msg)
    (cond
      ((not msg))
      ((wcmatch (strcase msg) "*QUIT*,*CANCEL*"))
      (T (princ (strcat "\nError: " msg)))
    )
    (setvar "cmdecho" 1)
    (vla-EndUndoMark doc)
    (princ)
  ) ;end error

 ;;;; START SUB-FUNCTIONS ;;;;

  ;; Argument: path string
  ;; Returns the path portion as a list of strings in reverse order.
  ;; (setq s "..\\..\\Common ABC\\XRefs ABC\\Plan Unit 3BR KLSC.dwg")
  ;; ("\\XRefs ABC" "\\Common ABC" "\\.." "\\..")
  ;; The file name is not included.
  (defun PathList (str / idx pat pos lst)
    (setq idx 0 pat "\\")
    (while (setq pos (vl-string-search pat str idx))
      (setq lst (cons (strcat pat (substr str (1+ idx) (- pos idx))) lst)
            idx (1+ pos)
      )
    )
    lst
  ) ;end

  ;; Returns a list of lists: (fullname fn blockname expath) 
  (defun XrefsData ( / blkname expath fullname fn xlst NestedXref)

    ;; Argument: block definition vla-object.
    ;; Returns a count number if the xref is nested, otherwise nil.
    ;; Based on code by Stephan Koster in a program named XrefTree.
    ;; Function renamed from nested_p.
    ;; The nestcnt variable is local to the primary routine.
    ;; There is a known flaw in the function which Jason pointed out.
    ;; If an xref is both nested and referenced as a parent, the
    ;; function does not flag it as nested. The fallout from that situation,
    ;; if it occurs, is handled near the end of the primary routine.
    (defun NestedXref (blkdef / elst) 
      (setq elst (entget (vlax-vla-object->ename blkdef)))
      (if
        (or
          (not (vl-position '(102 . "{BLKREFS") elst))
          (and
            (vl-position '(102 . "{BLKREFS") elst)
            (not (cdr (assoc 331 elst)))
          )
        )
        (setq nestcnt (1+ nestcnt))
        ;; Else return nil to the parent function.
      )
    ) ;end

    (vlax-for x blocks
      (if 
        (and
          (= -1 (vlax-get x 'IsXref))
          (setq blkname (vlax-get x 'Name))
          ;; Filter out nested xrefs.
          (not (NestedXref x))
          (setq expath (cdr (assoc 1 (tblsearch "block" blkname))))
          (setq fn (strcat (vl-filename-base expath) ".dwg"))
        )
        (progn           
          (cond 
            ;; Xref found at full or relative path.
            ((setq fullname (findfile expath)))
            ;; Xref found in the same folder as the active file
            ;; and it the xref has not been renamed.
            ((setq fullname (findfile fn)))
            ;; Xref not found so far. Substitute the path for full name.
            (T (setq fullname expath))
          )
          (setq xlst (cons (list fullname fn blkname expath) xlst))
        )
      )
    )
    xlst
  ) ;end

  ;; Arguments: strlst - a list of strings returned by PathList.
  ;;            path - a file name returned by FileName.
  ;;            dot - a string either ".\\" to search down the folder structure
  ;;            or "..\\" to search up the folder structure.
  ;; Returns: a relative path if the file is found.
  (defun XrefSearch (strlst path dot / xpath)
    (if (and strlst path dot)
      (progn
        (setq path (strcat "\\" path))
        (while 
          (and
            strlst
            (not (findfile (setq xpath (strcat dot 
              (substr (setq path (strcat (car strlst) path)) 2))))
            )
          )          
          (setq strlst (cdr strlst))
          (setq dot (strcat dot dot))
        )
        (if (and xpath (findfile xpath))
          xpath
        )
      )
    )
  ) ;end



  ;;;; END SUB-FUNCTIONS ;;;;

  ;;;; START PRIMARY FUNCTION ;;;;

  (vl-load-com)
  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
  (vla-StartUndoMark doc)


  (setvar "cmdecho" 0)

  (setq blocks (vla-get-blocks doc)
        cnt 0
        nestcnt 0
        datalst (XrefsData)
  )
  
  ;; datalst is a list of lists
  ;; xref (fullname fn blkname expath)
  (foreach x datalst
    (setq strlst (PathList (car x))
          ;; Xref file name.
          str (cadr x)
          ;; The xref block name.
          xname (caddr x)
    )

    (cond
      ;; Xref found in the same folder as the active file.
      ((findfile str) (setq xpath str))
      ;; Search for xref down the folder structure.
      ((setq xpath (XrefSearch strlst str ".\\")))
      ;; Search for xref up the folder structure.
      ((setq xpath (XrefSearch strlst str "..\\")))
    )

    (if 
      (and 
        xpath
        ;; Check the path found is not the same as the original path.
        (not (eq xpath (cadddr x)))
      )
      (progn
        (command "._xref" "path" xname xpath)
        (setq reportlst (cons (list xname xpath) reportlst)
              cnt (1+ cnt)
        )
      )
    )
	(if (not xpath)
		(progn
			(dcl_Control_SetValue RTOOLS_BEI_Cloud_XREFS1 0)
			(dcl_Control_SetCaption RTOOLS_BEI_Cloud_XREFS1 "Some not repathed.")
			(dcl_Control_Redraw RTOOLS_BEI_Cloud_XREFS1)
		)
	)    
  ) ;foreach

  ;; Double check each xref which should have been repathed actually was.
  ;; If not try again. In some cases where an xref is both referenced as a
  ;; parent and also nested, this will allow repathing the xref.
  ;; Without it an xref may be reported as repathed when it was not.
  (foreach x reportlst
    (if (not (eq (cadr x) (cdr (assoc 1 (tblsearch "block" xname)))))
      (command "._xref" "path" (car x) (cadr x))
    )
  )

  ;; Report:
  ;; Doing this separate from the repath operation avoids a message,
  ;; "press enter to continue" from getting tangled up with the report.
  ;; I don't know what that message refers to, but it doesn't cause a problem.
  (foreach x reportlst   
    (princ (strcat "\nXref: " (car x) " repathed: \n"))
    (princ (strcat "  " (cadr x)))
  )

  (print)
  (if (not (zerop nestcnt))
    (princ (strcat "\nNumber of nested xrefs found: " (itoa nestcnt)))
  )
  (princ (strcat "\nNumber of xrefs repathed: " (itoa cnt)))

  (*error* nil)
) ;end

  ;;;; END PRIMARY FUNCTION ;;;;
;------------------------------------
;shortcut
(defun c:REX () (c:RelativeXrefs))
;------------------------------------
;End of Remove XREF Paths
;End of xref Tools
(defun c:rtools_bsr ()	
	(command "tilemode" "1")	
	(if (= 1 (getvar "pstylemode"))
		(progn			
			(command "filedia" "0")
			(command "convertpstyles" "Conversion.stb")
			(command "filedia" "1")
		);end progn
	);end if
	(command "._-layer" "unlock" "*" "on" "*" "thaw" "*" "")
	(setvar "setbylayermode" 113)
	(command "setbylayer" "all" "" "yes" "yes")
	(command "._-insert" "H:\\0ACAD Support\\AutoCAD\\Support Files\\Plot Styles\\shaded.dwg" "0,0" "1" "" "0")
	(command "._erase" (entlast) "")	
	(COMMAND "-LAYER" "COLOR" "8" "*" "")
	(COMMAND "-LAYER" "PSTYLE" "SHADED" "*" "")
	(c:RelativeXrefs)
	(bsr_xreftoattach nil)
	(setq ss (ssget "X" (list (cons 8 "BEI Plot Stamp"))))
	(if (/= SS nil) (command "._erase" SS ""))    
	(command "-purge" "r" "*" "n")
	(command "-purge" "a" "*" "n")
	(command "-purge" "a" "*" "n")	
	(command "-purge" "a" "*" "n")
	(command "-purge" "a" "*" "n")
	(dcl_ListBox_DeleteItem RTOOLS_BEI_Cloud_File_List 0)
	(dcl_Control_Redraw RTOOLS_BEI_Cloud_File_List)
	(bsrprog)
	(command "._QSAVE")	
	(command "._Close")
)

(defun cmdOpen (name)  
  ;;; posted by Frank Whaley  
  ;(vl-load-com) 
  ;(if (= 0 (getvar "SDI"))  
    ;(vla-activate (vla-open (vla-get-documents (vlax-get-acad-object)) name))
	;(vla-open (vla-get-documents (vla-get-application (vlax-get-acad-object))) name)
    ;(vla-sendcommand (vla-get-activedocument (vlax-get-acad-object)) (strcat "_.OPEN\n" name "\n"))
  ;) 

  ;(dcl_SendString (strcat "._open " name " "))
  
  (setq vgao (vlax-get-acad-object))
(setq vgad (vla-get-activedocument vgao))
(setq vgd (vla-get-documents vgao))
(if
  (= 0 (getvar "SDI"))
  (vla-activate (vla-open vgd name))                               ; if sdi = 0
  (vla-sendcommand vgad (strcat "(command \"_open\")\n" name "\n")); if sdi = 1
  )
  
) 


(defun cleanfinish ()	
	(setvar "SDI" 0)	
	(dcl_ListBox_Clear RTOOLS_BEI_Cloud_File_List)
	(if (= (dcl_Control_GetValue RTOOLS_BEI_Cloud_XREFS1) 0)
		(progn
			(dcl_Control_SetCaption RTOOLS_BEI_Cloud_XREFS1 "Some of the x-refs could not be repathed")
			(dcl_Control_SetToolTipTitle RTOOLS_BEI_Cloud_XREFS1 "Some of the x-refs could not be repathed")
			(dcl_Control_SetToolTipMainText RTOOLS_BEI_Cloud_XREFS1 "Reference Manager needs to be Run, please note it should have automatically launched! :-(")
			(setq REFMAN (strcat (findfile "AdRefMan.exe") " \"" (dcl_Control_GetText CLOUD_BackFolder) "\""))
			(if (/= REFMAN nil)
				(progn
					(dos_execute (strcat "explorer \"" (dcl_Control_GetText CLOUD_BackFolder) "\""))
					(dos_exewait (strcat REFMAN) 4)
				)
			)
		)
	)
	
	(dos_delete (strcat (dcl_control_gettext CLOUD_BackFolder) "\\*.adt"))
	(dos_delete (strcat (dcl_control_gettext CLOUD_BackFolder) "\\*.bak"))							
	(dos_copy (strcat (dcl_control_gettext CLOUD_BackFolder) "\\*.*") (dcl_control_gettext CLOUD_CopyToFolder))
	(dos_delete (strcat (dcl_control_gettext CLOUD_BackFolder) "\\*.*"))
	(bsrprog)
)

(defun c:BEI_Cloud_OnDocActivated ( /)					
		;(setq Running (dcl_Control_GetValue RTOOLS_BEI_Cloud_Batch_Running))
		;(if (= Running 1)
		(if (= (getvar "dwgprefix") (dcl_Control_GetText CLOUD_BackFolder))
			(c:rtools_bsr)
		)
		
		
		(dcl_Control_SetCaption RTOOLS_BEI_Cloud_Total (rtos (dcl_ListBox_GetCount RTOOLS_BEI_Cloud_File_List) 2 0))
		(dcl_Control_SetValue RTOOLS_BEI_Cloud_Batch_Running 1)
		(setq ct (dcl_ListBox_GetCount RTOOLS_BEI_Cloud_File_List))
		(if (> ct 0)
			(progn
				(setq FileString (dcl_ListBox_GetItemText RTOOLS_BEI_Cloud_File_List 0))				
				(setq ct (- ct 1))
			)
			(progn
				
						(dcl_Control_SetValue RTOOLS_BEI_Cloud_Batch_Running 0)
						(command "._qsave")
						;(command "._qnew" "")						
						(cleanfinish)			
			)
		)
		
		(if (/= FileString nil)
			(progn
				(dcl_ListBox_SetCurSel RTOOLS_BEI_Cloud_File_List 0)				
				(dcl_Control_Redraw RTOOLS_BEI_Cloud_File_List)
				(dos_cleardbmod)									
				(setq YN nil)
				(if (> (getvar "DBMod") 0)
					(progn
						(setq YN (dos_msgbox (strcat "Do you want to save changes to the drawing: " (getvar "dwgname") "?") "UNSAVED CHANGES" 5 4))
						(if (= YN 6)
							(command "._qsave")
						)
						
						(if (= YN 1)
							(progn
								(dcl_Control_SetValue RTOOLS_BEI_Cloud_Batch_Running 0)
								(dcl_ListBox_Clear RTOOLS_BEI_Cloud_File_List)								
								(exit)
							)
						)
					)
				)
				(if (= YN 3)
					(progn											
						;(command "._open" "Y" FileString)
						(cmdOpen FileSting)
					)
					(progn												
						(command "._recover" FileString)
					)
				)
			)
			
		)
		(setq YN nil)
)

(defun largefiles ()
	(dcl_ComboBox_AddString RTOOLS_BEI_Cloud_SendLargeFiles "http://www.Driveway.com")
	(dcl_ComboBox_AddString RTOOLS_BEI_Cloud_SendLargeFiles "http://www.TransferBigFiles.com")
	(dcl_ComboBox_AddString RTOOLS_BEI_Cloud_SendLargeFiles "http://www.YouSendIt.com")
	(dcl_ComboBox_AddString RTOOLS_BEI_Cloud_SendLargeFiles "http://www.LargeFilesAsap.com")
	(dcl_ComboBox_AddString RTOOLS_BEI_Cloud_SendLargeFiles "http://www.FileMail.com")
	(dcl_ComboBox_AddString RTOOLS_BEI_Cloud_SendLargeFiles "http://www.SendSpace.com")
)
(defun bsrprog ()
;FUNCTIONS used for XRP and X2)
	(dcl_Control_SetValue RTOOLS_BEI_Cloud_ProgressBar1 (+ (dcl_Control_GetValue RTOOLS_BEI_Cloud_ProgressBar1) 1))
	(dcl_Control_Redraw RTOOLS_BEI_Cloud_ProgressBar1)
)
(DEFUN JN2 (JN100)  
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
	(vl-cmdf "._redefine" "revcloud")
	(vl-cmdf "._REVCLOUD" "A" (dcl_control_gettext CLOUD_MinArcLen) (dcl_control_gettext CLOUD_MaxArcLen) "Object" l2 "" )   
	(setq el (entlast))
	(bei_chlayer)
)

(defun bei_chlayer ()
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
	(dcl_control_settext CLOUD_MinArcLen (rtos (* ds 0.35) 2 10))
	(dcl_control_settext CLOUD_MaxArcLen (rtos (* ds 0.35) 2 10))	
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

(defun beidelta ()
	(bei_layer)	
	(setq ip (getpoint (strcat "\nPlease select a point to insert the delta symbol at (Press enter or pick a blank spot for none): ")))      
	(setq ip2 (osnap ip "_nea"))
	(setq el (nentselp "" ip2))
	
	(bei_chlayer)
	(if ip2
		(progn			
			(setvar "attreq" 1)
		    (setvar "attdia" 0)
			(if (or (= (getvar "tilemode") 1) (/= (getvar "cvport") 1))
				(progn
					(setq a324 (strcat "@" (rtos (* 0.25362901 (getvar "dimscale"))) "<90"))	    
					(command "polygon" "3" (osnap (cadr el) "_nea") "I" a324)
					(setq dtemp (entlast))
					(command "._trim" dtemp "" (osnap (cadr el) "_nea") "")
					(command "._erase" dtemp "")					
					(command ".-insert" "BEIDelta-Rev4" ip2 (getvar "dimscale") (getvar "dimscale") "0" (dcl_control_gettext Cloud_Delta))
					(command "._chprop" (entlast) "" "la" DeltaLayer "")
				)
			)
			(if (and (= (getvar "tilemode") 0) (= (getvar "cvport") 1))
				(progn	    
					(command "polygon" "3" (osnap (cadr el) "_nea") "I" "@0.25362901<90")
					(setq dtemp (entlast))
					(command "._trim" dtemp "" (osnap (cadr el) "_nea") "")
					(command "._erase" dtemp "")
					(command ".-insert" "BEIDelta-Rev4" ip2 "1" "1" "0" (dcl_control_gettext Cloud_Delta))	    
					(command "._chprop" (entlast) "" "la" DeltaLayer "")
				)
			)
		)
	)   
)




(defun beifill (pth)
	(setq pth (fixfolder pth))
	(setq fname (strcat pth "RTOOLS-Do_Not_Modify.ini"))  
	(if (setq fil(open fname "r"))
		(progn 
			(while (setq lineone(read-line fil))           				
				(princ)
			)
			(setq Auto_Filled (strcat (getvar "dwgprefix") (getvar "dwgname")))
		)
	)
)

(defun chtst ()
	(if (and Delta_Changed Date_Changed Desc_Changed)
		(setq Auto_Filled (strcat (getvar "dwgprefix") (getvar "dwgname")))
	)
)

(defun fixfolder (PFolder)
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
	PFolder
)
(defun rtools_main ()
	(setq Delta_Changed nil)
	(setq Date_Changed nil)
	(setq Desc_Changed nil)
	(setq Auto_Filled nil)	
	(dcl_Project_Load "rtools.odcl" T)
	(dcl_Form_Show BEI_Cloud)	
	(vl-cmdf "._redefine" "revcloud")
	(largefiles)
	(bei_civil)
)
(defun dtr (a)
	(* pi (/ a 180.0))
)
(defun rtd (a)
	(/ (* a 180) pi)
)
;End of supporting functions

;Main Function
(defun C:RTOOLS () ; This loads the project as a dockable window.
	(rtools_main)
)
;End of main function

;Alias functions
(defun c:rc ()
	(c:RTOOLS_BEI_Cloud_RemoveClouds_OnClicked)
)
(defun c:RCLOUD ()
	(rtools_main)
)
;End of alias functions.

;; RelativeXrefs by Joe Burke

;; Bug reports may be sent to me directly at lowercase@hawaii.rr.com.
;; Program updates will be posted at www.theswamp.org under 
;; "Show your stuff" in a topic named "Relative xref paths".

;; PROGRAM NOTES:

;; The standard disclaimer applies. Use at your own risk...

;; In general it's important to understand how relative paths work
;; before using this program.

;; Please be aware the program is potentially dangerous in the sense
;; relative repathing from one drive to another may cause pointing to 
;; unexpected files in cases where duplicate files exist on different
;; drives and similar conditions.

;; The shortcut is REX.

;; Tested with 2002, 2004, 2006 and 2008. Should work with 2000,
;; but not tested.

;; Thanks to Steve Doman and Jason Piercey for their help.

;; The program works with unloaded xrefs, unlike other similar routines 
;; I've seen.

;; It does not deal with raster image references. I may add support 
;; for those later.

;; Reloading an xref can cause associative dimensions/leaders to do
;; strange things. Something to watch for. If it happens, undo
;; and change such dimensions to non-associative.

;; The program may take a long time depending on the number of xrefs, 
;; how many are reloaded and the size of reloaded files. 

;; Possible scenarios where RelativeXrefs might be useful.

;; First:
;; A project uses relative paths but all paths are not relative.
;; Convert full paths to relative assuming an xref can be found somewhere
;; along its orignal path. If not the original path remains.
;; Note, nested xrefs are not repathed because the path is determined within 
;; the parent file. Run the program on the parent file and save it. Then 
;; reload the parent in the active file to update nested paths.
;; There is at least one case where the path of nested xrefs will change 
;; in the active file. If the parent xref was "not found" and the program 
;; finds it, the parent is repathed. That may update nested paths.

;; Second:
;; A project begins as a group of files in one folder. Eventually the number
;; of files involved requires sub-folder organization and you want to use
;; relative paths. Repath as needed using full paths. Then convert full paths
;; to relative.

;; Third:
;; All project files are kept in a single folder so xrefs are found 
;; without a path. Some xrefs may have a full path which isn't used.
;; The program removes such paths leaving just the file name as the path.

;; VERSION HISTORY

;; Version 1.0 - first beta version 12/31/2007.

;; Version 1.1 - revised the XrefsData function 1/3/2008.

;; Version 1.2 - revised 1/5/2008.
;;   Changed the name of the XrefLoaded function to XrefIsLoaded.
;;   Changed its method of testing loaded or not.
;;   Changed the XrefsData function to return the xref block name
;;   at the end of each list so the reload and report calls are
;;   cosmetically correct in terms of the actual xref block name.

;; Version 1.3 - revised 1/8/2008.
;;   Removed the front end question about reload xrefs.
;;   Uses the xref command "path" rather than "reload".
;;   Removed checking for xref is loaded, not need now.
;;   Revised the XrefsData function per above.
;;   This version should be faster. 
;;   Also cleaner in terms the report at the end.
;;   Added report regarding number of nested xrefs found.
;;   Added a check near the end regarding an xref which should
;;   have been repathed, but possibly was not.

;; Version 1.4 - revised 1/12/2008.
;;   Added the Spinbar function with message, Searching for xrefs...

;; Version 1.5 - revised 2/22/2008.
;;   Removed the FileName sub-function. Added the SpinWait function so 
;;   the spinbar will work with some files where it otherwise does not.
;;   Added error checking in the XrefSearch sub-function.
;;   Fixed a bug which occured with 2004 and earlier versions. In those 
;;   versions an xref block definition does not have a Path property.