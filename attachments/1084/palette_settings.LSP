;; Sample (palette_settings "Layerthemen-Manager" "{AB3492EE-987D-4F0C-BDD0-28D54E6F41A8}" -1 0 0 200 800 400 0 200 800 400 59420 1 1 0 0 46 60 100)

(defun palette_settings (strTitlebarText
			 strGUID
			 intOrientation
			 intAllowDocking
			 intFloatLeft
			 intFloatTop
			 intFloatWidth
			 intFloatHeight
			 intDockLeft
			 intDockTop
			 intDockWidth
			 intDockHeight
			 intDockingStyle
			 intActive
			 intVisible
			 intTitleBarLocation
			 intAutoCollapse
			 intStyle
			 intMouseOffOpacity
			 intMouseOverOpacity


			 / bRes strFile filFile
			   write error release
			   get_item_by_tag
			   get_tool_by_clsid
			   create_child
			   get_or_create_child

			   oCAdUiPaletteSet oDockInfo oFloatInfo
			   oCAdUiDockControlBar oTool oToolsInfo
			   oAdUiTools oAcApData oStorage oProfile
			   oXML)
  (cond
    ((not (or (setq strFile (vl-registry-read (strcat "HKEY_CURRENT_USER\\" (vlax-product-key) "\\Profiles\\" (getvar "CPROFILE") "\\General") "ProfileStorage"))
	      (setq strFile (strcat (getvar "ROAMABLEROOTPREFIX") "Support\\Profiles\\" (getvar "CPROFILE") "\\Profile.aws"))))
     (error (list -2 "\nCannot create Profile.aws\r")))

    ;; If aws-file was not found: The Principle of Hope!
    
    ((not (findfile strFile))
     (defun write (strLine) (write-line strLine filFile))
     (setq filFile (open strFile "w"))
     (mapcar 'write (list "<Profile>"
			  (strcat "  <Name>" (getvar "CPROFILE") "</Name>")
			  "  <Description></Description>"
			  "  <StorageRoot>"
			  "    <AcApData>"
			  "      <AdUiTools>"
			  "        <ToolsInfo>"
			  (strcat "          <Tool CLSID=\"" strGUID "\">")
			  (strcat "            <CAdUiDockControlBar Orientation=\"" (itoa intOrientation) "\" AllowDocking=\"" (itoa intAllowDocking) "\">")
			  (strcat "              <FloatInfo Left=\"" (itoa intFloatLeft) "\" Top=\"" (itoa intFloatTop) "\" Width=\"" (itoa intFloatWidth) "\" Height=\"" (itoa intFloatHeight) "\" />")
			  (strcat "              <DockInfo Left=\"" (itoa intDockLeft) "\" Top=\"" (itoa intDockTop) "\" Width=\"" (itoa intDockWidth) "\" Height=\"" (itoa intDockHeight) "\" MRUDockID=\"" (itoa intDockingStyle) "\" />")
			  "            </CAdUiDockControlBar>"
			  (strcat "            <CAdUiPaletteSet ActivePaletteIndex=\"" (itoa intActive)
			  	"\" TitleBarLocation=\"" (itoa intTitleBarLocation) "\" AutoRollup=\"" (itoa intAutoCollapse)
			  	"\" Name=\"" strTitlebarText
			  	"\" Style=\"" (itoa intStyle)
			  	"\" Opacity=\"" (itoa intMouseOffOpacity)
			  	"\" RolloverOpacity=\"" (itoa intMouseOverOpacity)
			  	"\" Visible=\"" (itoa intVisible) "\" />")
			  "          </Tool>"
			  "        </ToolsInfo>"
			  "      </AdUiTools>"
			  "    </AcApData>"
			  "  </StorageRoot>"
			  "</Profile>"))
     (close filFile)
     (if (findfile strFile)
       (progn
	 (princ "\nNew Profile.aws created!\r")
	 (setq bRes T)
       ); progn
     )); ifcond

    ;; Try to get MSXML-object for editing
    
    ((setq oXML (vlax-create-object "MSXML.DOMDocument"))

     (defun error (uData)
       (cond
	 ((not uData) nil)
	 ((numberp uData) (princ (strcat "\nParser-Error: " (itoa uData) "\r")))
	 ((listp uData) (princ (strcat "\nParser-Error: " (itoa (car uData)) ": " (cadr uData) "\r")))
	 (T (princ (strcat "\nError: " uData "\r")))
       ); cond
     ); error

     (defun release (oObj)
       (if (and oObj (not (vlax-object-released-p oObj)))
	 (vlax-release-object oObj)
       ); if
     ); release

     (defun get_item_by_tag (oParent strTag / oChild intLen intCnt)
       (if (and (setq oParent (vlax-get oParent 'ChildNodes))
		(> (setq intLen (vlax-get oParent 'Length)) 0)
		(setq intCnt 0 strTag (strcase strTag)))
	 (while (and (< intCnt intLen) (not oChild))
	   (if (setq oChild (vlax-get-property oParent 'Item intCnt))
	     (if (= (strcase (vlax-get oChild 'TagName)) strTag)
	       (setq intCnt intLen)
	       (progn
		 (setq intCnt (1+ intCnt))
		 (vlax-release-object oChild)
		 (setq oChild nil)
	       ); progn
	     ); if
	     (setq intCnt intLen)
	   ); if
	 ); while
       ); if
       (release oParent)
       oChild
     ); get_item_by_tag

     (defun get_tool_by_clsid (oParent strClsid / intLen intCnt strTag oChild strValue)
       (if (and (setq oParent (vlax-get oParent 'ChildNodes))
		(> (setq intLen (vlax-get oParent 'Length)) 0)
		(setq intCnt 0 strTag "TOOL"))
	 (while (and (< intCnt intLen) (not oChild))
	   (if (setq oChild (vlax-get-property oParent 'Item intCnt))
	     (if (and (= (strcase (vlax-get oChild 'TagName)) strTag)
		      (setq strValue (vlax-variant-value (vlax-invoke-method oChild 'GetAttribute "CLSID")))
		      (= strValue strClsid))
	       (setq intCnt intLen)
	       (progn
		 (setq intCnt (1+ intCnt))
		 (vlax-release-object oChild)
		 (setq oChild nil)
	       ); progn
	     ); if
	     (setq intCnt intLen)
	   ); if
	 ); while
       ); if
       (release oParent)
       oChild
     ); get_tool_by_clsid

     (defun create_child (oParent strTag)
       (vlax-invoke-method oParent 'AppendChild (vlax-invoke-method oXML 'CreateNode 1 strTag ""))
     ); create_child

     (defun get_or_create_child (oParent strTag / oObj)
       (if (not (setq oObj (get_item_by_tag oParent strTag)))
	 (setq oObj (create_child oParent strTag))
       ); if
       oObj
     ); get_or_create_child

     (cond
       ((= (vlax-invoke-method oXML 'Load strFile) :vlax-false) (error (list 0 "\nProfile.aws cannot be opened!\r")))

       ((not (setq oProfile (get_item_by_tag oXML "Profile"))) (error 1))

       ((not (setq oStorage (get_item_by_tag oProfile "StorageRoot"))) (error 2))

       ((not (setq oAcApData (get_item_by_tag oStorage "AcApData"))) (error 3))

       ((not (setq oAdUiTools (get_item_by_tag oAcApData "AdUiTools"))) (error 4))

       ((not (setq oToolsInfo (get_item_by_tag oAdUiTools "ToolsInfo"))) (error 5))

       ((or (setq oTool (get_tool_by_clsid oToolsInfo strGUID))
	    (setq oTool (create_child oToolsInfo "Tool")))

	(if (not (vlax-variant-value (vlax-invoke-method oTool 'GetAttribute "CLSID")))
	  (vlax-invoke-method oTool 'SetAttribute "CLSID" strGUID)
	); if

	(if (setq oCAdUiDockControlBar (get_or_create_child oTool "CAdUiDockControlBar"))
	  (progn
	    (vlax-invoke-method oCAdUiDockControlBar 'SetAttribute "Orientation" (itoa intOrientation))
	    (vlax-invoke-method oCAdUiDockControlBar 'SetAttribute "AllowDocking" (itoa intAllowDocking))

	    (if (setq oFloatInfo (get_or_create_child oCAdUiDockControlBar "FloatInfo"))
	      (progn
		(vlax-invoke-method oFloatInfo 'SetAttribute "Left" (itoa intFloatLeft))
		(vlax-invoke-method oFloatInfo 'SetAttribute "Top" (itoa intFloatTop))
		(vlax-invoke-method oFloatInfo 'SetAttribute "Width" (itoa intFloatWidth))
		(vlax-invoke-method oFloatInfo 'SetAttribute "Height" (itoa intFloatHeight))
	      ); progn
	      (error 8)
	    ); if

	    (if (setq oDockInfo (get_or_create_child oCAdUiDockControlBar "DockInfo"))
	      (progn
		(vlax-invoke-method oDockInfo 'SetAttribute "Left" (itoa intDockLeft))
		(vlax-invoke-method oDockInfo 'SetAttribute "Top" (itoa intDockTop))
		(vlax-invoke-method oDockInfo 'SetAttribute "Width" (itoa intDockWidth))
		(vlax-invoke-method oDockInfo 'SetAttribute "Height" (itoa intDockHeight))
		(vlax-invoke-method oDockInfo 'SetAttribute "MRUDockID" (itoa intDockingStyle))
	      ); progn
	      (error 9)
	    ); if
	  ); progn
	  (error 7)
	); if

	(if (setq oCAdUiPaletteSet (get_or_create_child oTool "CAdUiPaletteSet"))
	  (progn
	    (vlax-invoke-method oCAdUiPaletteSet 'SetAttribute "ActivePaletteIndex" (itoa intActive))
	    (vlax-invoke-method oCAdUiPaletteSet 'SetAttribute "TitleBarLocation" (itoa intTitleBarLocation))
	    (vlax-invoke-method oCAdUiPaletteSet 'SetAttribute "AutoRollup" (itoa intAutoCollapse))
	    (vlax-invoke-method oCAdUiPaletteSet 'SetAttribute "Name" strTitlebarText)
	    (vlax-invoke-method oCAdUiPaletteSet 'SetAttribute "Style" (itoa intStyle))
	    (vlax-invoke-method oCAdUiPaletteSet 'SetAttribute "Opacity" (itoa intMouseOffOpacity))
	    (vlax-invoke-method oCAdUiPaletteSet 'SetAttribute "RolloverOpacity" (itoa intMouseOverOpacity))
	    (vlax-invoke-method oCAdUiPaletteSet 'SetAttribute "Visible" (itoa intVisible))
	  ); progn
	  (error 10)
	); if

	(if (vl-catch-all-error-p (setq errObj (vl-catch-all-apply 'vlax-invoke-method (list oXML 'Save strFile))))
	  (error (list 11 (vl-catch-all-error-message errObj)))
	  (progn
	    (princ "\nProfile.aws was changed successfully!\r")
	    (setq bRes T)
	  ); progn
	)); ifcond
	

       (T (error 6))
     ); cond

     (mapcar 'release (list oCAdUiPaletteSet oDockInfo oFloatInfo oCAdUiDockControlBar oTool oToolsInfo oAdUiTools oAcApData oStorage oProfile oXML)))

    (T (error (list -1 "\nMSXML is not installed properly! Profile.aws not edited\r")))
  ); cond

  bRes
); palette_settings

(vl-load-com)