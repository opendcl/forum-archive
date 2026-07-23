;;;							;
;;;	Palette Test v1.0				;
;;;	include files:					;
;;;		None					;
;;;							;
(vl-load-com)

(if (not (vl-bb-ref 'PaletteTest))
  (vl-bb-set
    'PaletteTest
    (dcl_project_import
      '("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"
"8ivv6byruaVSOBG7iQHdgJwo"))))


;;;								;
;;;	Support Subs						;
;;;								;

(defun jb:PopulateListBox  (rValue /)
  (dcl_ListBox_Clear 000_00_ListBox1)
  (cond	((= rValue "BMW")
	 (dcl_ListBox_AddList
	   000_00_ListBox1
	   (List "R1200S" "R1200R" "R1200GS" "R1200RT")))
	((= rValue "Moto Guzzi")
	 (dcl_ListBox_AddList
	   000_00_ListBox1
	   (List "Griso" "MGS-01" "Norge" "Stelvio")))
	((= rValue "Ducati")
	 (dcl_ListBox_AddList
	   000_00_ListBox1
	   (List "1098" "848" "Monster" "Multistrada")))
	((= rValue "MV Agusta")
	 (dcl_ListBox_AddList
	   000_00_ListBox1
	   (List "F4-R 312" "F4-1000R" "F4-750R" "Brutale 910R")))
	)
  )


(defun jb:Description  (rValue /)
  (dcl_Control_SetCaption 000_00_DESC "")
  (cond	((= rValue "R1200S")
	 (dcl_Control_SetCaption 000_00_DESC "The sportiest Boxer, very nice!"))
	((= rValue "R1200R")
	 (dcl_Control_SetCaption 000_00_DESC "The Naked Roadster - can do anything!"))
	((= rValue "R1200GS")
	 (dcl_Control_SetCaption 000_00_DESC "The BIG Trailie - Africa, Aisia, where do you want to go?"))
	((= rValue "R1200rt")
	 (dcl_Control_SetCaption 000_00_DESC "For the over 50 crowd . . .."))

	((= rValue "Griso")
	 (dcl_Control_SetCaption 000_00_DESC "The Guzzi muscle bike, very, very nice."))
	((= rValue "MGS-01")
	 (dcl_Control_SetCaption 000_00_DESC "The SEXIEST bike in the world - period."))
	((= rValue "Norge")
	 (dcl_Control_SetCaption 000_00_DESC "Guzzi's BMW RT - over 50 only!"))
	((= rValue "Stelvio")
	 (dcl_Control_SetCaption 000_00_DESC "Guzzi's BMW GS - only better, much better!"))

	((= rValue "1098")
	 (dcl_Control_SetCaption 000_00_DESC "Can you say insane? Turn you liscence over now."))
	((= rValue "848")
	 (dcl_Control_SetCaption 000_00_DESC "Can you say insane? You might be able to keep your liscence."))
	((= rValue "Monster")
	 (dcl_Control_SetCaption 000_00_DESC "The original Naked Hooligan Bike."))
	((= rValue "Multistrada")
	 (dcl_Control_SetCaption 000_00_DESC "Hey, it's just what the name says . . . ('Multiple Roads')"))

	((= rValue "F4-R 312")
	 (dcl_Control_SetCaption 000_00_DESC "The fastest production bike in the world."))
	((= rValue "F4-1000R")
	 (dcl_Control_SetCaption 000_00_DESC "The MV version of: Can you say insane? Turn you liscence over now."))
	((= rValue "F4-750R")
	 (dcl_Control_SetCaption 000_00_DESC "The MV version of: Can you say insane? You might be able to keep your liscence."))
	((= rValue "Brutale 910R")
	 (dcl_Control_SetCaption 000_00_DESC "The other Naked Hooligan Bike."))
	)
  )

(defun jb:LaunchWeb(rValue / )
  (cond ((= rValue "BMW")
	    (startapp "C:\\Program Files\\Internet Explorer\\IEXPLORE.EXE" "http://www.bmwmotorcycles.com/"))
	   ((= rValue "Moto Guzzi")
	    (startapp "C:\\Program Files\\Internet Explorer\\IEXPLORE.EXE" "http://www.motoguzzi.it/"))
	   ((= rValue "Ducati")
	    (startapp "C:\\Program Files\\Internet Explorer\\IEXPLORE.EXE" "http://www.ducati.com/"))
	   ((= rValue "MV Agusta")
	    (startapp "C:\\Program Files\\Internet Explorer\\IEXPLORE.EXE" "http://www.mvagusta.com/"))
	   )
  )

(defun c:000_00_ComboBox1_OnSelChanged (nSelection sSelText /)
  (dcl_Control_SetCaption 000_00_DESC "")
  (dcl_Control_SetCaption 000_00_DESC (strcat "Your Motorcycle will be ordered in the color " sSelText))
)



(defun c:000_00_ListBox1_OnDblClicked ( /)
     (c:000_00_TreeControl1_OnDblClicked)
)



(defun c:000_00_ListBox1_OnSelChanged (nSelection sSelText /)
  (dcl_Control_SetCaption 000_00_DESC "")
  (jb:Description sSelText)
)



(defun c:000_00_TreeControl1_OnDblClicked ( / rValue)
     (Setq rValue (dcl_Tree_GetItemText 000_00_TreeControl1 
	 (dcl_Tree_GetSelectedItem 000_00_TreeControl1)))
  (if rValue(jb:LaunchWeb rValue))
)


(defun c:000_00_TreeControl1_OnSelChanged (sItemText Key /)
  (alert "OnSelChanged")
     (if sItemText(jb:PopulateListBox sItemText))
)



(defun c:000_00_TreeControl1_OnClicked ( / rValue)
  (alert "OnClicked")
     (Setq rValue (dcl_Tree_GetItemText 000_00_TreeControl1 
	 (dcl_Tree_GetSelectedItem 000_00_TreeControl1)))
  (if rValue(jb:PopulateListBox rValue))
)


(defun c:000_00_GraphicButton2_OnClicked  (/)
  (cond	((= (dcl_Control_GetPicture 000_00_GraphicButton2) 100)
	 (dcl_Control_SetPicture 000_00_GraphicButton2 101)
	 (dcl_Control_SetCaption 000_00_DESC "")
	 (dcl_Control_SetCaption
	   000_00_DESC
	   "Just showing that the picture property works!"))
	((= (dcl_Control_GetPicture 000_00_GraphicButton2) 101)
	 (dcl_Control_SetPicture 000_00_GraphicButton2 100)
	 (dcl_Control_SetCaption 000_00_DESC "")
	 (dcl_Control_SetCaption
	   000_00_DESC
	   "Just showing that the picture property works!"))
	)
  )


(defun c:000_00_GraphicButton1_OnClicked ( /)
     (c:000_00_TreeControl1_OnDblClicked)
)

(defun c:000_00_OnClose ( /)
     (vl-bb-set 'jbPaletteTestFloating "false")
)

(defun c:000_00_Refresh_OnClicked ( /)
     (c:000_00_OnInitialize)
)


(defun c:000_00_OnInitialize ( /)
  (dcl_ComboBox_Clear 000_00_ComboBox1)
  (dcl_ComboBox_AddList 000_00_ComboBox1 (list "Red" "White" "Black" "Silver" "Yellow"))
  (dcl_Control_SetText 000_00_ComboBox1	 "Available Colors")

  (dcl_Tree_Clear 000_00_TreeControl1)
  (dcl_Tree_AddParent 000_00_TreeControl1 "Motorcycle Manufacturers" "00")
  (dcl_Tree_AddChild 000_00_TreeControl1 
	   (list  (list  "00" "BMW" 0 1)
		  (list "00" "Moto Guzzi" 0 1)
		  (list "00" "Ducati" 0 1)
		  (list "00" "MV Agusta" 0 1)
		  
	))
  
)


(defun c:000_00_OnDocActivated ( /)
     (c:000_00_OnInitialize)
)


(defun c:000_00_OnEnteringNoDocState ( /)
     (if (dcl_Form_IsActive 000_00)
    (progn (vl-bb-set 'jbPaletteTestFloating "true")
	   (dcl_form_close 000_00)))
)

;;;							;
;;;	Command Interface				;
;;;							;

(defun c:jbPaletteTest  (/)
  (if(not(member "000" (dcl_GetProjects)))
	 (dcl_Project_load "000"))
	   
  (if dcl_HideErrorMsgBox
    (progn
  (if (not (dcl_Form_IsActive 000_00))
    (dcl_Form_Show 000_00))
  )
    (alert "The OpenDCL arx module did not load!"))
  (princ))



;;;							;
;;;		Floating Form				;
;;;		Document Opened				;
;;;							;

(defun jb:000_IsFloating  (/ )
 
  (if dcl_HideErrorMsgBox
    (progn
  (if (dcl_Form_IsActive 000_00)
    (c:000_00_OnDocActivated)))
    (alert "The OpenDCL arx module did not load!"))
  (princ))

(jb:000_IsFloating)

(if (= (vl-bb-ref 'jbPaletteTestFloating) "true") (c:jbPaletteTest))

(princ "\njbPaletteTest v1.0 loaded!")
(princ)  
;|«Visual LISP© Format Options»
(94 2 4 0 nil "end of " 72 6 0 0 1 T nil nil T)
;*** DO NOT add text below the comment! ***|;
