(defun c:pdf ()
  (command "opendcl")
  (dcl_project_load "pdf")
  (dcl_form_show pdf_pdf)
  (dcl_AxControl_Put pdf_pdf_PDF1 "src" "d:\\tut_flora_07.pdf")
  (dcl_AxControl_Invoke pdf_pdf_PDF1 "setZoom" 200.0)
  (princ)
); pdf