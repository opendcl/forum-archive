;;;							;
;;;	kbTools ADT and Production Tools v1.0		;
;;;							;
;;;	include files					;
;;;							;


(vl-load-com)

(if (not (vl-bb-ref 'kbADT))
  (vl-bb-set
    'kbADT
    (dcl_project_import
      '("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"))))

(defun c:kbaddclng( / )
  (command ".aecceilinggridadd" "s")
  )
(defun c:kbmaskatt( / )
(command ".aecmaskattach")
)
;;;							;
;;;		Support Functions			;
;;;							;

;;;AddCustomObject
;;; use (setq ret(kb:AecInitDocument nil))
;;;     (setq doc2(kb:AecInitDocument docref))
;;; NOT ObjectDBX compatible!
;;; Release as soon as possible in the sequence of the routine
(defun kb:AecInitDocument  (doc / acadapp activedoc ret)
  (setq acadapp (vlax-get-acad-object))
  (if (not doc)
    (setq doc (vlax-get acadapp "ActiveDocument")))

  (setq ret (vlax-invoke acadapp "getinterfaceobject" (kb:ReturnAecArchBaseDocument)))
  (vlax-invoke ret "init" doc)
  ret)

;;;(kb:ReleaseAECDoc ret)
(defun kb:ReleaseAECDoc(doc / )
  (vlax-release-object doc))

;;;							;
;;;	Add AEC Mask Block				;
;;;							;
;;;	MaskAnchorAdd					;
;;;	[NAme/X scale/Y scale/Z scale/Rotation/Match]	;
;;;							;
;;;	MaskAttach					;
;;;							;
;;;							;

;(setq MBlist(kb:getLocalObjectList "AEC_MASKBLOCK_DEFS"))
  

;;;pgp kbAddFluorMask,		*kbAddFluorMask
(defun c:kbAddFluorMask ( / *Error* ss ans oldsnap oldecho oldclayer newclayer dname)
	(defun *Error*  (Msg)
    (cond ((or (not Msg)
	       (member Msg '("console break" "Function cancelled" "quit / exit abort"))))
	  ((princ (strcat "\nError: " Msg))))
    (kb:ResetActiveSymbolLayer)
    (princ))

  (if(dcl_Form_IsActive ADT_ADTPalette)
  (setq	dname (dcl_Tree_GetItemText ADT_ADTPalette_StyleTreeControl
		(dcl_Tree_GetSelectedItem ADT_ADTPalette_StyleTreeControl)))
	)

  (setq	oldsnap	  (getvar "osmode")
	oldecho	  (getvar "cmdecho")
	oldclayer (getvar "clayer")
	newclayer (AecGenerateLayerKey "viewport")
  )
  (setvar "cmdecho" 1)

  (if newclayer
    (setvar "clayer" newclayer)
  )
  (dcl_setcmdbarfocus)
  (setvar "osmode" 0)
  (command "MaskAnchorAdd" "name" dname pause)
  (while (/= (getvar "cmdActive") 0)
    (command pause)
  )
  (setvar "osmode" oldsnap)
  (setq	ans (dcl_messagebox
	      "\nWould you like to mask the blocks now?"
	      "Mask Blocks?"
	      5
	      3
	    )
  )
  (if (= ans 6)
    (progn
      (setq ss (ssget '((0 . "AEC_MASKBLOCK_REF"))))
      (command "MaskAttach" ss "")
      (while (/= (getvar "cmdActive") 0)
	(command pause)
      )
    )
  )

  (setvar "cmdecho" oldecho)
  (setvar "clayer" oldclayer)
  (princ)
)


;(setq name "E_LIGHT_WALL_MOUNT")
;(setq llist nil ret nil)
;(kb:GetLocalSymbolBlocks "E_LIGHT*")
(defun kb:GetLocalSymbolBlocks(patt / name ret llist)
  (vlax-for x (vla-get-blocks (vla-get-activedocument(vlax-get-acad-object)))
    (setq name (vla-get-name x))
    (cond ((wcmatch name patt)
	   (setq ret(append ret(list name)))))
	  
	  )
  ret)

(defun kb:ReturnDescription(name / ret)
  (if (tblsearch "block" name)
  (setq ret(cdr(assoc 4(tblsearch "block" name)))))
    ret)

;;;pgp: kbInsertSymbol,		*kbInsertSymbol
(defun c:kbInsertSymbol	 (/ *Error* lkey dname continue)
  (defun *Error*  (Msg)
    (cond ((or (not Msg)
	       (member Msg '("console break" "Function cancelled" "quit / exit abort"))))
	  ((princ (strcat "\nError: " Msg))))
    (kb:ResetActiveSymbolLayer)
    (setq continue nil)
    (princ))
  (if(dcl_Form_IsActive ADT_ADTPalette)
  (setq	lkey  (dcl_Tree_GetParent
		ADT_ADTPalette_StyleTreeControl
		(dcl_Tree_GetSelectedItem ADT_ADTPalette_StyleTreeControl))
	dname (dcl_Tree_GetItemText
		ADT_ADTPalette_StyleTreeControl
		(dcl_Tree_GetSelectedItem ADT_ADTPalette_StyleTreeControl))
        )
    
	)
	
  (cond	((or (= lkey "anno") (= lkey "lay"))
	 (if (vl-string-search "REV" (strcase dname))
	   (kb:SetActiveSymbolLayer "ANNREV")
	   (kb:SetActiveSymbolLayer "ANNDTOBJ")))
	((= lkey "appl") (kb:SetActiveSymbolLayer "APPL"))
	((= lkey "furn") (kb:SetActiveSymbolLayer "FURN"))
	((= lkey "lite") (kb:SetActiveSymbolLayer "LIGHTCLG"))
	((= lkey "powr") (kb:SetActiveSymbolLayer "POWER"))
	((= lkey "hvac") (kb:SetActiveSymbolLayer "EQUIPCLG"))
	((= lkey "plmb") (kb:SetActiveSymbolLayer "PFIXT"))
	((= lkey "fire") (kb:SetActiveSymbolLayer "FIRE"))
	((= lkey "eqmt") (kb:SetActiveSymbolLayer "EQUIP"))
	(t (kb:SetActiveSymbolLayer "EQUIP")))

  (if (not (tblsearch "block" dname))
    (kb:ImportCollectionObjects (kb:ReturnProjectAECStylesStandardsFile) "BLOCKS" (list dname)))

  (if (tblsearch "block" dname)
    (progn
      (vl-cmdf "_.insert" dname "_scale" 1 pause 0)
      ;(command "_.copy" "_last" "" "_Multiple" (cdr(assoc 10(entget(entlast)))) pause)
      ;(while (/= (getvar "cmdActive") 0)
    ;(command pause))
      )
	   (alert "There was a problem Inserting the Block!"))
  (kb:ResetActiveSymbolLayer)
  (princ))


;(command "AecAnnoRevisionCloudAdd")
;(kb:SetActiveSymbolLayer "ANNOBJ")
;(setq lname "DOORNO")
(defun kb:SetActiveSymbolLayer	(lname / newlayer layers)
  (setq	layers (vlax-get-property (vla-get-activedocument(vlax-get-acad-object)) 'layers)
	kb%previouslayer
	 (vlax-get-property (vla-get-activedocument(vlax-get-acad-object)) 'activelayer)
	newlayer
	 (vlax-invoke layers "item" (kb:SetLayerKey lname)))
  (if newlayer
    (vlax-put-property (vla-get-activedocument(vlax-get-acad-object)) 'activelayer newlayer)))


;(kb:ResetActiveSymbolLayer)
(defun kb:ResetActiveSymbolLayer  (/)
  (if kb%previouslayer
    (progn (vlax-put-property (vla-get-activedocument(vlax-get-acad-object)) 'activelayer kb%previouslayer)
	   (setq kb%previouslayer nil)))
  (princ))

;(kb:InsertSheetViewTag)
(defun kb:InsertSheetViewTag( / coords inspt)
  (kb:SetActiveSymbolLayer "ANNDTOBJ")
  (setq coords(getvar "lastpoint")
	inspt(list(-(nth 0 coords)0.25)(-(nth 1 coords)0.65)(nth 2 coords)))
 
        (if (not (tblsearch "block" "TAG_SHEET_VIEW_TITLE"))
          (kb:ImportCollectionObjects  (kb:ReturnProjectAECStylesStandardsFile)"BLOCKS" (list"TAG_SHEET_VIEW_TITLE")))
  (vla-insertBlock (kb:getactivespace) (vlax-3d-point inspt) "TAG_SHEET_VIEW_TITLE" 1.0 1.0 1.0 0.0)
  (kb:ResetActiveSymbolLayer)
  )


(defun kb:InsertRevTag( / inspt)
  (setq inspt(getvar "lastpoint"))
 (kb:SetActiveSymbolLayer "ANNREV")
        (if (not (tblsearch "block" "TAG_REV"))
          (kb:ImportCollectionObjects  (kb:ReturnProjectAECStylesStandardsFile)"BLOCKS" (list"TAG_REVCLOUD")))
  (vla-insertBlock (kb:getactivespace) (vlax-3d-point inspt) "TAG_REV" 1.0 1.0 1.0 0.0)
  (kb:ResetActiveSymbolLayer)
  )



;;;pgp: kbRevCloud,		*kbRevCloud
(defun c:kbRevCloud( / *Error*)
  (defun *Error*  (Msg)
    (cond ((or (not Msg)
	       (member Msg '("console break"
			     "Function cancelled"
			     "quit / exit abort"))))
	  ((princ (strcat "\nError: " Msg))))
    (princ))
  (kb:SetActiveSymbolLayer "ANNREV")
        (if (not (tblsearch "block" "TAG_REVCLOUD"))
          (kb:ImportCollectionObjects
	    (kb:ReturnProjectAECStylesStandardsFile)"BLOCKS" (list"TAG_REVCLOUD")))
  (command "_.insert" "TAG_REVCLOUD" "_scale" 1 pause "0")
  (kb:ResetActiveSymbolLayer)
 
  )
 
;;;pgp:kbFindUnlinkedTags,		*kbFindUnlinkedTags
(defun c:kbFindUnlinkedTags  (/ ss o i attr)
  (setq ss (ssadd))
  (vlax-for
         o  (vla-get-modelspace (vla-get-activedocument(vlax-get-acad-object)))
    (if (= (vla-get-ObjectName o) "AcDbBlockReference")
      (progn
        (if (< (vlax-get o "hasattributes") 0)
          (progn (setq attr (vlax-invoke o "getattributes"))
                 (foreach
                        i  attr
                   (if (and (= (vlax-get i "TagString") "kb_NUMBER")
                            (= (vlax-get i "textstring") "VIEWNUMBER"))
                     (ssadd (vlax-vla-object->ename o) ss))))))))
  (sssetfirst ss ss)
  (princ)
  (princ))


;;;								;
;;;		Scheduling Control functions			;
;;;								;

;;;		Controls commands in the kbTools Menu		;


(defun kb:SetActiveScheduleStyle  (style / )
  (vl-registry-write
    (strcat "HKEY_CURRENT_USER\\"
	    (vlax-product-key)
	    "\\Profiles\\"
	    (vla-get-ActiveProfile
			(vla-get-Profiles (vla-get-preferences (vlax-get-acad-object))))
	    "\\Dialogs\\"
	    (kb:ReturnScheduleStyle))
    "Style name"
    style)
  (princ))



;;;(kb:AddSchTag "SC_DOOR")
(defun kb:AddSchTag  (dname / *Error* file dim ent oe)
  (defun *Error*  (Msg)
    (cond ((or (not Msg)
               (member Msg '("console break" "Function cancelled" "quit / exit abort"))))
          ((princ (strcat "\nError: " Msg))))
    (princ))
  ;(if (findfile "project.dwg")
        ;(progn
          (setvar "cmdecho" 1)
          (command ".AnnoScheduleTagAdd" (findfile "project.dwg") "_S" dname)
          ;)
        ;(alert "Can't find Property Set Definition Drawing!"))
  (princ)
  (princ))

;;;(kb:AnchorSchTag tag obj)
;;;(setq obj(vlax-ename->vla-object(car(nentsel)))tag(vlax-ename->vla-object(car(nentsel))))
(defun kb:AnchorSchTag  (tag obj / )
  (setq anchor (vla-getInterfaceObject (vlax-get-acad-object)(kb:ReturnAecAnchorTagtoEntity)))
  (vlax-put-property anchor 'Reference obj)
  (vlax-invoke-method anchor 'AttachEntity tag)
  (vlax-release-object anchor)
  )

(defun kb:AnchorRef  (tag obj / )
  (setq anchor (vla-getInterfaceObject (vlax-get-acad-object)(kb:ReturnAecAnchor)))
  (vlax-put-property anchor 'Reference obj)
  (vlax-invoke-method anchor 'AttachEntity tag)
  (vlax-release-object anchor)
  )
;;;(kb:ADTScheduleAdd "ROOM_FINISH")
(defun kb:ADTScheduleAdd(style / *Error* ent oe)
  (defun *Error*  (Msg)
    (cond ((or (not Msg)
	       (member Msg '("console break"
			     "Function cancelled"
			     "quit / exit abort"))))
	  ((princ (strcat "\nError: " Msg))))
    (princ))
  (if style(kb:SetActiveScheduleStyle style))
  (command "AecScheduleAdd")
  (princ)(princ))


;;;							;
;;;		Support Functions			;
;;;							;

(defun kb:ReturnCollectionName(sSelText / ret)
  (cond	((= sSelText "Walls")
	 (setq ret (list "AECWALL" "AEC_WALL_STYLES")))
	((= sSelText "Doors")
	 (setq ret (list "AECDOOR" "AEC_DOOR_STYLES")))
	((= sSelText "Windows")
	 (setq ret (list "AECWINDOW" "AEC_WINDOW_STYLES")))
	((= sSelText "Storefronts")
	 (setq ret (list "AecWindowAssembly" "AEC_WINDOW_ASSEMBLY_STYLES")))
	((= sSelText "Curtainwalls")
	 (setq ret (list "AecCurtainWallLayout" "AEC_CURTAIN_WALL_LAYOUT_STYLES")))
	((= sSelText "Spaces")
	 (setq ret (list "AecSpace" "AEC_SPACE_STYLES")))
	((= sSelText "Stairs")
	 (setq ret (list "AECStAIR" "AEC_STAIR_STYLES")))
	((= sSelText "Railings")
	 (setq ret (list "AECRAILING" "AEC_RAILING_STYLES")))
	((= sSelText "Schedule Tags")
	 (setq ret (list "AecMvBlockRef" "AEC_MVBLOCK_DEFS")))
	((= sSelText "Schedules")
	 (setq ret (list "AecScheduleTable" "AEC_SCHEDULE_TABLE_STYLES")))
	(t(setq ret(list"standard" "standard"))))
  ret)
;(setq dictname "AEC_MASKBLOCK_DEFS" llist nil)
(defun kb:getLocalObjectList(dictname / llist)
  (if (dictsearch (namedobjdict) dictname)
    (progn
    (foreach x (dictsearch (namedobjdict) dictname)
      (if (= (car x) 3)
	(setq llist (append (list (cdr x)) llist))))))
  llist)


(defun kb:getLocaltaglist(/ llist)
  (vlax-for
         x  (vla-get-blocks (vla-get-ActiveDocument (vlax-get-acad-object)))
    (if (and(= (vlax-get-property x 'isxref) :vlax-false)
            (= (vlax-get-property x 'islayout) :vlax-false)
            (not(vl-string-search "|"(vla-get-name x)))
            (vl-string-search "SC_"(vla-get-name x)))
            
      (setq llist (append llist (list (vlax-get-property x 'name))))))
  llist)



;(setq doorlist nil localblocklist nil)
;;;pgp:kbDoorElevationTool,		*kbDoorElevationTool
(defun c:kbDoorElevationTool( / *Error* p1 doorlist dimscale i x dwg dbxdoc localblocklist)
  (defun *Error*  (Msg)
    (cond ((or (not Msg)
               (member Msg '("console break" "Function cancelled" "quit / exit abort"))))
          ((princ (strcat "\nError: " Msg))))
    (princ))
  (setq dwg t)
  (if dwg
    (progn
      (setq dbxdoc(vla-get-ActiveDocument(vlax-get-acad-object)))
      (if dbxdoc
	(progn
(vlax-for x(vla-get-modelspace dbxdoc)
  (if (= (vla-get-ObjectName x)"AecDbDoor")
    (if (not (member (vla-get-StyleName x) doorlist))
      (setq doorlist(append doorlist(list (vla-get-StyleName x)))))))


(setq p1(getpoint "\nSelect start point for Elevations: "))
      
(foreach i doorlist
  (if (tblsearch "block" i)
    ;(if (not (member i localblocklist))
      (progn
    (command "-insert" i "_scale" 1 p1 "0")
    (setq p1(list(+(car p1)120.0)(cadr p1)(caddr p1)))
    );)
    (progn
    (alert (strcat "Door Elevation '" i "' is not available - check the door style!"))
    (princ(strcat "\n" i)))
    )))
	(alert (strcat dwg " is not available - it may be opened by another user!"))
	)
      ))
  (princ))

;;; Automation Error
(defun c:kbDoorElevationToolDBX( / *Error* p1 doorlist dimscale i x dwg dbxdoc localblocklist)
  (defun *Error*  (Msg)
    (cond ((or (not Msg)
               (member Msg '("console break" "Function cancelled" "quit / exit abort"))))
          ((princ (strcat "\nError: " Msg))))
    (princ))
  (setq dwg(getfiled "Select a file" (strcat(kb:ReturnProjectDir)"\\constructs\\") "dwg;dws" 0))
  (if dwg
    (progn
      (setq dbxdoc(kb:OPENDBXDOCUMENT dwg))
      (if dbxdoc
	(progn
(vlax-for x(vla-get-modelspace dbxdoc)
  (if (= (vla-get-ObjectName x)"AecDbDoor")
    (if (not (member (vla-get-StyleName x) doorlist))
      (setq doorlist(append doorlist(list (vla-get-StyleName x)))))))
(kb:CLOSEDBXDOCUMENT dbxdoc)
      (kb:ImportCollectionObjects dwg "BLOCKS" doorlist)

(setq p1(getpoint "\nSelect start point for Elevations: "))
      
(foreach i doorlist
  (if (tblsearch "block" i)
    ;(if (not (member i localblocklist))
      (progn
    (command "-insert" i "_scale" 1 p1 "0")
    (setq p1(list(+(car p1)120.0)(cadr p1)(caddr p1)))
    );)
    (progn
    (alert (strcat "Door Elevation '" i "' is not available - check the door style!"))
    (princ(strcat "\n" i)))
    )))
	(alert (strcat dwg " is not available - it may be opened by another user!"))
	)
      ))
  (princ))





(defun kb:ADTAdd  (style sSelText / collection aecobjtype)
  (cond	((= style "wall")
	 (setq collection "AECWALL"
	       aecobjtype "AEC_WALL_STYLES"))
	((member style (list "HM" "SC" "OT" "AL" "FD1" "FD2" "FD3" "FD4" "FD"))
	 (setq collection "AECDOOR"
	       aecobjtype "AEC_DOOR_STYLES"))
	((= style "window")
	 (setq collection "AECWINDOW"
	       aecobjtype "AEC_WINDOW_STYLES"))
	((= style "doorwinass")
	 (setq collection "AecWindowAssembly"
	       aecobjtype "AEC_WINDOW_ASSEMBLY_STYLES"))
	((= style "curtain")
	 (setq collection "AecCurtainWallLayout"
	       aecobjtype "AEC_CURTAIN_WALL_LAYOUT_STYLES"))
	((= style "space")
	 (setq collection "AecSpace"
	       aecobjtype "AEC_SPACE_STYLES"))
	((= style "stair")
	 (setq collection "AECStAIR"
	       aecobjtype "AEC_STAIR_STYLES"))
	((= style "rail")
	 (setq collection "AECRAILING"
	       aecobjtype "AEC_RAILING_STYLES"))
	((= style "schdtag")
	 (setq collection "AecMvBlockRef"
	       aecobjtype "AEC_MVBLOCK_DEFS"))
	((= style "schd")
	 (setq collection "AecScheduleTable"
	       aecobjtype "AEC_SCHEDULE_TABLE_STYLES"))
	(t
	 (setq collection "standard"
	       aecobjtype "standard")))
  
  (dcl_SetCmdBarFocus)
	   (cond ((= style "wall") (command ".walladd" "_style" sSelText))
		 ((member style (list "HM" "SC" "OT" "AL" "FD1" "FD2" "FD3" "FD4" "FD"))
		  (command ".dooradd" pause "_style" sSelText))
		 ((= style "window") (command ".windowadd" pause "_style" sSelText))
		 ((= style "doorwinass")
		  (command "_.AecDoorWinAssemblyAdd" pause "_style" sSelText))
		 ((= style "curtain") (command ".curtainwalladd" "_style" sSelText))
		 ((= style "space") (command ".AecSpaceAdd" "_style" sSelText))
		 ((= style "stair") (command ".stairadd" "_style" sSelText))
		 ((= style "rail") (command ".railingadd" "_style" sSelText))
		 ((= style "slab") (command ".slabAdd"))
		 ((= style "roof") (command ".roofadd"))
		 ((= style "mass") (command ".masselementadd"))
		 ((= style "schdtag") (kb:AddSchTag sSelText))
		 ((= style "schd") (kb:ADTScheduleAdd sSelText)))
  (princ)(princ))


;;;							;
;;;		Forms					;
;;;							;



;;;							;
;;;		Palette					;
;;;							;
;;;							;
(defun c:ADTPaletteAdd  (/ *Error* style sSelText collection aecobjtype)
  (defun *Error*  (Msg)
    (cond ((or (not Msg)
	       (member Msg '("console break" "Function cancelled" "quit / exit abort"))))
	  ((princ (strcat "\nError: " Msg))))
    (princ)) ;(alert "ADD")
  (setq	style	 (dcl_Tree_GetParent
		   ADT_ADTPalette_StyleTreeControl
		   (dcl_Tree_GetSelectedItem ADT_ADTPalette_StyleTreeControl))
	sSelText (dcl_Tree_GetItemText
		   ADT_ADTPalette_StyleTreeControl
		   (dcl_Tree_GetSelectedItem ADT_ADTPalette_StyleTreeControl)))
  
  (if (and style sSelText)(kb:ADTAdd style sSelText))
  (princ)(princ))



(defun kb:Propogate_00_StyleTreeControl  ( / llist doors hmlist sclist allist sllist fd1list
				   fd2list fd3list fd4list otlist)
  (dcl_Tree_AddParent
    ADT_ADTPalette_StyleTreeControl
    (list (list "Walls" "wall" 0 0 0)
	  (list "Doors" "door" 1 1 1)
	  (list "Storefront" "doorwinass" 2 2 2)
	  (list "Windows" "window" 3 3 3)
	  (list "Curtain Wall" "curtain" 4 4 4)
	  (list "Spaces" "space" 5 5 5)
	  (list "Stairs" "stair" 6 6 6)
	  (list "Railings" "rail" 7 7 7)
	  (list "Roofs" "roof" 8 8 8)
	  (list "Slabs" "slab" 9 9 9)
	  (list "Masses" "mass" 10 10 10)
	  (list "Schedule Tags" "schdtag" 11 11 11)
	  (list "Schedules" "schd" 12 12 12)
	  (list "Tags and Symbols" "tags" 13 13 13)
          (list "Mask Blocks" "mbks" 14 14 14)))
  (dcl_Tree_AddChild
    ADT_ADTPalette_StyleTreeControl
    (list (list "door" "Metal Doors" "HM" 1 1 1)
	  (list "door" "Wood Doors" "SC" 1 1 1)
	  (list "door" "Aluminum & Glass Doors" "AL" 1 1 1)
	  (list "door" "other Doors" "OT" 1 1 1)
	  (list "door" "Fire Doors" "FD" 1 1 1)))
  (dcl_Tree_AddChild
    ADT_ADTPalette_StyleTreeControl
    (list (list "FD" "1 hour doors" "FD1" 1 1 1)
	  (list "FD" "2 hour doors" "FD2" 1 1 1)
	  (list "FD" "3 hour doors" "FD3" 1 1 1)
	  (list "FD" "4 hour doors" "FD4" 1 1 1)))
;;;		Propogate Doors				;
  
	   (setq doorlist (kb:getlocalObjectList "AEC_DOOR_STYLES"))
	   
	 (foreach
		x  doorlist
	   (cond ((= (substr x 1 2) "HM") (setq hmlist (append (list x) hmlist)))
		 ((= (substr x 1 2) "SC") (setq sclist (append (list x) sclist)))
		 ((= (substr x 1 2) "AL") (setq allist (append (list x) allist)))
		 ((= (substr x 1 2) "SL") (setq sllist (append (list x) sllist)))
		 ((= (substr x 1 3) "FD1") (setq fd1list (append (list x) fd1list)))
		 ((= (substr x 1 3) "FD2") (setq fd2list (append (list x) fd2list)))
		 ((= (substr x 1 3) "FD3") (setq fd3list (append (list x) fd3list)))
		 ((= (substr x 1 3) "FD4") (setq fd4list (append (list x) fd4list)))
		 (t (setq otlist (append (list x) otlist)))))
	 (if hmlist
	   (foreach
		  i  hmlist
	     (dcl_Tree_AddChild ADT_ADTPalette_StyleTreeControl "HM" i i 1 1 1)))
	 (if sclist
	   (foreach
		  i  sclist
	     (dcl_Tree_AddChild ADT_ADTPalette_StyleTreeControl "SC" i i 1 1 1)))
	 (if allist
	   (foreach
		  i  allist
	     (dcl_Tree_AddChild ADT_ADTPalette_StyleTreeControl "AL" i i 1 1 1)))
	 (if sllist
	   (foreach
		  i  sllist
	     (dcl_Tree_AddChild ADT_ADTPalette_StyleTreeControl "AL" i i 1 1 1)))
	 (if otlist
	   (foreach
		  i  otlist
	     (dcl_Tree_AddChild ADT_ADTPalette_StyleTreeControl "OT" i i 1 1 1)))
	 (if fd1list
	   (foreach
		  i  fd1list
	     (dcl_Tree_AddChild ADT_ADTPalette_StyleTreeControl "FD1" i i 1 1 1)))
	 (if fd2list
	   (foreach
		  i  fd2list
	     (dcl_Tree_AddChild ADT_ADTPalette_StyleTreeControl "FD2" i i 1 1 1)))
	 (if fd3list
	   (foreach
		  i  fd3list
	     (dcl_Tree_AddChild ADT_ADTPalette_StyleTreeControl "FD3" i i 1 1 1)))
	 (if fd4list
	   (foreach
		  i  fd4list
	     (dcl_Tree_AddChild ADT_ADTPalette_StyleTreeControl "FD4" i i 1 1 1)))
;;;		Propogate DoorWinAssembly		;
  (setq llist (kb:getlocalObjectList "AEC_WINDOW_ASSEMBLY_STYLES"))
  (foreach
	 x  llist
    (dcl_Tree_AddChild ADT_ADTPalette_StyleTreeControl "DoorWinAss" x x 2 2 2))
;;;		Propogate Walls				;
  (setq llist (kb:getlocalObjectList "AEC_WALL_STYLES"))
  (foreach
	 x  llist
    (dcl_Tree_AddChild ADT_ADTPalette_StyleTreeControl "wall" x x 0 0 0))
;;;		Propogate CurtainWalls			;
  (setq llist (kb:getlocalObjectList "AEC_CURTAIN_WALL_LAYOUT_STYLES"))
  (foreach
	 x  llist
    (dcl_Tree_AddChild ADT_ADTPalette_StyleTreeControl "curtain" x x 4 4 4))
;;;		Propogate Windows			;
  (setq llist (kb:getlocalObjectList "AEC_WINDOW_STYLES"))
  (foreach
	 x  llist
    (dcl_Tree_AddChild ADT_ADTPalette_StyleTreeControl "window" x x 3 3 3))
;;;		Propogate Spaces			;
  (setq llist (kb:getlocalObjectList "AEC_SPACE_STYLES"))
  (foreach
	 x  llist
    (dcl_Tree_AddChild ADT_ADTPalette_StyleTreeControl "space" x 5 5 5))
;;;		Propogate Stairs			;
  (setq llist (kb:getlocalObjectList "AEC_STAIR_STYLES"))
  (foreach
	 x  llist
    (dcl_Tree_AddChild ADT_ADTPalette_StyleTreeControl "stair" x x 6 6 6))
;;;		Propogate Railings			;
  (setq llist (kb:getlocalObjectList "AEC_RAILING_STYLES"))
  (foreach
	 x  llist
    (dcl_Tree_AddChild ADT_ADTPalette_StyleTreeControl "rail" x x 7 7 7))
;;;		Propogate Roof			;
  (dcl_Tree_AddChild ADT_ADTPalette_StyleTreeControl "roof" "standard" 8 8 8)
  (setq llist (kb:getlocalObjectList "AEC_ROOF_SLAB_STYLES"))
  (foreach
	 x  llist
    (dcl_Tree_AddChild ADT_ADTPalette_StyleTreeControl "roof" x x 8 8 8))
;;;		Propogate Slab			;
  (dcl_Tree_AddChild ADT_ADTPalette_StyleTreeControl "slab" "standard" 9 9 9)
  (setq llist (kb:getlocalObjectList "AEC_SLABE_STYLES"))
  (foreach
	 x  llist
    (dcl_Tree_AddChild ADT_ADTPalette_StyleTreeControl "slab" x x 9 9 9))
;;;		Propogate Mass			;
  (dcl_Tree_AddChild ADT_ADTPalette_StyleTreeControl "mass" "standard" 10 10 10)
  (setq llist (kb:getlocalObjectList "AEC_MASS_ELEM_STYLES"))
  (foreach
	 x  llist
    (dcl_Tree_AddChild ADT_ADTPalette_StyleTreeControl "mass" x x 10 10 10))

  ;;;		Propogate Mask Blocks			;
  (setq llist (kb:getlocalObjectList "AEC_MASKBLOCK_DEFS"))
  (foreach
	 x  llist
    (dcl_Tree_AddChild ADT_ADTPalette_StyleTreeControl "mbks" x x 14 14 14))

  ;;;		Propogate Schedules			;
  (setq llist (kb:getlocalObjectList "AEC_SCHEDULE_TABLE_STYLES"))
  (foreach
	 x  llist
    (dcl_Tree_AddChild ADT_ADTPalette_StyleTreeControl "schd" x x 12 12 12))
;;;		Propogate Schedule Tags			;
  (setq llist (kb:getlocaltaglist))
  (foreach
	 x  llist
    (dcl_Tree_AddChild ADT_ADTPalette_StyleTreeControl "schdtag" x x 11 11 11))

  ;;;		Propogate Anno Tags			;
  (dcl_Tree_AddChild
    ADT_ADTPalette_StyleTreeControl
    (list (list "tags" "Annotation" "anno" 13 13 13)
	  (list "tags" "Layout Blocks" "lay" 13 13 13)
	  (list "tags" "Appliances" "appl" 13 13 13)
	  (list "tags" "Furniture" "furn" 13 13 13)
	  (list "tags" "Lighting" "lite" 13 13 13)
	  (list "tags" "Power" "powr" 13 13 13)
	  (list "tags" "HVAC" "hvac" 13 13 13)
	  (list "tags" "Plumbing" "plmb" 13 13 13)
	  (list "tags" "Fire" "fire" 13 13 13)
	  (list "tags" "Equipment" "eqmt" 13 13 13)))

  (setq llist (kb:GetLocalSymbolBlocks "TAG_*"))
  (foreach
	 x  llist
    (dcl_Tree_AddChild ADT_ADTPalette_StyleTreeControl "anno" x x 13 13 13))

  (setq llist (kb:GetLocalSymbolBlocks "LAY_*"))
  (foreach
	 x  llist
    (dcl_Tree_AddChild ADT_ADTPalette_StyleTreeControl "lay" x x 13 13 13))

  (setq llist (kb:GetLocalSymbolBlocks "I_APPL*"))
  (foreach
	 x  llist
    (dcl_Tree_AddChild ADT_ADTPalette_StyleTreeControl "appl" x x 13 13 13))

  (setq llist (kb:GetLocalSymbolBlocks "I_APPL*"))
  (foreach
	 x  llist
    (dcl_Tree_AddChild ADT_ADTPalette_StyleTreeControl "appl" x x 13 13 13))

  (setq llist (kb:GetLocalSymbolBlocks "I_FURN*"))
  (foreach
	 x  llist
    (dcl_Tree_AddChild ADT_ADTPalette_StyleTreeControl "furn" x x 13 13 13))

  (setq llist (kb:GetLocalSymbolBlocks "E_LIGHT*"))
  (foreach
	 x  llist
    (dcl_Tree_AddChild ADT_ADTPalette_StyleTreeControl "lite" x x 13 13 13))

  (setq llist (kb:GetLocalSymbolBlocks "E_POWER*"))
  (foreach
	 x  llist
    (dcl_Tree_AddChild ADT_ADTPalette_StyleTreeControl "powr" x x 13 13 13))

  (setq llist (kb:GetLocalSymbolBlocks "M_HVAC*"))
  (foreach
	 x  llist
    (dcl_Tree_AddChild ADT_ADTPalette_StyleTreeControl "hvac" x x 13 13 13))

  (setq llist (kb:GetLocalSymbolBlocks "M_PLUMB*"))
  (foreach
	 x  llist
    (dcl_Tree_AddChild ADT_ADTPalette_StyleTreeControl "plmb" x x 13 13 13))

  (princ)
  (princ))

(defun c:ADT_ADTPalette_MaskAttach_OnClicked (/)
  (command ".aecmaskattach")
  (princ)(princ))


(defun c:ADT_ADTPalette_AddClngGrid_OnClicked	 (/)
  (command ".aecceilinggridadd" "s")
  (princ)(princ))


(defun c:ADT_ADTPalette_AddColumnGrid_OnClicked	(/)
  (command ".aeccolumngridadd")
  (princ)(princ))

(defun c:ADT_ADTPalette_PropertyBrowse_OnClicked ( /)
     (command ".propertydatabrowse")
  (princ)(princ))

(defun c:ADT_ADTPalette_DoorElevButton_OnClicked (/)
  (c:kbdoorelevationtool)
(princ)(princ))


(defun c:ADT_ADTPalette_OnInitialize	(/)
  (dcl_Tree_Clear ADT_ADTPalette_StyleTreeControl)
    (kb:Propogate_00_StyleTreeControl)
  (princ)(princ))


(defun c:ADT_ADTPalette_StyleTreeControl_OnSelChanged (sItemText Key /)
     (princ)
)


(defun c:ADT_ADTPalette_StyleTreeControl_OnItemExpanded (sItemText Key /)
     (princ)
)


(defun c:ADT_ADTPalette_StyleTreeControl_OnClicked  (/ key sItemText parent object)
  (setq	key	  (dcl_Tree_GetSelectedItem ADT_ADTPalette_StyleTreeControl)
	sItemText (dcl_Tree_GetItemText ADT_ADTPalette_StyleTreeControl key)
	parent	  (dcl_tree_getParent ADT_ADTPalette_StyleTreeControl key))
  (if (member parent
	      (list "door" "doorwinass" "SC" "HM" "AL" "OT" "FD1" "FD2" "FD3" "FD4" "schdtag" "anno" "lay" "appl" "furn"
		    "fire" "plmb" "hvac" "powr"	"lite"))
    (progn (if (tblsearch "block" sItemText)
	(dcl_BlockView_DisplayBlock ADT_ADTPalette_StylePreview sItemText 0 0.75)
	)
      )
     (dcl_BlockView_Clear ADT_ADTPalette_StylePreview)
    )
    
  (princ)(princ))

(defun c:ADT_ADTPalette_StyleTreeControl_OnSelChanged (Label Key /)
  (princ)
  (princ)
  
)


(defun c:ADT_ADTPalette_StyleTreeControl_OnDblClicked  (/ key itemName)
  (setq itemName(dcl_Tree_GetSelectedItem ADT_ADTPalette_StyleTreeControl)
	key(dcl_Tree_GetParent ADT_ADTPalette_StyleTreeControl itemName))
  (cond ((= key "mbks")
         (vla-sendcommand
           (vla-get-activedocument (vlax-get-acad-object))
           "kbAddFluorMask "
           )
         )
        ((member key
                 (list "anno" "lay" "appl" "furn" "fire" "plmb" "hvac" "powr" "lite")
                 )
         (vla-sendcommand
           (vla-get-activedocument (vlax-get-acad-object))
           "kbInsertSymbol "
           )
         )
        (t
         (vla-sendcommand
           (vla-get-activedocument (vlax-get-acad-object))
           "ADTPaletteAdd "
           )
         )
        )
  (princ)(princ))

(defun c:ADT_ADTPalette_Refresh_OnClicked (/)
  (c:ADT_ADTPalette_OnInitialize)
)

(defun c:ADT_ADTPalette_StyleManager_OnClicked  (/ sSelText)
  (command "aecstylemanager")
  (princ)(princ))

(defun c:ADT_ADTPalette_OnEnteringNoDocState	(/)
  (vl-registry-write
	"HKEY_CURRENT_USER\\Software\\kbTools2009\\ADT_ADTPalette"

  "isFloating"
	"true"
	)
      (dcl_form_close ADT_ADTPalette)
  (princ)(princ))


(defun c:ADT_ADTPalette_OnClose (UpperLeftX UpperLeftY / )
  (vl-registry-write
	"HKEY_CURRENT_USER\\Software\\kbTools2009\\ADT_ADTPalette"

  "isFloating"
	"false"
	)
  (princ)(princ))

(defun c:ADT_ADTPalette_OnDocActivated  (/ dwg path)	   
  (dcl_Tree_Clear ADT_ADTPalette_StyleTreeControl)
    (kb:Propogate_00_StyleTreeControl)
  (princ)(princ))

(defun c:ADT_ADTPalette_XrefTagButton_OnClicked (/)
  (c:kbXrefScheduleTagAdd)
)


;;;							;
;;;		Command Line 00				;
;;;							;
;;;pgp: kbadt,		*kbadt
(defun c:kbadt	(/ )
  (if (not (member "ADT" (dcl_GetProjects)))
    (dcl_Project_load "ADT"))
  (if dcl_HideErrorMsgBox
    (progn
      (if (not (dcl_Form_IsActive ADT_ADTPalette))
        (progn
	  (dcl_Form_Show ADT_ADTPalette )
          (c:ADT_ADTPalette_OnInitialize)
         )
        )
      )	
    (alert "The OpenDCL arx module did not load!")
    )
  (princ))


;;;		Floating Form				;
;;;		Document Opened				;

(defun kb:ADT_ADTPalette_IsFloating  (/)
  (if dcl_HideErrorMsgBox
    (if (dcl_Form_IsActive ADT_ADTPalette)
	      
	     (c:kbadt)
	   )
  (alert "The OpenDCL arx module did not load!")
    )
  (princ)
  (princ)
  )



;(kb:ADT_ADTPalette_IsFloating)


(princ "\nADT & Production Tools loaded!")
(princ)
;|«Visual LISP© Format Options»
(94 2 4 1 nil "end of " 72 6 0 0 1 nil nil nil T)
;*** DO NOT add text below the comment! ***|;
