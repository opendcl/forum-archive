;;;
;;; Form Move Sample
;;;
;;; This sample demonstrates how to move or resize a form after it's been shown.
;;; It uses (dcl-DelayedInvoke) to wait a few milliseconds before moving the
;;; form in order give the movement an animated appearance.

;; Main program
(defun c:Mover (/ cmdecho)

	;; Ensure OpenDCL Runtime is (quietly) loaded
	(setq cmdecho (getvar "CMDECHO"))
	(setvar "CMDECHO" 0)
	(command "_OPENDCL")
	(setvar "CMDECHO" cmdecho)

	;; Load the project
	(dcl-Project-Load (*ODCL:Samples-FindFile "FormMover.odcl"))

	;; Show the main form
	(dcl-Form-Show FormMover/Form1)
	(dcl-Form-Resize FormMover/Form1 300 200)
	(dcl-Form-Center FormMover/Form1)
	(c:FormMover/Form1/GraphicButton1#OnClicked)

	;; This is a modeless form, so (dcl-Form-Show) returns immediately,
	;; leaving the event handlers to manage the form.

	(princ)
)

;;This function moves the form to the 4 corners of the screen, then to the center.
(defun C:FormMover ( / ce FormSize delay wd ht ScreenSize ScreenX ScreenY)
	(Setq FormSize (dcl-Form-GetRectangle FormMover/Form1))
	(setq wd (caddr FormSize))
	(setq ht (cadddr FormSize))
	(setq ScreenSize (dcl-GetScreenSize))
	(setq ScreenX (car ScreenSize))
	(setq ScreenY (cadr ScreenSize))

	(cond
;;;		(	(= *FormPos* 0)
;;;			(dcl-Form-SetPos FormMover/Form1 0 0);_TL
;;;		)
;;;		(	(= *FormPos* 1)
;;;			(dcl-Form-SetPos FormMover/Form1 0 (- ScreenY ht));_ BL
;;;		)
;;;		(	(= *FormPos* 2)
;;;			(dcl-Form-SetPos FormMover/Form1 (- ScreenX wd) (- ScreenY ht));_ BR
;;;		)
;;;		(	(= *FormPos* 3)
;;;			(dcl-Form-SetPos FormMover/Form1 (- ScreenX wd) 0);_ TR
;;;		)
		(	(= *FormPos* 4)
			(dcl-Form-Center FormMover/Form1)
		)
	);_ cond

	(setq *FormPos* (1+ *FormPos*));_ bump the form position count
	(if (<= *FormPos* 4)
		(dcl-DelayedInvoke 800 "C:FormMover");_ repeat
	)
	(princ)
)

;;This function moves & resizes the form to the bottom left corner of the screen or back to the center.
(defun C:FormMinMax ( / FormSize lf tp wd ht ScreenSize ScreenX ScreenY)
	(Setq FormSize (dcl-Form-GetRectangle FormMover/Form1))
	(setq lf (car FormSize))
	(setq tp (cadr FormSize))
	(setq wd (caddr FormSize))
	(setq ht (cadddr FormSize))
	(setq ScreenSize (dcl-GetScreenSize))
	(setq ScreenX (car ScreenSize))
	(setq ScreenY (cadr ScreenSize))

	(if (/= (dcl-Control-GetCaption FormMover/Form1/cmdMin) "_")
		(progn
			(dcl-Control-SetVisible FormMover/Form1/Label1 nil)
			(if (< lf (- *CtrLf* *offsetX*))
				(dcl-Form-SetPos FormMover/Form1 (+ lf *offsetX*) (- tp *offsetY*) (+ wd *WdOffset*) (+ ht *HtOffset*));_ MAX
				(progn
					(setq *DONE* T)
					(dcl-Control-SetCaption FormMover/Form1/cmdMin "_")
					(dcl-Form-Resize FormMover/Form1 *MaxWd* *MaxHt*)
					(dcl-Form-Center FormMover/Form1)
				);_ progn
			);_ if
		);_ progn
		(progn
			(if (>= lf *offsetX*)
				(dcl-Form-SetPos FormMover/Form1 (- lf *offsetX*) (+ tp *offsetY*) (- wd *WdOffset*) (- ht *HtOffset*));_ MIN
				(progn
					(setq *DONE* T)
					(dcl-Control-SetVisible FormMover/Form1/Label1 T)
					(dcl-Control-SetCaption FormMover/Form1/cmdMin "[  ]")
					(dcl-Form-SetPos FormMover/Form1 0 (- ScreenY *MinHt*) *MinWd* *MinHt*)
				);_ progn
			);_ if
		);_ progn
	);_ if

	(if (null *DONE*)
		(dcl-DelayedInvoke 50 "C:FormMinMax");_ repeat
	)
	(princ)
)

;|保penDCL Event Handlers誡;

(defun c:FormMover/Form1/GraphicButton1#OnClicked ( /)
	(setq *FormPos* 0)
;	(C:FormMover)
)

(defun c:FormMover/Form1/cmdMin#OnClicked ( /  FormSize lf tp wd ht ScreenSize ScreenX ScreenY);_ MIN/MAX
	(Setq FormSize (dcl-Form-GetRectangle FormMover/Form1))
	(setq lf (car FormSize))
	(setq tp (cadr FormSize))
	(setq wd (caddr FormSize))
	(setq ht (cadddr FormSize))
	(setq ScreenSize (dcl-GetScreenSize))
	(setq ScreenX (car ScreenSize))
	(setq ScreenY (cadr ScreenSize))

	(setq *MinHt* 32)
	(setq *MinWd* 150)
	(setq *MaxHt* 200)
	(setq *MaxWd* 300)
	(setq *STEPS* 10)

	(setq *CtrLf* (fix (- (* ScreenX 0.5) (* *MaxWd* 0.5))))
	(setq *Ctrtp* (fix (- (* ScreenY 0.5) (* *MaxHt* 0.5))))

	(setq *offsetX* (/ *CtrLf* *STEPS*))
	(setq *offsetY* (/ (- (- ScreenY *Ctrtp*) *MinHt*) *STEPS*))

	(setq *WdOffset* (/ (- *MaxWd* *MinWd*) *STEPS*))
	(setq *HtOffset* (/ (- *MaxHt* *MinHt*) *STEPS*))

	(setq *DONE* nil)
	(C:FormMinMax)
)

(defun c:FormMover/Form1/cmdClose#OnClicked ( /);_ CLOSE
	(dcl-Form-Close FormMover/Form1)
)

;;Expand or Collapse the form
(defun c:FormMover/Form1/cmdExpand#OnClicked ( / );_ expand
	(if (= (Car (dcl-Form-GetControlArea FormMover/Form1)) 300)
		(progn
			(dcl-Form-Resize FormMover/Form1 500 200)
			(dcl-Control-SetPicture FormMover/Form1/cmdExpand 101)
		);_ progn
		(progn
			(dcl-Form-Resize FormMover/Form1 300 200)
			(dcl-Control-SetPicture FormMover/Form1/cmdExpand 100)
		);_ progn
	);_ if
)

(princ)

;|保penDCL Samples Epilog誡;

;;;######################################################################
;;;######################################################################
;;; The following section of code is designed to locate OpenDCL Studio
;;; sample files in the samples folder by prefixing the filename with
;;; the path prefix that was saved in the registry by the installer.
;;; The global *ODCL:Prefix and function *ODCL:Samples-FindFile
;;; are used throughout the samples.
;;;
(or *ODCL:Samples-FindFile
	(defun *ODCL:Samples-FindFile (file)
		(setq *ODCL:Prefix
			(cond
				(	*ODCL:Prefix
				) ;_ already defined
				(	(vl-registry-read
						 "HKEY_CURRENT_USER\\SOFTWARE\\OpenDCL"
						 "SamplesFolder"
					)
				) ;_ 32-bit location
				(	(vl-registry-read
						 "HKEY_LOCAL_MACHINE\\SOFTWARE\\OpenDCL"
						 "SamplesFolder"
					)
				) ;_ 32-bit location
				(	(vl-registry-read
						 "HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\OpenDCL"
						 "SamplesFolder"
					)
				) ;_ 64-bit location
			)
		)
		(cond
			((findfile file)) ; check the support path first
			(*ODCL:Prefix (findfile (strcat *ODCL:Prefix file)))
			(file)
		)
	)
)

;; If AllSamples is active, run the main function immediately; otherwise
;; display a banner. The extra gymnastics allow the sample name to be
;; specified in only one place, thus making it easier to reuse this code.
(	(lambda (demoname)
		(if *ODCL:AllSamples
			(progn
				(princ (strcat "'" demoname "\n"))
				(apply (read (strcat "C:" demoname)) nil)
			)
			(progn
				(princ (strcat "\n" demoname " OpenDCL sample loaded"))
				(princ (strcat " (Enter " (strcase demoname) " command to run)\n"))
			)
		)
	)
	"Mover"
)
(princ)

;;;######################################################################
;;;######################################################################













;;; *** HALAM the modified parts start from here
;;; *** COPIED SELECTIONS.LSP IN IT
;;; *** REPLACED /SELECTIONS/FORM TO \FormMover/Form1/
















;;;######################################################################
;;;######################################################################







;;;
;;; From Selections Sample
;;;
;; This sample demonstrates how to handle a modal dialog box that closes to
;; allow the user to select objects or pick points, then reopens and updates
;; its state based on the user's actions. If the users presses the [Esc] key
;; while interacting with AutoCAD, the dialog box will not reopen.

;; Main program
(DEFUN c:Sel (/

              ;; local variables
              lstPoints lstObjects doContinue intResult

              ;; local Sub Functions
              point_selection object_selection

              ;; local Sub Event handlers for Modal Form.
              ;; Commands and functions, which show modal form, won't continue after the line
              ;; (dcl-Form-show ...) until the form will be closed. That's why the event
              ;; functions are only needed in this command. Therefore the event function
              ;; can be defined as local sub functions.

              c:FormMover/Form1#OnInitialize
              c:FormMover/Form1/Close#OnClicked
              c:FormMover/Form1/PickPointButton#OnClicked
              c:FormMover/Form1/PickObjectButton#OnClicked
              c:FormMover/Form1/PointListBox#OnDblClicked
              c:FormMover/Form1/ObjectListBox#OnDblClicked
              )

    

    ;|<<Additional sub functions>>|;


    ;; point selection

    (defun point_selection (/ intBlip ptPoint strPoint doSel)

        ;; activate BLIPMODE
        (setq intBlip (getvar "BLIPMODE"))
        (setvar "BLIPMODE" 1)

        (setq doSel T)
        (while doSel

            ;; secure point picking
            (setq ptPoint (vl-catch-all-apply 'getpoint (list "\nPick a point (or press ENTER to return to the form): ")))

            (cond
                ;; ENTER was pressed, set doContinue to T,
                ;; to re-show the form
                ((not ptPoint)
                 (setq ptPoint nil
                       doSel nil
                       doContinue T))

                ;; ESC was pressed, set doContinue to nil,
                ;; to cancel the loop and cancel the command
                ((vl-catch-all-error-p ptPoint)
                 (setq ptPoint nil
                       doSel nil
                       doContinue nil))

                ;; Convert the point to string
                ((not (setq strPoint (vl-prin1-to-string ptPoint)))
                 (setq ptPoint nil
                       doSel T))

                ;; Add a point to the list if it doesnt already exist
                ;; and return to the form after that
                ((not (member strPoint lstPoints))
                 (setq lstPoints (reverse (cons strPoint (reverse lstPoints)))
                       doSel T))
            ); cond
        ); while
        
        ;; restore BLIPMODE
        (setvar "BLIPMODE" intBlip)
    ); point_selection


    ;; object selection

    (defun object_selection (/ intBlip ssAusw intLen entObj vlaObj strObj)

        ;; activate BLIPMODE
        (setq intBlip (getvar "BLIPMODE"))
        (setvar "BLIPMODE" 1)

        ;; secure object picking
        (princ "\nSelect objects (or press ENTER to return to the form): ")
        (setq ssAusw (vl-catch-all-apply 'ssget nil))
        
        (cond
            ;; ENTER was pressed, set doContinue to T,
            ;; to re-show the form
            ((not ssAusw)
             (setq ssAusw nil
                   doContinue T))

            ;; ESC was pressed, set doContinue to nil,
            ;; to cancel the loop and cancel the command
            ((vl-catch-all-error-p ssAusw)
             (setq ssAusw nil
                   doContinue nil))

            ;; check if selection set has objects
            ((zerop (setq intLen (sslength ssAusw)))
             (setq ssAusw nil
                   doContinue T))

            ;; Add objects to list, if they're still not in
            ;; and return to the form after that
            (T (repeat intLen
                   (setq entObj (ssname ssAusw (setq intLen (1- intLen))))
                   (setq vlaObj (vlax-ename->vla-object entObj))
                   (setq strObj (strcat (vla-get-ObjectName vlaObj) " (" (vla-get-Handle vlaObj) ")"))
                   (if (not (member strObj lstObjects))
                       (setq lstObjects (reverse (cons strObj (reverse lstObjects))))
                   ); if
               ); repeat
             (setq doContinue T))
        ); cond
        
        ;; restore BLIPMODE
        (setvar "BLIPMODE" intBlip)
    ); object_selection

    

    ;|保penDCL Event Handlers誡;



    ;; The event OnInitialize will be called each time
    ;; the form is going to be shown
    
    (defun c:FormMover/Form1#OnInitialize (/)
        
        ;; clean if necessary
        (dcl-ListBox-Clear FormMover/Form1/PointListBox)
        (dcl-ListBox-Clear FormMover/Form1/ObjectListBox)

        ;; fill pointlist
        (if lstPoints
            (dcl-ListBox-AddList FormMover/Form1/PointListBox lstPoints)
        ); if

        ;; fill objectlist
        (if lstObjects
            (dcl-ListBox-AddList FormMover/Form1/ObjectListBox lstObjects)
        ); if
        
    ); c:FormMover/Form1#OnInitialize

    
    
    ;; This event will be called when the user picks the close-button
    ;; In that case the value 1 is given to close method as an argument.
    ;; This is the return value for the show method (see there).
    
    (defun c:FormMover/Form1/Close#OnClicked (/)
        (dcl-Form-close FormMover/Form1 1)
    ); c:FormMover/Form1/Close#OnClicked

    
    
    ;; This event will be called when the user picks the pointselection-button
    ;; In that case the value 3 is given to close method as an argument.
    ;; This is the return value for the show method (see there).
    
    (defun c:FormMover/Form1/PickPointButton#OnClicked (/)
        (point_selection)						 					; HLAM : it WAS ... (dcl-Form-close FormMover/Form1 3)
    ); c:FormMover/Form1/PickPointButton#OnClicked

    
    
    ;; This event will be called when the user picks the objectselection-button
    ;; In that case the value 14is given to close method as an argument.
    ;; This is the return value for the show method (see there).
    
    (defun c:FormMover/Form1/PickObjectButton#OnClicked (/)
        (dcl-Form-close FormMover/Form1 4)
    ); c:FormMover/Form1/PickObjectButton#OnClicked

    
    
    ;; This event will be called when the user doubleclicks an item
    
    (defun c:FormMover/Form1/PointListBox#OnDblClicked (/ intRow)
        (if (not (minusp (setq intRow (dcl-ListBox-GetCurSel FormMover/Form1/PointListBox))))
            (progn
                
                ;; remove an item from the lists
                
                (setq lstPoints (vl-remove (dcl-ListBox-GetItemText FormMover/Form1/PointListBox intRow) lstPoints))
                (dcl-ListBox-DeleteItem FormMover/Form1/PointListBox intRow)
            ); progn
        ); if
    ); c:FormMover/Form1/PointListBox#OnDblClicked

    
    
    ;; This event will be called when the user doubleclicks an item
    
    (defun c:FormMover/Form1/ObjectListBox#OnDblClicked (/ intRow)
        (if (not (minusp (setq intRow (dcl-ListBox-GetCurSel FormMover/Form1/ObjectListBox))))
            (progn

                ;; remove an item from the lists
                
                (setq lstObjects (vl-remove (dcl-ListBox-GetItemText FormMover/Form1/ObjectListBox intRow) lstObjects))
                (dcl-ListBox-DeleteItem FormMover/Form1/ObjectListBox intRow)
            ); progn
        ); if
    ); c:FormMover/Form1/ObjectListBox#OnDblClicked

    ;; load COM
    (vl-load-com)

    ;; Ensure OpenDCL Runtime is (quietly) loaded
    (setq cmdecho (getvar "CMDECHO"))
    (setvar "CMDECHO" 0)
    (command "_OPENDCL")
    (setvar "CMDECHO" cmdecho)

    ;; Load the project
    (dcl-Project-Load (*ODCL:Samples-FindFile "Selections.odcl"))

    ;; The repeating calls to show the modal form can be easily achieved
    ;; by a while loop
    (setq doContinue T)
    (while doContinue
        ;; However, to avoid an endless loop, the condition for repeating the loop, must negate at first
        ;; The condition will be "activated" again after dcl-Form-show for some cases.
        (setq doContinue nil)

        ;; if the dialog get closed, the function returns a value
        ;; This is 1 for OK (reserved value), 2 for ESC or Cancel (reserved value)
        ;; or the value, which was given to dcl-Form-close
        (setq intResult (dcl-Form-show FormMover/Form1))

        ;; This is a modal form, so (dcl-Form-Show) does not return until
        ;; the modal form is closed. In the meantime, the event handlers
        ;; manage the form.

        ;; Now the return value can be interpreted
        (cond
            
            ;; close-button
            ;; Here something can be done with the selected points ans objects
            ((= intResult 1) (setq doContinue nil))

            ;; ESC key
            ((= intResult 2) (setq doContinue nil))

            ;; point selection
            ((= intResult 3) (point_selection))

            ;; objectselection
            ((= intResult 4) (object_selection))

        ); cond
    ); while

    (redraw)
    (princ)
); c:Sel

(princ)

;|保penDCL Samples Epilog誡;

;;;######################################################################
;;;######################################################################
;;; The following section of code is designed to locate OpenDCL Studio
;;; sample files in the samples folder by prefixing the filename with
;;; the path prefix that was saved in the registry by the installer.
;;; The global *ODCL:Prefix and function *ODCL:Samples-FindFile
;;; are used throughout the samples.
;;;
(or *ODCL:Samples-FindFile
  (defun *ODCL:Samples-FindFile (file)
    (setq *ODCL:Prefix
      (cond
        (	*ODCL:Prefix
        ) ;_ already defined
        (	(vl-registry-read
             "HKEY_CURRENT_USER\\SOFTWARE\\OpenDCL"
             "SamplesFolder"
          )
        ) ;_ 32-bit location
        (	(vl-registry-read
             "HKEY_LOCAL_MACHINE\\SOFTWARE\\OpenDCL"
             "SamplesFolder"
          )
        ) ;_ 32-bit location
        (	(vl-registry-read
             "HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\OpenDCL"
             "SamplesFolder"
          )
        ) ;_ 64-bit location
      )
    )
    (cond
      ((findfile file)) ; check the support path first
      (*ODCL:Prefix (findfile (strcat *ODCL:Prefix file)))
      (file)
    )
  )
)

;; If AllSamples is active, run the main function immediately; otherwise
;; display a banner. The extra gymnastics allow the sample name to be
;; specified in only one place, thus making it easier to reuse this code.
(	(lambda (demoname)
    (if *ODCL:AllSamples
      (progn
        (princ (strcat "'" demoname "\n"))
        (apply (read (strcat "C:" demoname)) nil)
      )
      (progn
        (princ (strcat "\n" demoname " OpenDCL sample loaded"))
        (princ (strcat " (Enter " (strcase demoname) " command to run)\n"))
      )
    )
  )
  "Sel"
)
(princ)

;;;######################################################################
;;;######################################################################


















;;; *** HALAM the modified parts start from here
;;; *** COPIED it form SELECTIONS.LSP IN IT
















;;;######################################################################
;;;######################################################################











    (defun point_selection (/ intBlip ptPoint strPoint doSel)

        ;; activate BLIPMODE
        (setq intBlip (getvar "BLIPMODE"))
        (setvar "BLIPMODE" 1)

        (setq doSel T)
        (while doSel

            ;; secure point picking
            (setq ptPoint (vl-catch-all-apply 'getpoint (list "\nPick a point (or press ENTER to return to the form): ")))

            (cond
                ;; ENTER was pressed, set doContinue to T,
                ;; to re-show the form
                ((not ptPoint)
                 (setq ptPoint nil
                       doSel nil
                       doContinue T))

                ;; ESC was pressed, set doContinue to nil,
                ;; to cancel the loop and cancel the command
                ((vl-catch-all-error-p ptPoint)
                 (setq ptPoint nil
                       doSel nil
                       doContinue nil))

                ;; Convert the point to string
                ((not (setq strPoint (vl-prin1-to-string ptPoint)))
                 (setq ptPoint nil
                       doSel T))

                ;; Add a point to the list if it doesnt already exist
                ;; and return to the form after that
                ((not (member strPoint lstPoints))
                 (setq lstPoints (reverse (cons strPoint (reverse lstPoints)))
                       doSel T))
            ); cond
        ); while
        
        ;; restore BLIPMODE
        (setvar "BLIPMODE" intBlip)
    ); point_selection