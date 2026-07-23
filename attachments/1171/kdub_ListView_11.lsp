(vl-load-com)
(command "_OPENDCL")

(defun c:doit (/ layernamelist dialogreturn)
  (setq layernamelist '("0"          "Layer1"     "Layer2"
                        "Layer3"     "Layer4"     "Layer5"
                        "Layer6"     "Layer7"     "Layer8"
                        "Layer9"     "Layer10"    "Layer11"
                        "Layer12"
                       )
  )
  (dcl_project_load "kdub_ListView_11.odcl" t)
  ;; Show the main form
  (setq dialogreturn (dcl_form_show kdub_listview_11_main))
  ;;------
  (princ)
)

 ;|<<OpenDCL Event Handlers>>|;
(defun c:kdub_listview_11_main_oninitialize (/)
  (dcl_listview_addcolumns
    kdub_listview_11_main_listview1
    '(("Layer Name" 0 100) ("Col 2" 0 50) ("Col 3" 0 50))
  )
  (dcl_listview_addstring kdub_listview_11_main_listview1
                          "Item 1\tItem 1-2\tItem 1-3"
  )
)
(defun c:kdub_listview_11_main_textbutton1_onclicked (/)
  (setq populatelist1 (mapcar '(lambda (x) (list x)) layernamelist))
  (dcl_listview_filllist kdub_listview_11_main_listview1
                         populatelist1
  )
)
(princ " << Enter DOIT to run >> \n")
(princ)


 ;|«Visual LISP© Format Options»
(70 2 45 2 nil "end of " 70 60 1 1 0 nil nil nil T)
;*** DO NOT add text below the comment! ***|;
