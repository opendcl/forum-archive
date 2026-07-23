(vl-load-com)

(defun C:layzer ( / )
(command "OPENDCL")
(dcl_Project_Load "LayZer" T)
(dcl_Form_Show LayZer_LayZer)
(princ)
)

;;; Begin LayZer settings

(setq mstAcadVersion (substr (vlax-product-key) (+ (vl-string-search "R" (vlax-product-key)) 2) 2)
      mstObjectDBXDoc (strcat "ObjectDBX.AxDbDocument." mstAcadVersion)
      mstUserLocation (substr (getenv "ComputerName") 1 2)
)

(if (vl-string-search "64" (getenv "PROCESSOR_ARCHITECTURE"))
  (setq mstOpenDCLFilename (strcat "OPENDCL.X64." mstAcadVersion ".ARX"))
  (setq mstOpenDCLFilename (strcat "OPENDCL." mstAcadVersion ".ARX"))
)

(setq mstMainDir "C:\\nvTools"
      mstOpenDCLFile (strcat mstMainDir "\\OpenDCL\\" mstOpenDCLFilename)
      mstLayZerFile (strcat mstMainDir "\\Layer Standards\\Masterlayerlist.txt")
      mstLinetypesCount (length mstLinetypes)
      mstLinetypeLog (strcat mstMainDir "\\LayZer_err.log")

     )

;;; End LayZer settings


;;; Begin LayZer

(defun LayZer_loadLinetype (ltype / ct)
  (setq ct 0)
  (while (and
           (not (tblsearch "LTYPE" ltype))
           (< ct nvLinetypesCount)
         )
    (command "_.-linetype" "_l" ltype (nth ct nvLinetypes))
    (command)
    (command)
    (setq ct (1+ ct))
  )
  (tblsearch "LTYPE" ltype)
)

(defun LayZer_LayZer_addLayers (thelist / lyrs lyrn lyrlt errmsg logf layersobj)
  (if (setq lyrs (vl-remove-if-not (function (lambda(x) (vl-position (car x) thelist))) LayZerLayerData))
    (progn
      (foreach lyr lyrs
        (setq lyrn (car lyr)
              lyrlt (caddr lyr)
        )
        (if (not (LayZer_loadLinetype lyrlt))
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

(defun c:LayZer_LayZer_LayZerButton_OnClicked (/)
  (c:lz)
  (princ)
)

(defun c:LayZer_LayZer_Prelist_OnSelChanged (ItemIndex Value / prelen)
  (setq prelen (strlen Value))
  (dcl_ListBox_Clear LayZer_LayZer_Midlist)
  (dcl_ListBox_AddList LayZer_LayZer_Midlist (vl-remove-if-not (function (lambda(x) (= Value (substr x 1 prelen)))) LayZerLayerMidList))
  (dcl_ListBox_Clear LayZer_LayZer_Layerlist)
  (dcl_ListBox_AddList LayZer_LayZer_Layerlist (vl-remove-if-not (function (lambda(x) (= Value (substr x 1 prelen)))) (mapcar 'car LayZerLayerData)))
  (princ)
)

(defun c:LayZer_LayZer_Midlist_OnSelChanged (ItemIndex Value / midlen)
  (setq midlen (strlen Value))
  (dcl_ListBox_Clear LayZer_LayZer_Layerlist)
  (dcl_ListBox_AddList LayZer_LayZer_Layerlist (vl-remove-if-not (function (lambda(x) (= Value (substr x 1 midlen)))) (mapcar 'car LayZerLayerData)))
  (princ)
)

(defun c:LayZer_LayZer_Layerlist_OnSelChanged (ItemIndex Value / sellayers descstr)
  (if (and
        ItemIndex
        (setq sellayers (dcl_ListBox_GetSelectedItems LayZer_LayZer_Layerlist))
      )
    (progn
      (setq descstr "")
      (foreach sellayer sellayers
        (setq descstr (strcat descstr "Layer: " sellayer "\r\n=========================\r\nDescription: " (last (car (vl-remove-if-not (function (lambda(x) (= (car x) sellayer))) LayZerLayerData))) "\r\n\r\n"))
      )
      (dcl_Control_SetText LayZer_LayZer_DescBox descstr)
    )
    (dcl_Control_SetText LayZer_LayZer_DescBox "Instructions: Click the single prefix letter in the Pre column farthest to the left.  All the six letter prefixes associated with that letter will appear in the 6-Pre column to the right.  Click the six letter prefix in that column and all the layers with that prefix will appear in the Layer column to the right.  Select layers from that column to see their descriptions; click the Add Layers button to add the selected layers to the drawing.  Click the Add All button to add all layers shown in the Layer column.  Click the Done/Close button to close this dialog box.")
  )
  (princ)
)

(defun c:LayZer_LayZer_AddButton_OnClicked (/)
  (LayZer_LayZer_addLayers (dcl_ListBox_GetSelectedItems LayZer_LayZer_Layerlist))
  (princ)
)

(defun c:LayZer_LayZer_AddAllButton_OnClicked (/)
  (dcl_ListBox_SelItemRange LayZer_LayZer_Layerlist 0 (dcl_ListBox_GetCount LayZer_LayZer_Layerlist) T)
  (LayZer_LayZer_addLayers (dcl_ListBox_GetSelectedItems LayZer_LayZer_Layerlist))
  (princ)
)

(defun c:LayZer_LayZer_SearchBox_OnReturnPressed (/ query results)
  (if (and
        (/= "" (setq query (strcase (dcl_Control_GetText LayZer_LayZer_SearchBox))))
        (setq results (mapcar 'car (vl-remove-if-not (function (lambda(x) (or (vl-string-search query (strcase (car x))) (vl-string-search query (strcase (last x)))))) LayZerLayerData)))
      )
    (progn
      (dcl_ListBox_Clear LayZer_LayZer_Midlist)
      (dcl_ListBox_Clear LayZer_LayZer_Layerlist)
      (dcl_ListBox_AddList LayZer_LayZer_Layerlist results)
    )
    (alert "LayZer: Your search produced no results or you have entered a blank query.")
  )
  (dcl_TextBox_SetSel LayZer_LayZer_SearchBox 0 -1)
  (princ)
)

(defun c:LayZer_LayZer_SearchButton_OnClicked (/)
  (c:LayZer_LayZer_SearchBox_OnReturnPressed)
  (princ)
)

(defun c:LayZer_LayZer_CloseButton_OnClicked (/)
  (dcl_Form_Close LayZer_LayZer)
  (princ)
)

(defun c:LayZer_LayZer_OnEnteringNoDocState (/)
  (dcl_form_Close LayZer_LayZer)
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

  (dcl-Form-Show LayZer_LayZer)
  
  (dcl_ListBox_Clear LayZer_LayZer_Prelist)
  (dcl_ListBox_Clear LayZer_LayZer_Midlist)
  (dcl_ListBox_Clear LayZer_LayZer_Layerlist)
  (dcl_Control_SetText LayZer_LayZer_DescBox "Instructions: Click the single prefix letter in the Major column farthest to the left.  All the six letter prefixes associated with that letter will appear in the Minor column to the right.  Click the six letter prefix in that column and all the layers with that prefix will appear in the Layer column to the right.  Select layers from that column to see their descriptions; click the Add Layers button to add the selected layers to the drawing.  Click the Add All button to add all layers shown in the Layer column.  Click the Done/Close button to close this dialog box.")

  (dcl_ListBox_AddList LayZer_LayZer_Prelist LayZerLayerPreList)
  (princ)
)

;;; End LayZer

;;; Begin utility functions

(defun c:resetprofile (/)
  (vla-resetprofile (vla-get-profiles (vla-get-preferences (vlax-get-acad-object))) (getvar "CPROFILE"))
  (princ)
)

(defun c:cr (/ ss pt1 pt2 dir ang)
  (prompt "\nvTools: Copy-Rotate\n")
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