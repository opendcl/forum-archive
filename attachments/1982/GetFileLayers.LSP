;; -----------------------------------------------------------
;; Read Layers using DBX
;; -----------------------------------------------------------


(defun GetFileLayers (strDwg / oDbx oLayer lstLayers)
  (if (and (setq oDbx (vl-catch-all-apply 'vla-GetInterfaceObject (list (vlax-get-acad-object) (strcat "ObjectDBX.AxDbDocument." (substr (getvar "ACADVER") 1 2)))))
	   (not (vl-catch-all-error-p oDbx)))
    (if (vl-catch-all-error-p (vl-catch-all-apply 'vla-open (list oDbx strDwg)))
      (vlax-release-object oDbx)
      (progn
	(vlax-for oLayer (vla-get-layers oDbx) (setq lstLayers (cons (vla-get-name oLayer) lstLayers)))
	(vlax-release-object oDbx)
      ); progn
    ); if
  ); if
); GetFileLayers



;; -----------------------------------------------------------
;; Read Layers using OnDocActivated
;; -----------------------------------------------------------


;; -----------------------------------------------------------
;; Event for temporary Event

(defun c:wait_form_OnDocActivated (/ strFile strDwg)
  (cond
    ((not (setq strFile (vl-bb-ref '***GetFileLayersActiveDrawing***))) nil)
    ((= strFile (if (/= (setq strDwg (vla-get-fullname (vla-get-ActiveDocument (vlax-get-acad-object)))) "") strDwg (getvar "DWGNAME")))
     (if (vl-bb-ref '***GetFileLayersReady***)
       (progn
    	 (princ "\nI'm back!\n")
;    	 (alert "I'm back!")
    	 (vl-bb-set '***GetFileLayersActiveDrawing*** nil)
    	 (vl-bb-set '***GetFileLayersReady*** nil)
    	 (if (dcl_form_isactive wait_form) (dcl_Form_Close wait_form))
       ); progn
       (dcl_DelayedInvoke 1000 "c:GetFileLayersActivate")
     ))
    (T (dcl_DelayedInvoke 1000 "c:GetFileLayersRead"))
  ); cond
  (princ)
); c:wait_form_OnDocActivated

;; -----------------------------------------------------------
;; Since Focus returns to calling drawing, newly opened
;; drawing has to be activated

(defun c:GetFileLayersActivate()(vla-activate (vla-item (vla-get-documents (vlax-get-acad-object)) (1- (vla-get-count (vla-get-documents (vlax-get-acad-object)))))))

;; -----------------------------------------------------------
;; Starting command

(defun c:GetFileLayersRead(/ lstLayers strFile oLayer lstLayers )
    (acad-push-dbmod)
  (if (and (setq lstLayers (vl-bb-ref '***GetFileLayers***))
	   (setq strFile (vla-get-fullname (vla-get-ActiveDocument (vlax-get-acad-object))))
	   (/= strFile "")
	   (= (car lstLayers) strFile))
    (progn
      (setq lstLayers '())
      (vlax-for oLayer (vla-get-layers (vla-get-ActiveDocument (vlax-get-acad-object))) (setq lstLayers (cons (vla-get-name oLayer) lstLayers)))
      (setq lstLayers (cons strFile lstLayers))
      (vl-bb-set '***GetFileLayers*** lstLayers)
      (vl-bb-set '***GetFileLayersReady*** T)
;      (command "_line" "0,0" "1,1" "")
      (dcl_Control_SetCaption wait_form_Bezeichnung1 "Please close!")
      (princ "\nI've read the layers!\n")
      (setvar "CMDDIA" 1)
      (setvar "FILEDIA" 1)
      ;(command "._Close")
      ;(dcl_SendString "_CLOSE\n")
      (if (> (getvar "DbMod") 0)
        (acad-pop-dbmod)
      )
      (dcl_SendString "_Close\n")
;      (if (> (getvar "DbMod") 0) (command "_Yes"))
    ); progn
  ); if

  (princ)
); c:GetFileLayersRead

(defun c:GetFileLayers(/ strFile lstLayers strDwg)
  (if (and (setq strFile (vl-catch-all-apply 'getfiled (list "Select drawing" (getvar "DWGPREFIX") "dwg" 0)))
	   (not (vl-catch-all-error-p strFile)))
    (progn
      (vl-bb-set '***GetFileLayers*** (list strFile))
      (if (= (setq strDwg (vla-get-fullname (vla-get-ActiveDocument (vlax-get-acad-object)))) "")
	(setq strDwg (getvar "DWGNAME"))
      ); if
      (vl-bb-set '***GetFileLayersActiveDrawing*** strDwg)
      (vl-bb-set '***GetFileLayersReady*** nil)

      (if (not dcl_project_load) (command "_opendcl"))
      (if (not (member "wait" (dcl_getprojects))) (dcl_project_load "wait"))
      (if (not (dcl_form_isactive wait_form)) (dcl_Form_Show wait_form))
      (dcl_Control_SetCaption wait_form_Bezeichnung1 "Please wait!")

      (setvar "CMDDIA" 0)
      (setvar "FILEDIA" 0)
      
      (vla-open (vla-get-Documents (vlax-get-acad-object)) strFile :vlax-false)
    ); progn
  ); if
  (princ)
); c:GetFileLayers

(princ "\r\nLoad this file using (vl-load-all \"GetFileLayers.lsp\")")
(princ "\r\nDBX: (GetFileLayers \"c:\\files\\drawing.dwg\"")
(princ "\r\nCommand: GetFileLayers")
;; (vl-load-all "GetFileLayers.lsp")

(princ)