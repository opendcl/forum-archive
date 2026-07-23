; (dcl-project-load "dcl-time-test-07" t) (dcl-form-show  "dcl-time-test-07" "form")


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
(defun :DCL-TIME-TEST-07 ()
	;			-
	(defun C:DCL-TIME-TEST-07/FORM#ONTIMER (/)
   	(dcl-form-close  "dcl-time-test-07" "form")
	)

	;			-
	(defun C:DCL-TIME-TEST-07/FORM#ONINITIALIZE (/)
		(dcl-Form-StartTimer "dcl-time-test-07" "form" 10)
	)

	(dcl-project-load "dcl-time-test-07" t)
	(dcl-form-show  "dcl-time-test-07" "form")
)


(defun C:T7 () (:DCL-TIME-TEST-PRJ-NO 7 100 ) )

(defun c:107 ( / count)
	(setq count 0)
	(repeat 10
		(setq count (+ 1 count) )
		(princ (strcat "\n" (itoa count) ) )
		(C:T7)
	)
)

