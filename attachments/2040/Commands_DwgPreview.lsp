;;;						;
;;;	Drawing Preview Form v1.0		;
;;;	James Buzbee 09.19.2014			;
;;;						;

;;;						;
;;;	Description:				;
;;;	This project utilizes a Modal Form	;
;;;	with a Blockview Control to provide	;
;;;	a higher resolution display of a 	;
;;;	drawing with zooming and panning 	;
;;;	capabilities				;
;;;						;
(vl-load-com)

;;;						;
;;;	Load OpenDCL project			;
;;;						;

(if (not (vl-bb-ref 'kbdwgpreview))
  (vl-bb-set
    'kbdwgpreview
    (dcl_project_import
      '("YWt6AxQTAAAG895KBuKTKDUxaj9ugOi5rLzc+nq9v71kXmTr2cb8Wf1aVPz+Zve4tYwu7+srmmtR"
"YANhix6Cd0BOvzlCBKxlefFiQgZOVJS35vbSq8O1MLHJ5SdoMi6dMhjEwdeUlJTUhATEWshmPZxX"
"EjtRiN113Wa6eviaQ3dh/qd83i4k0yqn+qMMSV76IxY8QdSbo1aJ3oqcE92KvNbtICYEi9wjWcR9"
"FrhXr5Pt0bNcTe24yrvO8mZORPP3TwscySeYrmhlmnc3MfFnahWrjBvZQiRBWqQEOjaYFvphf5PT"
"ZvN/my5Aml4Pt0p7kAvXKVYj7Fiqqm+aUwOs+KobreaVw2YriRr0+iYF0QBs4F4ilPIB3ZOz7wKs"
"+0mJHXGs297oDntET/z9jHIfMuBOXIzAWkyLsuev0pZ3n9mar/Jb6eCEP2Awb4iFogb/XAh7e7fu"
"lfYrxiwurFSVdrV0+LqJrXYkleTqCGqUW4xTDS70mAWTzHnLq5MBXimkc3iTnoJpY+tX2FoeU2bp"
"iWbcnDpDKr7LuhO1MzxTrKX1WRnhNzdB+DsZflTh6I/2vIT+jj28iXcN5ly3SrqPTp8Nt06HwJfK"
"OjcA6I5z5BFAZ7dGIAqKM6RBrYYxt0z2nTRkgbuPubatDk95FJftlArM0kFUwVXPB+NGUR9g/+QI"
"1K+WQFgiNqtEnMxtlj7xqhpxsPbL9qI/V/r2qteznQxDkHCnVw2aLWQJR4bUuKNwQN6POdScVDlA"
"3Zv5Y2Kqhm7PxqO/GIBw7MnvYkDJwbLcU8pg9SsF7x6rBH0tJ9tVQ/T1bEzledW1FsAdSvtEVdgV"
"BDmtrEstY08D59AyGdiRNJXuF7RKGOSNSL6lehFdJ6qHDcaVoqpLEWWj6psypXgRTbJtoEhME00B"
"RNFItNWmvniYq8RoLdDEWvEH4iYSMCfZ63FEhWm25cIayPO+mB7buLLKHAZPse1bGMsii+cmvNIc"
"6AYqlTPzueOLZwPQoCDMITirFyuNCfPR7UApiUu8yXahC4KvYwv8mrlNzptatxEtwqnuM9ggUkgz"
"vbNYnTFFz9n9mhNasfxDIZt3FpP+/0tXkpfsHZjmEt6TrIjnE0p1iObNwLtoXcmmHIhsQQeVg+G0"
"sugBm+GMvPetwqiJHpNY88kt4lMoeJ8YmyUGgR3KXRW3dE3Bu/QnBoEdcoDz0uY9nNIoGh60J7Oh"
"XDnc1oI3sr8Uh1lKjdEJqQUQc4rj35TV6AFEzSOFAVjNDmgZTC0BaCFonrPpCYbFhxxOjRtrGcyM"
"OoV1spYqGg==")
      )
    )
  )


;;;						;
;;;	Event Handlers				;
;;;						;

;;;	OnInitialized				;
(defun c:DWGPreview/Preview#OnInitialize (/)
  (if kb%dwgpreviewdrawing
    (progn(dcl-BlockView-DisplayDwg DWGPreview/Preview/BlockView kb%dwgpreviewdrawing)
     (dcl-Control-SetCaption DWGPreview/Preview/PathLabel kb%dwgpreviewdrawing) )
    (dcl-Control-SetCaption DWGPreview/Preview/PathLabel "")
    )
)

;;;						;
;;;	Control Handlers			;
;;;						;

;;;	Browse Button Clicked			;
(defun c:DWGPreview/Preview/Browse#OnClicked (/)
  (if (not kb%dwgpreviewdrawing)
    (setq dwgName(getfiled "Select a file" (getvar "dwgprefix") "dwg" 0))
    (setq dwgName(getfiled "Select a file" kb%dwgpreviewdrawing "dwg" 0)))
  (if dwgname(progn
	       (setq kb%dwgpreviewdrawing dwgname)
	       (dcl-BlockView-DisplayDwg DWGPreview/Preview/BlockView DwgName)))
  (princ)
)

;;;	Open Button Clicked			;
(defun c:DWGPreview/Preview/TextButton1#OnClicked (/)
  (if kb%dwgpreviewdrawing
   (progn(dcl-form-close DWGPreview/Preview)
     (kb:OpenDrawing kb%dwgpreviewdrawing))
    (alert "select a drawing"))
)

;;;	Close Button Clicked			;
(defun c:DWGPreview/Preview/CloseButton#OnClicked (/)
  (dcl-form-close DWGPreview/Preview)
)

;;;						;
;;;	Command Interface			;
;;;						;
(defun c:kbDwgPreview	(/)
  (if (not (member "DWGPreview" (dcl_GetProjects)))
    (dcl_Project_load "DWGPreview"))

  (if dcl_HideErrorMsgBox
    (dcl_Form_Show DWGPreview/Preview)
    (alert "The OpenDCL arx module did not load!"))

  (princ)
  (princ)
  )