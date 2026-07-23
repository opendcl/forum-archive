(defun C:Batchtest (/ item)
  (initerr)
  (command "undo" "m")
  (setvar "CMDECHO" 0)
  (command "_opendcl")
  (dcl_Project_Load "BatchListBox.odcl")
  (dcl_Form_show batchlistbox_form1)
  (princ)
)
;;-------------------------------------
(defun c:BatchListBox_Form1_OnInitialize (/)
  (dcl_Control_SetValue BatchListBox_Form1_OptionButton1 0)
  (dcl_Control_SetValue BatchListBox_Form1_OptionButton2 0)
  (setq magellanbtton 0)
  (setq buckeyebtton 0)
  (dcl_OptionList_Clear BatchListBox_Form1_OptionList2)
)


;;-------------------------------------
(defun c:BatchListBox_Form1_OptionButton1_OnClicked (Value /)
  (setq	magellanbtton
	 (dcl_Control_GetValue
	   BatchListBox_Form1_OptionButton1
	 )
  )
  (cond
    ((= 1 magellanbtton)
     (setq buckeyebtton 0)
     (dcl_OptionList_Clear BatchListBox_Form1_OptionList2)
     (dcl_Control_SetBackColor
       BatchListBox_Form1_OptionList2
       -24
     )
     (dcl_OptionList_AddList
       BatchListBox_Form1_OptionList2
       "For Review"
       "For Bid"
       "For Construction"
     )
    )
  )
)

(defun c:BatchListBox_Form1_OptionButton2_OnClicked (Value /)
  (setq	buckeyebtton
	 (dcl_Control_GetValue BatchListBox_Form1_OptionButton2)
  )
  (cond
    ((= 1 buckeyebtton)
     (setq magellanbtton 0)
     (dcl_OptionList_Clear BatchListBox_Form1_OptionList2)
     (dcl_Control_SetBackColor
       BatchListBox_Form1_OptionList2
       -24
     )
     (dcl_OptionList_AddList
       BatchListBox_Form1_OptionList2
       "For Review"		  "For Bid"
       "For Construction"	  "For Approval"
      )
    )
  )
)

;;;(defun c:BatchListBox_Form1_OptionList1_OnSelChanged (ItemIndexOrCount Value /)
;;;  (dcl_OptionList_Clear BatchListBox_Form1_OptionList2)
;;;  (cond
;;;    ((= ItemIndexOrCount 0)
;;;     (dcl_OptionList_Clear BatchListBox_Form1_OptionList2)
;;;     (dcl_OptionList_AddList BatchListBox_Form1_OptionList2 "For Review" "For Bid" "For Construction")
;;;     )
;;;    ((= ItemIndexOrCount 1)
;;;     (dcl_OptionList_Clear BatchListBox_Form1_OptionList2)
;;;     (dcl_OptionList_AddList BatchListBox_Form1_OptionList2 "For Review" "For Bid" "For Construction" "For Approval")
;;;     )
;;;    )
;;;  )

;;-------------------------------------
(DEFUN c:BatchListBox_Form1_SelectFiles_OnClicked (/ fn)
  (SETQ	bs_filelist
	 (DCL_MULTIFILEDIALOG
	   "Drawing files (*.dwg)|*.dwg||" ; Filters
	   "Select files"		; Title
	   (IF g:lastfolder
	     g:lastfolder
	     (GETVAR "DWGPREFIX")
	   )				; Default Folder
	 )
  )
  (IF bs_filelist
    (PROGN
      (SETQ g:lastfolder (VL-FILENAME-DIRECTORY (CAR bs_filelist)))
      (FOREACH fn bs_filelist
	(IF
	  (< (DCL_LISTBOX_FINDSTRINGEXACT batchlistbox_Form1_ListBox fn)
	     0
	  )
	   (DCL_LISTBOX_ADDSTRING batchlistbox_Form1_ListBox fn)
	)
      )
    )
  )
)
;;----------------------------------------------------
(DEFUN c:batchlistbox_form1_clearlist_onclicked	(/)
  (DCL_LISTBOX_CLEAR batchlistbox_form1_listbox)
)
;;----------------------------------------------------
(DEFUN c:batchlistbox_form1_remove_onclicked (/ rsel item)
  (IF (SETQ rsel (DCL_LISTBOX_GETSELECTEDNTHS batchlistbox_Form1_ListBox))
    (PROGN
      (FOREACH item (REVERSE rsel)
	(DCL_LISTBOX_DELETEITEM batchlistbox_Form1_ListBox item)
      )
      (SETQ g:bs_filelist '())
      (SETQ item (DCL_LISTBOX_GETCOUNT batchlistbox_Form1_ListBox))
      (WHILE (>= (SETQ item (1- item)) 0)
	(SETQ
	  g:bs_filelist
	   (CONS
	     (DCL_LISTBOX_GETITEMTEXT batchlistbox_Form1_ListBox item)
	     g:bs_filelist
	   )
	)
      )
    )
  )
)
;;----------------------------------------------------
(defun c:BatchListBox_Form1_Batch_OnClicked (/)
  (DCL_FORM_CLOSE BatchListBox_Form1)
  (vl-load-com)
  (load "review.lsp")
  (cond
    (bs_filelist
     (vlax-for & (vla-get-documents (vlax-get-acad-object))
       (setq FilesList
	      (cons (strcase (vla-get-fullname &)) FilesList)
       )
     )
     (foreach &	bs_filelist
       (cond
	 ((not (member & FilesList))
	  (cond
	    ((setq File	(vla-open (vla-get-documents
				    (vlax-get-acad-object)
				  )
				  &
			)
	     )
	     (prompt (strcat "\nPurge " & ". Please wait..."))
;;;	     (selelisp file)
	     (vla-sendcommand file "review\r")
	     (vla-AuditInfo File T)
	     (prompt (strcat "\nSave and close " &))
	     (vla-save File)
	     (vla-close File)
	     (vlax-release-object File)
	    )
	  )
	 )

       )
     )
    )
  )
)

;;;)

;;----------------------------------------------------
(defun
	  c:BatchListBox_Form1_ExitDialog_OnClicked
						   (/)
  (DCL_FORM_CLOSE BatchListBox_Form1)
  (princ)
)

(princ)
