;;; *********************************************************************************
;;; 				Starting command				     
;;; *********************************************************************************




(defun c:STKBK (/ cmdecho )

  ;; Ensure OpenDCL Runtime is (quietly) loaded
  ;; but only if it wasn't already loaded
  (if (not dcl_Project_Load)
    (progn
      (setq cmdecho (getvar "CMDECHO"))
      (setvar "CMDECHO" 0)
      (command "_OPENDCL")
      (setvar "CMDECHO" cmdecho)
    ); progn
  ); if

  (cond

    ;; project is not loaded yet
    
    ((not STKBK_Form1)
     (dcl_Project_Load "STKBK")
     (dcl_Form_Show STKBK_Form1))

    ;; form is not active yet
    
    ((not (dcl_Form_isactive STKBK_Form1))
     (dcl_Form_Show STKBK_Form1))

    ;; form is active but not visible yet
    
    ((not (dcl_Form_IsVisible STKBK_Form1))
     (dcl_Form_Hide STKBK_Form1 nil))
     
  ); cond
  (princ)
); c:STKBK

;; Events of a modeless form, palette or Dockable form must not be locally defined!!!
;; In this case this event handler is nonsense, see the button at the button of the modeless form for a better solution

(defun c:STKBK_Form1_TextButton1_OnClicked (/)
  (dcl_sendstring "STKBK_LIST ")
); c:STKBK_Form1_TextButton1_OnClicked






;;; *********************************************************************************
;;; 				Show-list command				     
;;; *********************************************************************************




(defun c:STKBK_LIST (/ change_text get_text
		       strStockBookNumber doContinue intRes
		       c:STKBK_stockbook_OnCancelClose
		       c:STKBK_stockbook_search_OnClicked
		       c:STKBK_stockbook_clear_OnClicked
		       c:STKBK_stockbook_ListBox1_OnDblClicked
		     )

  ;; Is the main form active and visible?
  ;; Then make it invisible, but don't close it.
  
  (if (and (dcl_Form_isactive STKBK_Form1)
	   (dcl_Form_IsVisible STKBK_Form1))
    (dcl_Form_Hide STKBK_Form1 T)
  ); if

  ;; subfunction for getting active searchstring
  
  (defun get_text (/ strText)
    (if (/= (setq strText (strcase (vl-string-trim " " (dcl_Control_GetText STKBK_stockbook_TextBox1)))) "")
      (setq strText (strcat "*" strText "*"))
      (setq strText nil)
    ); if
  ); get_text

  ;; subform for changing textstring
  
  (defun change_text (/ lstSel entText)
    (while (and (setq lstSel (vl-catch-all-apply 'entsel (list "\nSelect Text: ")))
		(not (vl-catch-all-error-p lstSel))
		(setq entText (car lstSel))
		(setq lstSel (entget entText))
		(= (cdr (assoc 0 lstSel)) "TEXT"))
      (entmod (subst (cons 1 strStockBookNumber) (assoc 1 lstSel) lstSel))
    ); while
  ); change_text

  ;; subform's initialization
  ;; make sure the the list is filled
  ;; and make sure that the clear button is only visible
  ;; if a valid searchstring was set

  (defun c:STKBK_stockbook_OnInitialize (/)
    (if (zerop (dcl_ListBox_GetCount STKBK_stockbook_ListBox1))
      (c:STKBK_stockbook_search_OnClicked)
      (dcl_control_setvisible STKBK_stockbook_clear (if (get_text) T))
    ); if
  ); c:STKBK_stockbook_OnInitialize

  ;; when pressing enter in the textbox
  ;; the subform must not be closed
  ;; call the filter command instead
  
  (defun c:STKBK_stockbook_OnCancelClose (intIsESC /)
    (if (zerop intIsESC) (c:STKBK_stockbook_search_OnClicked))
    (/= intIsESC 1)
  ); c:STKBK_stockbook_OnCancelClose

  ;; event handler for filter command
  
  (defun c:STKBK_stockbook_search_OnClicked (/ strSearch strFile filFile lstLines is_text)
    (dcl_ListBox_Clear STKBK_stockbook_ListBox1)
    (setq strSearch (get_text))

    (if strSearch
      (defun is_text (strText) (wcmatch (strcase strText) strSearch))
    ); if
    (dcl_control_setvisible STKBK_stockbook_clear (if strSearch T))

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

  ;; clear searchstring textbox and
  ;; list all the items of the textfile
  
  (defun c:STKBK_stockbook_clear_OnClicked (/)
    (dcl_Control_SetText STKBK_stockbook_TextBox1 "")
    (c:STKBK_stockbook_search_OnClicked)
  ); c:STKBK_stockbook_clear_OnClicked

  ;; read the StockBockNumber and close the form
  ;; and pass the own value 3
  
  (defun c:STKBK_stockbook_ListBox1_OnDblClicked (/)
    (setq strStockBookNumber (substr (dcl_ListBox_GetSelectedItems STKBK_stockbook_ListBox1) 1 21))
    (dcl_Form_Close STKBK_stockbook 3)
  ); c:STKBK_stockbook_ListBox1_OnDblClicked

  ;; start the endless (!!!) loop
  
  (setq doContinue T)
  (while doContinue

    ;;; cancel the endless loop
    (setq doContinue nil)

    ;; show the form and save the return value
    ;; 1 = OK
    ;; 2 = ESC
    ;; any other values passing with close method
    
    (setq intRes (dcl_Form_Show STKBK_stockbook))

    ;; evaluate the return value
    (cond

      ;; if the close method was invoked in the listbox
      ;; change the text and restart the loop the show the form again
      ((= intRes 3) (change_text) (setq doContinue T))

      ;; otherwise leave the loop
      
    ); cond
  ); while

  ;; was the main form visible before?
  ;; then make it visible again
  
  (if (and (dcl_Form_isactive STKBK_Form1)
	   (not (dcl_Form_IsVisible STKBK_Form1)))
    (dcl_Form_Hide STKBK_Form1 nil)
  ); if

  (princ)
); c:STKBK_LIST
