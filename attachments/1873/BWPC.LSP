(defun C:BPC ( / )
(command "OPENDCL")
(dcl_Project_Load "BWPC" T)
(dcl_Form_Show BWPC_BWpara)
(princ)
)



(defun c:BWPC_BWpara_OnInitialize (/)
	(dcl_ListBox_Clear BWPC_BWpara_Entlist)
	;(dcl_LISTBOX_ADDLIST BWPC_BWpara_entlist (GetEList))

  )

(defun c:BWPC_BWpara_Layerlist_OnSelChanged (nSelection sSelText /)
  	(setq myFilter(list (cons 8 sSelText)))
        (setq elist (list (ssget "X" myFilter)))
	(princ elist);just here so i can see what result is
  	(vl-load-com)
  	;(mapcar 'vl-princ-to-string elist )
	;(dcl_ListBox_AddList BWPC_BWpara_ListBox1 elist)
)
