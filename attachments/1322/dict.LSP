;;; ------------------------------------------------------------------------
;;; Save list data as associated lists using names for seperate data objects
;;; ------------------------------------------------------------------------

(defun c:obj_set1 (/ entObj oObj strN)
  (if (and (setq entObj (car (entsel "\nSelect object to add data: ")))
	   (setq oObj (vlax-ename->vla-object entObj))
	   (setq strN (vla-get-objectname oObj)))
    (cond
      ((member strN '("AcDbArc" "AcDb2dPolyline" "AcDb2dPolyline" "AcDbPolyline" "AcDbLine" "AcDbSpline"))
       (dict_properties_set oObj "Data1" (list (cons "ID" (cdr (assoc (if (= strN "AcDbArc") 67 70) (entget entObj))))
					       (cons "DIST" (vlax-curve-getdistatpoint oObj (vlax-curve-getendpoint oObj)))
					       (cons "LAYER" (vla-get-Layer oObj)) (cons "OBJ" oObj)
					       (cons "POINT" (vlax-curve-getstartpoint oObj)))))

      ((member strN '("AcDbCircle" "AcDbEllipse"))
       (dict_properties_set oObj "Data1" (list (cons "ID" 1)
					       (cons "DIST" (if (= "AcDbEllipse" strN) 0.0 (vla-get-Circumference oObj)))
					       (cons "LAYER" (vla-get-Layer oObj)) (cons "OBJ" oObj)
					       (cons "POINT" (cdr (assoc 10 (entget entObj)))))))
      ((member strN '("AcDbShape" "AcDbBlockReference" "AcDbText" "AcDbMtext"))
       (dict_properties_set oObj "Data1" (list (cons "ID" 1)
					       (cons "DIST" 0.0)
					       (cons "LAYER" (vla-get-Layer oObj)) (cons "OBJ" oObj)
					       (cons "POINT" (cdr (assoc 10 (entget entObj)))))))
    ); cond
  ); if
); c:obj_set1

(defun c:obj_get1 (/ entObj oObj lstData)
  (if (and (setq entObj (car (entsel "\nSelect object to read data: ")))
	   (setq oObj (vlax-ename->vla-object entObj))
	   (setq lstData (dict_properties_get oObj "Data1")))
    (princ lstData)
    (princ "\nNo data found!")
  ); if
); c:obj_get1

;;; ------------------------------------------------------------------------
;;; Save list data as associated lists using names for seperate data objects
;;; ------------------------------------------------------------------------

(defun c:obj_set2 (/ entObj oObj strN)
  (if (and (setq entObj (car (entsel "\nSelect object to add data: ")))
	   (setq oObj (vlax-ename->vla-object entObj))
	   (setq strN (vla-get-objectname oObj)))
    (cond
      ((member strN '("AcDbArc" "AcDb2dPolyline" "AcDb2dPolyline" "AcDbPolyline" "AcDbLine" "AcDbSpline"))
       (dict_properties_set oObj "Data2" (list (cons 70 (cdr (assoc (if (= strN "AcDbArc") 67 70) (entget entObj))))
					       (cons 40 (vlax-curve-getdistatpoint oObj (vlax-curve-getendpoint oObj)))
					       (cons 8 (vla-get-Layer oObj))
					       (cons 330 oObj)
					       (cons 10 (vlax-curve-getstartpoint oObj)))))

      ((member strN '("AcDbCircle" "AcDbEllipse"))
       (dict_properties_set oObj "Data2" (list (cons 70 1)
					       (cons 40 (if (= "AcDbEllipse" strN) 0.0 (vla-get-Circumference oObj)))
					       (cons 8 (vla-get-Layer oObj))
					       (cons 330 oObj)
					       (cons 10 (cdr (assoc 10 (entget entObj)))))))
      ((member strN '("AcDbShape" "AcDbBlockReference" "AcDbText" "AcDbMtext"))
       (dict_properties_set oObj "Data2" (list (cons 70 1)
					       (cons 40 0.0)
					       (cons 8 (vla-get-Layer oObj))
					       (cons 330 oObj)
					       (cons 10 (cdr (assoc 10 (entget entObj)))))))
    ); cond
  ); if
); c:obj_set2

(defun c:obj_get2 (/ entObj oObj lstData)
  (if (and (setq entObj (car (entsel "\nSelect object to read data: ")))
	   (setq oObj (vlax-ename->vla-object entObj))
	   (setq lstData (dict_properties_get oObj "Data2")))
    (princ lstData)
    (princ "\nNo data found!")
  ); if
  (princ)
); c:obj_get2






(defun dict_group_create (oObj strKey / oDic oItem)
  (cond
    ((not oObj)
     (setq oDic (vla-get-Dictionaries (vla-get-ActiveDocument (vlax-get-acad-object)))))
    ((= (type oObj) 'STR)
     (setq oDic (dict_group_create nil oObj)))
    ((= (vla-get-objectname oObj) "AcDbDictionary")
     (setq oDic oObj))
    (T (setq oDic (vla-GetExtensionDictionary oObj)))
  ); cond
  (cond
    ((and (setq oItem (vl-catch-all-apply 'vla-item (list oDic strKey)))
	  (not (vl-catch-all-error-p oItem))) nil)
    ((not oObj) (setq oItem (vla-add oDic strKey)))
    (T (setq oItem (vla-AddObject oDic strKey "AcDbDictionary")))
  ); cond
  oItem
); dict_group_create

(defun dict_group_get (oObj strKey / oDic oItem)
  (cond
    ((not oObj)
     (setq oDic (vla-get-Dictionaries (vla-get-ActiveDocument (vlax-get-acad-object)))))
    ((= (type oObj) 'STR)
     (setq oDic (dict_group_get nil oObj)))
    ((= (vla-get-objectname oObj) "AcDbDictionary")
     (setq oDic oObj))
    (T (setq oDic (vla-GetExtensionDictionary oObj)))
  ); cond
  (if (vl-catch-all-error-p (setq oItem (vl-catch-all-apply 'vla-item (list oDic strKey))))
    (setq oItem nil)
  ); if
  oItem
); dict_group_get

(defun dict_item_owner (oItem / is64Bit intID oOwner)
  (setq is64Bit (not (= (getenv "PROCESSOR_ARCHITECTURE") "x86")))
  (setq intID (if is64Bit (vla-get-OwnerID32 oItem) (vla-get-OwnerID oItem)))
  (if (and (setq oOwner (vl-catch-all-apply (if is64Bit 'vla-ObjectIDToObject32 'vla-objectidtoobject) (list (vla-get-Document oItem) intID)))
	   (vl-catch-all-error-p oOwner))
    (setq oOwner nil)
  ); if
  oOwner
); dict_item_owner

(defun dict_item_objidtoobj (oDoc intId / oObj)
  (if (and (setq oObj (vl-catch-all-apply
			(if (not (= (getenv "PROCESSOR_ARCHITECTURE") "x86"))
			  'vla-ObjectIDToObject32
			  'vla-objectidtoobject
			); if
			(list oDoc intId)))
	   (vl-catch-all-error-p oObj))
    (progn
      (princ (vl-catch-all-error-message oObj))
      (setq oObj nil)
    ); progn
  ); if
  oObj
); dict_item_objidtoobj

(defun dict_item_create (oDic strKey / oItem)
  (if (vl-catch-all-error-p (setq oItem (vl-catch-all-apply 'vla-item (list oDic strKey))))
    (setq oItem (vla-addxrecord oDic strKey))
  ); if
  oItem
); dict_item_create

(defun dict_item_get (oDic strKey / oItem)
  (if (vl-catch-all-error-p (setq oItem (vl-catch-all-apply 'vla-item (list oDic strKey))))
    (setq oItem nil)
  ); if
  oItem
); dict_item_get

(defun dict_item_del (uItem / bErg oOwner)
  (cond
    ((listp uItem) (setq uItem (dict_item_get (car uItem) (cdr uItem))))
    ((= (type uItem) 'STR) (setq uItem (dict_group_get nil uItem)))
  ); cond
  (cond
    ((not uItem) (setq bErg nil))
    ((and (= (vla-get-objectname uItem) "AcDbDictionary")
	  (not (equal (setq oOwner (dict_item_owner uItem))
		      (vla-get-Dictionaries (vla-get-ActiveDocument (vlax-get-acad-object))))))
     (setq bErg (not (vl-catch-all-error-p (vl-catch-all-apply 'vla-remove (list oOwner (vla-get-name uItem)))))))
    ((vlax-method-applicable-p uItem 'Erase) (setq bErg (not (vl-catch-all-error-p (vl-catch-all-apply 'vla-erase (list uItem))))))
    ((vlax-method-applicable-p uItem 'Delete) (setq bErg (not (vl-catch-all-error-p (vl-catch-all-apply 'vla-delete (list uItem))))))
  ); cond
  bErg
); dict_item_del

(defun dict_data_conv (uData / lstData symType)
  (cond
    ((and (= (setq symType (type uData)) 'STR)
	  (>= (strlen uData) 250))
     (while (/= uData "") (setq lstData (cons (cons 3 (substr uData 1 250)) lstData) uData (substr 251)))
     (setq lstData (reverse lstData)))
    ((= symType 'STR)
     (setq lstData (list (cons 1 uData))))
    ((dict_data_ispoint uData)
     (setq lstData (list (cons 10 (vlax-safearray-fill (vlax-make-safearray vlax-vbDouble (cons 0 2)) uData)))))
    ((= symType 'REAL)
     (setq lstData (list (cons 40 uData))))
    ((equal uData T)
     (setq lstData (list (cons 71 uData))))
    ((= symType 'INT)
     (setq lstData (list (cons 93 uData))))
    ((= symType 'VLA-OBJECT)
     (setq lstData (list (cons 330 uData))))
    ((= symType 'ENAME)
     (setq lstData (list (cons 331 (vlax-ename->vla-object uData)))))
  ); cond
  lstData
); dict_data_conv

(defun dict_data_pts (lstData)
  (mapcar '(lambda (lstItem)
	     (if (= (car lstItem) 10)
	       (cons 10 (vlax-safearray-fill (vlax-make-safearray vlax-vbDouble (cons 0 2)) (cdr lstItem)))
	       lstItem
	     ); if
	   ); lambda
	  lstData)
); dict_data_pts

(defun dict_data_read (uData / lstData intLast uLast)
  (foreach lstItem uData
    (setq intLast (car lstItem))
    (if (= intLast 3)
      (if uLast
	(setq uLast (strcat uLast (cdr lstItem)))
	(setq uLast (cdr lstItem))
      ); if
      (progn
	(if uLast (setq lstData (cons (cons 3 uLast) lstData) uLast nil))
	(cond
	  ((= intLast 10) (setq lstData (cons (cons 10 (vlax-safearray->list (cdr lstItem))) lstData)))
	  ((= intLast 330) (setq lstData (cons (cons 330 (dict_item_objidtoobj oDoc (car (vlax-safearray->list (cdr lstItem))))) lstData)))
	  ((= intLast 331) (setq lstData (cons (cons 331 (vlax-vla-object->ename (dict_item_objidtoobj (car (vlax-safearray->list (cdr lstItem)))))) lstData)))
	  (T (setq lstData (cons (cons intLast (cdr lstItem)) lstData)))
	); cond
      ); progn
    ); if
  ); foreach
  (reverse lstData)
); dict_data_read

(defun dict_data_isasso (lstItem)
  (and (listp lstItem)
       (= (type (car lstItem)) 'INT)
       (or (not (listp (cdr lstItem)))
	   (dict_data_ispoint (cdr lstItem))))
); dict_data_isasso

(defun dict_data_ispoint (uItem)
  (and (listp uItem)
       (= (length uItem) 3)
       (mapcar 'numberp uItem))
); dict_data_ispoint

(defun dict_data_set (uKey uData / oRec aTyp aVal lstData isRelease)
  (if (setq isRelease (listp uKey))
    (setq oRec (dict_item_create (car uKey) (cdr uKey)))
    (setq oRec uKey)
  ); if
  (cond
    ((null uData) (setq uErg (dict_item_del oRec)))
    ((and (listp uData) (apply 'and (mapcar 'dict_data_isasso uData)))
     (vlax-safearray-fill (setq aTyp (vlax-make-safearray vlax-vbInteger (cons 0 (1- (length uData))))) (mapcar 'car uData))
     (vlax-safearray-fill (setq aVal (vlax-make-safearray vlax-vbVariant (cons 0 (1- (length uData))))) (mapcar 'cdr (dict_data_pts uData))))
    ((setq lstData (dict_data_conv uData))
     (vlax-safearray-fill (setq aTyp (vlax-make-safearray vlax-vbInteger (cons 0 (1- (length lstData))))) (mapcar 'car lstData))
     (vlax-safearray-fill (setq aVal (vlax-make-safearray vlax-vbVariant (cons 0 (1- (length lstData))))) (mapcar 'cdr lstData)))
  ); cond
  (cond
    ((not (and aTyp aVal)) nil)
    ((not (vl-catch-all-error-p (vl-catch-all-apply 'vla-SetXRecordData (list oRec aTyp aVal))))
     (setq uErg uData))
  ); cond
  (if isRelease (vlax-release-object oRec))
  uErg
); dict_data_set

(defun dict_data_get (uKey / isRelease oRec lstData aTyp aVal oDoc)
  (if (setq isRelease (listp uKey))
    (setq oRec (dict_item_create (car uKey) (cdr uKey)))
    (setq oRec uKey)
  ); if
  (if (and (not (vl-catch-all-error-p (vl-catch-all-apply 'vla-GetXRecordData (list oRec 'aTyp 'aVal))))
	   aTyp (>= (vlax-safearray-get-u-bound aTyp 1) 0))
    (setq oDoc (vla-get-Document oRec)
	  lstData (dict_data_read (mapcar 'cons (vlax-safearray->list aTyp) (mapcar 'vlax-variant-value (vlax-safearray->list aVal)))))
  ); if
  (if isRelease (vlax-release-object oRec))
  lstData
); dict_data_get

(defun dict_properties_set (oObj strKey lstData / oDic lstErg)
  (if (apply 'and (mapcar 'dict_data_isasso lstData))
    (setq oDic (vla-GetExtensionDictionary oObj)
	  lstErg (dict_data_set (cons oDic strKey) lstData))
    (setq oDic (dict_group_create oObj strKey)
	  lstErg (mapcar '(lambda ( lstItem )
			    (if (dict_data_set (cons oDic (car lstItem)) (cdr lstItem))
			      lstItem
			    ); if
			  ); lambda
			 lstData))
  ); if
  (vlax-release-object oDic)
  (vl-remove nil lstErg)
); dict_properties_set

(defun dict_properties_get (uObj uKey / lstData oDic oItem)
  (setq isObject (= (type uObj) 'VLA-OBJECT))
  (cond
    ((and (or (and (= (type uObj) 'STR)
		   (setq oDic (dict_group_get uObj))
		   (= (vla-get-ObjectName oDic) "AcDbDictionary"))
	      (and isObject
		   (= (vla-get-ObjectName uObj) "AcDbDictionary")
		   (setq oDic uObj)))
	  (= (type uKey) 'STR))
     (cond
       ((not (setq uKey (dict_item_get oDic uKey))) nil)
       ((= (vla-get-ObjectName uKey) "AcDbDictionary")
	(vlax-for oItem oDic
	  (setq lstData (cons (cons (vla-get-name oItem) (cdar (dict_data_get oItem))) lstData))
	); vlax
	(setq lstData (reverse lstData)))
       (T (setq lstData (dict_data_get uKey)))
     ))

    ((or (not isObject) (= (vla-get-ObjectName uObj) "AcDbDictionary")) nil)

    ((= (vla-get-ObjectName uObj) "AcDbXrecord")
     (setq lstData (dict_data_get uObj)))

    ((and (= (vla-get-HasExtensionDictionary uObj) :vlax-true)
	  (= (type uKey) 'STR)
	  (setq oDic (vla-GetExtensionDictionary uObj))
	  (setq uKey (dict_item_get oDic uKey)))
     (if (= (vla-get-ObjectName uKey) "AcDbDictionary")
       (progn
	 (vlax-for oItem uKey
	   (setq lstData (cons (cons (vla-get-name oItem) (cdar (dict_data_get oItem))) lstData))
	 ); vlax
	 (setq lstData (reverse lstData))
       ); progn
       (setq lstData (dict_data_get uKey))
     )) 
    
  ); cond
  (vlax-release-object oDic)
  lstData
); dict_properties_get