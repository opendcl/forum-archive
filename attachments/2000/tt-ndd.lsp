(defun ttndd (/ cmdecho en ent txto etyp txtn)
(DOS_CAPSLOCK T)
(setq en (ssget))
(setq ent (ssname en 0))
(SETQ EN (ENTGET ENT))
(setq ETYP (cdr (assoc 0 en)))
  		(IF (= ETYP "TEXT") 
		   (PROGN
      	    (SETQ TXTO (CDR (ASSOC 1 EN)))
    	   );end progn
  		);end if
  		(IF (= ETYP "INSERT")
           (IF (NOT (OR (= (CDR (ASSOC 2 EN)) "TBALL")
		                (= (CDR (ASSOC 2 EN)) "REVTRI")
		                (= (CDR (ASSOC 2 EN)) "NAOTAG-S")
						(= (CDR (ASSOC 2 EN)) "NAOTAG-M")
						(= (CDR (ASSOC 2 EN)) "NAOTAG-L")
					)
			   )		
    	    (PROGN
			 (command "ddatte" ENT)
			 (exit)
      	    );end progn
		    (PROGN
		     (SETQ EN (ENTGET (ENTNEXT ENT)))
			 (SETQ TXTO (CDR (ASSOC 1 EN)))
			);end progn
			);end if
  		);endif

	;; Ensure OpenDCL Runtime is (quietly) loaded
	(setq cmdecho (getvar "CMDECHO"))
	(setvar "CMDECHO" 0)
	(command "_OPENDCL")
	(setvar "CMDECHO" cmdecho)

  (defun add_under ()
    	(setq txtn (dcl_Control_GetText test-ndd_Form1_TextBox1))
    	(if (or (= (substr txtn 1 3) "%%U") (= (substr txtn 1 3) "%%u"))
      		(dcl_Control_SetText test-ndd_Form1_TextBox1 txtn )
      		(dcl_Control_SetText test-ndd_Form1_TextBox1(strcat "%%u" txtn))
    	);end if
  );end function

  (defun del_under () 
    	(setq txtn (dcl_Control_GetText test-ndd_Form1_TextBox1))
    	(if (or (= (substr txtn 1 3) "%%U") 
                (= (substr txtn 1 3) "%%u")
                (= (substr txtn 1 3) "{\L")
            )
			(dcl_Control_SetText test-ndd_Form1_TextBox1 (substr txtn 4))
    	);end if
  );end function

  (defun add_paren ()
    	(setq txtn (dcl_Control_GetText test-ndd_Form1_TextBox1))
    	(if (OR (= (substr txtn 1 3) "%%U") (= (substr txtn 1 3) "%%u"))
      		(dcl_Control_SetText test-ndd_Form1_TextBox1 (strcat "%%U(" (substr txtn 4) ")"))
      		(dcl_Control_SetText test-ndd_Form1_TextBox1 (strcat "(" txtn ")"))
    	);end if
  );end function

(defun _ConvertColorStringToNumber (ColorString / tmp)
    (setq ColorString (vl-string-subst "" "Color " ColorString))
    (cond ((numberp (setq tmp (read ColorString))) tmp)
          ((numberp (setq tmp (eval (read (strcat "ac" ColorString))))) tmp)
          (t 8)
    )
)

(defun check_stock (/ TextFile SearchStr tmpLine EndList Opened GOOD_STK)
(if
(and
(findfile (setq TextFile "f:\\stock\\partdes.txt"))
(setq SearchStr txto)
(setq Opened (open TextFile "r"))
)
(while (setq tmpLine (read-line Opened))
(if (vl-string-search (strcase SearchStr) (strcase tmpLine))
(setq EndList (cons tmpLine EndList))
)
)
)
(if EndList
(progn
 (if (> (length endlist) 1)
  (PROGN
    (dcl_Control_SetText test-ndd_Form1_TextBox2 "More then 1 entry, use stock book search")
  )
  (PROGN
     (if (wcmatch TXTO "*@*")
	   (PROGN
         (dcl_Control_SetText test-ndd_Form1_TextBox2 (NTH 0 ENDLIST))
	   )
       (PROGN
         (SETQ GOOD_STK (SUBSTR (NTH 0 endlist) 24))
         (dcl_Control_SetText test-ndd_Form1_TextBox2 GOOD_STK)
	   ) ;END PROGN
     ) ;END IF
  ) ;END PROGN
 )   ;END IF
)   ;END PROGN
(dcl_Control_SetText test-ndd_Form1_TextBox2 "NOT AVAILABLE")
)   ;end endlist

(princ)
) ;end defun check_stock 
 
; call the method to load the odcl file.
(dcl_Project_Load "test-ndd" T)

; call the method to show the Hello World dialog box example
(dcl_Form_Show test-ndd_Form1)
(princ)
) ;end defun

(defun c:test-ndd_Form1_OnInitialize (/)
(setq newval nil)
(dcl_ComboBox_SetCurSel test-ndd_Form1_ComboBox1 0)
(setq cursel (dcl_ComboBox_GetCurSel test-ndd_Form1_ComboBox1))
(dcl_Control_SetText test-ndd_Form1_TextBox1 TXTO)
(dcl_Control_SetValue test-ndd_Form1_CheckBox2 1)
             (dcl_Control_SetVisible test-ndd_Form1_ComboBox1 nil)
			 (dcl_Control_SetVisible test-ndd_Form1_CheckBox1 nil)
			 (setq newval "ByLayer")
			 (dcl_Control_SetVisible test-ndd_Form1_Label3 nil)
(check_stock)	 			 
(princ) 
)

(defun c:test-ndd_Form1_ComboBox1_OnSelChanged (ItemIndex Value /)
;(dcl_Control_SetValue test-ndd_Form1_CheckBox1 cursel)
(setq am itemindex)
  (setq newval Value)
  (if (or (/= newval "ByLayer") (/= newval "ByBlock"))
     (progn
      (setq colornumber (_ConvertColorStringToNumber Value))
	 )
	 (progn
	 (setq newval Value)
	 (setq colornumber nil)
	 )
  )
)
(defun c:test-ndd_Form1_TextButton1_OnClicked (/)
  (add_paren)
)
(defun c:test-ndd_Form1_TextButton2_OnClicked (/)
 (add_under)
)
(defun c:test-ndd_Form1_TextButton3_OnClicked (/)
(del_under)
)
(defun c:test-ndd_Form1_CheckBox1_OnClicked (Value /)

   (cond ((= (dcl_Control_GetValue test-ndd_Form1_CheckBox1) 1) 
            (progn
			(setq newval nil)
             (dcl_Control_SetVisible test-ndd_Form1_ComboBox1 nil)
			 (dcl_Control_SetVisible test-ndd_Form1_CheckBox2 nil)
			 (dcl_Control_SetVisible test-ndd_Form1_Label3 T)
             (setq colornumber 2)
            )
		 )
         ((= (dcl_Control_GetValue test-ndd_Form1_CheckBox1) 0) 
		    (progn
			(dcl_Control_SetVisible test-ndd_Form1_Label3 nil)
             (dcl_Control_SetVisible test-ndd_Form1_ComboBox1 T)
			 (dcl_Control_SetVisible test-ndd_Form1_CheckBox2 T)
             (setq newval "ByLayer")
            )
		  )
   ) ; end of cond statment
)

(defun c:test-ndd_Form1_CheckBox2_OnClicked (Value /)

   (cond ((= (dcl_Control_GetValue test-ndd_Form1_CheckBox2) 1) 
		    (progn
			 (dcl_Control_SetValue test-ndd_Form1_CheckBox1 0)
             (dcl_Control_SetVisible test-ndd_Form1_ComboBox1 nil)
			 (dcl_Control_SetVisible test-ndd_Form1_CheckBox1 nil)
			 (dcl_Control_SetVisible test-ndd_Form1_Label3 nil)
			 (dcl_Control_SetVisible test-ndd_Form1_Label2 T)
			 (setq newval "ByLayer")
            )
	     )
		 ((= (dcl_Control_GetValue test-ndd_Form1_CheckBox2) 0) 
		    (progn
			 (dcl_Control_SetVisible test-ndd_Form1_Label2 nil)
             (dcl_Control_SetVisible test-ndd_Form1_ComboBox1 T)
			 (dcl_Control_SetVisible test-ndd_Form1_CheckBox1 T)
			 (dcl_Control_SetVisible test-ndd_Form1_Label3 nil)
            )
		  )
	 )
)

(defun c:test-ndd_Form1_TextButton4_OnClicked (/)
  (setq TXTN (dcl_Control_GetText test-ndd_Form1_TextBox1))
  
   (cond ((= (dcl_Control_GetValue test-ndd_Form1_OptionButton1) 1) (setq TXTN (strcase TXTN)))
         ((= (dcl_Control_GetValue test-ndd_Form1_OptionButton2) 1) (setq TXTN (strcase TXTN t)))
   ) ; end of cond statment
   
(dcl_Form_Close test-ndd_Form1)

   (setq EN (subst (cons 1 TXTN) (cons 1 TXTO) EN))
   (entmod EN)

	 (if (or (= newval "ByLayer") (= newval "ByBlock"))
	  (progn
	    (command "chprop" ent "" "C" newval "")
       )
      (progn
	  (if (>= colornumber 0)
	    (progn
        (setq newpair (cons 62 colornumber))
         (progn
          (setq elist (entget ent))
             (if (setq oldpair (assoc 62 elist))
                 (setq elist (subst newpair oldpair elist))
                 (setq elist (append elist (list newpair)))
             )
          (entmod elist)
          )
		)
	  )
	  )
     )
	 (princ)
)
(defun c:test-ndd_Form1_TextButton5_OnClicked (/)
  (dcl_Form_Close test-ndd_Form1)
  (princ)
)
(defun c:test-ndd_Form1_OnOK (/)
  (c:test-ndd_Form1_TextButton4_OnClicked)
  (princ)
)

(ttndd)
(princ)