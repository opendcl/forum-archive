(defun c:format-test ()
   ;;(dcl_Project_Load "//red4/san3/Groups/Drafting/Common/autocad2012/FORMAT" T)
   (dcl_Project_Load "FORMAT" T)
   (dcl_Form_Show format_Form1)

(setq namelist
  (LIST
       (list "Drafter" )
       (list "Checker" )
       (list "RE"      )
       (list "ME"      )
       (list "QA"      )
     )
)

  (setq DRAFTER-INFO (list "tom" "bill" "bob"))
  (setq CHK-INFO     (list "mike" "bill" "bob"))
  (setq ME-INFO      (list "nic" "ray" "ron"))
  
(foreach x namelist
   (setq nRow (dcl_Grid_AddRow format_Form1_Grid1 x))
   (dcl_Grid_SetCellStyle format_Form1_Grid1 nRow 2 15);set date function
   (dcl_Grid_SetCellStyle format_Form1_Grid1 nRow 1 40);setup name dropdown style
   
)
  
   (dcl_Grid_SetCellDropList format_Form1_Grid1 0 1 DRAFTER-INFO);drating list  
   (dcl_Grid_SetCellDropList format_Form1_Grid1 1 1 CHK-INFO)    ;checker list
   (dcl_Grid_SetCellDropList format_Form1_Grid1 3 1 ME-INFO)     ;me  list


)



;updates format
(defun c:format_Form1_Grid1_OnSelChanged (Row Column /)
  (if (= column 1)
       (progn
	   (setq txt (dcl_Grid_GetCellText format_Form1_Grid1 Row Column))
	   (dcl_Control_SetText format_Form1_TextBox1 txt);test code
;;;	   (cond
;;;              ((= row 0) (block_update_now "NAME"  txt))
;;;	      ((= row 1) (block_update_now "CHK"   txt))
;;;	      ((= row 2) (block_update_now "ENGR"  txt))
;;;	      ((= row 3) (block_update_now "APVD"  txt))
;;;	      ((= row 4) (block_update_now "QA"    txt))
;;;
;;;
;;;	   );cond
       );progn
  );if


  (if (= column 2)
       (progn
	   (setq txt (dcl_Grid_GetCellText format_Form1_Grid1 Row Column))
	   (dcl_Control_SetText format_Form1_TextBox2 txt);test code
;;;	   (cond
;;;              ((= row 0) (block_update_now "DATE"    txt))
;;;	      ((= row 1) (block_update_now "C_DATE"  txt))
;;;	      ((= row 2) (block_update_now "E_DATE"  txt))
;;;	      ((= row 3) (block_update_now "A_DATE"  txt))
;;;	      ((= row 4) (block_update_now "Q_DATE"  txt))
;;;
;;;
;;;	   );cond
       );progn
  );if
)
