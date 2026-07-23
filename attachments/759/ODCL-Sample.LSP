

(defun c:LoadSignTab ()

   (command "opendcl")
   (dcl_project_load "ODCL-Sample" t)

   (dcl_form_show ODCL-Sample_formSignTab)

   (princ)

) ;_ end of defun

(defun c:SelObj	( / *OBJ_ENAME *OBJ_LAYER )

   (setq *Obj_Ename (car (entsel "\n Select Object!")))
   (setq *Obj_Layer (cdr (assoc 8 (entget *Obj_Ename))))

   (command "opendcl")
   (dcl_project_load "ODCL-Sample" t)

   (cond
      ((= *Obj_Layer "DRAZ0801")
       (dcl_form_show ODCL-Sample_formP_SIDE)
      )
   ) ;_ end of cond
) ;_ end of defun




(defun c:ODCL-Sample_formP_SIDE_btnCancel_OnClicked (/)
   (dcl_form_close ODCL-Sample_formP_SIDE)
) ;_ end of defun

