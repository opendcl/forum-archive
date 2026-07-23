(dcl_project_load "D:/gb" T)
(defun c:gb_gb:demo_GraphicButton1_OnClicked (/)
  (dcl_MessageBox "To Do: code must be added to event handler\r\nc:gb_gb:demo_GraphicButton1_OnClicked" "To do")
)
(defun c:html_gb:demo_ListBox1_OnDragnDropFromControl (ProjectName FormName ControlName DropPoint /)
  (alert (strcat "\n c:html_gb:demo_ListBox1_OnDragnDropFromControl " ProjectName" " FormName " " ControlName))
)
(dcl_Form_Show gb_gb:demo)
  


