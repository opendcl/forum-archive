(vl-load-com)
(arxload "C:/Program Files (x86)/Common Files/OpenDCL/OpenDCL.x64.23.arx")
(command "OPENDCL") 
(defun c:dwg () 
   ; call the method to load the HelloWorld.odcl file. 
   (dcl_Project_Load "insert" T) 
   ; call the method to show the Hello World dialog box example 
   (dcl_Form_Show insert/Form1) 
   (princ) 
)


(defun c:insert/Form1#OnInitialize (/)


	(dcl-ComboBox-Dir insert/Form1/ComboBox1  "\\\\netowrk_address_here\\working\\AUTOCAD Library")
	(setq dir (dcl-ComboBox-GetDir insert/Form1/ComboBox1))
	(dcl-ListBox-Dir insert/Form1/ListBox1 (strcat dir) "*.dir")
	(setq dwgnum (dcl-Control-GetList insert/Form1/ListBox1))
	(setq cntdwg (length dwgnum))
	(dcl-Control-SetCaption insert/Form1/Label2 (strcat "There are " (itoa cntdwg) " blocks to insert \nin this folder."))
)


(defun c:insert/Form1/ComboBox1#OnSelChanged (ItemIndexOrCount Value /)
	(dcl-ListBox-Clear insert/Form1/ListBox1)
	(setq prevdir (strcat dir))
	(setq dir (dcl-ComboBox-GetDir insert/Form1/ComboBox1))
	(dcl-ComboBox-Dir insert/Form1/ComboBox1 (strcat dir))
	(dcl-ListBox-Dir insert/Form1/ListBox1 (strcat dir) "*.DWG")
	(setq dwgnum (dcl-Control-GetList insert/Form1/ListBox1))
	(setq cntdwg (length dwgnum))
	(dcl-Control-SetCaption insert/Form1/Label2 (strcat "There are " (itoa cntdwg) " blocks to insert \nin this folder."))
)



(defun c:insert/Form1/ListBox1#OnSelChanged (ItemIndexOrCount Value )
	(setq itemid (dcl-ListBox-GetCurSel insert/Form1/ListBox1))
	(setq dwgfile(dcl-ListBox-GetItemText insert/Form1/ListBox1 itemid))
	(dcl-DWGPreview-LoadDwg insert/Form1/DwgPreview1 (strcat dir "\\" dwgfile))
	(setq dwging (strcat dir dwgfile))
)


(defun c:insert/Form1/GraphicButton1#OnClicked ()
	(dcl-ListBox-Clear insert/Form1/ListBox1)
	(dcl-ComboBox-Dir insert/Form1/ComboBox1 (strcat prevdir))
	(setq dir (dcl-ComboBox-GetDir insert/Form1/ComboBox1))
	(dcl-ComboBox-Dir insert/Form1/ComboBox1 (strcat dir))
	(dcl-ListBox-Dir insert/Form1/ListBox1 (strcat dir) "*.DWG")
	(setq dwgnum (dcl-Control-GetList insert/Form1/ListBox1))
	(setq cntdwg (length dwgnum))
	(dcl-Control-SetCaption insert/Form1/Label2 (strcat "There are " (itoa cntdwg) " blocks to insert \nin this folder."))
)


(defun c:insert/Form1/TextButton1#OnClicked ()
  (dcl_Form_Close insert/Form1)
)


(defun c:insert/Form1/TextButton2#OnClicked ()
	(dcl-Control-SetCaption insert/Form1/Label1 (strcat "Select Insertion Point: "))
    (setq acadObj (vlax-get-acad-object))
    (setq doc (vla-get-ActiveDocument acadObj))
	(setq pt (getpoint "\nPlease Select Insertion Point: "))
	(dcl-Control-SetCaption insert/Form1/Label1 (strcat ""))
    (setq insertionPnt (vlax-3d-point pt))
    (setq modelSpace (vla-get-ModelSpace doc))
    (setq blockRefObj (vla-InsertBlock modelSpace insertionPnt dwging 1 1 1 0))
)


