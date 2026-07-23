;;;--------------------------------------Textjust.lsp-------------------------
;;; Purpose:  Changes justification of textlike objects in AutoCAD
;;; Author:   Herman Mayfarth
;;; Date;     July, 2007
;;; Version:  1.0
;;;---------------------------------------------------------------------------
;;; Copyright Notice and Disclaimer of Warranty:
;;; © 2007 Herman Mayfarth No warranty express or implied.
;;; Permission granted to freely use and redistribute without fee,
;;; provided this notice remains intact.
;;;---------------------------------------------------------------------------
;;; Acknowledgements:
;;; Autoloader code is copied from ODCL example files & is © by others
;;; credits in autoloader code block, which follows
;;;---------------------------------------------------------------------------
;;; Program Usage: AutoCAD 2006 & later
;;; Required external files:
;;; 1. OpenDCL runtime: OpenDCL.16.arx for AutoCAD 2006
;;;                     OpenDCL.17.arx for AutoCAD 2007 & AutoCAD 2008
;;; 2. Textjust.slb
;;;---------------------------------------------------------------------------
;;; Usage notes:
;;; This program uses an OpenDCL modeless dialog, which remains open in all
;;; open drawings (AutoCAD documents) once it is initialized, until the dialog
;;; is closed by the user. Initialize the dialog by typing "Textjust" (without
;;; the quotes) at the command line.
;;; This file, Textjust.lsp, must be loaded into each document in order to make
;;; the callback functions for the various controls available to the dialog.
;;; This is because the callback functions are defined in this file, and each
;;; AutoCAD drawing (document) has a separate AutoLISP namespace.
;;; One standard way of loading an AutoLISP file into every document is to add
;;; the statement:
;;; (load "<filename>"), which in this case is (load "Textjust")
;;; to your acaddoc.lsp file. DO NOT use (autoload) for the .lsp file!
;;; Another standard method is to define the command in a partial menu file
;;; and load the partial menu file. Then if the partial menu file is loaded,
;;; it will look for a *.mnl file with the same name & load it. The *.mnl file
;;; is an AutoLISP source file with a *.mnl extension, so placing a (load)
;;; statment in the *.mnl will have the same effect as placing it in the
;;; acaddoc.lsp file, *provided* the menu assoicted with the *.mnl is loaded.
;;; The correct OpenDCL arx runtime should be loaded by the autoloader code
;;; in this file. Or, if you prefer, you can explicitly load the correct
;;; OpenDCL.xx.arx using either the acad.rx file or acad.lsp and
;;; dispense with the arx autoloader code below entirely.
;;;--------------------------------------------------------------------------
(vl-load-com)
(setq *THISDWG* (vla-get-activedocument (vlax-get-acad-object)))
;;; autoloader for odcl runtime arx
;;; copied from example files
;;; OpenDCL_ARXLoader.LSP
;;; For OpenDCL Ver 4.0
;;; Edit kwb 20070225 GMT00:00:00
;;; Edit orw 20070518 GMT07:30:xx :: added 64 bit arx file selection
;;;                                       returns "OpenDCL.x64.17.ARX"
;;; Last Edit kwb as suggested by MichaelP 20070608 GMT00:30:xx
;;;                :: change location of dcl_GETVERSIONEX test.
;;

;; This code block loads the OpenDCL.##.arx files if not already loaded
;; Note, Loader will return T if loaded or nil otherwise.
;;
;;
;; If the OpenDCL.##.arx is loaded at startup or demand loaded
;; this routine need never run.
(OR dcl_GETVERSIONEX
    (   (lambda ( / proc_arch arxname arxpath )

            ;;  Determine the appropriate arx module for
            ;;  the processor and the AutoCAD version.

            (setq arxname
                (strcat "OpenDCL"
                    (if
                        (and
                            (setq proc_arch (getenv "PROCESSOR_ARCHITECTURE"))
                            (< 1 (strlen proc_arch))
                            (eq "64" (substr proc_arch (1- (strlen proc_arch))))
                        )
                        ".x64."
                        "."
                    )
                    (substr (getvar "acadver") 1 2)
                    ".arx"
                )
            )
            ;;  Alert the user of a failure to:
            ;;      (A) Find the arxfile, or
            ;;      (B) Load the arxfile.
            ;;          and return nil.
            ;;  Otherwise just quietly return t.

            (cond
                (   (null (setq arxpath (findfile arxname)))
                    (alert (strcat "Couldn't find " arxname "." "\nDialogs Unavailable"))
                )
                (   (null (arxload arxpath 'nil))
                    (alert (strcat "Failed to load " arxname "."  "\nDialogs Unavailable"))
                )
                (   t   )
            )
        )
    )
)
;;;end runtime autoloader
;;;main program
;;load the project
;;no error checking
(dcl_Project_Load "Textjust.odcl");do not reload
;;;callbacks for image button
;;C:Slide_OnMouseDown does the following:
;; 1. acquires image coordinates to enable swapping slides
;; 2. updates the form graphics to reflect pick point
;; 3. sets variables to do something useful based on the selected point
;; 4. starts an undo mark
;; 5. does the actual work of changing justification via local functions
(defun c:Slide_OnMouseDown (nButton nFlags nX nY /
                    ;;local functions
                    align_mtext
                    align_text
                    display_slide
                    map_slide
                    slide_name
                    ;;local symbols
                    %X
                    %Y
                    ename
                    ent
                    height
                    i
                    just_list
                    keep-pos
                    Map#
                    Map#->Align
                    Map#->Attach
                    ss
                    width
                    Xmap
                    Ymap
);params & variables
;;local functions
;;align-mtext
(defun align_mtext (obj align / )
  (if (equal (type obj) 'ENAME )
   (setq obj (vlax-ename->vla-object obj)))
  (vla-put-attachmentpoint obj align)
);align_mtext
;;align-text
;;works for TEXT & ATTDEFs
(defun align_text (obj align keep-pos / inspt inspt2 alignpt disp var2list)
  (defun var2list ( var / )
    (vlax-safearray->list (vlax-variant-value var))
  );var2list
  (if (equal (type obj) 'ENAME )
   (setq obj (vlax-ename->vla-object obj)))
  (cond ((null keep-pos);;text will move when alignment changes
          (cond ((and (= align 0) (= 0 (vla-get-alignment obj)))
                  nil);must include this case!
                ((= 0 (vla-get-alignment obj));is left justified
                  (setq inspt (vla-get-insertionpoint obj))
                  (vla-put-alignment obj align)
                  (vla-put-textalignmentpoint obj inspt))
                ((= align 0);change to left justified
                  (setq alignpt (vla-get-textalignmentpoint obj))
                  (vla-put-alignment obj align)
                  (vla-put-insertionpoint obj alignpt))
                  (1 (vla-put-alignment obj align));all other cases
        ));null keep-pos
        ((eq keep-pos T);;text will not move when alignment changes
          (cond ((= align 0);change to left justified
                  (vla-put-alignment obj align))
                (1          ;all other cases
                    (setq inspt (var2list(vla-get-insertionpoint obj)))
                    (vla-put-alignment obj align)
                    (setq inspt2 (var2list(vla-get-insertionpoint obj))
                          disp (mapcar '- inspt inspt2)
                          alignpt (var2list (vla-get-textalignmentpoint obj))
                          alignpt (vlax-3d-point(mapcar '+ alignpt disp)))
                    (vla-put-textalignmentpoint obj alignpt))
        ));keep-pos
  );cond
);align_text
;;;function to display slide images
(defun display_slide (control library slide / )
  (dcl_SlideView_Clear control)
  (dcl_SlideView_Load control library slide)
);display_slide
;;function to map pick point
;;returns an integer from 1 to 12
(defun map_slide (X Y Xmap Ymap / )
  (cond ((< y (car Ymap))
         (cond ((< x (car Xmap))
                  1)
                ((< x (cadr Xmap))
                  2)
                (T 3)
         )
        );1st row
        ((< y (cadr Ymap))
         (cond ((< x (car Xmap))
                 4)
                ((< x (cadr Xmap))
                  5)
                (T 6)
          )
        );2nd row
        ((< y (caddr Ymap))
          (cond ((< x (car Xmap))
                  7)
                ((< x (cadr Xmap))
                  8)
               (T 9)
          )
        );3rd row
       (T
          (cond ((< x (car Xmap))
                  10)
                ((< x (cadr Xmap))
                  11)
                (T 12)
         )
        );4th row
  )
);map_slide
;;function to generate slide name from map #
(defun slide_name (Map# / )
  (strcat "A" (itoa Map#))
);slide_name
      (vla-startundomark *THISDWG*)
;;get slide control dimensions
      (setq width  (float (dcl_Control_GetWidth Textjust:Slide))
            height (float (dcl_Control_GetHeight Textjust:Slide))
            %X (/ nX Width)
            %Y (/ nY Height))
      ;;diagnostic print
      ;(princ (strcat "\n" "X= " (rtos %X 2 2) "\n" "Y= " (rtos %Y 2 2)))
;;initialize map of image coordinates for mouse event callback
(setq XMap '(0.30 0.70) YMap '(0.30 0.60 0.80))
;;translate image map# to alignment code for TEXT objects
(setq Map#->Align
   (list '(1 . acAlignmentTopLeft)
         '(2 . acAlignmentTopCenter)
         '(3 . acAlignmentTopRight)
         '(4 . acAlignmentMiddleLeft)
         '(5 . acAlignmentMiddleCenter)
         '(6 . acAlignmentMiddleRight)
         '(7 . acAlignmentLeft)
         '(8 . acAlignmentCenter)
         '(9 . acAlignmentRight)
        '(10 . acAlignmentBottomLeft)
        '(11 . acAlignmentBottomCenter)
        '(12 . acAlignmentBottomRight)
   )
);Map#->Align
;;translate image map# to attachment code for MTEXT objects
(setq Map#->Attach
   (list '(1 . acAttachmentPointTopLeft)
         '(2 . acAttachmentPointTopCenter)
         '(3 . acAttachmentPointTopRight)
         '(4 . acAttachmentPointMiddleLeft)
         '(5 . acAttachmentPointMiddleCenter)
         '(6 . acAttachmentPointMiddleRight)
         '(7 . acAttachmentPointBottomLeft)
         '(8 . acAttachmentPointBottomCenter)
         '(9 . acAttachmentPointBottomRight)
        '(10 . acAttachmentPointBottomLeft)
        '(11 . acAttachmentPointBottomCenter)
        '(12 . acAttachmentPointBottomRight)
   )
);Map#->Attach
;;association list for text caption
(setq just_list
   (list '(1 . "Top Left")
         '(2 . "Top Center")
         '(3 . "Top Right")
         '(4 . "Middle Left")
         '(5 . "Middle Center")
         '(6 . "Middle Right")
         '(7 . "Left")
         '(8 . "Center")
         '(9 . "Right")
        '(10 . "Bottom Left")
        '(11 . "Bottom Center")
        '(12 . "Bottom Right")
   )
);just_list
;;need to map the pick point, based on _relative_ coords
      (setq Map# (map_slide %X %Y XMap YMap))
;;update the form graphics
      (display_slide  Textjust:Slide  "Textjust.slb" (slide_name Map#))
      (dcl_Control_SetCaption Textjust:Text1
        (cdr(assoc Map# just_list )))
;;now do the actual work
;;set local variable for use by align_text
(setq keep-pos (dcl_Control_GetValue Textjust:CheckBox))
;;if items are selected, iterate the selection set
(and
  (setq ss (cadr (ssgetfirst)))
  (setq i 0)
  (repeat (sslength ss)
    (setq ename (ssname ss i) ent (entget ename))
    (cond ((member (cdr (assoc 0 ent)) '("TEXT" "ATTDEF"))
           (align_text ename (eval(cdr(assoc Map# Map#->Align))) keep-pos))
          ((eq (cdr (assoc 0 ent)) "MTEXT")
           (align_mtext ename (eval(cdr(assoc Map# Map#->Attach)))))
    );cond
  (setq i (1+ i))
  );repeat
);and
);c:Textjust:Slide_OnMouseDown
;;C:Slide_OnMouseMovedOff does the following:
;;when mouse moves off the control
;;clear red circle indicator & reset caption text
;;since these only have meaning when mouse is clicked on the control
;;& end the undo mark
(defun c:Slide_OnMouseMovedOff ( /)
  (dcl_SlideView_Load Textjust:Slide "Textjust.slb" "A0" )
  (dcl_Control_SetCaption Textjust:Text1 "Justify")
  (vla-endundomark *THISDWG*)
);c:Slide_OnMouseMovedOff
;;;command to initialize the modeless form
(defun C:Textjust ( / )
  ;;display the form & initialize the slide control
  (dcl_Form_Show Textjust:ImgBtn)
  (dcl_SlideView_Load Textjust:Slide  "Textjust.slb" "A0")
  (princ)
);C:Textjust
;;load prompts
(princ "\nTextjust © 2007 Herman Mayfarth loaded.")
(princ)
