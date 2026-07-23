
(defun c:cutnpaste ()
  (setvar "CMDECHO" 0)
  (command "OPENDCL")
  (dcl_project_load "cutnpaste.odcl" T)
(dcl_Form_Show cutnpaste_CutnPaste)
  (princ)
)



(defun c:cutnpaste_CutnPaste_OnInitialize (/)
(dcl_SlideView_Load cutnpaste_CutnPaste_SlideView1 "cut.sld")
(dcl_SlideView_Load cutnpaste_CutnPaste_SlideView2 "paste.sld")
)

(defun c:cutnpaste_CutnPaste_SlideView1_OnClicked (/)
(dcl_Form_Close cutnpaste_CutnPaste)
(load "brktxt")
)


(defun c:cutnpaste_CutnPaste_SlideView2_OnClicked (/)
(dcl_Form_Close cutnpaste_CutnPaste)
(load "pst")
)






















