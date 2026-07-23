(vl-load-com)
(command "_OpenDcl")
;;;---------------------------------------------------------------------------
;;;---------------------------------------------------------------------------
;;;
;|
Grid_CellStyle refer OpenDCL Grid_SetCellStyle Method.
This method sets the cell style for the cell at the specified row and column.
Note that cells inherit the column default style when no style has been set.

Style : Description 
0 No style set 
1 Check box 
2 Option button 
3 Toggle Icon (see SetCellImages) 
4 Ellipsis button 
5 Pick button 
6 Text 
7 Angle 
8 Integer 
9 Unit (affected by DIMZIN system variable) 
10 Upper case text 
11 Lower case text 
12 Password 
13 Multiline text 
14 Currency 
15 Date 
16 Time 
17 Percentage 
18 Dropdown list 
19 Arrows 
20 AutoCAD colors 
21 Text styles 
22 Plot styles 
23 Plot style tables 
24 Plotters 
25 Fonts 
26 Drives 
27 Layers 
28 Dimension styles 
29 Image/text dropdown list 
30 AutoCAD color 
31 Truecolor 
32 Lineweight 
33 Linetype 
34 Folders 
35 Files (see SetCellDropList) 
36 Dropdown combo list 
37 Dropdown angles combo list 
38 Dropdown integers combo list 
39 Dropdown units combo list (affected by DIMZIN system variable) 
40 Dropdown upper case text combo list 
41 Dropdown lower case text combo list 
42 AutoCAD symbol name 
43 Dropdown AutoCAD symbol name combo list 

|;


(defun C:TEST_01 ()
   (setq PropsData (list "Title Text for the Dialog"                  ;<=Caption Title
                         '("Column" "Value")                          ;<=Column Header Title <Header1> Header2>
                         0                                            ;<= <CellStyle>
                         (list (list "Name" "FirstValue")             ;<= <Field1 value> <Field2 Value>
                               (list "Number" "12345")
                               (list "Layer" "0")                               
                         )
                   )
   )
   (KDUB_Properties PropsData)
)
;;------------------------------------------------------- 
;;   

(defun KDUB_Properties (PropsData / InitializeComplete dclReturn )
   ;;---- MAIN ENTRY POINT----------------------------------  
   ;;(findfile "KDUB_Props.odcl" )
   (dcl_Project_Load "Props.odcl" T)
   (setq dclReturn (dcl_Form_Show Props_Main))
   ;; (alert (strcat "dclReturn :" (itoa dclReturn)))
   (princ)
)

;;------------------------------------------------------- 
;;   
(defun c:Props_Main_OnInitialize (/ )
   ;;| Set the Label TitleText |;
   (dcl_Control_SetCaption Props_Main_Label (car PropsData))
   ;;| Set the Column Header Names |;
   (dcl_Control_SetColumnCaptionList Props_Main_Grid (cadr PropsData))
   ;;
   (setq GridData  (cadddr PropsData)
         RowCount  (length GridData)
         CellStyle (caddr PropsData)
         RowIndex  0
   )
   ;;
   (dcl_Control_SetColumnStyleList Props_Main_Grid (List 0 CellStyle))

   (dcl_Grid_FillList Props_Main_Grid GridData)

   ;;
   ;;

  (dcl_Control_SetHeight Props_Main (+ 85 (* RowCount 24)) )
   
   (setq InitializeComplete T)
   ;; (dcl_MessageBox (itoa (dcl_Grid_CalcColumnWidth Props_Main_Grid "FirstValue")) "Column Width")
   (princ)
)

;|

(dcl_Grid_CalcColumnWidth Props_Main_Grid "FirstValue")

|;

;;------------------------------------------------------- 
;; 
(defun c:Props_Main_OnSize (NewWidth NewHeight /)
   ;; allow for 7 pixel border
   ;; Set the Column Widthss
   (if InitializeComplete
      (progn
         (dcl_MessageBox "Props_Main_OnSize" "To do")
         (setq ColumnWidth (/ (- (dcl_Control_GetWidth Props_Main) 14) 2))
         (dcl_Control_SetColumnWidthList Props_Main_Grid (list ColumnWidth ColumnWidth))
         ;;
         
      )
   )
)
;;------------------------------------------------------- 
;;
(defun c:Props_Main_Cancel_OnClicked (/)
   (dcl_Form_Close Props_Main 2)
)
;;------------------------------------------------------- 
;;  
(defun c:Props_Main_ok_OnClicked (/)
   (dcl_MessageBox
      "To Do: code must be added to event handler\r\nc:Props_Main_ok_OnClicked"
      "To do"
   )
)

 ;|«Visual LISP© Format Options»
(90 3 70 2 nil "end of " 90 70 0 0 2 nil nil nil T)
;*** DO NOT add text below the comment! ***|;
