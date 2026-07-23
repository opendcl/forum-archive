(defun c:STKBK (/ cmdecho )


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

(defun start_form (/ doContinue intRes)
  (setq doContinue T)
  (while doContinue
    (setq doContinue nil)
    (setq intRes (dcl_Form_Show STKBK_stockbook))
    (cond
      ((= intRes 3) (change_text) (setq doContinue T))
    ); cond
  ); while
); start_form

(defun change_text (/ lstSel entText)
  (while (and (setq lstSel (vl-catch-all-apply 'entsel (list "\nSelect Text: ")))
	      (not (vl-catch-all-error-p lstSel))
	      (setq entText (car lstSel))
	      (setq lstSel (entget entText))
	      (= (cdr (assoc 0 lstSel)) "TEXT"))
    (vla-put-textstring (vlax-ename->vla-object entText) stockno)
  ); while
); change_text


(defun c:STKBK_Form1_TextButton1_OnClicked (/)
  (dcl_Form_Close STKBK_Form1 5)
  (start_form)
); c:STKBK_Form1_TextButton1_OnClicked


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; stock book search ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(defun c:dwgbrowser_stockbook_OnInitialize (/)
  (dcl_Control_SetText STKBK_stockbook_TextBox1 "")
); c:dwgbrowser_stockbook_OnInitialize


(defun c:STKBK_stockbook_search_OnClicked (/ strSearch strFile filFile lstLines is_text)
  (dcl_ListBox_Clear STKBK_stockbook_ListBox1)
  (if (/= (setq strSearch (strcase (vl-string-trim " " (dcl_Control_GetText STKBK_stockbook_TextBox1)))) "")
    (setq strSearch (strcat "*" strSearch "*"))
    (setq strSearch nil)
  ); if

  (if strSearch
    (defun is_text (strText) (wcmatch (strcase strText) strSearch))
  ); if
  
  (if (and (findfile (setq strFile "d:\\partdes.txt"))
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
    ); progn
  ); if

  (if lstLines (dcl_ListBox_AddList STKBK_stockbook_ListBox1 (reverse lstLines)))
); c:STKBK_stockbook_search_OnClicked

(defun c:STKBK_stockbook_ListBox1_OnDblClicked (/)
  (setq stockno (substr (dcl_ListBox_GetSelectedItems STKBK_stockbook_ListBox1) 1 21))
  (dcl_Form_Close STKBK_stockbook 3)
); c:STKBK_stockbook_ListBox1_OnDblClicked

(princ)
