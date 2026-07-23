;;; -------------------------------------------------------------------------------------------------------------------
;;;Pega o espaco ativo no desenho corrente seja qual for
  (defun JoyGetActiveSpace (/ JoyDoc JoySpace)
    (setq JoyDoc   (vla-get-ActiveDocument (vlax-get-Acad-Object))
	  JoySpace (if (zerop (vla-get-activespace JoyDoc)) ;_paperspace
		     (if (= (vla-get-mspace JoyDoc) :vlax-true)
		       (vla-get-modelspace JoyDoc)
		       (vla-get-paperspace JoyDoc)
		     ) ;_ fim de if
		     (vla-get-modelspace JoyDoc)
		   ) ;_ fim de if
    ) ;_ fim de setq
;;;Descarta #<VLA-OBJECT 
    (vlax-Release-Object JoyDoc)
    JoySpace
  ) ;_ fim de defun
;;; -------------------------------------------------------------------------------------------------------------------
(defun c:Blki (/ intform oBlock)
;;;CARREGA O PROJETO
  (dcl_Project_Load "MyProj")

;;;
  (defun c:MyProj_MyForm_pb_Cancel_OnClicked ()
    (dcl_form_close MyProj_MyForm 2)
;;; (setq intForm (dcl_form_close MyProj_MyForm 2))
  )			
;;;
  (defun c:MyProj_MyForm_pb_BlockInsert_OnClicked ()
    (dcl_form_close MyProj_MyForm 3)
;;;    (setq intForm (dcl_form_close MyProj_MyForm 3))
  ) ;_ fim de defun
;;;  
  (setq doCont T)
  (while doCont
    (setq doCont nil)
    (setq intForm (dcl_form_show MyProj_MyForm))
    (cond
      ((= intForm 2) (setq doCont nil)) ;_ Cancelling the form via ESC or c:MyProj_MyForm_pb_Cancel_OnClicked
      ((= intForm 3)
       (if (and	(setq JoyInsPt (vl-catch-all-apply
				 'getpoint
				 (list "\nPick a point to insert block: ")
			       ) ;_ fim de vl-catch-all-apply
		) ;_ fim de setq
		(not (vl-catch-all-error-p JoyInsPt))
	   ) ;_ fim de and
	   (setq oBlock	(vla-insertBlock (JoyGetActiveSpace) ;_Pega o espaco ativo  
					 (vlax-3d-point JoyInsPt)
					 "Bola"
					 1 ;_xscalefactor  
					 1 ;_ yscalefactor ent
					 1 ;_ zscalefactor  
					 0 ;_rotation
			) ;_ fim de vla-insertBlock
	   ) ;_ fim de setq
       ) ;_ fim de if
      )
    ) ;_ fim de cond
  ) ;_ fim de while
) ;_ fim de defun
;;; -------------------------------------------------------------------------------------------------------------------
