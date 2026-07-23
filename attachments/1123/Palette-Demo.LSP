(vl-load-com)
(command "OPENDCL")

(if (not (vl-symbol-value 'kglobal:librarybuild))
  (load "KDUB_LIBRARY.VLX")
)

;;;---------------------------------------------------------------------------
;;;
;; (findfile "Pal.ODCL")

;|<<MAIN>>|; 

(defun c:pal (/ dialogreturn)
  ;; (dcl_project_load "Pal.ODCL" t)
   
  (dcl_project_load "Pal.ODCL" T)
  (dcl_form_show Pal_main)
  
  ;;------  
  (princ)
)

;;;---------------------------------------------------------------------------
;;;
;|<<SUPPORT>>|;

;;;---------------------------------------------------------------------------
;;;
;|<<OPENDCL Handlers Event>>|;

;;;-------------------------------------------
;|
This event is triggered immediately before the dialog is closed.
UpperLeftX, UpperLeftY is the coordinate of the upper left corner of the dialog.
|;
(defun c:Pal_Main_OnClose (UpperLeftX UpperLeftY /)
  ;; (dcl_MessageBox "To Do: code must be added to event handler\r\nc:Pal_Main_OnClose" "To do")
  (princ)
)
;;;-------------------------------------------
;|	The OnInitialize event is called immediately before a form is shown on the screen.
This event handler can initialize the form and its controls before they are displayed.
|;
(defun c:Pal_Main_OnInitialize (/)
  ;; (dcl_MessageBox "To Do: code must be added to event handler\r\nc:Pal_Main_OnInitialize" "To do")
  (dcl_Control_SetCaption Pal_Main_Label1 (getvar "DWGNAME"))
  (dcl_MessageBox
    "Note, Palette is Initialized.\n Control Code Needs to be loaded in any NEW drawings opened."
    "Pal_Main_OnInitialize"
  )
  (princ)
)
;;;-------------------------------------------
;|	This event is triggered when the user closes the last open AutoCAD drawing.
If any of the modeless dialog's controls are dependent on the state or contents of the current drawing file,
they should be cleared at this time. Once the drawing is closed, no AutoLISP code can execute since there
is no document context for it to execute in.
This event handler will be the last opportunity to execute code until a new document is opened.
|;
(defun c:Pal_Main_OnEnteringNoDocState (/)
  (if (dcl_Form_IsActive Pap)
    (dcl_form_close Pal)
  )
)

;;;-------------------------------------------
;|	This event is triggered when the user switches to a different open AutoCAD drawing.
Note that opening a new drawing will not trigger any event. An application that uses modeless dialogs
must be installed so that its code is loaded into each newly created drawing document,
and the application's initialization code must check for already active dialogs that it must manage.
|;
(defun c:Pal_Main_OnDocActivated (/)
  (dcl_Control_SetCaption Pal_Main_Label1 (getvar "DWGNAME"))
  (princ)
)

-------------------------------------------
;|	This event is triggered when the mouse pointer enters the
Control Bar, Modeless Dialog, Palette, Picture Box, Slide View.
|;
(defun c:Pal_Main_OnMouseEntered (/)
  (dcl_Control_SetKeepFocus Pal_Main T)
  (princ)
)

-------------------------------------------
;|	This event is triggered when the mouse pointer leaves the
Control Bar, Modeless Dialog, Palette, Picture Box, Slide View. 
|;
(defun c:Pal_Main_OnMouseMovedOff (/)
  (dcl_Control_SetKeepFocus Pal_Main nil)
  (princ)
)


;;;-------------------------------------------


;;;---------------------------------------------------------------------------
;;;
(princ)
;|«Visual LISP© Format Options»
(80 2 65 2 nil "end of " 80 50 0 0 0 nil nil nil T)
;*** DO NOT add text below the comment! ***|;
