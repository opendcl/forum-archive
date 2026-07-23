(vl-load-com)

(princ "\ncommand: gridtest sample for checkbox, layer, color, textstyle, lineweight, linetype ")
;;  (load "rriodcl")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:gridtest ( / 
    tabcontrol gridcontrol gridname
    gridcontrol1 gridcontrol2 gridcontrol3 gridcontrol4 gridcontrol5 gridcontrol6
    project captions rows
    n
    
  )
  
  (or LoadRunTime (load "_OpenDclUtils.lsp") 
    (exit)
  )
  (LoadRunTime)
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (cond
    ((not (setq project (dcl_Project_Load "gridtest.odcl" T))))
    (T
      (dcl_FORM_SHOW Form1)
      (set_titlebar Form1 project)

      (setq tabcontrol   Form1_Tab1)
      (dcl_Control_SetTabCaptionList tabcontrol '( "test" "0- 9" "10- 19" "20- 29" "30- 39" "40- 43"))      

      (foreach n '( "1" "2" "3" "4" "5" "6")
        (setq gridname (strcat "Form1_GRID" n))
        (eval (read (strcat "(setq gridcontrol (setq gridcontrol" n " " gridname "))")))
        (eval (read (strcat "(defun c:" gridname "_OnColumnClick ( ncol / )         (GRIDn_OnColumnClick " gridname " ncol))")))
        (eval (read (strcat "(defun c:" gridname "_OnButtonClicked ( Row Column / ) (GRIDn_OnButtonClicked " gridname " Row Column))")))
        (eval (read (strcat "(defun c:" gridname "_OnBeginLabelEdit ( Row Column / )(GRIDn_OnBeginLabelEdit " gridname " Row Column))")))
        (eval (read (strcat "(defun c:" gridname "_OnEndLabelEdit ( Row Column / )  (GRIDn_OnEndLabelEdit " gridname " Row Column))")))

        (dcl_Control_SetVisible gridcontrol  nil)
        (dcl_Grid_Clear gridcontrol)

      )     
      
      (dcl_Control_SetVisible gridcontrol1  T)
    
      (setq captions '( "1 check" "20 color" "21 textstyle" "27 layer" "29 drop img/text" "30 color" "31 rgb-color" "32 lineweight" "33 linetype" "34 folder" "35 files" "" "43 drop acsymbols"))
      (setq rows
        (list
        "0;256;    standard                        ;0;;    256; 256;       bylayer;byblock"
        "0;0;      standard;0;;    0;   0;         bylayer;byblock"
        "1;red;    standard;test;; red; red;       bylayer;byblock"
        "1;3;      standard;0;;    3;   3;         bylayer;byblock"
        "1;31;     standard;0;;    31;  31;        bylayer;byblock"
        "1;4;      standard;0;;    41;  100,200,100;  bylayer;default"
        "1;3;      standard;0;;    3;   color 3;   bylayer;byblock"
        "1;31;     standard;0;;    31;  color 31;  bylayer;byblock"
        "1;"
      ))
      (setgrid gridcontrol1 captions rows )

      (setq captions '( "0 nostyle" "1 check" "2 option" "3 toggle" "4 ellipsis" "5 pick" "6 text" "7 angle" "8 int" "9 unit" ))
      (setq rows (list
       ";;;;;;;;;;" ";;;;;;;;;;"
       ";;;;;;;;;;" ";;;;;;;;;;"
       ";;;;;;;;;;" ";;;;;;;;;;"
      ))
      (setgrid gridcontrol2 captions rows )

      (setq captions '( "10 upper" "11 lower" "12 pass" "13 mtext" "14 currency" "15 date" "16 time" "17 percentage" "18 drop" "19 arrows" ))
      (setq rows (list
       ";;;;;;;;;;" ";;;;;;;;;;"
       ";;;;;;;;;;" ";;;;;;;;;;"
       ";;;;;;;;;;" ";;;;;;;;;;"
      ))
      (setgrid gridcontrol3 captions rows )
      
      (setq captions '( "20 colors" "21 txstyle" "22 plstyle" "23 plstyle table" "24 plotters" "25 fonts" "26 drives" "27 layers" "28 dimstyles" "29 img tx drop" ))
      (setq rows (list
       ";;;;;;;;;;" ";;;;;;;;;;"
       ";;;;;;;;;;" ";;;;;;;;;;"
       ";;;;;;;;;;" ";;;;;;;;;;"
      ))
      (setgrid gridcontrol4 captions rows )
      
      (setq captions '( "30 ac color" "31 true color" "32 lweight" "33 ltype" "34 folders" "35 dwg/dxf" "36 drop combo" "37 drop ang combo" "38 drop int combo" "39 drop unit combo" ))
      (setq rows (list
       ";;;;;;;;;;" ";;;;;;;;;;"
       ";;;;;;;;;;" ";;;;;;;;;;"
       ";;;;;;;;;;" ";;;;;;;;;;"
      ))
      (setgrid gridcontrol5 captions rows )
      
      (setq captions '( "40 drop uptext cmb" "41 drop lotext cmb" "42 acsymname" "43 drop acsymname cmb" ))
      (setq rows (list
       ";;;;;;;;;;" ";;;;;;;;;;"
       ";;;;;;;;;;" ";;;;;;;;;;"
       ";;;;;;;;;;" ";;;;;;;;;;"
      ))
      (setgrid gridcontrol6 captions rows )
      
    )
  )  
) ;; (c:grid_test ( / gridcontrol column_styles row ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun setgrid ( gridcontrol captions rows /     
    caption 
    styles style styles2
    row
    ncol
      )
      
      (dcl_Grid_Clear gridcontrol)
    
      (dcl_Control_SetColumnCaptionList gridcontrol captions)
;;      (dcl_Control_SetFont gridcontrol "Arial")

      (setq styles nil)
      (foreach caption captions
        (setq styles (cons (setq style (atoi caption)) styles))
      )  
      (dcl_Control_SetColumnStyleList gridcontrol (setq styles (reverse styles)))
    
      (foreach row rows
        (dcl_Grid_AddString gridcontrol row ";")
      )
  
      (setq styles2 (dcl_Control_GetColumnStyleList gridcontrol))  
;;(alert (strcat (vl-prin1-to-string styles) "\n" (vl-prin1-to-string styles2)))       
      (set_checkboxes_from_data gridcontrol styles)
;; set column width from data      
      (setq ncol 0)
      (foreach caption captions      
        (GRIDn_OnColumnClick gridcontrol ncol)
        (setq ncol (1+ ncol))
      )
      
) ;; (defun setgrid ( gridcontrol /     ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun set_checkboxes_from_data ( gridcontrol column_styles / 
              column_style 
              ncol nrow
              column_cell column_cells
            )
  (setq ncol 0)
  (foreach column_style column_styles
    (cond
      ((member column_style '(1))
        (setq column_cells (dcl_Grid_GetColumnCells gridcontrol ncol))
        (setq nrow 0)
        (foreach column_cell column_cells
          (setq column_cell (vl-string-trim " \n\r\t" (strcase column_cell)))
          (cond
            ((wcmatch column_cell "0,OFF,")
              (dcl_Grid_SetCellCheckState gridcontrol nrow ncol 0)
              (dcl_Grid_SetCellText gridcontrol nrow ncol "OFF")
            )
            ((wcmatch column_cell "1,ON")
              (dcl_Grid_SetCellCheckState gridcontrol nrow ncol 1)
              (dcl_Grid_SetCellText gridcontrol nrow ncol "ON")
            )
          )
          (setq nrow (1+ nrow))
        )
      )
      ((= 3 column_style)
;;        (dcl_Grid_SetCellImages gridcontrol nRow nCol ImageIndex AltImageIndex)
      )
    )
    (setq ncol (1+ ncol))
  )

) ;; (defun set_checkboxes_from_data ( column_styles / column_style ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun set_titlebar ( dialog title / program acadver _vernum dclver)

  (setq program (getvar "PROGRAM"))
  (setq acadver (getvar "ACADVER"))
  (setq _vernum (getvar "_VERNUM"))
  (setq dclver  (dcl_getversionex))

  (dcl_Control_SetTitleBarText dialog (strcat dclver " - " program " - " acadver " - " _vernum " - " title))

) ;; (defun set_titlebar ( dialog title / program acadver _vernum ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun GRIDn_OnColumnClick ( gridcontrol intColumn /
                                                 ColumnWidth ColumnText px_maxwidth ColumnCaption ColumnStyle)
                                                 
;;(setq gridcontrol testgrid_CSVDialog_GRID2)                                                
;;   (dcl_MessageBox (strcat "4 Hier sollte etwas Sinnvolles passieren: An dieser Stelle können Sie nun den Quellcode zur Ereignisfunktion hinzufügen"))
;;{ RRI100114
  (setq px_maxwidth 0)
;;} RRI100114
  (cond
    ((not (setq ColumnCaption (nth intColumn (dcl_Control_GetColumnCaptionList gridcontrol)))))
    ((not (setq ColumnStyle   (nth intColumn (dcl_control_GetColumnStyleList gridcontrol)))))
    ((not (setq ColumnWidth   (dcl_Grid_GetColumnWidth gridcontrol intColumn))))
    ((not (setq ColumnText    (dcl_Grid_GetColumnCells gridcontrol intColumn))))
    (T
;;{ RRI100114
      (setq px_maxwidth (max px_maxwidth (- ColumnWidth 10)))
      (if ColumnCaption
        (setq ColumnText (cons (strcat " " ColumnCaption " ") ColumnText))
      )
      (foreach text ColumnText
;;;      (setq px_maxwidth (- ColumnWidth 10))
;;;      (foreach text (cdr ColumnText)
;;} RRI100114
        (setq px_maxwidth (max px_maxwidth (dcl_Grid_CalcColumnWidth gridcontrol text)))
      )
      (cond
        ((member ColumnStyle '(20 30 31))
          (setq px_maxwidth (+ px_maxwidth 20))
        
        )
        ((= 32 ColumnStyle)
;; lineweight        
          (setq px_maxwidth (+ px_maxwidth 50))
        )
        ((= 33 ColumnStyle)
;; linetype
          (setq px_maxwidth (+ px_maxwidth))
        )
      )
;;(alert (strcat (itoa px_maxwidth) "\n" (vl-princ-to-string gridcontrol)))
      (dcl_Grid_SetColumnWidth gridcontrol intColumn (+ px_maxwidth 10))
;;      (dcl_Grid_SetColumnWidth gridcontrol intColumn (+ px_maxwidth 10))
    )
  )
) ;; (defun GRIDn_OnColumnClick ( gridcontrol intColumn / ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun GRIDn_OnButtonClicked ( gridcontrol Row Column / cstyle cstate )
;; (dcl_MessageBox "To Do: code must be added to event handler\r\nc:Form1_Grid1_OnButtonClicked" "To do")
;;(alert (strcat "GRIDn_OnButtonClicked " (dcl_control_getname gridcontrol) " " (itoa row) " " (itoa column)))
  (setq cstyle (dcl_Grid_GetCellStyle gridcontrol Row Column))
  (cond
    ((member cstyle '(1))
      (setq cstate (dcl_Grid_GetCellCheckState gridcontrol Row Column))
      (cond
        ((= 0 cstate)
          (dcl_Grid_SetCellText gridcontrol Row Column "Off")
        )
        ((= 1 cstate)
          (dcl_Grid_SetCellText gridcontrol Row Column "On")
        )
      )
    )
    ((= 3 cstyle)
    )
  )
) ;; (defun GRIDn_OnButtonClicked ( gridcontrol Row Column / columnstyle ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun GRIDn_OnBeginLabelEdit ( gridcontrol Row Column / 
    checkstate cellstyle celltext columnstyle value )
;;  (dcl_MessageBox "To Do: code must be added to event handler\r\nc:Form1_Grid1_OnBeginLabelEdit" "To do")
;; save labeltext
  (setq mydclcelltext_saved (dcl_grid_getcelltext gridcontrol row column))
;;  (setq value       (dcl_grid_getcellvalue gridcontrol ro column))

  (setq columnstyle (nth Column (dcl_control_getcolumnstylelist gridcontrol)))
  (setq checkstate  (dcl_grid_getcellcheckstate gridcontrol row column))
  
  (setq celltext    (dcl_grid_getcelltext gridcontrol row column))
(if nil
  (alert (strcat 
    "OnBeginLabelEdit"
    "\nrow/column=   " (itoa row) "/ " (itoa column)
    "\n columnstyle= " (vl-princ-to-string columnstyle)
    "\n celltext=    " (vl-princ-to-string celltext)
    "\n checkstate=  " (vl-princ-to-string checkstate)
         )
  )
)
;; prepare checkboxes
  (cond
    ((member columnstyle '(1))
      (cond
        ((= 0 checkstate)
          (dcl_grid_setcelltext gridcontrol row column "OFF")
        )
        ((= 1 checkstate)
          (dcl_grid_setcelltext gridcontrol row column "ON")
        )
      )
    )
    ((= 3 columnstyle)
    )
  )    
) ;; (defun GRIDn_OnBeginLabelEdit ( gridcontrol Row Column / checkstate cellstyle celltext columnstyle ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun GRIDn_OnEndLabelEdit ( gridcontrol Row Column / columnstyle celltext checkstate value )

;;  (dcl_MessageBox "To Do: code must be added to event handler\r\nc:Form1_Grid1_OnEndLabelEdit" "To do")

  (setq columnstyle (nth column (dcl_control_getcolumnstylelist gridcontrol)))
  (setq celltext    (dcl_grid_getcelltext gridcontrol row column))
  (setq checkstate  (dcl_grid_getcellcheckstate gridcontrol row column))
;;  (setq value       (dcl_grid_getcellvalue gridcontrol ro column))

;; restore labeltext
  (if (= "" (setq celltext (vl-string-trim " \n\r\t" celltext)))
    (dcl_grid_setcelltext gridcontrol row column mydclcelltext_saved)
  )
(if nil
  (alert (strcat 
    "OnEndLabelEdit"
    "\nrow/column=   " (itoa row) "/ " (itoa column)
    "\n columnstyle= " (vl-princ-to-string columnstyle)
    "\n celltext =  " (vl-princ-to-string celltext) " / " (if (= "" celltext) mydclcelltext_saved "")
    "\n checkstate=  " (vl-princ-to-string checkstate)
         )
  )
)
) ;; (defun GRIDn_OnEndLabelEdit ( gridcontrol Row Column / columnstyle celltext checkstate ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:Form1_TAB1_OnSelChanging ( intItemIndex /)
;;(alert "c:Form1_TAB1_OnSelChanging " (itoa intItemIndex))
   (eval (read (strcat "(dcl_Control_SetVisible Form1_GRID" (itoa (1+ intItemIndex)) " nil)")))
   nil  

) ;; (defun c:Form1_TAB1_OnSelChanging ( intItemIndex /))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:Form1_TAB1_OnChanged ( intItemIndex /)
;;(alert (strcat "c:Form1_TAB1_OnChanged " (itoa intItemIndex))

   (eval (read (strcat "(dcl_Control_SetVisible Form1_GRID" (itoa (1+ intItemIndex)) " T)")))
   nil  

) ;; (defun c:Form1_TAB1_OnChanged ( intItemIndex /))


(princ)


