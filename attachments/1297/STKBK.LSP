(defun c:STKBK (/ cmdecho)


	;; Ensure OpenDCL Runtime is (quietly) loaded
	(setq cmdecho (getvar "CMDECHO"))
	(setvar "CMDECHO" 0)
	(command "_OPENDCL")
	(setvar "CMDECHO" cmdecho)


; call the method to load the HelloWorld.odcl file.
(dcl_Project_Load "STKBK" T)

; call the method to show the Hello World dialog box example
(dcl_Form_Show STKBK_Form1)
(princ)
)


(defun c:STKBK_Form1_TextButton1_OnClicked (/)
(dcl_Form_Close STKBK_Form1)
(dcl_Form_Show STKBK_stockbook)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; stock book search ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(defun c:dwgbrowser_stockbook_OnInitialize (/)
(dcl_Control_SetText STKBK_stockbook_TextBox1 "")
;(dcl_ListBox_Clear STKBK_stockbook_ListBox1)
)


(defun c:STKBK_stockbook_search_OnClicked (/ TextFile SearchStr tmpLine EndList Opened)
;(dcl_ListBox_Clear dwgbrowser_stockbook_ListBox1)
(if (and (findfile (setq TextFile "f:\\stock\\partdes.txt"))

       (setq SearchStr (strcase (dcl_Control_GetText STKBK_stockbook_TextBox1)))
       (setq Opened (open TextFile "r"))
     )
   (while (setq tmpLine (read-line Opened))
     (if (vl-string-search (strcase SearchStr) (strcase tmpLine))
        (setq EndList (cons tmpLine EndList))
     ) ; end if
   ) ; end while
) ; end if

(if EndList
 (foreach i EndList
  (setq display_stock (append display_stock (list i)))
 ) ; end foreach
) ; end if endlist
  

(dcl_Control_SetList STKBK_stockbook_ListBox1 display_stock)
) ; end defun
(princ)

(defun c:STKBK_stockbook_ListBox1_OnDblClicked (/)
(setq stockno (substr (dcl_ListBox_GetSelectedItems STKBK_stockbook_ListBox1) 1 21))
(dcl_Form_Close STKBK_stockbook)
(WHILE
      (setq stocknum (entsel "\nSelect Text: "))
      (setq stockassoc (entget (car stocknum)))
      (setq stocktx stockno)
      (setq stockassoc (subst (cons 1 stocktx) (assoc 1 stockassoc) stockassoc))
      (entmod stockassoc)
) ;END WHILE
)
(princ)
