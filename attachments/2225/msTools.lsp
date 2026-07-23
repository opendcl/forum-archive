; msTools
; written by Jacob Abel modified by Jarod Tulanowski
; Property of ms consultants, inc.
;
; Revised by drosselli 7/18/2016
;	revised code for DragnDropToAutocad
;	revised mstMainDir path		"\\Support\\msTools" > "\\Support\\msTools\\Acad2014"
;
; Revised by drosselli 8/16/2016
;	revised mstCuiFile 		"\\menu\\mst.mns" > "\\menu\\mst2014.mns"
;	@ 4:45 I undid the above change. the code is trying to regenerate the CUI Group "MST" and the above line was creating issues.
;		This needs addressed throughout the code. References to different .cuix files. files get overwritten.
;
; Revised by drosselli 8/23/2016
;	revised all code back to "mstools" from "mstools2014"
;	existing msTools2014 renamed to "msTools_Legacy"



(setvar "CMDECHO" 0)
(setvar "LWUNITS" 1)

(vl-load-com)

;;; Begin msTools settings

(setq mstAcadVersion (substr (vlax-product-key) (+ (vl-string-search "R" (vlax-product-key)) 2) 2)
      mstObjectDBXDoc (strcat "ObjectDBX.AxDbDocument." mstAcadVersion)
      mstUserLocation (substr (getenv "ComputerName") 1 2)
)

(if (vl-string-search "64" (getenv "PROCESSOR_ARCHITECTURE"))
  (setq mstOpenDCLFilename (strcat "OPENDCL.X64." mstAcadVersion ".ARX"))
  (setq mstOpenDCLFilename (strcat "OPENDCL." mstAcadVersion ".ARX"))
)

(setq mstStandardsDir "S:\\std\\acad\\ComDev"
      mstMainDir (strcat mstStandardsDir "\\Support\\msTools")
      mstOpenDCLFile (strcat mstMainDir "\\OpenDCL\\" mstOpenDCLFilename)
      mstDialogFile (strcat mstMainDir "\\msTools.odcl")
      mstCuiFile (strcat mstMainDir "\\menu\\mst.mns")
      mstBlocksDir (strcat mstMainDir "\\blocks")

      mstLayZerFile (strcat mstStandardsDir "\\Layer Standards\\Master layer list.txt")
      mstLinetypes (list (strcat mstStandardsDir "\\Layer Standards\\USACE Layer Files\\Tsaec32_Standard.lin")
                         "\\\\columbus-fs1\\S\\std\\acad\\ms consultants\\Support\\acad08.lin"
                         (strcat mstStandardsDir "\\Layer Standards\\CoC_CAD_Std_Linetypes.lin")
                         "\\\\columbus-sv2\\N\\62\\_Comm sect\\CAD Stnds\\Civil Library\\linetypes\\Custom Linetypes.lin")	;path needs updated/removed
      mstLinetypesCount (length mstLinetypes)
      mstLinetypeLog (strcat mstMainDir "\\LayZer_err.log")

      mstRevTriOldThk 0.0
      mstRevTriOldColor 1
      mstRevTriNewThk 0.025
      mstRevTriNewColor 252
      mstRevTriName "AdrRevTri"
      mstRevTriColor 4

      mstDetLibDir (strcat mstStandardsDir "\\Detail Library")
      mstDetLibCache (strcat mstDetLibDir "\\cache.dat")
      mstDetLibIndexFile nil ; (strcat mstDetLibDir "\\Master list.txt")
      mstDetLibPass "stupidfools"												;detail library password

      mstDsizeDst (strcat mstStandardsDir "\\Template\\SheetSets\\ms Arch D\\ms Arch D.dst")
      mstDsizeBord (strcat mstStandardsDir "\\DwgSetup\\ms Arch D.dwg")
      mstDsizeDwt (strcat mstStandardsDir "\\Template\\Arch D Plan.dwt")
      mstEsizeDst (strcat mstStandardsDir "\\Template\\SheetSets\\ms Arch E\\ms Arch E.dst")
      mstEsizeBord (strcat mstStandardsDir "\\DwgSetup\\ms Arch E.dwg")
      mstEsizeDwt (strcat mstStandardsDir "\\Template\\Arch E Plan.dwt")
)

;;; End msTools settings



;;; Begin LayZer

(defun msTools_loadLinetype (ltype / ct)
  (setq ct 0)
  (while (and
           (not (tblsearch "LTYPE" ltype))
           (< ct mstLinetypesCount)
         )
    (command "_.-linetype" "_l" ltype (nth ct mstLinetypes))
    (command)
    (command)
    (setq ct (1+ ct))
  )
  (tblsearch "LTYPE" ltype)
)

(defun msTools_LayZer_addLayers (thelist / lyrs lyrn lyrlt errmsg logf layersobj)
  (if (setq lyrs (vl-remove-if-not (function (lambda(x) (vl-position (car x) thelist))) LayZerLayerData))
    (progn
      (foreach lyr lyrs
        (setq lyrn (car lyr)
              lyrlt (caddr lyr)
        )
        (if (not (msTools_loadLinetype lyrlt))
          (progn
            (alert (strcat (setq errmsg (strcat "Could not find linetype \"" lyrlt "\" for layer \"" lyrn "\".")) " Will use \"Continuous\" linetype."))
            (setq lyrlt "Continuous")
            (if (setq logf (open mstLinetypeLog "a"))
              (progn
                (princ (strcat (getvar "LOGINNAME") " - " errmsg "\n") logf)
                (close logf)
              )
            )
          )
        )
        (if (tblsearch "LAYER" lyrn)
          (progn
            (command "_.-layer" "_c" (cadr lyr) lyrn "_l" lyrlt lyrn "_lw" (cadddr lyr) lyrn "_p" (nth 4 lyr) lyrn)
            (command)
          )
          (progn
            (command "_.-layer" "_n" lyrn "_c" (cadr lyr) lyrn "_l" lyrlt lyrn "_lw" (cadddr lyr) lyrn "_p" (nth 4 lyr) lyrn)
            (command)
          )
        )
      )
      (setq layersobj (vlax-get-property (vlax-get-property (vlax-get-acad-object) 'ActiveDocument) 'Layers))
      (foreach lyr lyrs
        (vlax-put-property (vla-item layersobj (car lyr)) 'Description (nth 5 lyr))
      )
      (vlax-release-object layersobj)
    )
  )
)

(defun c:msTools_msTools_LayZerButton_OnClicked (/)
  (c:lz)
  (princ)
)

(defun c:msTools_LayZer_Prelist_OnSelChanged (ItemIndex Value / prelen)
  (setq prelen (strlen Value))
  (dcl_ListBox_Clear msTools_LayZer_Midlist)
  (dcl_ListBox_AddList msTools_LayZer_Midlist (vl-remove-if-not (function (lambda(x) (= Value (substr x 1 prelen)))) LayZerLayerMidList))
  (dcl_ListBox_Clear msTools_LayZer_Layerlist)
  (dcl_ListBox_AddList msTools_LayZer_Layerlist (vl-remove-if-not (function (lambda(x) (= Value (substr x 1 prelen)))) (mapcar 'car LayZerLayerData)))
  (princ)
)

(defun c:msTools_LayZer_Midlist_OnSelChanged (ItemIndex Value / midlen)
  (setq midlen (strlen Value))
  (dcl_ListBox_Clear msTools_LayZer_Layerlist)
  (dcl_ListBox_AddList msTools_LayZer_Layerlist (vl-remove-if-not (function (lambda(x) (= Value (substr x 1 midlen)))) (mapcar 'car LayZerLayerData)))
  (princ)
)

(defun c:msTools_LayZer_Layerlist_OnSelChanged (ItemIndex Value / sellayers descstr)
  (if (and
        ItemIndex
        (setq sellayers (dcl_ListBox_GetSelectedItems msTools_LayZer_Layerlist))
      )
    (progn
      (setq descstr "")
      (foreach sellayer sellayers
        (setq descstr (strcat descstr "Layer: " sellayer "\r\n=========================\r\nDescription: " (last (car (vl-remove-if-not (function (lambda(x) (= (car x) sellayer))) LayZerLayerData))) "\r\n\r\n"))
      )
      (dcl_Control_SetText msTools_LayZer_DescBox descstr)
    )
    (dcl_Control_SetText msTools_LayZer_DescBox "Instructions: Click the single prefix letter in the Pre column farthest to the left.  All the six letter prefixes associated with that letter will appear in the 6-Pre column to the right.  Click the six letter prefix in that column and all the layers with that prefix will appear in the Layer column to the right.  Select layers from that column to see their descriptions; click the Add Layers button to add the selected layers to the drawing.  Click the Add All button to add all layers shown in the Layer column.  Click the Done/Close button to close this dialog box.")
  )
  (princ)
)

(defun c:msTools_LayZer_AddButton_OnClicked (/)
  (msTools_LayZer_addLayers (dcl_ListBox_GetSelectedItems msTools_LayZer_Layerlist))
  (princ)
)

(defun c:msTools_LayZer_AddAllButton_OnClicked (/)
  (dcl_ListBox_SelItemRange msTools_LayZer_Layerlist 0 (dcl_ListBox_GetCount msTools_LayZer_Layerlist) T)
  (msTools_LayZer_addLayers (dcl_ListBox_GetSelectedItems msTools_LayZer_Layerlist))
  (princ)
)

(defun c:msTools_LayZer_SearchBox_OnReturnPressed (/ query results)
  (if (and
        (/= "" (setq query (strcase (dcl_Control_GetText msTools_LayZer_SearchBox))))
        (setq results (mapcar 'car (vl-remove-if-not (function (lambda(x) (or (vl-string-search query (strcase (car x))) (vl-string-search query (strcase (last x)))))) LayZerLayerData)))
      )
    (progn
      (dcl_ListBox_Clear msTools_LayZer_Midlist)
      (dcl_ListBox_Clear msTools_LayZer_Layerlist)
      (dcl_ListBox_AddList msTools_LayZer_Layerlist results)
    )
    (alert "LayZer: Your search produced no results or you have entered a blank query.")
  )
  (dcl_TextBox_SetSel msTools_LayZer_SearchBox 0 -1)
  (princ)
)

(defun c:msTools_LayZer_SearchButton_OnClicked (/)
  (c:msTools_LayZer_SearchBox_OnReturnPressed)
  (princ)
)

(defun c:msTools_LayZer_CloseButton_OnClicked (/)
  (dcl_Form_Close msTools_LayZer)
  (princ)
)

(defun c:msTools_LayZer_OnEnteringNoDocState (/)
  (dcl_form_Close msTools_LayZer)
  (princ)
)

(defun c:lz (/ t1 ct file line pos layernamelist pre mid)
  (if (not LayZerLayerData)
    (progn
      (setq t1 (getvar "MILLISECS")
            ct 0
      )
      (if (not (setq file (open mstLayZerFile "r")))
        (progn
          (alert "LayZer: Failed to load resource file. Exiting.")
          (exit)
        )
      )

      (defun formatPres (prefix /)
        (cond
          ((= "-" (substr prefix 2 1))
            (substr prefix 1 1)
          )
          ((= "-" (substr prefix 3 1))
            (substr prefix 1 2)
          )
          (T
            prefix
          )
        )
      )

      (defun formatMids (midfix /)
        (cond
          ((= "-" (substr midfix 2 1))
            (substr midfix 1 6)
          )
          ((or
             (= "-" (substr midfix 3 1))
             (= "_" (substr midfix 8 1))
           )
            (substr midfix 1 7)
          )
          (T
            midfix
          )
        )
      )

      (setq LayZerLayerData (list)
            LayZerLayerPreList (list)
            LayZerLayerMidlist (list)
      )
      (read-line file) ; skip header
      (while (and
               (setq line (read-line file))
               (/= "" (setq line (vl-string-right-trim "\t" line)))
             )
        (setq LayZerLayerData (cons (cdr (str2lst line "\t")) LayZerLayerData) ; cdr to skip first column
              ct (1+ ct)
        )
        (prompt (strcat "\r" (itoa ct) " lines parsed."))
      )
      (setq LayZerLayerData (reverse LayZerLayerData))

      (prompt (strcat "\nLayZer: Finished parsing in " (rtos (* 0.001 (float (- (getvar "MILLISECS") t1))) 2 1) " seconds.\n"))

      (setq layernamelist (mapcar 'car LayZerLayerData))
      (foreach layer layernamelist
        (if (not (vl-position (setq pre (formatPres (substr layer 1 3))) LayZerLayerPreList))
          (setq LayZerLayerPreList (cons pre LayZerLayerPreList))
        )
        (if (not (vl-position (setq mid (formatMids (substr layer 1 8))) LayZerLayerMidList))
          (setq LayZerLayerMidList (cons mid LayZerLayerMidList))
        )
      )
      (setq LayZerLayerPreList (acad_strlsort LayZerLayerPreList)
            LayZerLayerMidList (acad_strlsort LayZerLayerMidList)
      )

      (vl-propagate 'LayZerLayerPreList)
      (vl-propagate 'LayZerLayerMidList)
      (vl-propagate 'LayZerLayerData)
    )
  )

  (dcl-Form-Show msTools_LayZer)

  (dcl_ListBox_Clear msTools_LayZer_Prelist)
  (dcl_ListBox_Clear msTools_LayZer_Midlist)
  (dcl_ListBox_Clear msTools_LayZer_Layerlist)
  (dcl_Control_SetText msTools_LayZer_DescBox "Instructions: Click the single prefix letter in the Major column farthest to the left.  All the six letter prefixes associated with that letter will appear in the Minor column to the right.  Click the six letter prefix in that column and all the layers with that prefix will appear in the Layer column to the right.  Select layers from that column to see their descriptions; click the Add Layers button to add the selected layers to the drawing.  Click the Add All button to add all layers shown in the Layer column.  Click the Done/Close button to close this dialog box.")

  (dcl_ListBox_AddList msTools_LayZer_Prelist LayZerLayerPreList)
  (princ)
)

;;; End LayZer



;;; Begin AddDelta

(defun msTools_AddDelta_Pre (/)
  (if (zerop (getvar "TILEMODE"))
    (progn
      (setvar "CMDECHO" 1)
      (command "_.revcloud" "_a" 0.25 0.25 "_s" "Normal")
      (while (< 0 (getvar "CMDACTIVE"))
        (command pause)
      )
      (setvar "CMDECHO" 0)
    )
    (progn
      (alert "AddDelta: Revclouds and revision triangles go in paperspace.")
      (exit)
    )
  )
)

(defun c:msTools_msTools_Adr1_OnClicked (/)
  (msTools_AddDelta_Pre)
  (msTools_AddDelta 1)
  (princ)
)

(defun c:msTools_msTools_Adr2_OnClicked (/)
  (msTools_AddDelta_Pre)
  (msTools_AddDelta 2)
  (princ)
)

(defun c:msTools_msTools_Adr3_OnClicked (/)
  (msTools_AddDelta_Pre)
  (msTools_AddDelta 3)
  (princ)
)

(defun c:msTools_msTools_Adr4_OnClicked (/)
  (msTools_AddDelta_Pre)
  (msTools_AddDelta 4)
  (princ)
)

(defun c:msTools_msTools_Adr5_OnClicked (/)
  (msTools_AddDelta_Pre)
  (msTools_AddDelta 5)
  (princ)
)

(defun c:msTools_msTools_Adr6_OnClicked (/)
  (msTools_AddDelta_Pre)
  (msTools_AddDelta 6)
  (princ)
)

(defun c:msTools_msTools_Adr7_OnClicked (/)
  (msTools_AddDelta_Pre)
  (initget 5)
  (msTools_AddDelta (getint "\nAddDelta\nRevision number: "))
  (princ)
)

(defun c:adr (/) (c:msTools_msTools_Adr7_OnClicked))
(defun c:adr1 (/) (c:msTools_msTools_Adr1_OnClicked))
(defun c:adr2 (/) (c:msTools_msTools_Adr2_OnClicked))
(defun c:adr3 (/) (c:msTools_msTools_Adr3_OnClicked))
(defun c:adr4 (/) (c:msTools_msTools_Adr4_OnClicked))
(defun c:adr5 (/) (c:msTools_msTools_Adr5_OnClicked))
(defun c:adr6 (/) (c:msTools_msTools_Adr6_OnClicked))

(defun msTools_AddDelta (rev / pt1 revc revs revlay revlayl laylist lay new thk ss ct enlist2 enlist1 enp layn clayer attreq enlist newcolor color)
  (initget 7)
  (setq pt1 (getpoint "\nSelect insertion point for the revision triangle: "))
  (command "_.undo" "_be")
  (setq revc (entget (entlast))
        revs (itoa rev)
        revlay (strcat "REV" revs)
        revlayl (cons 8 revlay)
        laylist (list)
        lay (tblnext "LAYER" T)
        new nil
        thk mstRevTriOldThk
  )
  (while lay
    (if (= "REV" (strcase (substr (setq layn (cdr (assoc 2 lay))) 1 3)))
      (setq laylist (cons layn laylist))
    )
    (setq lay (tblnext "LAYER"))
  )
  (if (= rev (apply 'max (cons rev (mapcar (function (lambda(x) (atoi (substr x 4)))) laylist))))
    (progn
      (setq new T
            thk mstRevTriNewThk
      )
      (if (setq ss (ssget "_X" '((0 . "POLYLINE,LWPOLYLINE") (8 . "REV*"))))
        (progn
          (setq ct 0
                enlist2 (list)
          )
          (repeat (sslength ss)
            (setq enlist1 (entget (ssname ss ct)))
            (foreach enprop enlist1
              (if (or
                    (= 40 (setq enp (car enprop)))
                    (= 41 enp)
                    (= 43 enp)
                  )
                (setq enlist2 (append enlist2 (list (cons enp mstRevTriOldThk))))
                (setq enlist2 (append enlist2 (list enprop)))
              )
            )
            (entmod enlist2)
            (setq enlist2 (list)
                  ct (1+ ct)
            )
          )
        )
      )
      (if (setq ss (ssget "_X" (list '(0 . "INSERT") '(8 . "REV*") (cons 2 mstRevTriName))))
        (progn
          (setq ct 0)
          (repeat (sslength ss)
            (setq enlist1 (entget (ssname ss ct))
                  ct (1+ ct)
            )
            (if (and
                  (not (vl-position revlayl enlist1))
                  (setq enp (assoc 62 enlist1))
                )
              (progn
                (setq enlist1 (subst '(62 . 256) enp enlist1))
                (entmod enlist1)
              )
            )
          )
        )
      )
      (if laylist
        (foreach layer laylist
          (command "_.-layer" "_c" mstRevTriOldColor layer)
          (command)
        )
      )
    )
  )
  (if (not (tblsearch "LAYER" revlay))
    (progn
      (command "_.-layer" "_n" revlay)
      (command)
    )
  )
  (if new
    (progn
      (command "_.-layer" "_c" mstRevTriNewColor revlay)
      (command)
    )
    (progn
      (command "_.-layer" "_c" mstRevTriOldColor revlay)
      (command)
    )
  )
  (setq revc (subst revlayl (assoc 8 revc) revc))
  (entmod revc)
  (if (setq ss (ssget "_X" (list '(0 . "POLYLINE,LWPOLYLINE") revlayl)))
    (progn
      (setq ct 0
            enlist2 (list)
      )
      (repeat (sslength ss)
        (setq enlist1 (entget (ssname ss ct)))
        (foreach enprop enlist1
          (if (or
                (= 40 (setq enp (car enprop)))
                (= 41 enp)
                (= 43 enp)
              )
            (setq enlist2 (append enlist2 (list (cons enp thk))))
            (setq enlist2 (append enlist2 (list enprop)))
          )
        )
        (entmod enlist2)
        (setq enlist2 (list)
              ct (1+ ct)
        )
      )
    )
  )
  (setq clayer (getvar "CLAYER")
        attreq (getvar "ATTREQ")
  )
  (setvar "CLAYER" revlay)
  (setvar "ATTREQ" 0)
  (command "_.-insert" (strcat mstBlocksDir "\\" mstRevTriName ".dwg") pt1 1.0 1.0 0.0)
  (setvar "CLAYER" clayer)
  (setvar "ATTREQ" attreq)
  (if new
    (progn
      (setq enlist (entget (entlast))
            enlist (vl-remove-if (function (lambda(x) (= (car x) 6))) enlist)
            newcolor (cons 62 mstRevTriColor)
      )
      (if (setq color (assoc 62 enlist))
        (setq enlist (subst newcolor color enlist))
        (setq enlist (append enlist (list newcolor)))
      )
      (entmod enlist)
    )
  )
  (setAttValue (entlast) "REVNO" revs)
  (command "_.undo" "_e")
  (command "_.eattedit" (entlast))
  (princ)
)

(defun c:msTools_msTools_RevDataButton_OnClicked (/)
  (c:msTools_DumpRevData)
  (princ)
)

(defun c:msTools_DumpRevData (/ ss ct revdata attdata f)
  (if (setq ss (ssget "_X" (list '(0 . "INSERT") (cons 2 mstRevTriName) (cons 410 (getvar "CTAB")))))
    (progn
      (setq ct 0
            revdata (list)
      )
      (repeat (sslength ss)
        (setq attdata (getAttData (ssname ss ct))
              revdata (append revdata (list (cons (atoi (cdr (assoc "REVNO" attdata))) (cdr (assoc "DESC" attdata)))))
              ct (1+ ct)
        )
      )
      (setq revdata (vl-sort revdata (function (lambda (a1 a2) (< (car a1) (car a2)))))
            f (open "DumpRevDataTemp.txt" "w")
      )
      (princ (strcat "Revision History for " (getvar "DWGPREFIX") (getvar "DWGNAME") ":\n\n") f)
      (foreach rev revdata
        (princ (strcat "Revision " (itoa (car rev)) ":\n" (cdr rev) "\n\n") f)
      )
      (close f)
      (startapp "notepad" "DumpRevDataTemp.txt")
      (command "_.delay" 500)
      (vl-file-delete "DumpRevDataTemp.txt")
    )
    (alert "msTools: No revision data to report!")
  )
  (princ)
)

;;; End AddDelta



;;; Begin BPS

(defun c:msTools_msTools_BPSButton_OnClicked (/)
  (c:bps)
  (princ)
)

(defun c:bps (/ newfile dwgp dwgn t1 bt lay lfs layn layoutdata layoutgrp pt1 pt2 ss1 ss2 ct t2)
  (defun layoutget (name /)
    (dictsearch (cdr (assoc -1 (dictsearch (namedobjdict) "ACAD_LAYOUT"))) name)
  )

  (alert "Bind+Purge+Save binds all Xrefs, purges the drawing, deletes all layers that are off or frozen, and finally audits the drawing.")
  (if (and
        (setq newfile (getfiled "Bind+Purge+Save: Save BPSed Drawing As" (strcat (setq dwgp (getvar "DWGPREFIX")) (substr (setq dwgn (getvar "DWGNAME")) 1 (- (strlen (getvar "DWGNAME")) 4)) "_fg.dwg") "dwg" 129))
        (/= newfile (strcat dwgp dwgn))
      )
    (progn
      (vl-file-delete newfile)
      (command "_.saveas" "2000" newfile)

      (setq t1 (getvar "MILLISECS")
            bt (getvar "BINDTYPE")
      )
      (setvar "BINDTYPE" 0)
      (command "_.-xref" "_b" "*")
      (setvar "BINDTYPE" bt)

      (if (ssget "_X" '((0 . "IMAGE")))
        (command "_.-image" "_d" "*")
      )

      (command "_.-purge" "_a" "*" "_n")

      (setq lay (tblnext "LAYER" T))
      (while lay
        (if (or
              (= 1 (logand 1 (setq lfs (cdr (assoc 70 lay)))))
              (minusp (cdr (assoc 62 lay)))
            )
          (progn
            (setq layn (cdr (assoc 2 lay)))
            (if (= 4 (logand 4 lfs))
              (progn
                (command "_.-layer" "_u" layn)
                (command)
              )
            )
            (command "_.-laydel" "_n" layn "" "_y")
            (command)
          )
        )
        (setq lay (tblnext "LAYER"))
      )

      (foreach layout (layoutlist)
        (setvar "CTAB" layout)
        (setq layoutdata (layoutget layout)
              layoutgrp (list (cons 410 layout))
              pt1 (cdr (assoc 10 layoutdata))
              pt2 (cdr (assoc 11 layoutdata))
              ss1 (ssget "_X" layoutgrp)
              ss2 (ssget "_CP" (list pt1 (list (car pt1) (cadr pt2) 0.0) pt2 (list (car pt2) (cadr pt1) 0.0)) layoutgrp)
              ct 0
        )
        (repeat (sslength ss2)
          (ssdel (ssname ss2 ct) ss1)
          (setq ct (1+ ct))
        )
        (if ss1
          (command "_.erase" ss1 "")
        )
      )

      (command "_.-purge" "_a" "*" "_n" "_.audit" "_y")

      (command "_.qsave")

      (setq t2 (* 0.001 (float (- (getvar "MILLISECS") t1))))
      (alert (strcat "Bind+Purge+Save: Drawing processed and saved in " (itoa (fix (* 0.016666666666667 t2))) ":" (itoa (fix (rem t2 60.0))) "."))
    )
    (prompt "\nBind+Purge+Save: No file selected or overwrite of current drawing attempted.")
  )
  (princ)
)

;;; End BPS



;;; Begin Detail Library Browser

(defun dlbClear (/)
  (dcl_ListBox_Clear msTools_DetLib_DwgList)
  (dcl_Control_SetText msTools_DetLib_TagList "")
  (dcl_Control_SetText msTools_DetLib_SearchBox "")
  (dcl_DWGPreview_Clear msTools_DetLib_DwgPrev)
  (dcl_Control_SetCaption msTools_DetLib_TitleLabel "")
  (dcl_Control_SetCaption msTools_DetLib_SubjectLabel "")
  (dcl_ListBox_SetCurSel msTools_DetLib_DwgList 0)
  (princ)
)

(defun dlbUpdateCache (/ dwglist index line len ct dbxdoc dwginfo cache)
  (setq dwglist (list)
        dlbDetData (list)
  )
  (if mstDetLibIndexFile
    (progn
      (if (not (setq index (open mstDetLibIndexFile "r")))
        (progn
          (alert "Detail Library: Failed to load index file. Exiting.")
          (exit)
        )
      )
      (dcl-Form-Show msTools_ProgressWindow)
      (dcl_Control_SetValue msTools_ProgressWindow_ProgressBar 0)
      (dcl_Control_SetCaption msTools_ProgressWindow_InfoLabel "Parsing index file...")
      (while (and
               (setq line (read-line index))
               (/= "" line)
             )
        (setq dwglist (cons line dwglist))
      )
      (close index)
    )
    (progn
      (dcl-Form-Show msTools_ProgressWindow)
      (dcl_Control_SetValue msTools_ProgressWindow_ProgressBar 0)
      (dcl_Control_SetCaption msTools_ProgressWindow_InfoLabel "Building file list...")
      (setq dwglist (reverse (listAllFiles mstDetLibDir "*.dwg")))
    )
  )

  (dcl_Control_SetValue msTools_ProgressWindow_ProgressBar 10)
  (dcl_Control_SetCaption msTools_ProgressWindow_InfoLabel "")
  (dcl_Control_Redraw msTools_ProgressWindow_InfoLabel)
  (dcl_Control_SetCaption msTools_ProgressWindow_InfoLabel "Extracting data from drawings...")
  (setq len (float (length dwglist))
        ct 0
        dbxdoc (vla-getinterfaceobject (vlax-get-acad-object) mstObjectDBXDoc)
  )
  (foreach dwg dwglist
    (vlax-invoke-method dbxdoc 'Open dwg :vlax-true) ; open drawings as read-only
    (setq dwginfo (vlax-get-property dbxdoc 'SummaryInfo)
          dlbDetData (cons (list dwg (vl-filename-base dwg) (vlax-get-property dwginfo 'Title) (vlax-get-property dwginfo 'Subject) (vlax-get-property dwginfo 'Keywords)) dlbDetData)
          ct (1+ ct)
    )
    (if (zerop (rem ct 10))
      (dcl_Control_SetValue msTools_ProgressWindow_ProgressBar (+ 10 (fix (* 89.0 (/ (float ct) len)))))
    )
  )
  (vlax-release-object dbxdoc)

  (if (setq cache (open mstDetLibCache "w"))
    (progn
      (foreach item dlbDetData
        (princ (lst2str item "\t") cache)
        (princ "\n" cache)
      )
      (princ "\n\n" cache)
      (close cache)
    )
  )

  (dcl_Form_Close msTools_ProgressWindow)

  (setq dlbDetDataCASE (mapcar (function (lambda(x) (list (car x) (cadr x) (strcase (caddr x)) (strcase (cadddr x)) (strcase (nth 4 x))))) dlbDetData))
  (princ)
)

(defun c:msTools_msTools_DetLibButton_OnClicked (/)
  (c:dlb)
  (princ)
)

(defun c:msTools_DetLib_CloseButton_OnClicked (/)
  (dcl_Form_Close msTools_DetLib)
  (princ)
)

(defun c:msTools_DetLib_OnClose (UpperLeftX UpperLeftY /)
  (gc)
  (princ)
)

(defun c:msTools_DetLib_OnEnteringNoDocState (/)
  (dcl_form_Close msTools_DetLib)
  (princ)
)

(defun c:msTools_DetLib_DwgList_OnSelChanged (ItemIndexOrCount Value / data)
  (if (/= "" Value)
    (progn
      (setq data (car (vl-remove-if-not (function (lambda(x) (= Value (cadr x)))) dlbDetData)))
      (dcl_DWGPreview_LoadDwg msTools_DetLib_DwgPrev (car data))
      (dcl_Control_SetCaption msTools_DetLib_SubjectLabel (strcat "Subject: " (cadddr data)))
      (dcl_Control_SetCaption msTools_DetLib_TitleLabel (strcat "Title: " (caddr data)))
      (dcl_Control_SetText msTools_DetLib_TagList (strcase (nth 4 data) T))
    )
  )
  (princ)
)

(defun c:msTools_DetLib_SearchBox_OnReturnPressed (/ query results qry ct)
  (if (/= "" (setq query (dcl_Control_GetText msTools_DetLib_SearchBox)))
    (if (= mstDetLibPass query)
      (progn
        (dcl_Control_SetVisible msTools_DetLib_UpdateButton T)
        (dcl_Control_SetVisible msTools_DetLib_EditButton T)
        (setq mstDetLibTagsEditable T)
        (vl-propagate 'mstDetLibTagsEditable)
        (alert "Detail Library: Manager mode enabled.")
      )
      (progn
        (setq query (vl-remove "" (str2lst (strcase (vl-string-trim " " query)) " "))
              qry (car query)
              results (vl-remove-if-not (function (lambda(x) (or (vl-string-search qry (caddr x)) (vl-string-search qry (cadddr x)) (vl-string-search qry (nth 4 x))))) dlbDetDataCASE)
              ct 0
        )
        (repeat (1- (length query))
          (setq qry (nth (setq ct (1+ ct)) query)
                results (vl-remove-if-not (function (lambda(x) (or (vl-string-search qry (caddr x)) (vl-string-search qry (cadddr x)) (vl-string-search qry (nth 4 x))))) results)
          )
        )
        (if results
          (progn
            (dcl_ListBox_Clear msTools_DetLib_DwgList)
            (dcl_ListBox_AddList msTools_DetLib_DwgList (mapcar 'cadr results))
          )
          (alert "Detail Library: Your search produced no results.")
        )
      )
    )
    (dcl_ListBox_AddList msTools_DetLib_DwgList (mapcar 'cadr dlbDetData))
  )
  (dcl_TextBox_SetSel msTools_DetLib_SearchBox 0 -1)
  (princ)
)

(defun c:msTools_DetLib_SearchButton_OnClicked (/)
  (c:msTools_DetLib_SearchBox_OnReturnPressed)
  (princ)
)

(defun c:msTools/DetLib/DwgList#OnDragnDropToAutoCAD (DropPoint Viewport /)
  (c:msTools_DetLib_DwgPrev_OnDragnDropToAutoCAD DropPoint Viewport)
  (princ)
)

(defun c:msTools/DetLib/DwgPrev#OnDragnDropToAutoCAD (DropPoint Viewport / dwg qaf)
  (if (setq dwg (dcl_ListBox_GetSelectedItems msTools_DetLib_DwgList))
    (progn
      (command "_.-insert" (car (car (vl-remove-if-not (function (lambda(x) (= (cadr x) dwg))) dlbDetData))) DropPoint 1.0 1.0 0.0)
      (command "_.explode" (entlast))
    )
  )
  (princ)
)

(defun c:msTools_DetLib_UpdateButton_OnClicked (/)
  (dlbUpdateCache)
  (dlbClear)
  (dcl_ListBox_AddList msTools_DetLib_DwgList (mapcar 'cadr dlbDetData))
  (princ)
)

(defun c:msTools_DetLib_EditButton_OnClicked (/ dwg)
  (if (setq dwg (dcl_ListBox_GetSelectedItems msTools_DetLib_DwgList))
    (vla-activate (vla-open (vla-get-documents (vlax-get-acad-object)) (car (car (vl-remove-if-not (function (lambda(x) (= (cadr x) dwg))) dlbDetData)))))
  )
  (princ)
)

(defun c:msTools_DetLib_TagList_OnReturnPressed (/ dwgname dwg dwgt dbxdoc)
  (if (and
        mstDetLibTagsEditable
        (/= "" (setq tags (dcl_Control_GetText msTools_DetLib_TagList)))
      )
    (progn
      (setq dwgname (dcl_ListBox_GetSelectedItems msTools_DetLib_DwgList)
            dwg (car (car (vl-remove-if-not (function (lambda(x) (= (cadr x) dwgname))) dlbDetData)))
            dwgt (strcat dwg "t")
            dbxdoc (vla-getinterfaceobject (vlax-get-acad-object) mstObjectDBXDoc)
      )
      (vlax-invoke-method dbxdoc 'Open dwg :vlax-false) ; open for read-write
      (vlax-put-property (vlax-get-property dbxdoc 'SummaryInfo) 'Keywords tags)
      (vlax-invoke-method dbxdoc 'SaveAs dwgt)
      (vlax-release-object dbxdoc)
      (vl-file-delete dwg)
      (vl-file-rename dwgt dwg)
    )
    (alert "Detail Library: Editing file tags has been disabled.")
  )
  (princ)
)

(defun c:dlb (/ dat deleted line)
  (if (not dlbDetData)
    (progn
      (if (not (setq dat (open mstDetLibCache "r")))
        (progn
          (alert "Detail Library: Failed to load cache file. Exiting.")
          (exit)
        )
      )

      (setq dlbDetData (list))
      (while (and
               (setq line (read-line dat))
               (/= "" line)
             )
        (setq dlbDetData (cons (str2lst line "\t") dlbDetData))
      )
      (setq dlbDetData (reverse dlbDetData)
            dlbDetDataCASE (mapcar (function (lambda(x) (list (car x) (cadr x) (strcase (caddr x)) (strcase (cadddr x)) (strcase (nth 4 x))))) dlbDetData)
      )
      (close dat)

      (vl-propagate 'dlbDetData)
      (vl-propagate 'dlbDetDataCASE)
    )
  )

  (dcl-Form-Show msTools_DetLib)
  (dlbClear)
  (dcl_ListBox_AddList msTools_DetLib_DwgList (mapcar 'cadr dlbDetData))

  (princ)
)

;;; End Detail Library Browser



;;; Begin make demo/existing

(defun makeDemo (ss / ct enlist layer layername layer3pre 1stlet 2ndlet 3rdlet newlayer lt layinfo color)
  (if ss
    (progn
      (command "_.undo" "_be")
      (if (not (tblsearch "LTYPE" "HIDDEN"))
        (progn
          (command "_.-linetype" "_l" "HIDDEN" "acad.lin")
          (command)
        )
      )

      (setq ct 0)
      (repeat (sslength ss)
        (setq enlist (entget (ssname ss ct)))
        (if (= "HATCH" (cdr (assoc 0 enlist)))
          (entdel (ssname ss ct))
          (progn
            (setq layer (assoc 8 enlist)
                  layername (strcase (cdr layer))
                  layer3pre (substr layername 1 3)
                  1stlet (substr layer3pre 1 1)
                  2ndlet (substr layer3pre 2 1)
                  3rdlet (substr layer3pre 3 1)
            )
            (if (and
                  (not (= "D" 2ndlet))
                  (or
                    (= "-" 2ndlet)
                    (= "-" 3rdlet)
                  )
                )
              (progn
                (if (= "XX-" layer3pre)
                  (setq newlayer (strcat "CD-" (substr layername 4)))
                  (if (= "-" 2ndlet)
                    (setq newlayer (strcat 1stlet "D-" (substr layername 3)))
                    (setq newlayer (strcat 1stlet "D-" (substr layername 4)))
                  )
                )
                (if (not (tblsearch "LAYER" newlayer))
                  (progn
                    (if (and
                          (or
                            (= "Continuous" (setq lt (cdr (assoc 6 (setq layinfo (tblsearch "LAYER" layername))))))
                            (= "0" lt)
                          )
                          (/= "X" 1stlet)
                          (/= "C" 1stlet)
                          (/= "L" 1stlet)
                        )
                      (setq lt "HIDDEN")
                    )
                    (if (or
                          (= "X" 1stlet)
                          (= "C" 1stlet)
                          (= "L" 1stlet)
                        )
                      (setq color (abs (cdr (assoc 62 layinfo))))
                      (setq color 1)
                    )
                    (command "_.-layer" "_n" newlayer "_l" lt newlayer "_c" color newlayer)
                    (command)
                  )
                )
                (setq enlist (subst (cons 8 newlayer) layer enlist))
                (entmod enlist)
              )
            )
          )
        )
        (setq ct (1+ ct))
      )
      (command "_.undo" "_e")
    )
  )
  (princ)
)

(defun makeExist (ss / ct enlist layer layername 1stlet 2ndlet 3rdlet newlayer layinfo)
  (if ss
    (progn
      (command "_.undo" "_be")
      (setq ct 0)
      (repeat (sslength ss)
        (setq enlist (entget (ssname ss ct))
              layer (assoc 8 enlist)
              layername (strcase (cdr layer))
              1stlet (substr layername 1 1)
              2ndlet (substr layername 2 1)
              3rdlet (substr layername 3 1)
              ct (1+ ct)
        )
        (if (and
              (not (= "E" 2ndlet))
              (or
                (= "-" 2ndlet)
                (= "-" 3rdlet)
              )
            )
          (progn
            (if (= "-" 2ndlet)
              (setq newlayer (strcat 1stlet "E" (substr layername 2)))
              (setq newlayer (strcat 1stlet "E" (substr layername 3)))
            )
            (if (not (tblsearch "LAYER" newlayer))
              (progn
                (setq layinfo (tblsearch "LAYER" layername))
                (command "_.-layer" "_n" newlayer "_l" (cdr (assoc 6 layinfo)) newlayer "_c" (abs (cdr (assoc 62 layinfo))) newlayer)
                (command)
              )
            )
            (setq enlist (subst (cons 8 newlayer) layer enlist))
            (entmod enlist)
          )
        )
      )
      (command "_.undo" "_e")
    )
  )
  (princ)
)

(defun c:msTools_msTools_MdButton_OnClicked (/)
  (c:md)
  (princ)
)

(defun c:msTools_msTools_MeButton_OnClicked (/)
  (c:me)
  (princ)
)

(defun c:md (/ ss)
  (if (setq ss (cadr (ssgetfirst)))
    (makeDemo ss)
    (progn
      (prompt "\nmsTools: Make Demo\n")
      (if (setq ss (ssget))
        (makeDemo ss)
        (prompt "\nNothing selected!")
      )
    )
  )
  (princ)
)

(defun c:me (/ ss)
  (if (setq ss (cadr (ssgetfirst)))
    (makeExist ss)
    (progn
      (prompt "\nmsTools: Make Existing\n")
      (if (setq ss (ssget))
        (makeExist ss)
        (prompt "\nNothing selected!")
      )
    )
  )
  (princ)
)

;;; End make demo/existing



;;; Begin New project

(defun c:msTools_msTools_NewSSButton_OnClicked (/)
  (dcl-Form-Show msTools_NewSS)
  (princ)
)

(defun c:msTools_NewSS_OnInitialize (/)
  (dcl_Control_SetCaption msTools_NewSS_DirLabel "")
  (dcl_ComboBox_Clear msTools_NewSS_SizeBox)
  (dcl_ComboBox_AddList msTools_NewSS_SizeBox '("24\"x36\"" "30\"x42\""))
  (dcl_ComboBox_SetCurSel msTools_NewSS_SizeBox 0)
  (princ)
)

(defun c:msTools_NewSS_BrowseButton_OnClicked (/ dir)
  (if (setq dir (acet-ui-pickdir "Select drawing directory..." "N:\\"))
    (dcl_Control_SetCaption msTools_NewSS_DirLabel dir)
  )
  (princ)
)

(defun c:msTools_NewSS_CancelButton_OnClicked (/)
  (dcl_Form_Close msTools_NewSS)
  (princ)
)

(defun c:msTools_NewSS_OnEnteringNoDocState (/)
  (dcl_Form_Close msTools_NewSS)
  (princ)
)

(defun c:msTools_NewSS_CreateButton_OnClicked (/ dwgdir projnum ssdir projss bord)
  (if (and
        (/= "" (setq dwgdir (dcl_Control_GetCaption msTools_NewSS_DirLabel)))
        (setq projnum (caddr (str2lst dwgdir "\\")))
      )
    (progn
      (setq ssdir (strcat dwgdir "\\SheetSets")
            projss (strcat ssdir "\\" projnum ".dst")
            bord (strcat dwgdir "\\x-border.dwg")
      )
      (vl-mkdir ssdir)
      (if (zerop (dcl_ComboBox_GetCurSel msTools_NewSS_SizeBox))
        (progn
          (vl-file-copy mstDsizeDst projss)
          (vl-file-copy mstDsizeDwt (strcat ssdir "\\Arch D Plan.dwt"))
          (if (not (vl-file-size bord))
            (vl-file-copy mstDsizeBord bord)
          )
        )
        (progn
          (vl-file-copy mstEsizeDst projss)
          (vl-file-copy mstEsizeDwt (strcat ssdir "\\Arch E Plan.dwt"))
          (if (not (vl-file-size bord))
            (vl-file-copy mstEsizeBord bord)
          )
        )
      )
      (dcl_Form_Close msTools_NewSS)
      (command "_.-opensheetset" projss)
    )
    (alert "New Sheet Set Project: Please browse for the drawing folder first.")
  )
  (princ)
)

;;; End New project



;;; Begin msTools

(defun mstSetupMenu (/)
  (command "_.menuunload" "MST" "_.menuload" mstCuiFile)
  (menucmd "P77=+MST.POP1")
  (princ)
)

(defun c:msTools_ProgressWindow_OnEnteringNoDocState (/)
  (dcl_Form_Close msTools_ProgressWindow)
  (princ)
)

(defun c:msTools_msTools_OnClose (UpperLeftX UpperLeftY /)
  (setcfg "AppData/msTools/Enabled" "F")
  (princ)
)

(defun c:msTools_msTools_OnEnteringNoDocState (/)
  (dcl_Form_Close msTools_msTools)
  (setcfg "AppData/msTools/Enabled" "T")
  (princ)
)

(defun c:msTools_msTools_HelpButton_OnClicked (/)
  (alert "Place your mouse cursor over any one of the buttons; ToolTips will appear and explain what each button does.\n\nWritten by Jacob Abel for ms consultants, inc.\nProperty of ms consultants, inc.")
  (princ)
)

(defun c:mstools (/)
  (setcfg "AppData/msTools/Enabled" "T")
  (dcl-Form-Show msTools_msTools)
  (princ)
)

(defun c:mstoolsr (/)
  (setq LayZerLayerPreList nil
        LayZerLayerMidList nil
        LayZerLayerData nil
        mstDetLibTagsEditable nil
        dlbDetData nil
        dlbDetDataCASE nil
  )
  (load (strcat mstMainDir "\\msTools.lsp"))
  (dcl_Project_Load mstDialogFile T)
  (c:mstools)
  (princ)
)

;;; End msTools



;;; Begin utility functions

(defun c:resetprofile (/)
  (vla-resetprofile (vla-get-profiles (vla-get-preferences (vlax-get-acad-object))) (getvar "CPROFILE"))
  (princ)
)

(defun c:cr (/ ss pt1 pt2 dir ang)
  (prompt "\nmsTools: Copy-Rotate\n")
  (if (and
        (setq ss (ssget))
        (sssetfirst nil ss)
        (setq pt1 (getpoint "\nSpecify base point: "))
      )
    (progn
      (command "_.copybase" pt1 ss "")
      (command) ; fixes unknown hiccup
      (while (setq pt2 (getpoint pt1 "\nSpecify second point: "))
        (prompt "\nPress directional key on numpad for rotation: Right == 0°, CCW positive\n")
        (setq dir (cadr (grread)))
        (cond
          ((= 57 dir) (setq ang "45"))
          ((= 56 dir) (setq ang "90"))
          ((= 55 dir) (setq ang "135"))
          ((= 52 dir) (setq ang "180"))
          ((= 49 dir) (setq ang "225"))
          ((= 50 dir) (setq ang "270"))
          ((= 51 dir) (setq ang "315"))
          (T (setq ang "0"))
        )
        (command "_.undo" "_be" "_.pasteblock" pt2 "_.rotate" "_l" "" pt2 ang "_.explode" "_l" "_.undo" "_e")
      )
    )
    (prompt "\nNothing selected!")
  )
  (princ)
)

(defun getAttData (en / attlist enlist)
  (setq attlist (list)
        en (entnext en)
        enlist (entget en)
  )
  (while (= (cdr (assoc 0 enlist)) "ATTRIB")
    (setq attlist (cons (cons (cdr (assoc 2 enlist)) (cdr (assoc 1 enlist))) attlist)
          en (entnext en)
          enlist (entget en)
    )
  )
  attlist
)

(defun listAllFiles (path ext /)
  (apply 'append
    (cons
      (mapcar
        (function (lambda(x) (strcat path "\\" x)))
        (vl-directory-files path ext 1)
      )
      (mapcar
        (function (lambda(x) (listAllFiles (strcat path "\\" x) ext)))
        (cddr (vl-directory-files path nil -1)) ; to exclude "." and ".."
      )
    )
  )
)

(defun lst2str (lst delim / strg)
  (setq strg "")
  (foreach item lst
    (setq strg (strcat strg item delim))
  )
  (substr strg 1 (- (strlen strg) (strlen delim)))
)

(defun setAttValue (en tag val / enlist ind)
  (setq en (entnext en)
        enlist (entget en)
        ind T
  )
  (while (and
           ind
           (= (cdr (assoc 0 enlist)) "ATTRIB")
         )
    (if (= (cdr (assoc 2 enlist)) tag)
      (progn
        (setq ind nil
              enlist (subst (cons 1 val) (assoc 1 enlist) enlist)
        )
        (entmod enlist)
      )
      (setq en (entnext en)
            enlist (entget en)
      )
    )
  )
  (if ind
    nil
    val
  )
)

(defun str2lst (strg delim / templist delen pos)
  (setq templist (list)
        delen (strlen delim)
  )
  (while (setq pos (vl-string-search delim strg))
    (setq templist (cons (substr strg 1 pos) templist)
          strg (substr strg (+ 1 delen pos))
    )
  )
  (reverse (cons strg templist))
)

;;; End utility functions

(command "_OPENDCL") ; no need to check every time, if it's already loaded openDCL does nothing
(dcl_Project_Load mstDialogFile nil)
(if (not (menugroup "MST"))
  (mstSetupMenu)
)
(if (not (= "F" (getcfg "AppData/msTools/Enabled"))) ; changed so that it will open on first run
  (c:mstools)
)
(prompt "\nmsTools loaded.")
