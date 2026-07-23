	(defun c:WEBBROWSER (/ ExitNextClick
						c:dclInitialize
						c:dclBeforeNavigate
						c:dclButtonClicked
						)

		 ;-----------------------------------------------------
		(defun c:dclInitialize (/ browser1)
			(setq browser1 (dcl_AxControl_GetAxObject webbrowser_form1_Explorer1))
			(dcl_AxControl_Invoke webbrowser_form1_Explorer1 "Navigate2" "http://www.google.com")
		) ; initialize
		 ;-----------------------------------------------------
		(defun c:dclBeforeNavigate (pDisp URL Flags TargetFrameName PostData Headers Cancel / at1)
			(if ExitNextClick
				(progn
					(dcl_Form_Close webbrowser_form1)
					'("" 0 "" "" "" T)
				)
			) ; if
		) ; beforenavigate
		 ;-----------------------------------------------------
		(defun c:dclButtonClicked (/)
			(setq ExitNextClick t)
		) ; buttonclicked
		 ;-----------------------------------------------------

		(command "_.OPENDCL")
		(dcl_Project_Load "webbrowser" t)
		(dcl_Form_Show webbrowser_form1) ; fires initialize

	) ; GOWEBPAGE
