(defun C:BPC ( / )
(command "OPENDCL")
(dcl_Project_Load "BWPC" T)
(dcl_Form_Show BWPC_BWpara)
(princ)
)


(defun c:BWPC_BWpara_OnInitialize (/ )
  (vl-load-com)
  (defun ax:layer-list (/ lst layer)
   (vlax-for layer (vla-get-Layers
                    (vla-get-ActiveDocument
                      (vlax-get-acad-object)
                    )
                  )
        (setq lst (cons
                (list
                  (vla-get-name layer)
                ) lst))
  )
  (vl-sort lst
           (function (lambda (e1 e2)
                       (< (strcase (car e1)) (strcase (car e2)))
                     )
           )
  )
  (princ lst)
  (setq lstwhole lst)
)
  )




(defun c:BWPC_BWpara_Layerlist_OnDropDown (/)
(dcl_ComboBox_AddList BWPC_BWpara_Layerlist NewItems lstwhole)
)


