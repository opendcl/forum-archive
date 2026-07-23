
;(odcl_define_datum "ED-50" "30" nil)
(defun odcl_define_datum (datum huso sur? / ls)

  (Dcl_LoadProject "Media.odcl" nil)

  (defun c:Media_datum_OnInitialize (/)
    (dcl_ComboBox_SelectString Media_datum_datu datum)
    (dcl_Control_SetText Media_datum_huso huso)
    (dcl_ComboBox_SetCurSel Media_datum_norte (if sur? 1 0))
    (dcl_Control_SetCaption Media_datum_err "")
  )

  (defun c:Media_datum_Cancel_OnClicked (/)(setq ls nil)(dcl_Form_Close Media_datum))

  (defun c:Media_datum_OK_OnClicked (/ hu)
    (setq hu (atoi (dcl_Control_GetText Media_datum_huso)))
    (cond
      ((not (< 0 hu 61)) (dcl_Control_SetCaption Media_datum_err "El huso debe estar entre 1 y 60"))
      (T (setq ls (list
	       (dcl_ComboBox_GetEBText Media_datum_datu)
	       (dcl_Control_GetText Media_datum_huso)
	       (= (dcl_ComboBox_GetEBText Media_datum_norte) "S")))
       (dcl_Form_Close Media_datum)))
  )


(dcl_Form_Show Media_datum)
ls
)