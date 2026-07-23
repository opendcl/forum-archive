(defun LM:Open ( target / Shell result ) (vl-load-com)
  (setq Shell (vla-getInterfaceObject (vlax-get-acad-object) "Shell.Application"))
  (setq result
    (and (or (eq 'INT (type target)) (setq target (findfile target)))
      (not
        (vl-catch-all-error-p
          (vl-catch-all-apply 'vlax-invoke (list Shell 'Open target))
        )
      )
    )
  )
  (vlax-release-object Shell)
  result
)


(defun c:dwghist ()

  (setvar "CMDECHO" 0)
  (command "OPENDCL")
  (dcl_project_load "dwghist.odcl")
  (dcl_Form_Show dwghist_dwghist_display)
  (princ)
)

(defun c:dwghist_dwghist_display_OnInitialize (/ datafile ofile curline file_content_list)
  (dcl_ListView_AddColumns dwghist_dwghist_display_ListView1(list (list "File Name" 0 500)))
 
  (setq datafile (strcat "C:\\dwg-history" (menucmd "M=$(edtime,$(getvar,date), MON DD YYYY)") ".txt")) 
  (dcl_Control_SetText dwghist_dwghist_display_ComboBox1 datafile)
  (setq ofile (open datafile "r"))  
  (while (setq curline (read-line ofile))  
    (setq file_content_list (cons curline file_content_list))  
  )  
  (close ofile)  
  (setq file_content_list (reverse file_content_list))
  (dcl_ListView_FillList dwghist_dwghist_display_ListView1 (mapcar 'list file_content_list))
  
) ;end OnInitialize


(defun c:dwghist_dwghist_display_ListView1_OnClicked (tRow tCol /)

(setq dwgfile (dcl_ListView_GetItemText dwghist_dwghist_display_ListView1 tRow))
  
(dcl_DWGPreview_LoadDwg dwghist_dwghist_display_DwgPreview1 dwgfile)
;(Setq opfile Column)
(princ)
)

(defun c:dwghist_dwghist_display_ListView1_OnDblClicked (oRow oCol /)
 (if (setq opendwg (dcl_ListView_GetItemText dwghist_dwghist_display_ListView1 oRow))
  (progn
 	 (dcl_Form_Close dwghist_dwghist_display)
	 (lm:open opendwg)
  )
 )
 )



(defun c:dwghist_dwghist_display_DwgPreview1_OnClicked (/)
 (dcl_Form_Show dwghist_LG_display)
  )
 
 (defun c:dwghist_LG_display_OnInitialize (/)
 
(dcl_BlockView_DisplayDwg dwghist_LG_display_BlockView1 DwgFile)
)


(defun c:dwghist_dwghist_display_ComboBox1_OnDropDown (/)
(setq hist "C:\\")
(dcl_ComboBox_Dir dwghist_dwghist_display_ComboBox1 hist "*.txt")
(princ)
)

(defun c:dwghist_dwghist_display_ComboBox1_OnSelChanged (ItemCount histfile / file_list datfile ofil curline)
  (setq datfile (strcat "C:\\" histfile))
  (setq ofil (open datfile "r"))  
   (while (setq curline (read-line ofil))  
      (setq file_list (cons curline file_list))  
  )  
  (close ofil)  

  (setq file_list (reverse file_list))
  (dcl_ListView_Clear dwghist_dwghist_display_ListView1)
  (dcl_ListView_FillList dwghist_dwghist_display_ListView1 (mapcar 'list file_list))
 
(princ)
)

(defun c:dwghist_dwghist_display_OnCancelClose (Reason /)
(dcl_ListView_Clear dwghist_dwghist_display_ListView1)
(setq current_hist (strcat "C:\\dwg-history" (menucmd "M=$(edtime,$(getvar,date), MON DD YYYY)") ".txt"))
(dcl_Control_SetText dwghist_dwghist_display_ComboBox1 current_hist)
(dcl_Form_Close dwghist_dwghist_display)
)

(defun c:dwghist_dwghist_display_OnClose (UpperLeftX UpperLeftY /)
(dcl_ListView_Clear dwghist_dwghist_display_ListView1)
(setq current_hist (strcat "C:\\dwg-history" (menucmd "M=$(edtime,$(getvar,date), MON DD YYYY)") ".txt"))
(dcl_Control_SetText dwghist_dwghist_display_ComboBox1 current_hist)
(dcl_Form_Close dwghist_dwghist_display)
)


(defun c:dwghist_dwghist_display_file_merge_OnClicked (/ YESNO)
(dcl_Form_Show dwghist_merge_confirmation)
)


(defun c:dwghist_dwghist_display_dwg_hist_close_OnClicked (/)
(dcl_Form_Close dwghist_dwghist_display)
)

(defun c:dwghist_merge_confirmation_merge_yes_OnClicked (/)
(dcl_Form_Close dwghist_merge_confirmation)
(load "merge_files")
(c:merge)
)

(defun c:dwghist_merge_confirmation_merge_no_OnClicked (/)
(dcl_Form_Close dwghist_merge_confirmation)
)

; dwgbrowser
;(dcl_Form_Show dwgbrowser_Form4)




