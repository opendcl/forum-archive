(defun c:ControlBackColor(/ c:project/dialog#OnInitialize
			    c:project/dialog/pbFormBackColor#OnClicked
			    c:project/dialog/pbRectBackColor#OnClicked)
  (if (not dcl-project-load) (command "opendcl"))
  (if (and (not project/dialog) (findfile "d:\\project.odcl")) (dcl-project-load "d:\\project.odcl"))

  (if project/dialog
    (progn

      (defun c:project/dialog#OnInitialize (/)
	(dcl-Control-SetBackColor project/dialog -16)
	(dcl-Control-SetBackColor project/dialog/rectangle -16)
      ); c:project/dialog#OnInitialize

      (defun c:project/dialog/pbFormBackColor#OnClicked (/)
	(dcl-Control-SetBackColor project/dialog 1)
      ); c:project/dialog/pbFormBackColor#OnClicked

      (defun c:project/dialog/pbRectBackColor#OnClicked (/)
	(dcl-Control-SetBackColor project/dialog/rectangle 1)
      ); c:project/dialog/pbRectBackColor#OnClicked

      (dcl-Form-Show project/dialog)
      
    ); progn
  ); if

  (princ)
); c:ControlBackColor
  