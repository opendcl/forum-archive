(defun add_string (strString / strExist strNew)
  (if ActiveX_form_rtf_events
    (progn
      (setq strExist (dcl_AxControl_Get ActiveX_form_rtf_events "TextRTF"))
      (if (/= strExist "")
	(setq strExist (apply 'strcat (mapcar 'chr (reverse (cdr (member 125 (reverse (vl-remove 10 (vl-remove 13 (vl-string->list strExist))))))))))
      ); if
      (setq strNew (strcat strExist "\\par" strString "}"))
      (dcl_AxControl_Put ActiveX_form_rtf_events "TextRTF" strNew)
      (dcl_AxControl_Put ActiveX_form_rtf_events "SelLength" 0)
      (dcl_AxControl_Put ActiveX_form_rtf_events "SelStart" (strlen strNew))
    ); progn
  ); if
); add_string

(defun add_event (strEvent lstArgs)
  (add_string (strcat "\\tx1278\\b\\f0\\fs16 Event:\\b0\\tab " strEvent "\\par\\b Arguments:\\b0\\tab "
		      (if lstArgs (vl-prin1-to-string lstArgs) "<keine>") "\\par"))
); add_event

(defun statusbar_text (strText / oPanel oPanels)
  (setq oPanels (dcl_AxControl_Get ActiveX_form_sb_appbar "Panels"))
  (setq oPanel (dcl_AxObject_Get oPanels nil "Item" 2))
  (dcl_AxObject_Put oPanel nil "Text" strText)
  (dcl_AxObject_Get oPanel nil "Text") ;; just for trying if assign was successfully
  (dcl_AxObject_Release oPanel)
  (dcl_AxObject_Release oPanels)
  (dcl_AxControl_Invoke ActiveX_form_sb_appbar "Refresh")
); statusbar_text

(defun layer_liste (/ oLayer strName lstLayers )
  (vlax-for oLayer (vla-get-layers (vla-get-ActiveDocument (vlax-get-acad-object)))
    (setq strName (vla-get-name oLayer))
    (if (not (wcmatch "*|*" strName)) (setq lstLayers (cons (cons strName oLayer) lstLayers)))
  ); vlax-for
  (setq lstLayers (vl-sort lstLayers '(lambda (a b) (< (strcase (car a)) (strcase (car b))))))
); layer_liste

(defun number_of_elements (strLayer / ssSel)
  (if (setq ssSel (ssget "X" (list (cons 410 (getvar "CTAB")) (cons 8 strLayer))))
    (sslength ssSel)
    0
  ); if
); number_of_elements

(defun grid_add (strLayer intCount)
  (dcl_AxControl_Invoke ActiveX_form_grd_layer "AddItem" strLayer)
  (dcl_AxControl_Put ActiveX_form_grd_layer "Row" (1+ intCnt))
  (dcl_AxControl_Put ActiveX_form_grd_layer "Col" 1)
  (dcl_AxControl_Put ActiveX_form_grd_layer "Text" (itoa intCount))
  (if (zerop intCount)
    (progn
      (dcl_AxControl_Put ActiveX_form_grd_layer "CellBackColor" (dcl_GetOLEColorValue (list 255 232 209)))
      (dcl_AxControl_Put ActiveX_form_grd_layer "CellForeColor" (dcl_GetOLEColorValue 254))
    ); progn
  ); if
); grid_add

(defun chart_update (intType / lstLayers intCnt lstItem intObjects strLayer doNotExecute)
  (setq doNotExecute T)
  (setq lstLayers (layer_liste))
  (setq intCnt 0)
  (dcl_AxControl_Put ActiveX_form_pic_chart "Repaint" T)
  (dcl_AxControl_Invoke ActiveX_form_grd_layer "Clear")
  (dcl_AxControl_Put ActiveX_form_grd_layer "Row" 0)
  (dcl_AxControl_Put ActiveX_form_grd_layer "Col" 0)
  (dcl_AxControl_Put ActiveX_form_grd_layer "CellFontBold" T)
  (dcl_AxControl_Put ActiveX_form_grd_layer "Text" "Layer")
  (dcl_AxControl_Put ActiveX_form_grd_layer "Col" 1)
  (dcl_AxControl_Put ActiveX_form_grd_layer "CellFontBold" T)
  (dcl_AxControl_Put ActiveX_form_grd_layer "Text" "Number of Entities")

  (repeat (1+ (dcl_AxControl_Get ActiveX_form_grd_layer "Rows"))
    (dcl_AxControl_Invoke ActiveX_form_grd_layer "RemoveItem" 1)
  ); repeat

  (if (not intType)
    (if (not (member (setq intType (dcl_AxControl_Get ActiveX_form_pic_chart "chartType")) '(1 14)))
      (setq intType 1)
    ); if
  ); if

  (if (= intType 1)
    (progn
      (dcl_AxControl_Put ActiveX_form_pic_chart "ShowLegend" nil)
      (dcl_AxControl_Put ActiveX_form_pic_chart "chartType" 1)
      (dcl_AxControl_Put ActiveX_form_pic_chart "RowCount" (length lstLayers))
      (dcl_AxControl_Put ActiveX_form_pic_chart "ColumnCount" 1)
      (dcl_AxControl_Put ActiveX_form_pic_chart "Column" 1)
      (dcl_AxControl_Put ActiveX_form_pic_chart "ColumnLabel" "")
      (foreach lstItem lstLayers
	(setq strLayer (car lstItem))
	(setq intObjects (number_of_elements (car lstItem)))
	(dcl_AxControl_Put ActiveX_form_pic_chart "Row" (setq intCnt (1+ intCnt)))
	(dcl_AxControl_Put ActiveX_form_pic_chart "Data" intObjects)
	(dcl_AxControl_Put ActiveX_form_pic_chart "RowLabel" strLayer)
	(grid_add strLayer intObjects)
      ); foreach
    ); progn
    (progn
      (dcl_AxControl_Put ActiveX_form_pic_chart "chartType" 14)
      (dcl_AxControl_Put ActiveX_form_pic_chart "ShowLegend" T)
      (dcl_AxControl_Put ActiveX_form_pic_chart "RowCount" 1)
      (dcl_AxControl_Put ActiveX_form_pic_chart "ColumnCount" (length lstLayers))
      (dcl_AxControl_Put ActiveX_form_pic_chart "ColumnLabelCount" (length lstLayers))
      (dcl_AxControl_Put ActiveX_form_pic_chart "Row" 1)
      (dcl_AxControl_Put ActiveX_form_pic_chart "RowLabel" "")
      (foreach lstItem lstLayers
	(setq strLayer (car lstItem))
	(setq intObjects (number_of_elements (car lstItem)))
	(dcl_AxControl_Put ActiveX_form_pic_chart "Column" (setq intCnt (1+ intCnt)))
	(dcl_AxControl_Put ActiveX_form_pic_chart "Data" intObjects)
	(dcl_AxControl_Put ActiveX_form_pic_chart "ColumnLabel" strLayer)
	(grid_add strLayer intObjects)
      ); foreach
    ); progn
  ); if
  (dcl_AxControl_Invoke ActiveX_form_grd_layer "RemoveItem" 1)
  (setq doNotExecute nil)
); chart_update

(defun chart_copy ()
  (dcl_AxControl_Invoke ActiveX_form_pic_chart "EditCopy")
  (dcl_messagebox (strcat "I've copied the data into clipboard, " (getvar "LOGINNAME") "!") "Data copy" 2 2)
); chart_copy

(defun c:ActiveX_form_OnInitialize (/)
  (dcl_AxControl_Put ActiveX_form_rtf_events "Text" "")
  (dcl_AxControl_Put ActiveX_form_rtf_events "TextRTF"  "{\\rtf1\\ansi\\ansicpg1252\\deff0\\deflang1031{\\fonttbl{\\f0\\fswiss\\fcharset0 0 Arial;}}{\\*\\generator Msftedit 5.41.15.1515;}\\viewkind4\\uc1\\pard\\b\\f0\\fs16 Hello, let's begin!\\b0\\par}")
  (add_event "OnInitialize" nil)
  (chart_update nil)
  (statusbar_text "Add some new entities and reread!")
); c:ActiveX_form_OnInitialize

(defun c:ActiveX_form_OnDocActivated (/)
  (add_event "OnDocActivated" nil)
  (chart_update nil)
); c:ActiveX_form_OnDocActivated

(defun c:ActiveX_form_OnCancelClose (intIsESC /)
  (add_event "OnCancelClose" (list intIsESC))
  (/= intIsESC 1)
); c:ActiveX_form_OnCancelClose

(defun c:ActiveX_form_OnEnteringNoDocState (/)
  (add_event "OnEnteringNoDocState" nil)
  (dcl_form_close ActiveX_form)
); c:ActiveX_form_OnEnteringNoDocState

(defun c:ActiveX_form_OnSize (intNewWidth intNewHeight / intWidth)
  (if intNewWidth (add_event "OnSize" (list intNewWidth intNewHeight)))
  (setq intWidth (fix (* 0.5 (- (dcl_Control_GetWidth ActiveX_form_grd_layer) 24))))
  (dcl_AxControl_Put ActiveX_form_grd_layer "ColWidth" 0 (dcl_XPixelsToTwips intWidth))
  (dcl_AxControl_Put ActiveX_form_grd_layer "ColWidth" 1 (dcl_XPixelsToTwips intWidth))
); c:ActiveX_form_OnSize

(defun c:ActiveX_form_spl_ver_OnSplitterMoved (intUpperLeftX intUpperLeftY intWidth intHeight /)
  (add_event "spl_ver_OnSplitterMoved" (list intUpperLeftX intUpperLeftY intWidth intHeight))
  (c:ActiveX_form_OnSize nil nil)
); c:ActiveX_form_spl_ver_OnSplitterMoved

(defun c:ActiveX_form_tb_toolbar_OnButtonClick (entButton /)
  (setq strKey (dcl_AxObject_Get entButton nil "Key"))
  (add_event "tb_toolbar_OnButtonClick" (list (strcat "Button " strKey)))
  (cond
    ((= strKey "Read") (chart_update nil))
    ((= strKey "Copy") (chart_copy))
    ((= strKey "Numbers") (if (/= (dcl_AxControl_Get ActiveX_form_pic_chart "chartType") 1) (chart_update 1)))
    ((= strKey "Pie") (if (/= (dcl_AxControl_Get ActiveX_form_pic_chart "chartType") 14) (chart_update 14)))
  ); cond
); c:ActiveX_form_tb_toolbar_OnButtonClick

(defun c:ActiveX_form_grd_layer_OnEnterCell (/)
  (if (not doNotExecute) (add_event "grd_layer_OnEnterCell" nil))
); c:ActiveX_form_grd_layer_OnEnterCell

(defun c:ActiveX_form_grd_layer_OnLeaveCell (/)
  (if (not doNotExecute) (add_event "grd_layer_OnLeaveCell" nil))
); c:ActiveX_form_grd_layer_OnLeaveCell

(defun c:ActiveX_form_grd_layer_OnRowColChange (/)
  (if (not doNotExecute) (add_event "grd_layer_OnRowColChange" nil))
); c:ActiveX_form_grd_layer_OnRowColChange

(defun c:ActiveX ()
  (command "_OPENDCL")
  (dcl_project_load "ActiveX" T)
  (dcl_form_show ActiveX_form)
  (princ)
); ActiveX