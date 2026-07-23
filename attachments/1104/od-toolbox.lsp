; Ensure the appropriate OpenDCL ARX file is loaded




(command "OPENDCL")

(defun c:tb1 ()

; call the method to load the HelloWorld.odcl file.
(dcl_Project_Load "od-toolbox" T)

; call the method to show the Hello World dialog box example
(dcl_Form_Show od-toolbox_Form1)
(princ)
)


(defun c:od-toolbox_Form1_TextButton1_OnClicked (/)
(dcl_Form_Close od-toolbox_Form1)
)

(defun c:od-toolbox_Form1_OnInitialize (/ datafile ofile curline)  
  (setq datafile "c:\\test.txt")  
  (setq ofile (open datafile "r"))  
  (while (setq curline (read-line ofile))  
    (setq file_content_list (cons curline file_content_list))  
  )  
  (close ofile)  
  (setq file_content_list (reverse file_content_list))  
  (dcl_ListBox_AddList od-toolbox_Form1_ListBox1 file_content_list)  
  ;(dcl_ListBox_AddList od-toolbox_Form1_ListBox1 (list "hello" "world"))
)  

(defun c:od-toolbox_Form1_TextButton2_OnClicked (/)
      (dcl_Control_SetCaption od-toolbox_Form1_Label1 "Searching...")
      (dcl_Control_SetCaption od-toolbox_Form1_Label2 "")

  (setq fln (dcl_Control_GetText od-toolbox_Form1_TextBox1))
   (SETQ A1 (CAR (DOS_FIND (strcat "Q:\\" FLN ".dwg"))))
     (if A1 
      (progn
        (dcl_Control_SetCaption od-toolbox_Form1_Label1 "found")
        (dcl_Control_SetCaption od-toolbox_Form1_Label2 A1)
      )
      (progn
        (dcl_Control_SetCaption od-toolbox_Form1_Label1 "DWG not Found!")
        (dcl_Control_SetCaption od-toolbox_Form1_Label2 "")
      )
     )
)

(defun c:od-toolbox_Form1_TextButton4_OnClicked (/)
  (command "._VBASTMT" (strcat "AcadApplication.Documents.Open \"" A1 "\""))
)



(defun c:od-toolbox_Form1_TextButton3_OnClicked (/)
  (startapp "Z:\\Questica Import\\NAOtoQuesticaImportTool.exe")
)




