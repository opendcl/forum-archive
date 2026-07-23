(command "OPENDCL")

(defun c:test ()
  (MultiSelectListBox "Select XRefs to fade" "" " blocks selected" (getblocknames) "mlb:XRefs")
  (if mlb:okay
    (princ (strcat "\nOkay:" (vl-prin1-to-string mlb:Selected)))
    (princ "\nCancelled")
    )
  (princ)
)

(Defun MultiSelectListBox (Title LabelPrefix LabelSuffix ListContents AppName /)
  (dcl_Project_Load "MultiSelectListBox" T)
  (setq	mlb:ListContents ListContents
	mlb:Title Title
	mlb:LabelPrefix	LabelPrefix
	mlb:Okay	nil
	mlb:LabelSuffix	LabelSuffix
  )
  (dcl_Form_Show MultiSelectListBox_form1)
)



(defun GetBlockNames (/ rtlist)
  (vl-remove-if	(function (lambda (bname) (wcmatch bname "`**")))
		(vlax-for blk (vla-get-blocks (vla-get-activedocument (vlax-get-acad-object)))
		  (setq rtlist (cons (vla-get-name blk) rtlist))
		)
  )
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;        Begin Event Handlers										;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:MultiSelectListBox_Form1_OnCancel (/)
  (setq mlb:okay nil)
)


(defun c:MultiSelectListBox_Form1_OnCancelClose	(Canceling /)
  (setq mlb:okay nil)
  (dcl_Form_Close MultiSelectListBox_Form1 0)
)


(defun c:MultiSelectListBox_Form1_OnClose (UpperLeftX UpperLeftY /)
  (Setcfg (strcat "AppData/IMFT/MultiSelectListBox/" AppName "/Top") (itoa UpperLeftY))
  (Setcfg (strcat "AppData/IMFT/MultiSelectListBox/" AppName "/Left") (itoa UpperLeftX))
  (Setcfg (strcat "AppData/IMFT/MultiSelectListBox/" AppName "/Width") (itoa (+ 9 (dcl_Control_GetWidth MultiSelectListBox_Form1))))
  (Setcfg (strcat "AppData/IMFT/MultiSelectListBox/" AppName "/Height") (itoa (+ 27 (dcl_Control_GetHeight MultiSelectListBox_Form1))))
  (dcl_Form_Close MultiSelectListBox_Form1 1)
)




  
(defun c:MultiSelectListBox_Form1_OnInitialize (/)
 (if (setq temp (Getcfg (strcat "AppData/IMFT/MultiSelectListBox/" AppName "/Left")))
  (dcl_Control_SetPos
    MultiSelectListBox_Form1
    (atoi temp)
    (atoi(Getcfg (strcat "AppData/IMFT/MultiSelectListBox/" AppName "/Top")))
    (atoi(Getcfg (strcat "AppData/IMFT/MultiSelectListBox/" AppName "/Width")))
    (atoi(Getcfg (strcat "AppData/IMFT/MultiSelectListBox/" AppName "/Height")))
    )
   )
  (dcl_Control_SetList MultiSelectListBox_Form1_ListBox1 mlb:ListContents)
  (dcl_Control_SetTitleBarText MultiSelectListBox_Form1 mlb:Title)
  (dcl_Control_SetCaption MultiSelectListBox_Form1_Label1 "")
)


(defun c:MultiSelectListBox_Form1_OnOK (/) (setq mlb:Okay T))



(defun c:MultiSelectListBox_Form1_ListBox1_OnSelChanged	(ItemIndex Value /)
  (setq mlb:Selected (dcl_ListBox_GetSelectedItems MultiSelectListBox_Form1_ListBox1))
  (if (= 0 (length mlb:Selected))
    (progn (dcl_Control_SetEnabled MultiSelectListBox_Form1_tbOkay nil)
	   (dcl_Control_SetCaption MultiSelectListBox_Form1_Label1 "")
    )
    (progn
      (dcl_Control_SetEnabled MultiSelectListBox_Form1_tbOkay T)
      (dcl_Control_SetCaption MultiSelectListBox_Form1_Label1
			      (strcat mlb:LabelPrefix (itoa (length mlb:Selected)) mlb:LabelSuffix)
      )
    )
  )
)




(defun c:MultiSelectListBox_Form1_TextButton2_OnClicked (/)
  (setq mlb:okay nil)
  (dcl_Form_Close MultiSelectListBox_Form1 1)
)

(defun c:MultiSelectListBox_Form1_TextButton1_OnClicked (/)
  (setq mlb:okay T)
  (dcl_Form_Close MultiSelectListBox_Form1 0)
)


(defun c:MultiSelectListBox_Form1_ListBox1_OnDblClicked (/)
  (setq mlb:okay T)
  (dcl_Form_Close MultiSelectListBox_Form1 0)
)

