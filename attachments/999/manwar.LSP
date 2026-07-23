
(dcl_Project_Load "manwar" T)
(dcl_Form_Show "manwar" "Form1")


(dcl_Grid_Clear "manwar" "Form1" "Grid1")

; list of layers data definition" In orginal it's read from file
(setq bb_lista_warstw
       (list
	 (list "bb_w_attyka" "K_attyka" "220" "continuous")
	 (list "bb_w_belka" "K_belka" "3" "continuous")
	 (list "bb_w_hatch" "K_hatch" "9" "continuous")
	 (list "bb_w_kota" "K_kota" "6" "continuous")
	 (list "bb_w_obrys_plyty" "K_obrys_plyty" "5" "continuous")
	 (list "bb_w_opis_otw_w_stropie" "K_opis_otw_w_stropie" "240" "continuous")
	 (list "bb_w_opis_otw_w_scianie" "K_opis_otw_w_scianie" "230" "continuous")
	 (list "bb_w_opis_plyty" "K_opis_plyty" "2" "continuous")
	 (list "bb_w_opis_przekroj" "K_opis_przekroj" "80" "continuous")
	 (list "bb_w_os_konst" "K_os_konst" "252" "ACAD_ISO10W100")
	 (list "bb_w_otwor_w_stropie" "K_otwor_w_stropie" "232" "continuous")
	 (list "bb_w_otwor_w_scianie" "K_otwor_w_scianie" "20" "continuous")
	 (list "bb_w_K_przekroj" "k_przekroj" "52" "continuous")
	 (list "bb_w_schody" "K_schody" "100" "continuous")
	 (list "bb_w_K_slup_zelbnad" "K_slup_zelb_nad" "200" "HIDDEN2")
	 (list "bb_w_slup_zelb_pod" "K_slup_zelb_pod" "50" "continuous")
	 (list "bb_w_solid" "K_solid" "16" "continuous")
	 (list "bb_w_strop" "k_strop" "192" "continuous")
	 (list "bb_w_sciana_zelb_nad" "K_sciana_zelb_nad" "210" "HIDDEN2")
	 (list "bb_w_sciana_zelb_pod" "K_sciana_zelb_pod" "40" "continuous")
	 );list
      );setq

(setq bb_licz 0)

(repeat (length bb_lista_warstw)
  
  (setq nrow (dcl_Grid_AddRow "manwar" "Form1" "Grid1" (rtos (1+ bb_licz) 2 0) "" "" (nth 1 (nth bb_licz bb_lista_warstw) )))
  (setq bb_licz (1+ bb_licz))
  (dcl_Grid_SetCellStyle "manwar" "Form1" "Grid1" nrow 1 1)
  (dcl_Grid_SetCellStyle "manwar" "Form1" "Grid1" nrow 2 1)
  (dcl_Grid_SetCellStyle "manwar" "Form1" "Grid1" nrow 3 2)
  
  
);repeat

(dcl_Control_Redraw "manwar" "Form1" "Grid1")
