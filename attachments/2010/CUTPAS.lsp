(defun c:cutpas ()
  (setvar "CMDECHO" 0)
  (command "OPENDCL")
  (dcl_project_load "cutpas" T)
(dcl-Form-Show cutpas/CutnPaste)
  (princ)
)

(defun c:cutpas/CutnPaste#OnInitialize (/)
(dcl-SlideView-Load cutpas/CutnPaste/SlideView1 "cut.sld")
(dcl-SlideView-Load cutpas/CutnPaste/SlideView2 "paste.sld")
)

(defun c:cutpas/CutnPaste/SlideView1#OnClicked (/)
(dcl-Form-Close cutpas/CutnPaste)
(load "brktxt")
)

(defun c:cutpas/CutnPaste/SlideView2#OnClicked (/)
(dcl-Form-Close cutpas/CutnPaste)
(load "pst")
)






















