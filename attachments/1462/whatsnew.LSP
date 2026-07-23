
(defun C:whatsnew ()


(setq hfile "f:\\acad\\acad2009\\update.log")


	;; Ensure OpenDCL Runtime is (quietly) loaded
	(setq cmdecho (getvar "CMDECHO"))
	(setvar "CMDECHO" 0)
	(command "_OPENDCL")
	(setvar "CMDECHO" cmdecho)


; call the method to load the odcl file.
(dcl_Project_Load "whatsnew" T)

(defun COPYdate ()
(load "COPYdate")     
) ;COPYdate

(defun printlog ()
(dos_spool hfile (dos_getprn))   
) ;printlog


(setq file1 (open HFILE "r"))
(setq lista (list))
(while (setq rl1 (read-line file1))
	(setq lista (append lista (list rl1)))
);end while
(close file1)
;;

;;
 ;(setq DCL_ID (load_dialog "whatsnew.dcl"))
 ;(if (not (new_dialog "whatsnew" DCL_ID))
 ; (exit)
 ;) ;_ end of if

   ;(start_list "txtlist")
   (mapcar ' add_list lista))
   ;(end_list)


;(setq aam (mapcar 'add_list lista))

(setq yo (dcl_ListBox_AddList whatsnew_Form1_ListBox1 lista)))


(dcl_Control_SetList whatsnew_Form1_ListBox1 yo)

; (action_tile "accept" "(done_dialog 1)")
; (action_tile "prnt" "(done_dialog 2)")
;  (setq button (start_dialog))
;  (if (= button 1)(COPYdate))
;   (cond ((= BUTTON 2) (printlog))
;   ) ;cond
; (unload_dialog DCL_ID)
; (princ)
)
