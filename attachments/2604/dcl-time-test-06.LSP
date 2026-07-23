(dcl-project-load "dcl-time-test-06" t)
(dcl-form-show  "dcl-time-test-06" "form")


(defun :LST-SORT> 	(l)	(vl-sort l '(lambda (i j) (< i j) ) ) )


(defun :DCL-TIME-TEST-PRJ-NO ( prj-no rep-no / average elapsed-time elapsed-time-lst func-name ind start )
	(setq func-name (strcat "(:DCL-TIME-TEST-0" (itoa prj-no) ")" ) )
	(setq ind 0)
	(repeat rep-no
		(setq start (getvar "millisecs") )
		(eval (read func-name) )
		(setq elapsed-time (- (getvar "millisecs") start) )
		(setq elapsed-time-lst (append elapsed-time-lst (list elapsed-time ) ) )
		;	(princ (strcat "\n"(itoa (setq ind (+ 1 ind))))) (princ)
		;  (princ (strcat "\n"(itoa elapsed-time) ) ) (princ)
	)

	(setq average  (/ (apply '+ elapsed-time-lst) (length elapsed-time-lst) ) )

	;	(princ (:LST-SORT> elapsed-time-lst) )	(princ)
	;	(princ (strcat "\n min : " (itoa (apply 'min elapsed-time-lst) ) ) )	(princ)
	;	(princ (strcat "\n max : " (itoa (apply 'max elapsed-time-lst) ) ) )	(princ)
	(princ (strcat "\n average : " (itoa average) ) )	(princ)
)



;			-			-			-			-			-
(defun :DCL-TIME-TEST-06 ()
	;			-
	(defun C:DCL-TIME-TEST-06/FORM#ONTIMER (/)
   	(dcl-form-close  "dcl-time-test-06" "form")
	)

	;			-
	(defun C:DCL-TIME-TEST-06/FORM#ONINITIALIZE (/)
		(dcl-Form-StartTimer "dcl-time-test-06" "form" 10)
	)

	(dcl-project-load "dcl-time-test-06" t)
	(dcl-form-show  "dcl-time-test-06" "form")
)


(defun C:T6 () (:DCL-TIME-TEST-PRJ-NO 6 100 ) )

;   (repeat 25 (C:T6))

;	 average : 149
;	 average : 166
;	 average : 186
;	 average : 204
;	 average : 226
;	 average : 245
;	 average : 265
;	 average : 282
;	 average : 302
;	 average : 325
;	 average : 342
;	 average : 363
;	 average : 382
;	 average : 406
;	 average : 429
;	 average : 452
;	 average : 472
;	 average : 496
;	 average : 521
;	 average : 547
;	 average : 580
;	 average : 596
;	 average : 616
;	 average : 647
;	 average : 677

