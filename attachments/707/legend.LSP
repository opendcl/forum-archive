;;;-----------------------------------------------------------------------
;;;									  
;;; Legend Version 1.1 				30/04/2009                
;;;									  
;;;									  
;;; 									  
;;;									  
;;;									  
;;;				     					  
;;;									  
;;;-----------------------------------------------------------------------


;;;---------------------------------------------------------- Main ----------------------------------------------------

(defun c:legend	()
  (command "_.undo" "_end")
  (command "_.undo" "_begin")
  (vl-load-com)
  (setq	bb nil											    ; clear vars
	cc nil
	block_text nil
	tSize 1
	legend_exit nil
	noncont_layer_list
	 nil
	lylst nil
  )
  (setq	osmode_orig  (getvar "osmode")
	cmdecho_orig (getvar "cmdecho")
	layer_orig   (getvar "clayer")
  )
  (setvar "osmode" 0)
  (setvar "cmdecho" 0)
  (command "layer" "m" "Legend" "")
  (if (not runonce)
    (progn
      (command "blockicon" "")
      (setq runonce "T")
    )
  )
  (dcl_Project_Load "legend" T)
  (dcl_Form_Show Legend_Form1)
  (if (not legend_exit)
    (progn
      (setq pt1 (getpoint "\nSelect TOP LEFT CORNER for Legend...."))
      (setq pt2 (polar pt1 (dtr 0) 5))
      (setq pt3 (polar pt1 (dtr 40) 5))
      (legend_create)
      (legend_excluded)
      (if (= legend_inc_ltypes 1)
	(legend_linetypes)
      )
    )
  )
  (setvar "osmode" osmode_orig)
  (setvar "cmdecho" cmdecho_orig)
  (setvar "clayer" layer_orig)
  (command "_.undo" "_end")
  (princ)
)


;;;---------------------------------------------------------- Subroutines----------------------------------------------

(defun legend_create ()										    ; create the legend
  (if legend_list
    (progn
      (setq legend_list_length (length legend_list))
      (legend_block_exist)
      (foreach n legend_list
	(if (assoc n legend_block_exist_list)							    ; if it is a standard block
	  (progn
	    (setq pt2 (polar pt1 (dtr 0) 5))
	    (setq bb (assoc n legend_block_exist_list))						    ; block name
	    (command "-insert" (car bb) pt1 "1" "1" "0")					    ; insert block
	    (setq pt1 (polar pt1 (dtr 270) 2))							    ; calc next insertion point
	    (setq block_text (cons (cadr bb) block_text))
	    (setq zz block_text)
	    (legend_mtext)
	  )
	  (progn
	    (setq cc (cons n cc))								    ; not a standard block - add to list
	  )
	)
      )
    )
  )
  (princ)
)


(defun legend_excluded ()									    ; if non standard blocks exist show an alert box
  (if cc
    (progn
      (dcl_Form_Show Legend_Form2)
    )
  )
  (princ)
)

(defun legend_linetypes	()									    ; Create list of layers and their linetypes 
  (setq pt1 (polar pt1 (dtr 180) 3))
  (setq pt5 (polar pt1 (dtr 0) 8))
  (get->layrobj)
  (vlax-for lay	(get->layrobj)									    ; Code by Mark Thomas amended
    (setq lylst
	   (cons
	     (list
	       (vlax-get-property lay 'Name)
	       (vlax-get-property lay 'Linetype)
	     )
	     lylst
	   )
    )
    (setq lylst (vl-sort lylst (function (lambda (e1 e2) (< (car e1) (car e2))))))		    ; sort list of layers Alphabetically
  )
  (foreach x lylst
    (setq item x)
    (if	(and (not (member "CONTINUOUS" item))							    ; sort out layers - only those not continuous selected
	     (not (wcmatch (car item) "*|*"))							    ; or it belongs to an xref
	)
      (progn
	(setq noncont_layer_list (cons item noncont_layer_list))
	(setvar "clayer" (car item))
	(setq pt4 (polar pt1 (dtr 0) 6))
	(entmake (list
		   (cons 0 "LINE")
		   (cons 8 (getvar "clayer"))
		   '(100 . "AcDbEntity")
		   (cons 10 pt1)
		   (cons 11 pt4)
		 )
	)
	(entmake (list
		   (cons 0 "MTEXT")
		   (cons 8 (getvar "clayer"))
		   '(100 . "AcDbEntity")							    ; Required for all post-R12 entities.
		   '(100 . "AcDbMText")
		   (cons 7 (getvar "TextStyle"))						    ; Current Style
		   (cons 41 0)									    ; 0 Width = no wrap
		   (cons 10 pt5)
		   (cons 62 7)
		   (cons 1 (car item))
		   (cons 40 tSize)								    ;* Text height
		   (cons 73 1)
		   (cons 71 4)									    ; centre left justification
		 )
	)
	(setq pt1 (polar pt1 (dtr 270) 2))
	(setq pt5 (polar pt1 (dtr 0) 8))
      )
    )
  )
)



(defun get->layrobj ()										    ; Code by Mark Thomas
  (vla-get-Layers
    (vla-get-ActiveDocument
      (vlax-get-acad-object)
    )
  )
)




(defun legend_mtext ()										    ; create mtext desciptions for chosen blocks
  (setq block_text (reverse block_text))
  (setq allstrings "")
  (foreach itm block_text									    ; combine all strings plus EOL code
    (setq allstrings (strcat allstrings itm "\\P"))
  )												    ; end foreach
;;; Entmake Legend Heading
  (entmake (list
	     (cons 0 "MTEXT")
	     (cons 8 "Legend")
	     '(100 . "AcDbEntity")								    ; Required for all post-R12 entities.
	     '(100 . "AcDbMText")
	     (cons 7 (getvar "TextStyle"))							    ; Current Style
	     (cons 40 (getvar "TextSize"))							    ; Current height
	     (cons 41 0)									    ; 0 Width = no wrap
	     (cons 10 pt3)
	     (cons 1 "\\LLegend\\L")
	     (cons 40 tSize)									    ;* Text height
	     (cons 73 1)
	     (cons 71 5)									    ; middle centre justification
	   )
  )
;;; Entmake Block Descriptions
  (entmake (list
	     (cons 0 "MTEXT")
	     (cons 8 "Legend")
	     '(100 . "AcDbEntity")								    ; Required for all post-R12 entities.
	     '(100 . "AcDbMText")
	     (cons 7 (getvar "TextStyle"))							    ; Current Style
	     (cons 41 0)									    ; 0 Width = no wrap
	     (cons 10 pt2)
	     (cons 1 (cadr bb))
	     (cons 40 tSize)									    ;* Text height
	     (cons 73 1)
	     (cons 71 4)									    ; centre left justification
	   )
  )
  (princ)
)

;;;-----------------------------------------------------------------------
;;;									  
;;; Modify the following list to reflect custom blocks and descriptions   
;;;									  
;;;-----------------------------------------------------------------------



(defun legend_block_exist ()									    ; List of blocks and their descriptions
  (setq	legend_block_exist_list
	 (list
	   '("2PGATE" "Gate")
	   '("AV" "Air Valve")
	   '("BLLRD" "Bollard")
	   '("BTIC" "BT Inspection Cover")
	   '("CV" "Control Valve")
	   '("DAV_SW" "Double Air Valve")
	   '("DP" "Down Pipe")
	   '("ELBX" "Electricity Box")
	   '("EPLE" "Electricity Pole")
	   '("EPLYN" "Electricty Pylon")
	   '("FENO" "Feno Marker")
	   '("FH" "Fire Hydrant")
	   '("FH_SW" "Fire Hydrant")
	   '("GLLY" "Gully")
	   '("GV" "Gas Valve")
	   '("HY_SW" "Hydrant")
	   '("IC" "Inspection Cover")
	   '("LP" "Light Pole")
	   '("METER_SW" "Water Meter")
	   '("MH" "Manhole")
	   '("MHF" "Manhole Foul")
	   '("MHFO" "Manhole Foul Round")
	   '("MHFT" "Manhoel Foul Triangular")
	   '("MHO" "Manhole Round")
	   '("MHSW" "Manhole Stormwater")
	   '("MHSWO" "Manhole Stormwater Round")
	   '("MHSWT" "Manhole Stormwater Triangular")
	   '("MHT" "Manhole Triangular")
	   '("MP" "Marker Post")
	   '("PEG" "Peg")
	   '("PIPE" "Pipe")
	   '("POLE" "Pole")
	   '("POST BOX" "Post Box")
	   '("RODE" "Rodding Eye")
	   '("RSGN" "Road Sign")
	   '("RUBBISH BIN" "Rubbish Bin")
	   '("SAV_SW" "Single Air Valve")
	   '("SCH_SW" "Scour Hydrant")
	   '("SHRUB-1" "Shrub")
	   '("SPRK" "Sprinkler")
	   '("STAY" "Stay Wire")
	   '("STUMP" "Tree Stump")
	   '("SURVEY_STATION"
	     "Survey Control Station"
	    )
	   '("SV" "Stop Valve")
	   '("TAP" "Tap")
	   '("TCB" "Traffic Control Box")
	   '("TOBY" "Toby")
	   '("TP" "Telegraph Pole")
	   '("TRAFFIC LIGHTS" "Traffic Lights")
	   '("TREE_CANOPY" "Tree Canopy")
	   '("WATMT" "Water Meter")
	   '("Smoke Detector" "Smoke Detector")
	   '("heat_smoke" "Heat and Smoke Detector")
	   '("Heat Detector" "Heat Detector")
	   '("Fire Hose Reel" "Fire Hose Reel")
	   '("Fire Extinguisher CO2" "Fire Extinguisher - CO2")
	   '("Fire Extinguisher - Water" "Fire Extinguisher - Water")
	   '("Fire Door" "Fire Door")
	   '("Fire Blanket" "Fire Blanket")
	   '("Fire Alarm Bells" "Fire Alarm Bells")
	   '("gully" "Gully")
	   '("Post Box" "Post Box")
	   '("SIGP" "Sign Post")
	 )
  )
  (princ)
)

(DEFUN DTR (A) (* PI (/ A 180.0)))



;;;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ OpenDCL Box ++++++++++++++++++++++++++++++++++++++++++++


(defun c:Legend_Form1_TextButton1_OnClicked (/)							    ;OK Button
  (dcl_Form_Close Legend_Form1)
  (setq legend_list (dcl_Control_GetList Legend_Form1_ListBox1))
)

(defun c:Legend_Form1_TextButton3_OnClicked (/)							    ; Cancel Button
  (dcl_Form_Close Legend_Form1)
  (setq legend_exit T)
)

(defun c:Legend_Form1_TextButton4_OnClicked (/)							    ; Add to list button
  (setq blocks_to_add (dcl_BlockList_GetSelectedItems Legend_Form1_BlockList1))
  (dcl_ListBox_AddList Legend_Form1_ListBox1 blocks_to_add)
)

(defun c:Legend_Form1_TextButton5_OnClicked (/)							    ; Remove from list button
  (setq blocks_to_remove (dcl_ListBox_GetCurSel Legend_Form1_ListBox1))
  (dcl_ListBox_DeleteItem Legend_Form1_ListBox1 blocks_to_remove)
)

(defun c:Legend_Form1_TextButton2_OnClicked (/ intCnt)						    ; Select All Button  
  (repeat (setq intCnt (dcl_BlockList_GetCount Legend_Form1_BlockList1))
    (dcl_BlockList_SetCurSel Legend_Form1_BlockList1 (setq intCnt (1- intCnt)))
  )												    ; repeat  
  (dcl_Control_SetFocus Legend_Form1_BlockList1)
  (setq blocks_to_add (dcl_BlockList_GetSelectedItems Legend_Form1_BlockList1))
  (dcl_ListBox_AddList Legend_Form1_ListBox1 blocks_to_add)
  (dcl_Control_SetEnabled Legend_Form1_TextButton2 nil)
  (dcl_BlockList_SetCurSel Legend_Form1_BlockList1 -1)
)												    ; c:Legend_Form1_TextButton2_OnClicked 

(defun c:Legend_Form2_TextButton1_OnClicked (/)
  (dcl_Form_Close Legend_Form2)
)

(defun c:Legend_Form2_OnInitialize (/)								    ; Add list on non-conforming blocks to form
  (dcl_Control_SetList Legend_Form2_ListBox1 cc)
)

(defun c:Legend_Form1_CheckBox1_OnClicked (Value /)						    ; Show linetypes selected
  (setq legend_inc_ltypes Value)
)

(defun c:Legend_Form1_TextButton6_OnClicked (/)
  (dcl_ListBox_Clear Legend_Form1_ListBox1)
  (dcl_Control_SetEnabled Legend_Form1_TextButton2 T)

)

(princ)




 ;|«Visual LISP© Format Options»
(120 2 100 2 nil "end of " 100 15 0 0 0 T T nil T)
;*** DO NOT add text below the comment! ***|;
