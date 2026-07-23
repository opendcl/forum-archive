(defun c:UPI ( / trap:UPI UPI_Main
	         state-list Daerah-List Mukim-list Seksyen-list
	         ExistingUPI-list SchemaObject-list AllUPI-LIST
	      )

;;;===========================================================================
;; error trap
;;
 (defun trap:UPI (s) 
  (if (or (= s "Function cancelled") (= s "quit / exit abort")) 
        (progn
         (princ "\nPROGRAM UPI - exit/abort by user") 
         (princ)
        ) 
    (progn
         (princ "\nPROGRAM - Error: ")
         (princ s)(princ)
        )
  ) 
 )

;;;===========================================================================
;; UPI
;;
 (defun UPI_Main ( /
		    objDictionary FileOpen  Anydata
		    oerr *error* 
		     
		   )
;;;
;;; error trap
;;;
     (setq oerr *error*               ;save *error* 
           *error* trap:UPI            ;reassign *error* 
     )
;;;
;;; Open codec.txt file for reading UPI,State,Daerah,Mukim,Seksyen
;;; read data from codec.txt 
;;;
    
  (cond
    ((setq FileOpen (findfile "c:\\goh-lisp\\strata\\codecvl.txt"))
     (setq FileOpen (open FileOpen "r"))
     (while (= (type (setq Anydata (wg10:Read-dataVL FileOpen "|"))) 'LIST)
       (setq AllUPI-LIST (cons Anydata AllUPI-LIST))
     )
     (close FileOpen)
;;;
;;; AllUPI-list data from item 3 onwards
;;; Construct the AllUPI-List
;;; <AllUPI-List> - a list containing list of '((upi state daerah mukim seksyen) ... )
;;;
;;;
     (setq AllUPI-list (cddr (reverse AllUPI-list))
	   State-List (remove_doubles (mapcar 'cadr AllUPI-List))
     )
     (if (not AllUPI-list)
       (progn
	 (alert "Codec file error.")
	 (exit)
	 )
       )
       
     (setq objDictionary (vla-get-Dictionaries (vla-get-Activedocument (vlax-get-acad-object)))
     )
;;;     ok 13062010
;;;
;;; Check WG_DICT_SCHEMA dictionary exist or not
;;; Retrieve Lot Info details from dictionary "WG_DICT_SCHEMA" "DICT_SCHEMA"
;;; SchemaObject-List = list of strings consisting of
;;; '(UPI negeri daerah mukim seksyen
;;;   "lot number of parent lot" "skim" "pa number" "no_hakmilik" "no_fail_ukur" "no_fail_pt"
;;;   "no_fail_ptg" "diukur_oleh" "pengukur_noic" "tarikh_siap" "bilangan_petak bilangan_aksesori"
;;;   "tarikh_terima_sijil_akuan" "tarikh_lulus_permohonan" "bayaran_ukur" "bayaran_pelan" "ulasan_jupem"
;;;   "nama_pemaju ""nama_perbadanan_pengurusan" "nama_projek" "no_ruj_jubl" "no_ruj_ljt" "no_fail_ukursemula"
;;;   "kodtujuanukur 18=pecahan 17=cantuman" "jumlah_unit_syer")
;;; "SchemaObject-list "
;;; ("010101000" "JOHOR" "BATU PAHAT" "BAGAN" "0" "" "" "" "" "" "" "" "" "" "" "" 
;;;  "" "" "" "" "" "" "" "" "" "" "" "" "" "")
;;; total 30 items in list
;;;     
     (setq SchemaObject-Dict (wg10:Xrecord-Get "WG_DICT_SCHEMA" "DICT_SCHEMA"))
;;   SchemaObject-Dict -   :<list dotted pairs (list '(lstDXFCodes . lstDXFValues) .....)>
     (if SchemaObject-Dict
       (setq SchemaObject-list (mapcar 'cdr SchemaObject-Dict))
       (setq SchemaObject-list (list (car (setq ExistingUPI-list
						 (car AllUPI-list)))     ; UPI code
				     (cadr ExistingUPI-list)             ; Negeri 
				     (caddr ExistingUPI-list)            ; Daerah 
				     (cadddr ExistingUPI-list)           ; Mukim 
				     (last ExistingUPI-list)             ; Seksyen 
				     ""                                  ; lot number of parent lot
				     ""                                  ; skim
				     ""                                  ; pa number
				     ""                                  ; no_hakmilik
				     ""                                  ; no_fail_ukur
				     ""                                  ; no_fail_pt
				     ""                                  ; no_fail_ptg
				     ""                                  ; diukur_oleh
				     ""                                  ; pengukur_noic
				     ""                                  ; tarikh_siap
				     ""                                  ; bilangan_petak
				     ""                                  ; bilangan_aksesori
				     ""                                  ; tarikh_terima_sijil_akuan
				     ""                                  ; tarikh_lulus_permohonan
				     ""                                  ; bayaran_ukur
				     ""                                  ; bayaran_pelan
				     ""                                  ; ulasan_jupem
				     ""                                  ; nama_pemaju
				     ""                                  ; nama_perbadanan_pengurusan
				     ""                                  ; nama_projek
				     ""                                  ; no_ruj_jubl
				     ""                                  ; no_ruj_ljt
				     ""                                  ; no_fail_ukursemula
				     ""                                  ; kodtujuanukur 18=pecahan 17=cantuman
				     ""                                  ; jumlah_unit_syer
			       )
	   )
     )

;;;
;;;     Build the daerah-list for the existing state
;;;     Daerah-list = list of string consisting all the daerah of the state '(daerah daerah ...)
;;;     "daerah-list " =
;;;     eg ("BATU PAHAT" "JOHOR BAHRU" "KLUANG" "KOTA TINGGI" "MERSING" "MUAR" "PONTIAN" "SEGAMAT")
;;;     
     (setq Daerah-list (remove_doubles
			 (vl-remove nil
			   (mapcar (function (lambda (x)
					       (if (= (cadr ExistingUPI-list) (cadr x))
						 (caddr x)
						 )
					       )
					     )
				   AllUPI-list
				   )
			  )
			 )
     )
;;;
;;;     Build the mukim-list for the existing daerah
;;;     Mukim-list = list of string consisting all the mukim/bandar/pekan of the daerah '(mukim mukim ...)
;;;     "Mukim-list " =
;;;     eg ("BAGAN" "CHAAH BAHRU" "KAMPUNG BAHRU" "LINAU" "LUBOK" "MINYAK BEKU"
;;;         "PESERAI" "SERI GADING" "SERI MEDAN" "SIMPANG KANAN" "SIMPANG KIRI"
;;;         "SUNGAI KLUANG" "SUNGAI PUNGGOR" "TANJUNG SEMBRONG"  "AYER HITAM"
;;;         "BANDAR PENGGARAM" "RENGIT" "SENGGARANG" "YONG PENG")
;;;     
     (setq Mukim-list (remove_doubles
			 (vl-remove nil
			   (mapcar (function (lambda (x)
					       (if (and
						     (= (cadr ExistingUPI-list) (cadr x))
						     (= (caddr ExistingUPI-list) (caddr x))
						    )
						 (cadddr x)
						 )
					       )
					     )
				   AllUPI-list
				   )
			  )
			 )
     )
;;;
;;;     Build the -list for the existing mukim/bandar/pekan
;;;     Seksyen-list = list of string consisting all the seksyen of the mukim/bandar/pekan '(0 1 2 ...)
;;;     "Seksyen-list " =
;;;     eg ("0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22"
;;;     "23" "24" "25" "26" "27" "28" "29" "30" "31" "32" "33" "34" "35" "36" "37" "38" "39" "40" "41" "42" "43" "44"
;;;     "45" "46" "47" "48" "49" "50" "51" "52" "53" "54" "55" "56" "57" "58" "59" "60" "61" "62" "63" "64" "65" "66"
;;;     "67" "68" "69" "70" "71" "72" "73" "74" "75" "76" "77" "78" "79" "80" "81" "82" "83" "84" "85" "86" "87" "88"
;;;     "89" "90" "91" "92" "93" "94" "95" "96" "97" "98" "99" "100" "101" "102" "103" "104" "105" "106" "107" "108"
;;;     "109" "110" "111" "112" "113" "114" "115" "116" "117" "118" "119" "120" "121" "122" "123" "124" "125" "126"
;;;     "127" "128" "129" "130" "131" "132" "133" "134" "135" "136" "137" "138" "139" "140" "141" "142" "143" "144"
;;;     "145" "146" "147" "148" "149" "150" "151" "152" "153" "154" "155" "156" "157" "158" "159" "160" "161" "162"
;;;     "163" "164" "165" "166" "167" "168" "169" "170" "171" "172" "173" "174" "175" "176" "177" "178" "179"
;;;     "180" "181" "182" "183" "184" "185" "186" "187" "188" "189" "190" "191" "192" "193" "194" "195" "196" "197"
;;;     "198" "199" "200" "85A" "86A" "87A" "88A" "89A" "90A" "91A" "92A" "93A" "94A" "94B" "95A" "96A")
;;;     
     (setq Seksyen-list (remove_doubles
			 (vl-remove nil
			   (mapcar (function (lambda (x)
					       (if (and
						     (= (cadr ExistingUPI-list) (cadr x))
						     (= (caddr ExistingUPI-list) (caddr x))
						     (= (cadddr ExistingUPI-list) (cadddr x))
						    )
						 (last x)
						 )
					       )
					     )
				   AllUPI-list
				   )
			  )
			 )
     )
     )
;;;
;;; Exit codec file not found
;;;
    
    ((not Fileopen)
     (alert "\nUPI Code File \"codec.txt\" not found.
	    \nEnsure this file in \"c:\\goh-lisp\\strata\" folder")
     (exit)
    )
  )

 ) ;; UPI_main

;;;
;;;		 start here
;;;
		 (UPI_main)
   (dcl_Project_Load "UPI" T)
   (dcl_Form_Show UPI_frmUPI)
   (princ)
 )


  (defun c:UPI_frmUPI_OnInitialize (/)
   (dcl_ComboBox_AddList UPI_frmUPI_cbNegeri State-list)
   (dcl_ComboBox_SetCurSel UPI_frmUPI_cbNegeri (vl-position (cadr ExistingUPI-list) State-list))
   (dcl_ComboBox_AddList UPI_frmUPI_cbDaerah Daerah-list)
   (dcl_ComboBox_SetCurSel UPI_frmUPI_cbDaerah (vl-position (caddr ExistingUPI-list) Daerah-list))
   (dcl_ComboBox_AddList UPI_frmUPI_cbMukim Mukim-list)
   (dcl_ComboBox_SetCurSel UPI_frmUPI_cbMukim (vl-position (cadddr ExistingUPI-list) Mukim-list))
   (dcl_ComboBox_AddList UPI_frmUPI_cbSeksyen Seksyen-list)
   (dcl_ComboBox_SetCurSel UPI_frmUPI_cbSeksyen (vl-position (last ExistingUPI-list) Seksyen-list))
   (dcl_Control_SetText UPI_frmUPI_tbLotNo (nth 5 SchemaObject-list))
  )

(defun c:UPI_frmUPI_tbuttonOK_OnClicked (/)
  (setq StateNew (nth (dcl_ComboBox_GetCurSel UPI_frmUPI_cbNegeri) State-list)
	DaerahNew (nth (dcl_ComboBox_GetCurSel UPI_frmUPI_cbDaerah) Daerah-list)
	MukimNew (nth (dcl_ComboBox_GetCurSel UPI_frmUPI_cbMukim) Mukim-List)
	SeksyenNew (nth (dcl_ComboBox_GetCurSel UPI_frmUPI_cbSeksyen) Seksyen-list)
  )
     (setq ExistingUPI-list (car (remove_doubles
			 (vl-remove nil
			   (mapcar (function (lambda (x)
					       (if (and
						     (= StateNew (cadr x))
						     (= DaerahNew (caddr x))
						     (= MukimNew (cadddr x))
						     (= SeksyenNew (last x))
						    )
						  x
						 )
					       )
					     )
				   AllUPI-list
				   )
			  )
			 ))
     )
     (setq LotNo (dcl_Control_GetText UPI_frmUPI_tbLotNo))
     (if (or (= LotNo "") (wcmatch LotNo "*-*"))
       (progn
        (alert "Lot Number must be greater than 0")
	(dcl_Control_SetText UPI_frmUPI_tbLotNo (nth 5 SchemaObject-list))
       )
       (progn
        (dcl_Form_Close UPI_frmUPI)
       )
     )
 )


  (defun c:UPI_frmUPI_cbNegeri_OnSelChanged (ItemIndexOrCount Value /)
  (dcl_ComboBox_Clear UPI_frmUPI_cbDaerah)
;;;
;;;    Rebuilds Daerah-list
;;;    
    (setq Daerah-list (remove_doubles
			 (vl-remove nil
			   (mapcar (function (lambda (x)
					       (if (= (setq StateNew value) (cadr x))
						 (caddr x)
						 )
					       )
					     )
				   AllUPI-list
				   )
			  )
			 )
     )
    (dcl_ComboBox_AddList UPI_frmUPI_cbDaerah Daerah-list)
    (dcl_ComboBox_SetCurSel UPI_frmUPI_cbDaerah (vl-position (setq DaerahNew (car Daerah-list)) Daerah-list))
;;;
;;; Rebuilds Mukim-list
;;;
     (dcl_ComboBox_Clear UPI_frmUPI_cbMukim)
     (setq Mukim-list (remove_doubles
			 (vl-remove nil
			   (mapcar (function (lambda (x)
					       (if (and
						     (= StateNew (cadr x))
						     (= DaerahNew (caddr x))
						    )
						 (cadddr x)
						 )
					       )
					     )
				   AllUPI-list
				   )
			  )
			 )
     )
    (dcl_ComboBox_AddList UPI_frmUPI_cbMukim Mukim-list)
    (dcl_ComboBox_SetCurSel UPI_frmUPI_cbMukim (vl-position (setq MukimNew (car Mukim-list)) Mukim-list))
;;;
;;; Rebuilds Seksyen-list
;;;
     (dcl_ComboBox_Clear UPI_frmUPI_cbSeksyen)
     (setq Seksyen-list (remove_doubles
			 (vl-remove nil
			   (mapcar (function (lambda (x)
					       (if (and
						     (= StateNew (cadr x))
						     (= DaerahNew (caddr x))
						     (= MukimNew (cadddr x))
						    )
						 (last x)
						 )
					       )
					     )
				   AllUPI-list
				   )
			  )
			 )
     )
    (dcl_ComboBox_AddList UPI_frmUPI_cbSeksyen Seksyen-list)
    (dcl_ComboBox_SetCurSel UPI_frmUPI_cbSeksyen (vl-position (setq SeksyenNew (car Seksyen-list)) Seksyen-list))
  )

(defun c:UPI_frmUPI_cbDaerah_OnSelChanged (ItemIndexOrCount Value /)
;;;
;;; Rebuilds Mukim-list
;;;
     (dcl_ComboBox_Clear UPI_frmUPI_cbMukim)
     (setq Mukim-list (remove_doubles
			 (vl-remove nil
			   (mapcar (function (lambda (x)
					       (if (and
						     (= StateNew (cadr x))
						     (= (setq DaerahNew value) (caddr x))
						    )
						 (cadddr x)
						 )
					       )
					     )
				   AllUPI-list
				   )
			  )
			 )
     )
    (dcl_ComboBox_AddList UPI_frmUPI_cbMukim Mukim-list)
    (dcl_ComboBox_SetCurSel UPI_frmUPI_cbMukim (vl-position (setq MukimNew (car Mukim-list)) Mukim-list))
;;;
;;; Rebuilds Seksyen-list
;;;
     (dcl_ComboBox_Clear UPI_frmUPI_cbSeksyen)
     (setq Seksyen-list (remove_doubles
			 (vl-remove nil
			   (mapcar (function (lambda (x)
					       (if (and
						     (= StateNew (cadr x))
						     (= DaerahNew (caddr x))
						     (= MukimNew (cadddr x))
						    )
						 (last x)
						 )
					       )
					     )
				   AllUPI-list
				   )
			  )
			 )
     )
    (dcl_ComboBox_AddList UPI_frmUPI_cbSeksyen Seksyen-list)
    (dcl_ComboBox_SetCurSel UPI_frmUPI_cbSeksyen (vl-position (setq SeksyenNew (car Seksyen-list)) Seksyen-list))
)

(defun c:UPI_frmUPI_cbMukim_OnSelChanged (ItemIndexOrCount Value /)
;;;
;;; Rebuilds Seksyen-list
;;;
     (dcl_ComboBox_Clear UPI_frmUPI_cbSeksyen)
     (setq Seksyen-list (remove_doubles
			 (vl-remove nil
			   (mapcar (function (lambda (x)
					       (if (and
						     (= StateNew (cadr x))
						     (= DaerahNew (caddr x))
						     (= (setq MukimNew value) (cadddr x))
						    )
						 (last x)
						 )
					       )
					     )
				   AllUPI-list
				   )
			  )
			 )
     )
    (dcl_ComboBox_AddList UPI_frmUPI_cbSeksyen Seksyen-list)
    (dcl_ComboBox_SetCurSel UPI_frmUPI_cbSeksyen (vl-position (setq SeksyenNew (car Seksyen-list)) Seksyen-list))
)

(defun c:UPI_frmUPI_tbLotNo_OnEditChanged (NewValue /)
  (if (<= (atof newvalue) 0)
    (progn
      (alert "No Negative Lot Number")
;      (dcl_Control_SetText UPI_frmUPI_tbLotNo (nth 5 SchemaObject-list))
    )
;    (setq a newvalue)
  )
)
