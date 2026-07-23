

(defun c:TestReport_frmReport_cmdCreate_OnClicked ( /)
  (WriteHTML "My Sample Report")
  (dcl_Html_Navigate TestReport_frmReport_HtmlControl1 *TempHTMLFile*)
  (princ)
)


(defun c:TestReport_frmReport_cmdClose_OnClicked ( /)
  (dcl_Form_Close TestReport_frmReport)
  (princ)
)


(defun WriteHTML (Title / output)
  (setq output (open *TempHTMLFile* "W"))
  (write-line (strcat "<html><body><center><h1><b><font color=\"ee1200\">" Title "</b></h1></center>") output)
  (write-line "<table border=\"1\" width=\"100%\">" output)
  (write-line "<tr><td>Row 1</td><td>Test 1</td><td>Stuff 1</td></tr>" output)
  (write-line "<tr><td>Row 2</td><td>Test 2</td><td>Stuff 2</td></tr>" output)
  (write-line "<tr><td>Row 3</td><td>Test 3</td><td>Stuff 3</td></tr>" output)
  (write-line "<tr><td>Row 4</td><td>Test 4</td><td>Stuff 4</td></tr>" output)
  (write-line "</table><br><center><font color=\"#115fff\">Right-click on this control to print...</center>" output)
  (write-line "</body></html>" output)
  (close output)
  (princ)
)

(defun C:report (/)
  (setq *TempHTMLFile* "C:\\TestReport.html")
  (dcl_Project_Load "TestReport")
  (dcl_Form_Show TestReport_frmReport)
  
)