(DEFUN C:BL (/ inspt first_point get_cur_date)
(vl-load-com)
(setq attval (getvar "attdia"))
(setq getosmode (getvar "osmode"))
(setq ds (getvar "dimscale"))

(setvar "osmode" 512)
	(SETQ first_point (GETPOINT "\nSelect first point: "))
(setvar "osmode" getosmode)
(setvar "attdia" 0)
  (SETQ inspt (GETPOINT first_point "\nSpecify next point: "))
	(if (= (getvar 'attdia)1)
   (setvar 'attdia 0)
  )
  (setq item_number (vlax-ldata-get "leadnum" "currentnum"))
  (if (not item_number)
    (setq item_number (vlax-ldata-put "leadnum" "currentnum" 1))
   )

  	(COMMAND "-insert" "tball" inspt (getvar "dimscale") "" "" (itoa item_number)
		         "line" first_point (POLAR first_point (ANGLE first_point inspt)
		                          (- (DISTANCE first_point inspt) (* (getvar "dimscale") 0.1875))
		                      ) (command)
	  )
  (vlax-ldata-put "leadnum" "currentnum" (1+ item_number))
(setvar "attdia" attval)

  (setvar "CMDECHO" 0)
  (command "OPENDCL")
  (dcl_project_load "newtb.odcl" T)
  (dcl_Form_Show newtb_Form1)
  (princ)
	
	(defun c:newtb_Form1_OnInitialize (/)
  (dcl_Control_SetText newtb_Form1_TextBox10 item_number)
)

(defun c:newtb_Form1_TextButton1_OnClicked (/)
 (setq item (dcl_Control_GetText newtb_Form1_TextBox10))
  (setq qty (dcl_Control_GetText newtb_Form1_TextBox11))
	(setq qty2 (dcl_Control_GetText newtb_Form1_TextBox12))
	(setq matl (dcl_Control_GetText newtb_Form1_TextBox1))
	(setq stk (dcl_Control_GetText newtb_Form1_TextBox2))
	(setq ft (dcl_Control_GetText newtb_Form1_TextBox3))
	(setq in (dcl_Control_GetText newtb_Form1_TextBox4))
	(setq mm (dcl_Control_GetText newtb_Form1_TextBox5))
	(setq spec1 (dcl_Control_GetText newtb_Form1_TextBox6))
	(setq spec2 (dcl_Control_GetText newtb_Form1_TextBox7))
	(setq remarks1 (dcl_Control_GetText newtb_Form1_TextBox8))
	(setq remarks2 (dcl_Control_GetText newtb_Form1_TextBox9))
				 (dcl_Form_Close newtb_Form1)
		  (cond
	     ((= item "") (setq item "-"))
       ((= qty "") (setq qty "-"))
			 ((= qty2 "") (setq qty2 "-"))
			 ((= matl "") (setq matl "-"))
			 ((= stk "") (setq stk "-"))
			 ((= ft "") (setq ft "-"))
			 ((= in "") (setq in "-"))
			 ((= mm "") (setq mm "-"))
			 ((= spec1 "") (setq spec1 "-"))
			 ((= spec2 "") (setq spec2 "-"))
			 ((= remarks1 "") (setq remarks1 "-"))
			 ((= remarks2 "") (setq remarks2 "-"))
	    )

		 ;;  remove any existing Properties
  (dictremove (namedobjdict) (strcat "DWGPROPS"item))
  ;; make data list  
  (setq xlist (list '(0 . "XRECORD")
                '(100 . "AcDbXrecord")
                (cons 1 (strcat "DWGPROPS"item))
                (cons 2 (substr (vl-Filename-Base (vl-Filename-Directory (getvar "Dwgprefix")))8))   ;customer (title)
                (cons 3 (substr (vl-Filename-Base (vl-Filename-Directory (getvar "Dwgprefix")))1 6)) ;order (subject)        
                ;(cons 4 (getvar "loginname")) ;author
                ;(cons 6 "Comments") ;comments
                (cons 7 (vl-Filename-Base (getvar "dwgname")))           ;dwg no (keyword)
                ;(cons 8 (getvar "loginname"))                           ;LastSavedBy
                ;(cons 9 "rev")                                          ;revision
                ;(cons 40 (getvar "TDINDWG"))
                ;(cons 41 get_cur_date)                                   ;date at time of running
                ;(cons 42 (getvar "TDUPDATE"))
                (cons 300 item)
                (cons 301 qty)
								(cons 302 qty2)
                (cons 303 matl)
                (cons 304 stk)
                (cons 305 ft)
                (cons 306 in)
                (cons 307 mm)
                (cons 308 spec1)
                (cons 309 spec2)
                (cons 410 remarks1)
								(cons 411 remarks2)                                       ;dxf codes 410-419
					)                                                               ;or dxf codes 470-479
	)
  ;;  make Xrecord and add to NOD
  (dictadd (namedobjdict) (strcat "DWGPROPS"item) (entmakex xlist))

	
) ; end click button

	
) ; end defun
(princ)