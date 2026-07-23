
;; gridTEST .
;; 

(defun c:gridtest ()

   (dcl_project_import (F:Sub_Import_gridTEST_ODCL_Form) nil nil)
   
   (dcl_Form_Show gridTEST_Form 500 150)

   (princ)
)




(defun c:gridTEST_Form_OnInitialize ( / *CELL_VAL_LIST *CODEDESC *CODE_VAL *ROW_NUM)

   (dcl_Grid_Clear gridTEST_Form_gridCODE)

   (dcl_ComboBox_Clear gridTEST_Form_cboCODE)
   
   (setq *Row_Num 1)
   (setq *Cell_Val_List (F:Get_Cells_Val))

   (foreach *Item *Cell_Val_List

      (setq *CodeDesc (car *Item))
      (setq *Code_Val (cadr *Item))

      ;; add Item to Grid
      (dcl_Grid_AddString
	 gridTEST_Form_gridCODE
	 (strcat (itoa *Row_Num) "\t" *CodeDesc "\t" *Code_Val "\t Block Name" )
      )

      (setq *Row_Num (1+ *Row_Num))

      ;; add Item to Combo
      (dcl_ComboBox_AddString gridTEST_Form_cboCODE *Code_Val)

      (princ "\n")(princ *CodeDesc)
      (princ " - ")(princ *Code_Val)
   )

   (princ)
   
)


(defun c:gridTEST_Form_cboCODE_OnSelChanged (ItemIndexOrCount Value / *CELL_CODE_VAL *CELL_DATA_LIST *DONE *MATCH_ROW)

   (setq *Cell_Data_List (F:Get_Cells_Val))

   (setq *Match_Row 0)
   (foreach *Item *Cell_Data_List
      (setq *Cell_Code_Val (cadr *Item))

      (if (= *Cell_Code_Val Value)
	 (progn
	    (setq *Done *Match_Row)
	 ) ;_ End of progn
      ) ;_ End of if

      (setq *Match_Row (1+ *Match_Row))
      
   ) ;_ End of foreach

   (if *Done
      (progn
;;;	 (if (< *Done 2)
;;;	    (progn
;;;	       (dcl_Grid_SetCurCell mrCODEPro_Form_gridCODE 0 2)
;;;	       (dcl_Grid_SetCurCell mrCODEPro_Form_gridCODE *Done 2)
;;;	       (dcl_Grid_SetCurCell mrCODEPro_Form_gridCODE 0 2)
;;;	       (dcl_Grid_SetCurCell mrCODEPro_Form_gridCODE *Done 2)
;;;	       (dcl_Grid_SetCurCell mrCODEPro_Form_gridCODE 0 2)
;;;	       (dcl_Grid_SetCurCell mrCODEPro_Form_gridCODE *Done 2)
;;;	    )
;;;	    (progn
;;;	       (dcl_Grid_SetCurCell mrCODEPro_Form_gridCODE (- *Done 2) 2)
;;;	       (dcl_Grid_SetCurCell mrCODEPro_Form_gridCODE *Done 2)
;;;	    )
;;;	 )

	 
	 (dcl_Grid_SetCurCell gridTEST_Form_gridCODE *Done 2)
	 (dcl_Grid_StartCellEdit gridTEST_Form_gridCODE *Done 2)
	 
      ) ;_ End of progn
   ) ;_ End of if

	 
   (princ)
   
)



(defun c:gridTEST_Form_btnClose_OnClicked (/)
   (dcl_Form_Close gridTEST_Form )
)

(defun c:gridTEST_Form_btnHide_OnClicked (/)
  (dcl_Form_Hide gridTEST_Form T)
)


(defun F:Get_Cells_Val ( / *Cells_Val)
   (setq *Cells_Val
	   '(("asp" "A")
	     ("HP(in,out)" "HP")
	     ("Jtype" "JO")
	     ("Ltype" "LO")
	     ("Vtype" "VO")
	     ("grail" "GD")
	     ("stlight" "GA")
	     ("gman" "GM")
	     ("bld(S)" "B(S)")
	     ("bld(g)" "B(G)")
	     ("bld(l)" "B(L)")
	     ("bld(j)" "B(J)")
	     ("bld(c)" "B¨Ï")
	     ("board" "K")
	     ("vertx" "KK")
	     ("vrd" "G")
	     ("Brg" "KR")
	     ("struct" "GU")
	     ("Depth" "(H=-)")
	     ("End" "ED")
	     ("T01" "R")
	     ("T02" "N")
	     ("T03" "DDR")
	     ("T04" "DD")
	     ("T05" "DL")
	     ("T06" "L")
	     ("T07" "LU")
	     ("T08" "MK")
	     ("T09" "M")
	     ("T10" "MG")
	     ("V01" "MGS")
	     ("V02" "BOX")
	     ("V03" "MR")
	     ("V04" "B")
	     ("V05" "BT")
	     ("V06" "BHB")
	     ("V07" "BB")
	     ("V08" "WL")
	     ("V09" "BL")
	     ("V10" "D")
	     ("A01" "VH")
	     ("A02" "SS")
	     ("A03" "S")
	     ("A04" "SM")
	     ("A05" "SK")
	     ("A06" "U")
	     ("A07" "ST")
	     ("A08" "BP")
	     ("A09" "SHD")
	     ("A10" "DY")
	     ("F01" "OM")
	     ("F02" "O")
	     ("F03" "UM")
	     ("F04" "DU")
	     ("F05" "INT")
	     ("F06" "Z")
	     ("F07" "EM")
	     ("F08" "J")
	     ("F09" "CL")
	     ("F10" "DC")
	     ("S01" "LG")
	     ("S02" "UG")
	     ("S03" "C")
	     ("S04" "TM")
	     ("S05" "T")
	     ("S06" "PG")
	     ("S07" "H")
	     ("S08" "E")
	     ("S09" "HO")
	     ("S10" "F")
	     ("D01" "HB")
	     ("D02" "FS")
	     
	    )

   )
   *Cells_Val
)



(defun F:Sub_Import_gridTEST_ODCL_Form (/)

'("YWt6A8URAADa4VhoBuKTKDcxaj9qAHN9LdJsbt33eS4q3PAf7zND/9bWUvz3969uCO9TL1369SnJ"
"TaAzInCQD19YIEpPBKxhHvzWxv70j56/eriJ1BnExUAOOPxmcIjaBJSVKYuUq6Xpetn9amTU/fAv"
"WcusANTaeAAlOoqsMepuvW0g7i0ye+o5G6o8+8LS8nyqODPq0Rnlh8HnoX84eyqyFXzy9WfLL1fR"
"UNsIQ1GcAQMeLkbojvBY2MhMoTyYbh7U8/odRetO8X6RU5yBPAMgTdHpX9nql6N7MvHdWh9UbJUZ"
"R1f1HLz2N8BjqrmplV8L7Jw94VOn3Hh/eX/BfKIRnutTyvsuD/NqQNPvFNfp1AYKrHdgM6qzkT/A"
"+cR+ArF98MkyQn6KGepgwCGW3NTgApoHqlcpX6HY2FKL9oua20EIz1Iql5CECpjXHFPhPwGerIuA"
"Bf6RfcB1Bssf7PrOpMxiu9eZuHQsx1D5N+AXXRlNNu9RmxYauf1VJpOl55kSNPRfm3ZKcHSHmmCJ"
"7WOq1T7zA97OJOkgUYZM53Q1evJ0kUu6MdAYWxqPRryAr7PBUsA6SQXpxH0CQvgUmee03nr5MS5z"
"/2Ui/6PnkBBvOavHBiLGk32EdpIBdBjDdiTifl3QD6lhagTz9fmbwkNQqIKJfIEU3pF4RESzRO6p"
"nTodDKAf9tpavt3qYrjAbvGOrpnDSZc/BqoVNEyWCASLqw6Kic4bG2AILuC5683zhUYhCO9keDe4"
"3OKKWHSDXVOLrI8vYVadCQq16KKhNIOS/yVH1nhGYdUJmPdsNFwMXHHzoeSKImALQngGMnZDexCm"
"dsalz+MoyZR8op3mv4RfSZJ9hC++s76BSp59/rF+QHmGUp5Kvvl+AQ8Crbit0AKkScH8wuG3EZ5i"
"pkGXoCEgRF+4jBrT3vNNbBxNKeMgMPmcH7nblFpljNP0KMMOwSOxVAprbfETnQNUcFSrM66/C75J"
"fiElHmE+ZVDOM9xrYzGvbsBUoE4n4rkmyV7voXiCybT12eLS7gMmPkJ7ndQbaPLjGmhytwLvdL4J"
"tVJ+J2rHfhZi334WMq7Zst9eEt0ubjd/I1EhjE72glNieAMQMa9/kOrEvpD1V3SjpzI/R688pMLz"
"Y65zpF1Upk3kZgumH4PxLadivJjfRu8M4yPo1QIx0Th1bWLnSjUOKkRrsbjgHjf9HmdvhEzZRc6p"
"QX9HQ78qW8Z2lqeeouVCo+5rR4ZUtnLAaa4DFwdcCiFkHYlL8Z5lXDF7pV4hGCpOwSP/CBcJEOUZ"
"EItHEmgfGDNbrSc432vBarvG9U/NPMXvgxmTOKY0geXzlict4CEwTzLQ")
   
)


(c:gridtest)