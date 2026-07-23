(defun c:test (/ c:test_test_OnInitialize c:test_test_img1 c:test_test_img2 c:test_test_cen oDoc oBlocks oBlock arrPoints intCen oPoly oSolid oColor)
  (defun c:test_test_OnInitialize (/)
    (dcl_Control_SetValue test_test_cen intCen)
    (dcl_Control_SetBackColor test_test_img1 61)
    (dcl_Control_SetBackColor test_test_img2 11)
    (dcl_BlockView_DisplayBlock test_test_bv "BV_DEMO" 0 1.0)
  ); c:test_test_OnInitialize

  (defun c:test_test_img1 (/)
    (vla-put-colorindex oColor 61)
    (vla-put-GradientColor1 oSolid oColor)
    (vla-update oSolid)
    (dcl_BlockView_RefreshBlock test_test_bv)
  ); c:test_test_img1

  (defun c:test_test_img2 (/)
    (vla-put-colorindex oColor 11)
    (vla-put-GradientColor1 oSolid oColor)
    (vla-update oSolid)
    (dcl_BlockView_RefreshBlock test_test_bv)
  ); c:test_test_img2

  (defun c:test_test_cen (intValue /)
    (setq intCen intValue)
    (vla-put-GradientCentered oSolid (if (= intCen 1) :vlax-true :vlax-false))
    (vla-update oSolid)
    (dcl_BlockView_RefreshBlock test_test_bv)
  ); c:test_test_cen

  (setq oDoc (vla-get-ActiveDocument (vlax-get-acad-object)))
  (setq oBlocks (vla-get-blocks oDoc))
  (setq arrPoints (vlax-make-variant (vlax-safearray-fill (vlax-make-safearray vlax-vbdouble (cons 0 7)) (list 0.0 0.0 0.0 40.0 100.0 40.0 100.0 0.0))))
  (setq intCen 0)

  (if (vl-catch-all-error-p (setq oBlock (vl-catch-all-apply 'vla-item (list oBlocks "BV_DEMO"))))
    (setq oBlock (vla-Add oBlocks (vlax-3d-point (list 0.0 0.0 0.0)) "BV_DEMO"))
    (vlax-map-Collection oBlock 'vla-erase)
  ); if

  (setq oPoly (vla-AddLightWeightPolyline oBlock arrPoints))
  (vla-put-closed oPoly :vlax-true)

  (setq oSolid (vl-catch-all-apply 'vla-AddHatch (list oBlock acPreDefinedGradient "LINEAR" :vlax-true acGradientObject)))
  (vla-put-GradientCentered oSolid (if (= intCen 1) :vlax-true :vlax-false))
  (vla-put-GradientAngle oSolid 0.0)
  (setq oColor (vla-get-GradientColor1 oSolid))
  (vla-put-colorindex oColor 61)
  (vla-put-GradientColor1 oSolid oColor)
  (vla-put-colorindex oColor 8)
  (vla-put-GradientColor2 oSolid oColor)
  (vl-catch-all-apply 'vla-AppendOuterLoop (list oSolid (vlax-make-variant (vlax-safearray-fill (vlax-make-safearray vlax-vbObject (cons 0 0)) (list oPoly)))))
  (vl-catch-all-apply 'vla-Evaluate (list oSolid))

  (dcl_project_load "test")
  (dcl_form_show test_test)

  (vl-catch-all-apply 'vla-delete (list oBlock))
  (mapcar 'vlax-release-object (list oColor oSolid oPoly oBlock oBlocks oDoc))
  (princ)
); test