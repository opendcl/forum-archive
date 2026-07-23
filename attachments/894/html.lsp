(defun c:test ()
  (dcl_project_load "D:/html" T)
  (dcl_Form_Show html_html:demo)
  (dcl_Html_Navigate html_html:demo_Html "http://www.ad-informatique.net/pages/mentions-legales/licences-dutilisation.php")
)

