(defun C:Test2 ()
  (command "OPENDCL")
  (dcl_Project_Load "ODBTest2" T)
  (dcl_FORM_SHOW ODBTest2_DemoModeless)
  (princ)
)

(defun c:ODBTest2_DemoModeless_Textschaltfläche2_OnClicked ()
  (princ "\nKlick-Test: ") (princ)   
)

(defun c:DemoModeless_CloseButton_Clicked ()
  (dcl_Form_Close ODBTest2_DemoModeless)   
)

(defun c:ODBTest2_DemoModeless_Textschaltfläche1_OnClicked (/)
  (dcl_MessageBox "Hier sollte etwas Sinnvolles passieren: An dieser Stelle können Sie nun den Quellcode zur Ereignisfunktion hinzufügen\r\nc:ODBTest2_DemoModeless_Textschaltfläche1_OnClicked" "Ereignisfunktion")
)


(defun C:-Test2 ()
  (dcl_Project_Unload "ODBTest2" T) (princ)
)
  
(princ)

