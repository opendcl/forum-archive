(dcl_project_load "layer")
(vl-load-com)

; *****************************************************************************************************
; Funktion:	c:layer_sc_layorder_OnInitialize
; Zweck:	Event zur Dialoginitialisierung
; Autor:	Fred Tomke
; Datum:	09.10.2006
; Argumente:	keine
; Rückgabewert:	keine
; Änderungen:	13.05.2008 - FT - Anpassung OpenDCL


(defun c:layer_sc_layorder_OnInitialize (/ 34_AKT_FUNKT_ALT lstLayer)
  (setq 34_AKT_FUNKT_ALT AKT_FUNKT
	AKT_FUNKT "c:layer_sc_layorder_OnInitialize")
  (dcl_Control_SetVisible layer_sc_layorder_lst_layer T)
  (dcl_Control_SetVisible layer_sc_layorder_txt_progress nil)
  (dcl_Control_SetVisible layer_sc_layorder_edt_progress nil)
  (dcl_Control_SetVisible layer_sc_layorder_pg_progress nil)
  (dcl_Control_SetVisible layer_sc_layorder_pic_progress nil)

;;;  Alternative way to make sure that listview is in front
;;;  (dcl_Control_ZOrder layer_sc_layorder_lst_layer 1)

  (dcl_Control_setValue layer_sc_layorder_chb_auto 1)
  (dcl_Control_setValue layer_sc_layorder_chb_regen 1)
  (dcl_Control_setValue layer_sc_layorder_chb_cmd 1)
  (dcl_Control_setValue layer_sc_layorder_chb_dragdrop 1)
  (dcl_Control_setValue layer_sc_layorder_chb_perspace 1)
  (dcl_Control_setValue layer_sc_layorder_chb_opendwg 1)
  (dcl_Control_SetDragnDropAllowBegin layer_sc_layorder_lst_layer T)
  
  (dcl_ComboBox_Clear layer_sc_layorder_cbb_list)
  (dcl_ListView_Clear layer_sc_layorder_lst_layer)

  (setq lstLayer '())
  (vlax-for oLayer (vla-get-layers (vla-get-ActiveDocument (vlax-get-acad-object))) (setq lstLayer (cons (vla-get-name oLayer) lstLayer)))
  (setq lstLayer (vl-sort lstLayer '(lambda (a b) (< (strcase a) (strcase b)))))
  
  (if lstLayer
    (progn
      (dcl_ComboBox_AddList layer_sc_layorder_cbb_list (list "Layerorder1"))
      (dcl_Control_setText layer_sc_layorder_cbb_list "Layerorder1")
      (setq lstRec (dcl_Control_GetCurPos layer_sc_layorder_lst_layer))
      (if (= (dcl_ListView_GetColumnCount layer_sc_layorder_lst_layer) 0)
	(dcl_ListView_AddColumns layer_sc_layorder_lst_layer (list (list "Layername" 0 (- (caddr lstRec) 4))))
      ); if
      (dcl_ListView_FillList layer_sc_layorder_lst_layer (mapcar 'list lstLayer))
      (dcl_Control_setEnabled layer_sc_layorder_pb_add nil)
      (dcl_Control_setEnabled layer_sc_layorder_pb_upd nil)
      (dcl_Control_setEnabled layer_sc_layorder_pb_del T)
    ); progn
    (progn
      (dcl_Control_setEnabled layer_sc_layorder_pb_add nil)
      (dcl_Control_setEnabled layer_sc_layorder_pb_upd nil)
      (dcl_Control_setEnabled layer_sc_layorder_pb_del nil)
    ); progn
  ); if

  (setq AKT_FUNKT 34_AKT_FUNKT_ALT)
  (princ)
); c:layer_sc_layorder_OnInitialize












; *****************************************************************************************************
; Funktion:	c:layer_sc_layorder_OnSize
; Zweck:	Event bei der Größenänderung des Dialoges
; Autor:	Fred Tomke
; Datum:	09.10.2006
; Argumente:	nWidth = width as integer
;		nHeight = height as integer
; Rückgabewert:	keine
; Änderungen:	13.05.2008 - FT - Anpassung OpenDCL


(defun c:layer_sc_layorder_OnSize (nWidth nHeight / 34_AKT_FUNKT_ALT lstRec)
  (setq 34_AKT_FUNKT_ALT AKT_FUNKT
	AKT_FUNKT "c:layer_sc_layorder_OnSize")
  (if (and layer_sc_layorder_lst_layer
	   (setq lstRec (dcl_Control_GetCurPos layer_sc_layorder_lst_layer)))
    (dcl_ListView_SetColWidth layer_sc_layorder_lst_layer 0 (- (caddr lstRec) 4))
  ); if
  (setq AKT_FUNKT 34_AKT_FUNKT_ALT)
  (princ)
); c:layer_sc_layorder_OnSize












; *****************************************************************************************************
; Funktion:	c:layer_sc_layorder_lst_layer_OnDragnDropToAutoCAD
; Zweck:	Event für das Drag&Drop ins AutoCAD
; Autor:	Fred Tomke
; Datum:	15.05.2008
; Argumente:	pt3dPoint = 3d point as list
; Rückgabewert:	keine
; Änderungen:	keine


(defun c:layer_sc_layorder_lst_layer_OnDragnDropToAutoCAD (pt3dPoint / 34_AKT_FUNKT_ALT lstObj)
  (setq 34_AKT_FUNKT_ALT AKT_FUNKT
	AKT_FUNKT "c:layer_sc_layorder_lst_layer_OnDragnDropToAutoCAD")
  (alert (strcat "Point: " (vl-prin1-to-string pt3dPoint)))
  (setq AKT_FUNKT 34_AKT_FUNKT_ALT)
  (princ)
); c:layer_sc_layorder_lst_layer_OnDragnDropToAutoCAD










; *****************************************************************************************************
; Funktion:	c:layer_sc_layorder_lst_layer_OnKeyDown
; Zweck:	Event für die Erkennung, sobald eine Taste gedrückt wird
; Autor:	Fred Tomke
; Datum:	09.10.2006
; Argumente:	sChar = character as string
;		nRepeatCount = number of repeating
;		nFlags = additional flags as integer
; Rückgabewert:	keine
; Änderungen:	13.05.2008 - FT - Anpassung OpenDCL


(defun c:layer_sc_layorder_lst_layer_OnKeyDown (sChar nRepeatCount nFlags / 34_AKT_FUNKT_ALT intChar)
  (setq 34_AKT_FUNKT_ALT AKT_FUNKT
	AKT_FUNKT "c:layer_sc_layorder_lst_layer_OnKeyDown")
  (setq intChar (ascii sChar))
;;;  (princ (strcat "\nDown: " (itoa intChar) " Flags: " (itoa nFlags) " Liste: " (vl-prin1-to-string (34:GET_BITS nFlags)) "\r"))
  (cond
    ((and (= (logand nFlags 8) 8) (= intChar 88)) (c:layer_sc_layorder_pb_layer_cut))
    ((and (= (logand nFlags 8) 8) (= intChar 86)) (if ***sc_laf_lstCutLayer*** (c:layer_sc_layorder_pb_layer_ins)))
;;;    (T (princ (strcat "\nDown: " (itoa intChar) "\r")))
  ); cond
  (setq AKT_FUNKT 34_AKT_FUNKT_ALT)
  (princ)
); c:layer_sc_layorder_lst_layer_OnKeyDown










; *****************************************************************************************************
; Funktion:	c:layer_sc_layorder_pb_layer_cut
; Zweck:	Event für Schaltfläche, um markierte Layer auszuschneiden
; Autor:	Fred Tomke
; Datum:	09.10.2006
; Argumente:	keine
; Rückgabewert:	keine
; Änderungen:	13.05.2008 - FT - Anpassung OpenDCL


(defun c:layer_sc_layorder_pb_layer_cut (/ 34_AKT_FUNKT_ALT lstSelected lstItems lstNewSel)
  (setq 34_AKT_FUNKT_ALT AKT_FUNKT
	AKT_FUNKT "c:layer_sc_layorder_pb_layer_cut")
  (if (and (setq lstSelected (dcl_ListView_GetSelectedNths layer_sc_layorder_lst_layer))
	   (listp lstSelected)
	   (setq lstItems (dcl_ListView_GetColumnItems layer_sc_layorder_lst_layer 0))
	   (setq lstNewSel (mapcar '(lambda (x) (nth x lstItems)) lstSelected)))
    (progn
      (if ***sc_laf_lstCutLayer***
	(progn
	  (mapcar '(lambda (x) (setq lstItems (vl-remove x lstItems))) lstNewSel)
	  (dcl_ListView_FillList layer_sc_layorder_lst_layer (mapcar 'list (append lstItems ***sc_laf_lstCutLayer***)))
	); progn
	(dcl_ListView_DeleteItems layer_sc_layorder_lst_layer (reverse lstSelected))
      ); if
      (setq ***sc_laf_lstCutLayer*** lstNewSel)
    ); progn
    (if (not lstSelected)
      (dcl_MessageBox (strcat "Bitte markieren Sie zunächst die Layer, die Sie ausschneiden wollen, " (34:USERNAME) "!") "Keine Layer markiert" 2 1)
    ); if
  ); if
  (setq AKT_FUNKT 34_AKT_FUNKT_ALT)
  (princ)
); c:layer_sc_layorder_pb_layer_cut










; *****************************************************************************************************
; Funktion:	c:layer_sc_layorder_pb_layer_ins
; Zweck:	Event für Schaltfläche, um markierte Layer einzufügen
; Autor:	Fred Tomke
; Datum:	09.10.2006
; Argumente:	keine
; Rückgabewert:	keine
; Änderungen:	13.05.2008 - FT - Anpassung OpenDCL


(defun c:layer_sc_layorder_pb_layer_ins (/ 34_AKT_FUNKT_ALT lstSelected lstItems lstNewItems strZiel lstSel)
  (setq 34_AKT_FUNKT_ALT AKT_FUNKT
	AKT_FUNKT "c:layer_sc_layorder_pb_layer_ins")

  (cond
    ((null ***sc_laf_lstCutLayer***) (dcl_MessageBox (strcat "Bitte schneiden Sie zunächst die Layer aus, die Sie hier einfügen wollen, " (34:USERNAME) "!") "Keine Layer in der Zwischenablage" 2 1))
    ((not (setq lstItems (dcl_ListView_GetColumnItems layer_sc_layorder_lst_layer 0))) (setq lstNewItems ***sc_laf_lstCutLayer***))
    ((or (not (setq lstSelected (dcl_ListView_GetSelectedNths layer_sc_layorder_lst_layer)))
	 (numberp lstSelected)) (dcl_MessageBox (strcat "Bitte markieren Sie den Eintrag, vor dem die augeschnittenen Layer eingefügt werden sollen, " (34:USERNAME) "!") "Kein Layer selektiert" 2 1))
    ((and (listp lstSelected)
	  (setq strZiel (dcl_ListView_GetItemText layer_sc_layorder_lst_layer (car lstSelected) 0)))
     (setq lstNewItems (append (reverse (cdr (member strZiel (reverse lstItems))))
				***sc_laf_lstCutLayer***
				(member strZiel lstItems))))
  ); cond

  (if lstNewItems (dcl_ListView_FillList layer_sc_layorder_lst_layer (mapcar 'list lstNewItems)))
  (setq lstSel (mapcar '(lambda (x) (dcl_ListView_SetCurSel layer_sc_layorder_lst_layer (vl-position x lstNewItems))) ***sc_laf_lstCutLayer***))
  
  (setq ***sc_laf_lstCutLayer*** '())
  (setq AKT_FUNKT 34_AKT_FUNKT_ALT)
  (princ)
); c:layer_sc_layorder_pb_layer_ins

(defun c:laf ()
  (dcl_form_show layer_sc_layorder)
  (princ)
); laf

(princ "Call LAF to start...")
(princ)