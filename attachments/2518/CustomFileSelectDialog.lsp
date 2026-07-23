(defun c:test()
  (dcl-project-load "CustomFileSelectDialog.odcl" T)
  (dcl-form-show CustomFileSelectDialog_MyDialog)
); test