; Multi button Dialog box for a single choice repalcment of initget
; By Alan H Feb 2019

; Example code as the radio button click will close the default button setting is required 
; if you have defined a default setting

; a=97 A=65 1=
(defun make_letters (heading  asc numch  / lstchar) 
(if (/= heading nil)(setq lstchar (list heading))(setq lstchar '()))
(repeat numch 
(setq lstchar (cons (chr asc) lstchar))
(setq asc (+ asc 1))
)
(setq lstchar (reverse lstchar))
(princ lstchar)
)

; (if (not AH:Butts)(load "Multi Radio buttons.lsp"))
; (if (= but nil)(setq but 1))
; (setq ans2 (ah:butts 1 "v"  (make_letters "Please choose" 97 8)))


; (if (not AH:Butts)(load "Multi radio buttons.lsp")) 			; loads the program if not loaded already
; (if (= but nil)(setq but 1)) 						; this is needed to set default button
									; you can reset default button to user pick
; (setq ans (ah:butts but "V"   '("A B C D " "A" "B" "C" "D" ))) 	; ans holds the button picked value as a string
									; if you want ans a number use (atof ans) or (atoi ans)

; (if (not AH:Butts)(load "Multi Radio buttons.lsp"))
; (if (= but nil)(setq but 1))
; (setq ans (ah:butts but "h"  '("Yes or No" "Yes" "No"))) ; ans holds the button picked value


; (if (not AH:Butts)(load "Multi Radio buttons.lsp"))
; (if (= but nil)(setq but 1))
; (setq ans (atoi(ah:butts but "V" '("Choose a number" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10")))) ; ans holds the button picked as an integer value


(vl-load-com)
(defun AH:Butts (AHdef verhor butlst / fo fname x  k numch)
(setq fo (open (setq fname (vl-filename-mktemp "" "" ".dcl")) "w"))
(write-line  "AHbutts : dialog 	{" fo)
(write-line  (strcat "	label =" (chr 34) (nth 0 butlst) (chr 34) " ;" )fo)
(write-line "	: row	{" fo)
(if (=  (strcase verhor) "V")
(progn
(write-line "	: boxed_radio_column 	{" fo)
(write-line  (strcat " width = " (rtos (+ (strlen (nth 0 butlst)) 10) 2 0) " ;")  fo)		; increase 10 if label does not appear
)
(write-line "	: boxed_radio_row	{" fo)
)
(setq x 1)
(repeat (- (length butlst) 1) 
(write-line "	: radio_button	{" fo)
(write-line  (strcat "key = "  (chr 34) "Rb" (rtos x 2 0)  (chr 34) ";") fo)
(write-line  (strcat "label = " (chr 34) (nth x  butlst) (chr 34) ";") fo)
(write-line "	}" fo)
(if (or (= numch nil) (< numch 12))
(write-line "spacer_1 ;" fo)
)
(setq x (+ x 1))
)
(write-line "	}" fo)
(write-line "	}" fo)
(write-line "spacer_1 ;" fo)
(write-line "	ok_only;" fo)
(write-line "	}" fo)
(close fo)
(setq dcl_id (load_dialog fname))
(if (not (new_dialog "AHbutts" dcl_id) )
(exit)
)
(setq x 1)
(repeat (- (length butlst) 1)
(setq k (strcat "Rb" (rtos x 2 0)))
(action_tile k  (strcat "(setq but "  (rtos x 2 0) ")" "(done_dialog)"))
(if (= ahdef x)(set_tile k "1"))
(setq x (+ x 1))
)
(action_tile "accept" (strcat "(setq but "  (rtos ahdef 2 0) ")" "(done_dialog)"))
(start_dialog)
(unload_dialog dcl_id)
(vl-file-delete fname)
(nth but butlst)
)

