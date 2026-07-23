;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	TEXT SCAN
;	CREATED BY ANDREW MILOREY
;       FUZZY SEARCH OF A DWG FOR A SPECIFIED PIECE OF TEXT
;;	2-1-07
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(SETQ SS1 (SSGET "X" (LIST (CONS 0 "TEXT"))))
(SETQ SSL (SSLENGTH SS1))
(SETQ CNT1 0)
(setq kk "Next")
(SETQ OLDS (strcase (GETSTRING T "\nSEARCH FOR WHAT TEXT: ")))
(WHILE (and (SETQ EN (SSNAME SS1 CNT1)) (eq kk "Next"))
(SETQ ED (ENTGET EN))
(SETQ ET (CDR (ASSOC 1 ED)))
(IF (WCMATCH ET (STRCAT "*" OLDS "*")) (PROGN
(setq x1x (car (cdr (assoc 10 ed))))
(setq y1y (cadr (cdr (assoc 10 ed))))
(setq sclxy (CDR (assoc 40 ed)))
(setq x2x (rtos (- x1x (* sclxy 30))))
(setq x3x (rtos (+ x1x (* sclxy 30))))
(setq y2y (rtos (+ y1y (* sclxy 20))))
(setq y3y (rtos (- y1y (* sclxy 20))))
(setq xy1 (strcat x2x "," y3y))
(setq xy2 (strcat x3x "," y2y))
(command "_.zoom" "_w" xy1 xy2)
(setq xyx 1)
(setq lyr1 (cdr (assoc 8 ed)))
(setq lyr2 "0")
(while (<= xyx 5)
(setq ed (subst (cons 8 lyr2) (assoc 8 ed) ed))
(entmod ed)
(setq ed (subst (cons 8 lyr1) (assoc 8 ed) ed))
(entmod ed)
(setq xyx (+ xyx 1))
);end while
(initget "Next eXit")
(SETQ KK (getkword "\nSEARCH [Next/eXit]?: "))
(IF (not kk) (setq kk "Next"))
)
)
(SETQ CNT1 (1+ CNT1))
) 