(defun C:CHENGEFONT ()


	(defun C:CHANGETBFONT_ONINITIALIZE (/)
	  	(dcl-combobox-addlist cb-prj cb-frm "cb" (mapcar 'car style-names-list ) )
		(dcl-combobox-setcursel cb-prj cb-frm "cb" 0)
	)


	
	(defun C:CHANGETBFONT_CB_ONSELCHANGED (ItemIndexOrCount Value /)
	  	(dcl-control-setfont  cb-prj cb-frm "tb"
			(setq xttf (vl-string-right-trim ".TTF" 	(strcase (cadr (assoc Value style-names-list ) ) ) ) )
		)
		(print xttf )
	)

	
	
	(setq style-names-list '())
	(while
		(setq x-style (tblnext "style" (not x-style) ) )
		(setq	style-names-list (cons (list 	(cdr (assoc 2 x-style) ) (cdr (assoc 3 x-style ) ) ) style-names-list ) )
	)
		
	(setq cb-prj "changetbfont" cb-frm "frm")
		
	(dcl-project-load cb-prj t			)
	(dcl-form-show 	cb-prj cb-frm	)
	
)

(defun c:CF () (C:CHENGEFONT) )
