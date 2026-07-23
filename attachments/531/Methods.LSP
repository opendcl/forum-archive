(IF (NOT *MasterDemo*)
    (princ "\nOpenDCL 4.0 example programs.\nType \"Methods\" to run the example.\n")
)


;; this function loads the project & shows the form
(DEFUN c:Methods (/ )
  (or LoadRunTime (load "_OpenDclUtils.lsp") (exit))
  (LoadRunTime)
  (LoadODCLProj "Methods.odcl")
  (dcl_FORM_SHOW Methods_DemoMethods)
  ;; The Event handlers manage the form here.
  (PRINC)
)




(defun c:Methods_DemoMethods_cmdClose_OnClicked ( /)
   (dcl_Form_Close Methods_DemoMethods)
)



(defun c:DemoMethods_TabControl_Changed	(nSelIndex / BottomFromBottom RightFromRight TopFromBottom LeftFromRight nLeft nTop nWidth nHeight)
   
   (if (= nSelIndex 1);_ Sliders Tab
      (progn
	 (dcl_Control_SetValue Methods_DemoMethods_AngleSlider1 (atoi (dcl_Control_GetText Methods_DemoMethods_AngleBox)))
         (dcl_Control_SetValue Methods_DemoMethods_ScrollBar1 (atoi (dcl_Control_GetText Methods_DemoMethods_VScrollLabel)))
         (dcl_Control_SetValue Methods_DemoMethods_SliderBar1 (atoi (dcl_Control_GetText Methods_DemoMethods_VSliderLabel)))
         (dcl_Control_SetValue Methods_DemoMethods_ScrollBar2 (atoi (dcl_Control_GetText Methods_DemoMethods_HScrollLabel)))
         (dcl_Control_SetValue Methods_DemoMethods_SliderBar2 (atoi (dcl_Control_GetText Methods_DemoMethods_HSliderLabel)))
         (dcl_Control_SetText Methods_DemoMethods_SpinnedBox (itoa (dcl_Control_GetValue Methods_DemoMethods_SpinButton1)))
      )
   );_ if
  
   (if (= nSelIndex 2);_ Manipulation Tab
      (progn
	 (setq
	    BottomFromBottom (dcl_Control_GetBottomFromBottom Methods_DemoMethods_SampleControl)
	    RightFromRight   (dcl_Control_GetRightFromRight Methods_DemoMethods_SampleControl)
	    TopFromBottom    (dcl_Control_GetTopFromBottom Methods_DemoMethods_SampleControl)
	    LeftFromRight    (dcl_Control_GetLeftFromRight Methods_DemoMethods_SampleControl)
	    nLeft	     (dcl_Control_GetLeft Methods_DemoMethods_SampleControl)
	    nTop	     (dcl_Control_GetTop Methods_DemoMethods_SampleControl)
	    nWidth	     (dcl_Control_GetWidth Methods_DemoMethods_SampleControl)
	    nHeight	     (dcl_Control_GetHeight Methods_DemoMethods_SampleControl)
	 )
	
	 (dcl_Control_SetText Methods_DemoMethods_BottomToBottom (itoa BottomFromBottom))
         (dcl_Control_SetText Methods_DemoMethods_RightToRight (itoa RightFromRight))
         (dcl_Control_SetText Methods_DemoMethods_TopToBottom (itoa TopFromBottom))
         (dcl_Control_SetText Methods_DemoMethods_LeftToRight (itoa LeftFromRight))
	
         (dcl_Control_SetText Methods_DemoMethods_LeftBox (itoa nLeft))
	 (dcl_Control_SetText Methods_DemoMethods_TopBox (itoa nTop))
	 (dcl_Control_SetText Methods_DemoMethods_WidthBox (itoa nWidth))
	 (dcl_Control_SetText Methods_DemoMethods_HeightBox (itoa nHeight))
      );_ progn
   ); _if
)
;; ------------------- PictureBox Tab -------------------------------
(defun c:DemoMethods_DrawText_Clicked ()
  (dcl_PictureBox_Clear Methods_DemoMethods_PictureBox)
  (dcl_PictureBox_DrawText
    Methods_DemoMethods_PictureBox
    (List (List 10 10 -19 20 "Line 1" "TL" 0)
	  (List 10 25 -19 30 "Line 2" "TL" 0)
	  (List 10 40 -19 40 "Line 3" "TL" 0)
	  (List 10 55 -19 50 "Line 4" "TL" 0)
	  (List 10 70 -19 56 "Line 5" "TL" 0)
    ) ;_ fim de List
  ) ;_ fim de dcl_PictureBox_DrawText
;;;Eu coloquei todos os StoreImage
  (dcl_PictureBox_StoreImage Methods_DemoMethods_PictureBox)
) ;_ fim de defun
;;;
(defun c:DemoMethods_DrawWrappedText_Clicked ()
  (dcl_PictureBox_Clear Methods_DemoMethods_PictureBox)
  (dcl_PictureBox_DrawWrappedText
    Methods_DemoMethods_PictureBox
    '((10
       10
       220
       -19
       "This sample text is supposed to wrap around if the width of the text is going to exceed the allowed width given."
       "L"
      )
      (10
       70
       220
       -19
       "This sample text is also supposed to wrap around if the width of the text is going to exceed the allowed width given."
       "C"
      )
      (10
       130
       220
       -19
       "This sample text is also supposed to wrap around if the width of the text is going to exceed the allowed width given."
       "R"
      )
     )
  ) ;_ fim de dcl_PictureBox_DrawWrappedText
  (dcl_PictureBox_StoreImage Methods_DemoMethods_PictureBox)
) ;_ fim de defun
;;;
(defun c:DemoMethods_DrawLine_Clicked ()
  (dcl_PictureBox_Clear Methods_DemoMethods_PictureBox)
  (dcl_PictureBox_DrawLine
    Methods_DemoMethods_PictureBox
    '(
      (10 10 230 10 248)
      (10 20 230 20 249)
      (10 30 230 30 250)
      (10 40 230 40 251)
      (10 50 230 50 252)
      (10 60 230 60 253)
      (10 70 230 70 254)
      (10 80 230 80 255)
     )
  ) ;_ fim de dcl_PictureBox_DrawLine
  (dcl_PictureBox_StoreImage Methods_DemoMethods_PictureBox)
) ;_ fim de defun
(defun c:DemoMethods_DrawArc_Clicked (/ nBoundingLeft nBoundingTop)
  (dcl_PictureBox_Clear Methods_DemoMethods_PictureBox)
  (setq nBoundingLeft 50)
  (setq nBoundingTop 50)
;;;OpenDCLARX is requires larger lists to be created in a  certain format, ensure you create list in the manor shown below
;;;we have experienced errors when specifying a list as follows
;;;'((nBoundingLeft nBoundingTop ...) (nBoundingLeft nBoundingTop ...)),
;;;For some unknown reason OpenDCLARX cannot handle list created in this manor.
  (setq	ArgumentList
	 (list
	   (list
	     nBoundingLeft
	     nBoundingTop
	     25
	     (+ nBoundingLeft 25)
	     nBoundingTop
	     (+ nBoundingLeft 25)
	     (+ nBoundingTop 50)
	     248
	   ) ;_ fim de list
	   (list
	     nBoundingLeft
	     (+ nBoundingTop 50)
	     25
	     (+ nBoundingLeft 25)
	     (+ nBoundingTop 100)
	     (+ nBoundingLeft 25)
	     (+ nBoundingTop 50)
	     248
	   ) ;_ fim de list
	 ) ;_ fim de list
  ) ;_ fim de setq
  (dcl_PictureBox_DrawArc
    Methods_DemoMethods_PictureBox
    ArgumentList
  ) ;_ fim de dcl_PictureBox_DrawArc
  (dcl_PictureBox_StoreImage Methods_DemoMethods_PictureBox)
) ;_ fim de defun
;;;
(defun c:DemoMethods_DrawCircle_Clicked	()
  (dcl_PictureBox_Clear Methods_DemoMethods_PictureBox)
  (dcl_PictureBox_DrawCircle
    Methods_DemoMethods_PictureBox
    '((10 10 140 140 1)
      (10 160 140 40 2)
     )
  ) ;_ fim de dcl_PictureBox_DrawCircle
;;;  
  (dcl_PictureBox_StoreImage Methods_DemoMethods_PictureBox)
) ;_ fim de defun


(defun c:DemoMethods_DrawHatchRect_Clicked ()
  (dcl_PictureBox_Clear Methods_DemoMethods_PictureBox)
  (dcl_PictureBox_DrawHatchRect
    Methods_DemoMethods_PictureBox
    '((10 10 40 40 1 1)
      (10 60 40 40 2 2)
      (60 10 40 40 3 3)
      (60 60 40 40 4 4)
      (10 110 40 40 5 5)
     )
  ) ;_ fim de dcl_PictureBox_DrawHatchRect
;;;  
  (dcl_PictureBox_StoreImage Methods_DemoMethods_PictureBox)
) ;_ fim de defun


(defun c:DemoMethods_DrawFillRect_Clicked ()
  (dcl_PictureBox_Clear Methods_DemoMethods_PictureBox)
  (dcl_PictureBox_DrawFillRect
    Methods_DemoMethods_PictureBox
    '((10 10 40 40 1)
      (10 60 40 40 2)
      (60 10 40 40 3)
      (60 60 40 40 4)
      (10 110 40 40 5)
     )
  ) ;_ fim de dcl_PictureBox_DrawFillRect
;;;  
  (dcl_PictureBox_StoreImage Methods_DemoMethods_PictureBox)
) ;_ fim de defun


(defun c:DemoMethods_PaintPicture_Clicked ()
  (dcl_PictureBox_Clear Methods_DemoMethods_PictureBox)
  (setq	PictureList
	 (list
	   (list 10 10 102 1 1)
	   (list 10 50 105 1 1)
	   (list 10 90 106 1 1)
	   (list 10 130 107 1 1)
	   (list 10 170 108 1 1)
	 ) ;_ fim de list
  ) ;_ fim de setq
  (dcl_PictureBox_PaintPicture
    Methods_DemoMethods_PictureBox
    PictureList
  ) ;_ fim de dcl_PictureBox_PaintPicture
;;;
  (dcl_PictureBox_StoreImage Methods_DemoMethods_PictureBox)
) ;_ fim de defun


(defun c:DemoMethods_DrawPoints_Clicked ()
   (dcl_PictureBox_Clear Methods_DemoMethods_PictureBox)
   (dcl_PictureBox_DrawPoint Methods_DemoMethods_PictureBox 14 10 1)
   (dcl_PictureBox_DrawPoint Methods_DemoMethods_PictureBox 18 10 2)
   (dcl_PictureBox_DrawPoint Methods_DemoMethods_PictureBox 22 10 3)
   (dcl_PictureBox_DrawPoint Methods_DemoMethods_PictureBox 26 10 4)
;;;
   (dcl_PictureBox_StoreImage Methods_DemoMethods_PictureBox)
)

(defun c:DemoMethods_DrawEdge_Clicked ()
   (dcl_PictureBox_Clear Methods_DemoMethods_PictureBox)
   (dcl_PictureBox_DrawEdge Methods_DemoMethods_PictureBox
      '((10 10 40 40 1)
	(60 10 40 40 2)
	(10 60 40 40 3)
	(60 60 40 40 4)
	(10 110 40 40 5)
	(60 110 40 40 6)
	(10 160 40 40 7)
	(60 160 40 40 8)
       )
   )
;;;
  (dcl_PictureBox_StoreImage Methods_DemoMethods_PictureBox)
)

(defun c:DemoMethods_LoadPictureFile_Clicked (/ sFileName)
   (setq sFileName (GetFiled "Select a picture file" "" "bmp;ico;jpg;gif;wmf" 8))
   (if (/= sFileName nil)
      (dcl_PictureBox_LoadPictureFile Methods_DemoMethods_PictureBox sFileName)
      (dcl_PictureBox_StoreImage Methods_DemoMethods_PictureBox)
   )
)

(defun c:DemoMethods_Clear_Clicked ()
   (dcl_PictureBox_Clear Methods_DemoMethods_PictureBox)
)
;;; ----------------------------------------------------------------------------
;;;Criados p/ testar o arrasto sobre o quadro
  (defun c:Methods_DemoMethods_OnInitialize (/)
    (dcl_PictureBox_DrawRect
      Methods_DemoMethods_PictureBox
      (list (list 0 0 57 57 1))
    ) ;_ fim de dcl_PictureBox_DrawRect
    (dcl_PictureBox_StoreImage Methods_DemoMethods_PictureBox)
    (alert "OnInitialize Method\n\ndcl_PictureBox_DrawRect doesn't work OnInitialize inside")
  ) ;_ fim de defun
;;;desenhando dois retangulos p/ testar o arrasto
;;;
  (defun c:Methods_DemoMethods_PictureBox4_OnPaint (nHasFocus /)
    (dcl_PictureBox_DrawRect
      Methods_DemoMethods_PictureBox
      (list (list 100 157 57 57 11239775))
    ) ;_ fim de dcl_PictureBox_DrawRect
    (dcl_PictureBox_DrawRect
      Methods_DemoMethods_PictureBox
      (list (list 167 157 57 57 1))
    ) ;_ fim de dcl_PictureBox_DrawRect
;;;Importante manter o desenho na memoria
    (dcl_PictureBox_StoreImage Methods_DemoMethods_PictureBox)
;;;
  ) ;_ fim de defun
;;; ----------------------------------------------------------------------------
;;;Funcao disparada quando Quadro HTM e fechado
  (defun c:Methods_ViewHtm_OnClose (nUpperLeftX nUpperLeftY /)
    (dcl_MessageBox
      "Mostra de novo o picture de OnPaint"
      "To do"
    ) ;_ fim de dcl_MessageBox
;;;Mostar de novo o picture de OnPaint p/ testar
    (dcl_Control_SetVisible Methods_DemoMethods_PictureBox4 T)
;;;Caption
    (dcl_Control_SetCaption
      Methods_DemoMethods_Label5
      "OnPaint Test - Visible = True"
    ) ;_ fim de dcl_Control_SetCaption
  ) ;_ fim de defun
;;;Inicializac
(defun c:Methods_ViewHtm_OnInitialize (/)
;;;Escondento picture de OnPaint p/ testar o arrasto
  (dcl_Control_SetVisible Methods_DemoMethods_PictureBox4 NIL)
;;;Caption
    (dcl_Control_SetCaption
      Methods_DemoMethods_Label5
      "OnPaint Test - Visible = False"
    ) ;_ fim de dcl_Control_SetCaption
;;;
;;;Obriga o Quadro a trabalhar OffLine
  (dcl_Html_SetOffline Methods_ViewHtm_HtmlControl1 0)
;;;Ve se e offline
  (setq ValOffline (dcl_Html_GetOffline Methods_ViewHtm_HtmlControl1))
) ;_ fim de defun
;;; ----------------------------------------------------------------------------
;;;Chama um quadro o quadro HTM p/ testar o arrasto
(defun c:Methods_DemoMethods_Dragging_OnClicked (/)
  (dcl_Form_Show Methods_ViewHtm)
) ;_ fim de defun
;; ------------------- Sliders Tab -------------------------------

(defun c:DemoMethods_ScrollBar1_Scroll (nValue /)
  (dcl_Control_SetText Methods_DemoMethods_VScrollLabel (itoa nValue))
)

(defun c:DemoMethods_ScrollBar2_Scroll (nValue /)
  (dcl_Control_SetText Methods_DemoMethods_HScrollLabel (itoa nValue))
)

(defun c:DemoMethods_AngleSlider1_Scroll (nValue /)
  (dcl_Control_SetText Methods_DemoMethods_AngleBox (itoa nValue))
)

(defun c:DemoMethods_SliderBar2_ReleasedCapture	(nValue /)
  (dcl_Control_SetText Methods_DemoMethods_HSliderLabel (itoa nValue))
)

(defun c:DemoMethods_SliderBar1_ReleasedCapture	(nValue /)
  (dcl_Control_SetText Methods_DemoMethods_VSliderLabel (itoa nValue))
)

(defun c:DemoMethods_SpinButton1_Changed (nValue nDelta/)
  (dcl_Control_SetText Methods_DemoMethods_SpinnedBox (itoa nValue))
)

(defun c:DemoMethods_AngleBox_EditChanged (sText /)
  (dcl_Control_SetValue Methods_DemoMethods_AngleSlider1 (atoi sText))
)

(defun c:DemoMethods_VScrollLabel_EditChanged (sText /)
  (dcl_Control_SetValue Methods_DemoMethods_ScrollBar1 (atoi sText))
)

(defun c:DemoMethods_VSliderLabel_EditChanged (sText /)
  (dcl_Control_SetValue Methods_DemoMethods_SliderBar1 (atoi sText))
)

(defun c:DemoMethods_HScrollLabel_EditChanged (sText /)
  (dcl_Control_SetValue Methods_DemoMethods_ScrollBar2 (atoi sText))
)

(defun c:DemoMethods_HSliderLabel_EditChanged (sText /)
  (dcl_Control_SetValue Methods_DemoMethods_SliderBar2 (atoi sText))
)


(defun c:DemoMethods_SpinnedBox_EditChanged (sText /)
  (dcl_Control_SetValue Methods_DemoMethods_SpinButton1 (atoi sText))
)


;; ------------------- Manipulation Tab -------------------------------

(defun c:DemoMethods_LeftBox_EditChanged (sText /)
  (dcl_Control_SetLeft Methods_DemoMethods_SampleControl (atoi sText))
)

(defun c:DemoMethods_TopBox_EditChanged	(sText /)
  (dcl_Control_SetTop Methods_DemoMethods_SampleControl (atoi sText))
)

(defun c:DemoMethods_WidthBox_EditChanged (sText /)
  (dcl_Control_SetWidth Methods_DemoMethods_SampleControl (atoi sText))
)

(defun c:DemoMethods_HeightBox_EditChanged (sText /)
  (dcl_Control_SetHeight Methods_DemoMethods_SampleControl (atoi sText))
)

(defun c:DemoMethods_VisibleCheck_Clicked (nValue /)
  (dcl_Control_SetVisible Methods_DemoMethods_SampleControl nValue)
)

(defun c:DemoMethods_EnableOption_Clicked (nValue /)
  (dcl_Control_SetEnabled Methods_DemoMethods_SampleControl T)
)

(defun c:DemoMethods_DisableOption_Clicked (nValue /)
  (dcl_Control_SetEnabled Methods_DemoMethods_SampleControl nil)
)

(defun c:DemoMethods_LeftCheck_Clicked (nValue /)
  (dcl_Control_SetUseLeftFromRight Methods_DemoMethods_SampleControl nValue)
)

(defun c:DemoMethods_TopCheck_Clicked (nValue /)
  (dcl_Control_SetUseTopFromBottom Methods_DemoMethods_SampleControl nValue)
)

(defun c:DemoMethods_RightCheck_Clicked	(nValue /)
  (dcl_Control_SetUseRightFromRight Methods_DemoMethods_SampleControl nValue)
)

(defun c:DemoMethods_BottomCheck_Clicked (nValue /)
  (dcl_Control_SetUseBottomFromBottom Methods_DemoMethods_SampleControl nValue)
)

(defun c:DemoMethods_LeftToRight_EditChanged (sText /)
  (dcl_Control_SetLeftFromRight Methods_DemoMethods_SampleControl (atoi sText))
)

(defun c:DemoMethods_TopToBottom_EditChanged (sText /)
  (dcl_Control_SetTopFromBottom Methods_DemoMethods_SampleControl (atoi sText))
)

(defun c:DemoMethods_RightToRight_EditChanged (sText /)
  (dcl_Control_SetRightFromRight Methods_DemoMethods_SampleControl (atoi sText))
)

(defun c:DemoMethods_BottomToBottom_EditChanged	(sText /)
  (dcl_Control_SetBottomFromBottom Methods_DemoMethods_SampleControl (atoi sText))
)

(princ)
;|«Visual LISP© Format Options»
(72 2 40 2 T "fim de " 60 9 0 0 2 T T nil T)
;*** DO NOT add text below the comment! ***|;
