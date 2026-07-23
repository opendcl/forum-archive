; Ensure the appropriate OpenDCL ARX file is loaded 
; !!!!!!! Ensure that the onclicked oninitialized and so on ere activated in the IDE !!!!!!!
;; !!!!!!! let op als je de file in de openDCL ide saveas hebt gedaan werken de 
;; c: commandos niet    enze zn je moet dan de events verwijderen en weer terugzetten
(command "OPENDCL") 
 
(defun c:Hello () 
   ; call the method to load the HelloWorld.odcl file. 
   ;(setq outCome (dcl_project_import "Oke3.odcl" "AD")) 
   (setq outCome (dcl_project_load "NotOke3.odcl" T "AD"))
   ; call the method to show the Hello World dialog box example 
   (dcl_Form_Show AD_Form1) 
   (princ) 
)

(defun c:NotOke3/Form1#OnInitialize  (/)
 (alert "c:Oke3Nu")
 (dcl-Control-SetKeepFocus  AD/Form1 "false") 
 (dcl-Control-SetEventInvoke AD_Form1 1)
 (dcl-Control-SetEventInvoke AD_Form1_TreeC1 1)
 (dcl-Control-SetEventInvoke AD_Form1_TBLine 1)
 (dcl-Control-SetEventInvoke AD_Form1_TBLine2 1)
 (dcl_Control_SetCaption AD_Form1_LblStatus "Started")
 (setq P20 (dcl_Tree_AddParent AD/Form1/TreeC1  "Houtafscheider" 10 -1 10))
    (dcl_Tree_AddChild AD/Form1/TreeC1
        (list
            (list P20 "c:LispRectangle" 4 5)
            (list P20 "c:LispCircle" 4 5)
            (list P20 "c:LispEllipse" 4 5)
        )
    )
)
(defun c:NotOke3/Form1/TreeC1#OnClicked (  /)
	(setq it(dcl-Tree-GetSelectedItem AD/Form1/TreeC1))
	(setq  curentlabel1 (dcl-Tree-GetItemLabel AD/Form1/TreeC1 it))
	(Princ "\ncurentlabel1 [")(princ curentlabel1)(princ "]")
	(setq comm (substr curentlabel1 1 2))
	;(alert comm)
	(if (= comm "c:")
	 (progn
	  (dcl-Control-SetEventInvoke AD_Form1_TreeC1 1)
	  (if (equal curentlabel1 "c:LispEllipse")
	   (dcl-Invoke curentlabel1)
	  )
	  (if (equal curentlabel1 "c:LispRectangle")
	   (dcl-Invoke curentlabel1)
	  )
	  (if (equal curentlabel1 "c:LispCircle")
	   (dcl-SendString (strcat "(" curentlabel1 ") " ))
	  )
	
	 )
    ) 
    (setq comm nil)
	(princ)
)
;(dcl-Tree-AddParent <CONTROL> (List of Lists as (Label [as String] {Key [as String]} {ImageIndex [as Integer]} {SelectedImageIndex [as Integer]} {ExpandedImageIndex [as Integer]}) ...))


(defun c:NotOke3/Form1/TBLine#OnClicked (/)
  (dcl_Control_SetCaption AD_Form1_LblStatus  "Drawing Line")
  (command "line" pause )
  (dcl_Control_SetCaption AD_Form1_LblStatus  "Done With Line")
)
(defun c:NotOke3/Form1/TButtonBack#OnClicked (/)
  (dcl_Control_SetCaption AD_Form1_LblStatus  "Drawing Line")
 (dcl-SendString  "(c:lispLine) " )
  (dcl_Control_SetCaption AD_Form1_LblStatus  "Done With Line")
)
(defun c:NotOke3/Form1/TButtonExit#OnClicked (/)
 (dcl-Form-Close AD_Form1)
)

(defun c:NotOke3/Form1#OnCancelClose (Reason /)
    ;; Reason = 0 when Enter is pressed
    ;; Reason = 1 when ESC key is pressed, or the closing button in the titlebar
    ;; is clicked. Hence, enter won't work to cancel the dialog
    (/= Reason 0)
)

(defun c:LispEllipse()
   (dcl_Control_SetCaption AD_Form1_LblStatus  "Drawing Ellipse")
   (princ "\nDrawing an Ellipse")
   (command "Ellipse" pause)
   (dcl_Control_SetCaption AD_Form1_LblStatus  "Done With Ellipse")
)
(defun c:LispRectangle()
   (dcl_Control_SetCaption AD_Form1_LblStatus  "Drawing Rectangle")
   (princ "\nDrawing an Rectangle")
   (command "Rectangle" pause)
   (dcl_Control_SetCaption AD_Form1_LblStatus  "Done With Rectangle")
)
(defun c:LispCircle()
   (dcl_Control_SetCaption AD_Form1_LblStatus  "Drawing circle")
   (princ "\nDrawing an Cirlce")
   (command "circle" pause)
   (dcl_Control_SetCaption AD_Form1_LblStatus  "Done With circle")
)
(defun c:LispLine()
   (dcl_Control_SetCaption AD_Form1_LblStatus  "Drawing Line")
   (princ "\nDrawing an Line")
   (command "line" pause)
   (dcl_Control_SetCaption AD_Form1_LblStatus  "Done With Line")
)

(c:Hello)


