;;; *********************************************************************************
;;; 				Starting command				     
;;; *********************************************************************************



(defun c:oSTKBK_Form1_OnDocActivated (/)
(dcl_Form_Show oSTKBK_Form1)
(princ)
)


(defun C:oSTKBK (/ cmdecho check_file)


	;; Ensure OpenDCL Runtime is (quietly) loaded
	(setq cmdecho (getvar "CMDECHO"))
	(setvar "CMDECHO" 0)
	(command "_OPENDCL")
	(setvar "CMDECHO" cmdecho)


; call the method to load the HelloWorld.odcl file.
(dcl_Project_Load "oSTKBK" T)

; call the method to show the Hello World dialog box example
;(dcl_sendstring "oSTKBK_LIST ")
(dcl_Form_Show oSTKBK_Form1)

(princ)
); c:STKBK



;;; *********************************************************************************
;;; 				Show-list command				     
;;; *********************************************************************************




  ;; subfunction for getting active searchstring
  
  (defun get_text (/ strText)
    (if (/= (setq strText (strcase (vl-string-trim " " (dcl_Control_GetText oSTKBK_Form1_TextBox1)))) "")
      (setq strText (strcat "*" strText "*"))
      (setq strText nil)
    ); if
  ); get_text

  ;; subform for changing textstring
  
  (defun change_text (/ lstSel entText)
    (while (and (setq lstSel (vl-catch-all-apply 'entsel (list "\nSelect Text <Enter to Exit>: ")))
		(not (vl-catch-all-error-p lstSel))
		(setq entText (car lstSel))
		(setq lstSel (entget entText))
		(= (cdr (assoc 0 lstSel)) "TEXT"))
      (entmod (subst (cons 1 strStockBookNumber) (assoc 1 lstSel) lstSel))
    ); while
(dcl_Control_SetKeepFocus oSTKBK_Form1 T)
  ); change_text


  ;; subform's initialization
  ;; make sure the the list is filled

(defun wcmatch_first ( lst pattern flag / result )
    (setq pattern (if flag (strcase pattern) pattern))
    (setq p pattern)
    (vl-some
       '(lambda (str) (if (wcmatch str pattern) (setq result str)))
        (if flag (mapcar 'strcase lst2lines) lst2lines)
    )
    result
(setq flasher result)
)

(defun special (/)
 (if (wcmatch_first lst2lines "*`**" nil)
    (if (wcmatch flasher "*`**")   
     (PROGN
      (dcl_Control_SetList oSTKBK_Form2_ListBox2 flasher)
       (dcl_Control_SetBackColor oSTKBK_Form2_ListBox2 1)
     )
    ) 
   (PROGN       
     (dcl_Control_SetList oSTKBK_Form2_ListBox2 "")
     (dcl_Control_SetBackColor oSTKBK_Form2_ListBox2 -5)
   )
 )
) ; special



  (defun c:oSTKBK_Form1_OnInitialize (/)
   ;(dcl_Control_ZOrder oSTKBK_Form1_TextBox1 1)
    (if (zerop (dcl_ListBox_GetCount oSTKBK_Form1_ListBox1))
      (c:oSTKBK_Form1_search_OnClicked)
    ); if
   ;(dcl_Control_SetCaption oSTKBK_Form1_Label8 check_file)
(dcl_Control_SetKeepFocus oSTKBK_Form1 T)
  ); c:oSTKBK_Form1_OnInitialize


  
  ;(defun c:oSTKBK_Form1_OnCancelClose (intIsESC /)
  ;  (if (zerop intIsESC) (c:oSTKBK_Form1_search_OnClicked))
  ;  (/= intIsESC 1)
  ;); c:oSTKBK_Form1_OnCancelClose

  ;; event handler for filter command


  
  (defun c:oSTKBK_Form1_search_OnClicked (/ strSearch strFile filFile lstLines is_text)
    (dcl_ListBox_Clear oSTKBK_Form1_ListBox1)
    (setq strSearch (get_text))

    (if strSearch
      (defun is_text (strText) 
         (wcmatch 
          (strcase strText) 
            (strcase (vl-string-subst "`#" "#" strSearch))
         )
      )
    ); if

    (if (and (findfile (setq strFile "f:\\stock\\partdes.txt"))
	     (setq filFile (open strFile "r")))
      (progn
	(if strSearch
	  (while (setq strLine (read-line filFile))
	    (if (is_text strLine) (setq lstLines (cons strLine lstLines)))
	  ); while
	  (while (setq strLine (read-line filFile))
	    (setq lstLines (cons strLine lstLines))
	  ); while
	); if
	(close filFile)
            (setq lst2lines (reverse lstlines))
      ); progn
    ); if
    (if lstLines (dcl_ListBox_AddList oSTKBK_Form1_ListBox1 (reverse lstLines)))


  ;; start the endless (!!!) loop
  
  (setq doContinue T)
  (while doContinue
    (setq doContinue nil)

    ;; show the form and save the return value
    ;; 1 = OK
    ;; 2 = ESC
    ;; any other values passing with close method
    
    (setq intRes (dcl_Form_Show oSTKBK_Form1))
    (cond
      ((= intRes 3) (change_text) (setq doContinue T))   
    ); cond
  ); while
  (princ)
); c:oSTKBK_FORM1_SEARCH


(defun c:oSTKBK_Form1_TextBox1_OnReturnPressed (/)
(c:oSTKBK_Form1_search_OnClicked)
(princ)
)

(defun c:oSTKBK_Form1_ListBox1_OnSelChanged (ItemIndexOrCount Value / full_desc desc)
(setq stock_num (SUBSTR value 1 21))
(setq full_desc (SUBSTR value 22))
(if (wcmatch full_desc "*\t*")
  (setq desc (vl-string-trim "\t" full_desc))
  (setq desc (vl-string-trim " " full_desc))
)

)
  (defun c:oSTKBK_Form1_ListBox1_OnDblClicked (/ stock_num stocknum stockassoc stocktx stockassoc)
     (dcl_Control_SetKeepFocus oSTKBK_Form1 NIL)
     (setq strStockBookNumber (substr (dcl_ListBox_GetSelectedItems oSTKBK_Form1_ListBox1) 1 21))
     (change_text)
     (princ)
  )



(defun c:oSTKBK_Form1_expand_OnClicked (/)
(dcl_Form_Show oSTKBK_Form2)
)


(defun c:oSTKBK_Form2_OnInitialize (/)
(dcl_ListBox_Clear oSTKBK_Form2_ListBox1)
(dcl_ListBox_AddList oSTKBK_Form2_ListBox1 lst2lines)
(dcl_ListBox_Clear oSTKBK_Form1_ListBox1)
    (special)
)

(defun c:oSTKBK_Form2_OnClose (UpperLeftX UpperLeftY /)
  (setq lst2lines nil)
  (c:oSTKBK_Form1_search_OnClicked)
)

(defun c:oSTKBK_Form2_ListBox1_OnDblClicked (/)
  (setq strStockBookNumber (substr (dcl_ListBox_GetSelectedItems oSTKBK_Form2_ListBox1) 1 21))
  (dcl_Form_Close oSTKBK_Form2)
  (c:oSTKBK_Form1_search_OnClicked)
  (change_text)

(princ)
)

(defun c:oSTKBK_Form2_ListBox2_OnDblClicked (/)
     (setq strStockBookNumber (substr (dcl_ListBox_GetSelectedItems oSTKBK_Form2_ListBox2) 1 21))
     (dcl_Form_Close oSTKBK_Form2)
     (change_text)
(princ)
)



;;;;;;;;;;;;;;;;;;;;;;;;;;; stock request ;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;


(defun data ( / sset i TEXT ans txt)
  (setq sset (ssget '((0 . "TEXT"))))
  (setq text "")
  (setq i 0)

  (repeat (sslengtH sset)
    (setq text (strcat text (cdr (assoc 1 (entget (ssname sset i))))" "))
    (setq i (1+ i))
  ) ;repeat

   (SETQ TXT (list (STRCAT TEXT "\n")))
   (setq new_stock_lst (APPEND new_stock_lst TXT))
   (initget 1 "Yes No")
   (setq ans (getkword "Select Again? [Y/N]:"))
    (if (= ans "Yes")
       (progn
        (data)
       ) ;progn

       (progn
         (setq manual_entry (apply 'strcat (mapcar '(lambda (x) (strcat " "x)) NEW_STOCK_LST)))
        (email)
       ) ;progn
    ) ; if
(princ)
) ; defun




(defun email ()
         (setq olApp (vlax-get-or-create-object "Outlook.Application"))
         (setq objMail (vlax-invoke olApp 'CreateItem 0))
         (vlax-put-property objMail 'Subject "Stock number request")
         (vlax-put-property objMail 'To "julia@nao.com")   ;<-----specified email
         (vlax-put-property objMail 'Body (strcat "Non Stock numbers needed for the following:" "\n" "\n"
                                           manual_entry
                                           "\n" "\n" "\n" "\n" "This is an automated email request via Autocad")
         )

         (vlax-invoke objMail 'Send)
)
(princ)
(defun c:oSTKBK_Form1_send_email_OnClicked (/)
    (setq manual_entry NIL)
    (setq new_stock_lst NIL)
    (setq manual_entry (dcl_Control_GetText oSTKBK_Form1_TextBox1))
    (email)
)


(defun c:oSTKBK_Form1_stkreq_OnClicked (/)
    (dcl_Control_SetText oSTKBK_Form1_TextBox1 "")
    (setq new_stock_lst NIL)
    (setq manual_entry NIL)
    (data)

)
(princ)



;;;;;;;;;;;;;;;;;;;;;;;;;;TEXT SCAN

(defun c:oSTKBK_Form1_next_OnClicked (/ )
(setq kk "Next")
)

(defun scantext	(/ olds)
  (SETQ SS1 (SSGET "X" (LIST (CONS 0 "TEXT"))))
  (SETQ SSL (SSLENGTH SS1))
  (SETQ CNT1 0)
  (SETQ OLDS (strcase (dcl_Control_GetText oSTKBK_Form1_TextBox1)))
(WHILE (SETQ EN (SSNAME SS1 CNT1))
    (SETQ ED (ENTGET EN))
    (SETQ ET (CDR (ASSOC 1 ED)))
    (IF	(WCMATCH ET (STRCAT "*" OLDS "*"))
      (PROGN
	(setq x1x (car (cdr (assoc 10 ed))))
	(setq y1y (cadr (cdr (assoc 10 ed))))
	(setq sclxy (CDR (assoc 40 ed)))
	(setq x2x (rtos (- x1x (* sclxy 30))))
	(setq x3x (rtos (+ x1x (* sclxy 30))))
	(setq y2y (rtos (+ y1y (* sclxy 20))))
	(setq y3y (rtos (- y1y (* sclxy 20))))
	(setq xy1 (strcat x2x "," y3y))
	(setq xy2 (strcat x3x "," y2y))
	(dcl_sendstring "(zoomtext) ")

	(setq xyx 1)
	(setq lyr1 (cdr (assoc 8 ed)))
	(setq lyr2 "0")
	(while (<= xyx 5)
	  (setq ed (subst (cons 8 lyr2) (assoc 8 ed) ed))
	  (entmod ed)
	  (setq ed (subst (cons 8 lyr1) (assoc 8 ed) ed))
	  (entmod ed)
	  (setq xyx (+ xyx 1))
	)				;end while

      )
    )
    (SETQ CNT1 (1+ CNT1))
  )
)


(defun zoomtext (/)
(command "_.zoom" "_w" xy1 xy2)
)



(defun c:oSTKBK_Form1_find_OnClicked (/)
(scantext)
(PRINC)
) ; end find onclick
