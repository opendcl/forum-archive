(defun c:reopen (/ oAcad oDocs oDoc strFile intAnswer)
  (setq oAcad (vlax-get-acad-object))
  (setq oDoc (vla-get-ActiveDocument oAcad))
  (setq oDocs (vla-get-Documents oAcad))
  (setq strFile (vla-get-FullName oDoc))

  (if (not (zerop (getvar "DBMOD")))
    (progn
      (setq intAnswer (dcl_messagebox (strcat "Do you want to save changes to " strFile ", " (getvar "LOGINNAME") "?") "Reopen drawing" 6 3))
      (if (= intAnswer 6) (if (= (getvar "WRITESTAT") 1) (vla-save oDoc)))
    ); progn
  ); if

  (if (or (not intAnswer) (member intAnswer '( 6 7 )))
    (progn
      (dcl_project_load "reopen")

      ;; Make sure, another drawing is open
      
      (if (= (vla-get-count oDocs) 1)
        (vlax-release-object (vla-Add oDocs))
      ); if

      ;; Show the modeless form afterwards
      
      (if (dcl_Form_IsActive reopen_reopen)
        (c:reopen_reopen_OnInitialize)
        (dcl_form_show reopen_reopen)
      ); if
      (vl-cmdf "_close")
    ); progn
  ); if
  (princ)
); reopen

(defun c:reopen_reopen_OnInitialize (/)
  (if strFile
    (dcl_Control_SetText reopen_reopen_edt_file strFile)
    (dcl_Control_SetText reopen_reopen_edt_file "")
  ); if
); c:reopen_reopen_OnInitialize

(defun c:reopen_reopen_OnEnteringNoDocState (/ oDoc)
  (setq oDoc (vla-Add (vla-get-documents (vlax-get-acad-object))))
  (vlax-release-object oDoc)
); c:reopen_reopen_OnEnteringNoDocState

(defun c:reopen_reopen_OnDocActivated (/ strFileToOpen oDoc)

  ;; This event will also be called in the drawing which is about to get reopened
  ;; but at this time the form isn't active anymore!
  
  (if (dcl_Form_IsActive reopen_reopen)
    (progn
      (if (and (setq strFileToOpen (dcl_Control_GetText reopen_reopen_edt_file))
               (findfile strFileToOpen)
               (dcl_Control_SetText reopen_reopen_edt_file "") ;; to avoid a loop
               (setq oDoc (vl-catch-all-apply 'vla-open (list (vla-get-documents (vlax-get-acad-object)) strFileToOpen)))
               (not (vl-catch-all-error-p oDoc)))
        (vla-Activate oDoc)
      ); if
      (dcl_Control_SetText reopen_reopen_edt_file "")
      (dcl_form_close reopen_reopen)
    ); progn
  ); if
); c:reopen_reopen_OnDocActivated

(vl-load-com)
(command "_opendcl")
(princ "Call the command REOPEN.")
(princ)