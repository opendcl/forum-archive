; Ensure the appropriate OpenDCL ARX file is loaded

(defun c:tb1 (/ cmdecho)


	;; Ensure OpenDCL Runtime is (quietly) loaded
	(setq cmdecho (getvar "CMDECHO"))
	(setvar "CMDECHO" 0)
	(command "_OPENDCL")
	(setvar "CMDECHO" cmdecho)


; call the method to load the odcl file.
(dcl_Project_Load "od-toolbox" T)

; call the method to show the dialog box
(dcl_Form_Show od-toolbox_Form1)
(princ)
)
;
;;closes the dialog
(defun c:od-toolbox_Form1_TextButton1_OnClicked (/)
(dcl_Form_Close od-toolbox_Form1)
(princ)
)

;;
;
(defun c:od-toolbox_Form1_OnInitialize (/ strFolder)
(setq strFolder (getvar "DWGPREFIX"))
(dcl_ComboBox_AddPath od-toolbox_Form1_ComboBox1 strFolder)
(dcl_ComboBox_SelectString od-toolbox_Form1_ComboBox1 strFolder)
(dcl_DWGList_Dir od-toolbox_Form1_DwgList1 strFolder)

)  ;end oninitialize



;;
;;;;;;;;;;;;;;;;;; file search;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:od-toolbox_Form1_GraphicButton8_OnClicked (/)
      (dcl_Control_SetCaption od-toolbox_Form1_Label1 "Searching...")
      (dcl_Control_SetCaption od-toolbox_Form1_Label2 "")

  (setq fln (dcl_Control_GetText od-toolbox_Form1_TextBox1))
   (SETQ A1 (CAR (DOS_FIND (strcat "Q:\\" FLN ".dwg"))))
     (if A1 
      (progn
        (dcl_Control_SetCaption od-toolbox_Form1_Label1 "found")
        (dcl_Control_SetCaption od-toolbox_Form1_Label2 A1)
        (setq preview A1)
      )
      (progn
        (dcl_Control_SetCaption od-toolbox_Form1_Label1 "DWG not Found!")        
        (dcl_Control_SetCaption od-toolbox_Form1_Label2 "")
      )
     )

	(setq sFileName A1);_ get the path to a dwg file
	(if sFileName
		(progn
		  (dcl_DWGPreview_LoadDwg od-toolbox_Form1_DwgPreview1 sFileName);_ load the DWG Thumbn			
		)
	)

(princ)
)

;; opend the dwg from file search
(defun c:od-toolbox_Form1_GraphicButton9_OnClicked (/)
      (vlax-invoke-method (vla-get-Documents (vlax-get-acad-object)) "Open" A1)
(princ)
)


;;;;;;;;;;;;;;;;;;;;;; opend 3rd party app, Questica Export tool;;;;;;;;;;;;;;;;;

(defun c:od-toolbox_Form1_TextButton3_OnClicked (/)
  (startapp "Z:\\Questica Import\\NAOtoQuesticaImportTool.exe")
(princ)
)

;;;;;;;;;;;;;;;;;;;;

(defun c:od-toolbox_Form1_ComboBox1_OnSelChanged (intItemIndexOrCount strFolder / path)
(setq path strfolder)
              (if (= path "H:\\")
                  (dcl_Form_Show od-toolbox_NAO_BLOCK_DIR)
                  (dcl_DWGList_Dir od-toolbox_Form1_DwgList1 path)
               )
(princ)
)

;;;;;;;;;;;;;;;;Displays drawing directory and drawing list;;;;;;;;;;;;;;;;;


(defun c:od-toolbox_Form1_TextButton5_OnClicked (/ strfolder lstchars)
(setq strfolder (dcl_DWGList_GetDir od-toolbox_Form1_DwgList1))
  (if (setq lstChars (reverse (cdr (member 92 (reverse (vl-string->list strFolder))))))
    (progn
      (setq strFolder (apply 'strcat (mapcar 'chr lstChars)))
(dcl_DWGList_Dir od-toolbox_Form1_DwgList1 strfolder)
(dcl_ComboBox_AddPath od-toolbox_Form1_ComboBox1 strfolder)
(dcl_ComboBox_SelectString od-toolbox_Form1_ComboBox1 strfolder)
)
(princ)
)

)
(defun c:od-toolbox_Form1_DwgList1_OnFolderChanged (strFolderPath /)
(dcl_ComboBox_AddPath od-toolbox_Form1_ComboBox1 strFolderPath)
(dcl_ComboBox_SelectString od-toolbox_Form1_ComboBox1 strFolderPath)
)

(defun c:od-toolbox_Form1_DwgList1_OnDblClicked (/ strfile)
	(if (Setq strfile (dcl_DWGList_GetFileName od-toolbox_Form1_DwgList1))
           (progn      (vl-bb-set '***strDoc*** strFile)
     (dcl_sendstring "browser_open ")
            )
         )
(princ)
)

;;;;;;;;;;;;;;;;Opens dwg for larger preview window;;;;;;;;;;;;;;;;;

(defun c:browser_open (/)
(dcl_Form_Show od-toolbox_Form2)
  (princ)
); c:browser_open

;;;;;;;;;;;;;;; Browse for Dwg directory;;;;;;;;;;;;;;;;;

(defun c:od-toolbox_Form1_TextButton6_OnClicked (/)
	(IF (SETQ path (dcl_SELECTFOLDER "Select a folder" nil nil 16))
              (if (= path "H:\\")
                  (dcl_Form_Show od-toolbox_NAO_BLOCK_DIR)
                  (dcl_DWGList_Dir od-toolbox_Form1_DwgList1 path)
               )
	)
(princ)
)

(defun c:od-toolbox_Form2_OnInitialize (/ strfile)
  (if (setq strFile (vl-bb-ref '***strDoc***))
    (dcl_BlockView_LoadDwg od-toolbox_Form2_BlockView1 strfile)
  ); if
  (vl-bb-set '***strDoc*** nil)
  (princ)
)

;;;;;;;;;;;;;;;;Open Dwg from larger preview window;;;;;;;;;;;;;;;;

(defun c:od-toolbox_Form2_BlockView1_OnDblClicked (/)
	(if (Setq opfile (dcl_DWGList_GetFileName od-toolbox_Form1_DwgList1))
(vlax-invoke-method (vla-get-Documents (vlax-get-acad-object)) "Open" opfile)
         )
(princ)
)

;;;;;;;;;;;;;;;;;Opens "Open Dwg History" window;;;;;;;;;;;;;;;;;;;;

(defun c:od-toolbox_Form1_GraphicButton10_OnClicked (/)
  (dcl_Form_Show od-toolbox_Form3)
(princ)
)

;;;;;;;;;;;;;;;;;;;;;;;; FORM3 / DWGHISTORY;;;;;;;;;;;;;;;;;;

(defun c:od-toolbox_Form3_OnInitialize (/ datafile ofile curline file_content_list)
  (setq datafile (strcat "C:\\dwg-history" (menucmd "M=$(edtime,$(getvar,date), MON DD YYYY)") ".txt")) 
(dcl_Control_SetText od-toolbox_Form3_ComboBox1 datafile) 
  (setq ofile (open datafile "r"))  
  (while (setq curline (read-line ofile))  
    (setq file_content_list (cons curline file_content_list))  
  )  
  (close ofile)  
  (setq file_content_list (reverse file_content_list)) 
(dcl_ListBox_Clear od-toolbox_Form3_ListBox1) 
  (dcl_ListBox_AddList od-toolbox_Form3_ListBox1 file_content_list)  
(princ)
)  ;end oninitialize

;;;;;;;;;;;;;;;;;;;;;;Display thumbnail of selected dwg from "Open Dwg History";;;;;;;;;;;;;;;

(defun c:od-toolbox_Form3_ListBox1_OnSelChanged (nselection sseltext /)

(dcl_DWGPreview_LoadDwg od-toolbox_Form3_DwgPreview1 sseltext)
(Setq opfile sseltext)
(princ)
)

(defun c:od-toolbox_Form3_DwgPreview1_OnDblClicked (/)
(if (findfile opfile)
(progn
(dcl_Form_Close od-toolbox_Form3)
(vlax-invoke-method (vla-get-Documents (vlax-get-acad-object)) "Open" opfile)
)
(dcl_MessageBox "File no longer exists!")
)
(princ)
)

;;;;;;;;;;;;;;;;;;;drop down list to select "Open Dwg History";;;;;;;;;;;;;;;;;

(defun c:od-toolbox_Form3_ComboBox1_OnDropDown (/)
(setq hist "C:\\")
(dcl_ComboBox_Dir od-toolbox_Form3_ComboBox1 hist "*.txt")
(princ)
)


(defun c:od-toolbox_Form3_ComboBox1_OnSelChanged (ItemCount histfile / file_list datfile ofil curline)
  (setq datfile (strcat "C:\\" histfile))
  (setq ofil (open datfile "r"))  
   (while (setq curline (read-line ofil))  
      (setq file_list (cons curline file_list))  
  )  
  (close ofil)  

  (setq file_list (reverse file_list)) 
(dcl_ListBox_Clear od-toolbox_Form3_ListBox1) 
  (dcl_ListBox_AddList od-toolbox_Form3_ListBox1 file_list)  
(princ)
)

(defun c:od-toolbox_Form3_OnCancelClose (Reason /)
(dcl_ListBox_Clear od-toolbox_Form3_ListBox1) 
(setq current_hist (strcat "C:\\dwg-history" (menucmd "M=$(edtime,$(getvar,date), MON DD YYYY)") ".txt"))
(dcl_Control_SetText od-toolbox_Form3_ComboBox1 current_hist)
(dcl_Form_Close od-toolbox_Form3)
)

(defun c:od-toolbox_Form1_TextButton2_OnClicked (/)
(initdia)
(command "saveas")
(princ)
)


;;;;;;;;;;;;;;;;;;;;;;;;;; NAO BLOCK DIR ;;;;;;;;;;;;;;;

(defun c:od-toolbox_NAO_BLOCK_DIR_OnInitialize (/)
(SETQ NAO_BLOCK_DIR PATH)
(dcl_Control_SetTitleBarText od-toolbox_NAO_BLOCK_DIR path)
(dcl_ListBox_Dir od-toolbox_NAO_BLOCK_DIR_ListBox1 NAO_BLOCK_DIR "*.DWG")
(princ)
)

(defun c:od-toolbox_NAO_BLOCK_DIR_ListBox1_OnSelChanged (BlockCount blockValue /)
(setq view_block blockvalue)
(dcl_BlockView_DisplayDwg od-toolbox_NAO_BLOCK_DIR_BlockView1 view_block)
(princ)
)

(defun c:od-toolbox_NAO_BLOCK_DIR_Close_block_window_OnClicked (/)
(dcl_Form_Close od-toolbox_NAO_BLOCK_DIR)
)

(defun c:od-toolbox_NAO_BLOCK_DIR_BlockView1_OnDblClicked (/)
(dcl_Form_Close od-toolbox_NAO_BLOCK_DIR)
(command  "-INSERT" view_block pause "" "")
(princ)
)

(defun c:od-toolbox_NAO_BLOCK_DIR_TextButton1_OnClicked (/)
(setq open_block (strcat path view_block))
(dcl_Form_Close od-toolbox_NAO_BLOCK_DIR)
(vlax-invoke-method (vla-get-Documents (vlax-get-acad-object)) "Open" open_block)
)



;(setvar "CMDECHO" cmdecho)




(princ)


