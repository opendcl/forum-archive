(command "OPENDCL")
(vl-load-com)
(setvar "CMDECHO" 0)

(defun c:rgi ()
(dcl_Project_Load "RGI" T)
(dcl-Form-Show RGI/Form4)
(princ)
)


;;Adaugam o cerere
(defun c:RGI/Form4/TextButton4#OnClicked (/)
(setq nrand (dcl-Grid-GetRowCount RGI/Form4/Grid1))
(dcl-Grid-AddRow RGI/Form4/Grid1 (itoa (1+ nrand)) "2014" "ALBA" "Aiud" "")
(dcl-Grid-SetCellStyle RGI/Form4/Grid1 nrand 1 18)
(dcl-Grid-SetCellStyle RGI/Form4/Grid1 nrand 2 18)
(dcl-Grid-SetCellStyle RGI/Form4/Grid1 nrand 3 18)
(dcl-Grid-SetCellStyle RGI/Form4/Grid1 nrand 4 8)
(setq lijud '("ALBA" "ARAD" "ARGES" "BACAU" "BIHOR" "BISTRITA-NASAUD" "BOTOSANI" "BRASOV" "BRAILA" "BUCURESTI" "BUZAU" "CARAS-SEVERIN" "CALARASI" "CLUJ" "CONSTANTA" "COVASNA" "DAMBOVITA" "DOLJ" "GALATI" "GIURGIU" "GORJ" "HARGHITA" "HUNEDOARA" "IALOMITA" "IASI" "ILFOV" "MARAMURES" "MEHEDINTI" "MURES" "NEAMT" "OLT" "PRAHOVA" "SATU MARE" "SALAJ" "SIBIU" "SUCEAVA" "TELEORMAN" "TIMIS" "TULCEA" "VASLUI" "VALCEA" "VRANCEA"))
(dcl-Grid-SetCellDropList RGI/Form4/Grid1 nrand 2 lijud)
(dcl-Grid-SetCellDropList RGI/Form4/Grid1 nrand 1 '("2006" "2007" "2008" "2009" "2010" "2011" "2012" "2013" "2014"))
(dcl-Grid-SetCellDropList RGI/Form4/Grid1 nrand 3 '("Aiud" "Alba Iulia" "Blaj" "Campeni" "Sebes"))
(setq nrand (1+ nrand))
)

;;Stergem o cerere
(defun c:RGI/Form4/TextButton3#OnClicked (/)
(setq nrand (dcl-Grid-GetRowCount RGI/Form4/Grid1))
(setq rand (car (dcl-Grid-GetCurCell RGI/Form4/Grid1)))
(if (= -1 (car (dcl-Grid-GetCurCell RGI/Form4/Grid1)))
(dcl-Grid-DeleteRow RGI/Form4/Grid1 (1- nrand))
(progn
(dcl-Grid-DeleteRow RGI/Form4/Grid1 (car (dcl-Grid-GetCurCell RGI/Form4/Grid1)))
(setq indx (car (dcl-Grid-GetCurCell RGI/Form4/Grid1)))
(repeat (- nrand (1+ indx))
(dcl-Grid-SetCellText RGI/Form4/Grid1 (1+ indx) 0 (itoa (+ 2 indx)))
(setq indx (1+ indx))
)
)
)
)
;;Stergem toate cererile
(defun c:RGI/Form4/TextButton1#OnClicked (/)
(dcl-Grid-Clear RGI/Form4/Grid1)
)

(defun c:RGI/Form4/TextButton2#OnClicked (/)
(dcl-Form-Close RGI/Form4)
(princ)
)

(defun setjud ()
(cond 
((= "ALBA" jud)
(setq jnr "10")
)
((= "ARAD" jud)
(setq jnr "29")
)
((= jud "ARGES")
(setq jnr "38")
)
((= jud "BACAU")
(setq jnr "47")
)
((= jud "BIHOR")
(setq jnr "56")
)
((= jud "BISTRITA-NASAUD")
(setq jnr "65")
)
((= jud "BOTOSANI")
(setq jnr "74")
)	
((= jud "BRASOV")
(setq jnr "83")
)
((= jud "BRAILA")
(setq jnr "92")
)
((= jud "BUCURESTI")
(setq jnr "403")
)
((= jud "BUZAU")
(setq jnr "109")
)
((= jud "CARAS-SEVERIN")
(setq jnr "118")
)
((= jud "CALARASI")
(setq jnr "519")
)
((= jud "CLUJ")
(setq jnr "127")
)
((= jud "CONSTANTA")
(setq jnr "136")
)
((= jud "COVASNA")
(setq jnr "145")
)
((= jud "DAMBOVITA")
(setq jnr "154")
)
((= jud "DOLJ")
(setq jnr "163")
)
((= jud "GALATI")
(setq jnr "172")
)
((= jud "GIURGIU")
(setq jnr "528")
)
((= jud "GORJ")
(setq jnr "181")
)
((= jud "HARGHITA")
(setq jnr "190")
)
((= jud "HUNEDOARA")
(setq jnr "207")
)
((= jud "IALOMITA")
(setq jnr "216")
)
((= jud "IASI")
(setq jnr "225")
)
((= jud "ILFOV")
(setq jnr "234")
)
((= jud "MARAMURES")
(setq jnr "243")
)
((= jud "MEHEDINTI")
(setq jnr "252")
)
((= jud "MURES")
(setq jnr "261")
)
((= jud "NEAMT")
(setq jnr "270")
)
((= jud "OLT")
(setq jnr "289")
)
((= jud "PRAHOVA")
(setq jnr "298")
)
((= jud "SATU MARE")
(setq jnr "305")
)
((= jud "SALAJ")
(setq jnr "314")
)
((= jud "SIBIU")
(setq jnr "323")
)
((= jud "SUCEAVA")
(setq jnr "332")
)
((= jud "TELEORMAN")
(setq jnr "341")
)
((= jud "TIMIS")
(setq jnr "350")
)
((= jud "TULCEA")
(setq jnr "369")
)
((= jud "VASLUI")
(setq jnr "378")
)
((= jud "VALCEA")
(setq jnr "387")
)
((= jud "VRANCEA")
(setq jnr "396")
)
(T nil)
)
)

(defun c:RGI/Form4/Grid1#OnEndLabelEdit (Row Column /)
(setq rand (car (dcl-Grid-GetCurCell RGI/Form4/Grid1)))
(setq coloana (cadr (dcl-Grid-GetCurCell RGI/Form4/Grid1)))
(if (= coloana 2)
(dcl-Grid-SetCellText RGI/Form4/Grid1 rand 3 "")
)
(setq jud (dcl-Grid-GetCellText RGI/Form4/Grid1 rand 2))
(setjud)
(dcl-Html-Navigate RGI/Form4/Html1 (strcat "http://www.ancpi.ro/CerereRGI/AT_getOrgUnits.php?id=" jnr "&sid=0"))
)

(defun c:RGI/Form4/Html1#OnNavigationComplete (URL / l1 l2 txt)
(setq l1 '())
(setq l2 '())
(setq txt (dcl-Html-GetHtmlDocument RGI/Form4/Html1))
(setq txt (StringSubst "" "</OPTION></SELECT> " txt)) 
(setq txt (StringSubst "" "\r\n" txt))
(setq txt (StringSubst "" "<SELECT id=orgunits> <OPTION selected value=alege...>alege..." txt))
(setq txt (cdr (ST_PatternTokens txt "value=")))
(setq l1 (mapcar 'itoa (mapcar 'LM:ParseNumbers txt)))
(setq l2 (mapcar '(lambda (x) (vl-string-right-trim "</OPTION> <OPTION" (vl-string-left-trim (strcat (itoa (LM:ParseNumbers x)) ">") x))) txt))
(setq rand (car (dcl-Grid-GetCurCell RGI/Form4/Grid1)))
(dcl-Grid-SetCellDropList RGI/Form4/Grid1 rand 3 l2)
)

;;Salvam date in fisier
(defun c:RGI/Form4/TextButton8#OnClicked (/)
(defun c:RGI/Form2/FileExplorer#OnTypeChanged (Filetype /)
(setq rgif (close (dcl-Form-Show RGI/Form2)))
)
(setq nrand (dcl-Grid-GetRowCount RGI/Form4/Grid1))
(setq index 0)
(setq list1 '())
(setq list2 '())
(setq list3 '())
(setq list4 '())
(while (< index nrand)
(setq nr (dcl-Grid-GetCellText RGI/Form4/Grid1 index 0))
(setq an (dcl-Grid-GetCellText RGI/Form4/Grid1 index 1))
(setq jud (dcl-Grid-GetCellText RGI/Form4/Grid1 index 2))
(setq bcpi (dcl-Grid-GetCellText RGI/Form4/Grid1 index 3))
(setq list2 (list (car (dcl-Grid-GetCellDropList RGI/Form4/Grid1 index 3))))
(setq nrcerere (dcl-Grid-GetCellText RGI/Form4/Grid1 index 4))
(setq list1 (list nrcerere bcpi jud an nr))
(setq list3 (append list1 list3))
(setq list4 (append list2 list4))
(setq index (1+ index))
)
(setq list3 (reverse list3))
(setq list4 (reverse list4))
(setq cale (dcl-Form-Show RGI/Form2))
(if (not (numberp cale))
(progn
(setq rgif (dcl-BinFile-Open cale "w"))
(dcl-BinFile-Write rgif list3)
(dcl-BinFile-Write rgif list4)
(dcl-BinFile-Close rgif)
(setq rgif rgif)
)
)
)

;;Incarcam date din fisier
(defun c:RGI/Form4/TextButton6#OnClicked (/)
(setq cale (dcl-Form-Show RGI/Form3))
(if (not (numberp cale))
(progn
(dcl-Grid-Clear RGI/Form4/Grid1)
(setq RGI (dcl-BinFile-Open cale "r"))
(defun c:RGI/Form3/FileExplorer#OnTypeChanged (Filetype /)
(setq RGI (close (dcl-Form-Show RGI/Form3)))
)
(setq li11 (dcl-BinFile-Read RGI T))
(setq li12 (dcl-BinFile-Read RGI T))
(setq index 0)
(setq nranduri (/ (length li11) 5))
(while (< index nranduri)
(dcl-Grid-AddRow RGI/Form4/Grid1 (itoa (1+ index)) (nth (1+ (* 5 index)) li11) (nth (+ (* index 5) 2) li11) (nth (+ (* index 5) 3) li11) (nth (+ (* index 5) 4) li11) (nth (+ (* index 5) 5) li11))
(dcl-Grid-SetCellStyle RGI/Form4/Grid1 index 1 18)
(dcl-Grid-SetCellStyle RGI/Form4/Grid1 index 2 18)
(dcl-Grid-SetCellStyle RGI/Form4/Grid1 index 3 18)
(dcl-Grid-SetCellStyle RGI/Form4/Grid1 index 4 8)
(setq lijud '("ALBA" "ARAD" "ARGES" "BACAU" "BIHOR" "BISTRITA-NASAUD" "BOTOSANI" "BRASOV" "BRAILA" "BUCURESTI" "BUZAU" "CARAS-SEVERIN" "CALARASI" "CLUJ" "CONSTANTA" "COVASNA" "DAMBOVITA" "DOLJ" "GALATI" "GIURGIU" "GORJ" "HARGHITA" "HUNEDOARA" "IALOMITA" "IASI" "ILFOV" "MARAMURES" "MEHEDINTI" "MURES" "NEAMT" "OLT" "PRAHOVA" "SATU MARE" "SALAJ" "SIBIU" "SUCEAVA" "TELEORMAN" "TIMIS" "TULCEA" "VASLUI" "VALCEA" "VRANCEA"))
(dcl-Grid-SetCellDropList RGI/Form4/Grid1 index 2 lijud)
(dcl-Grid-SetCellDropList RGI/Form4/Grid1 index 1 '("2006" "2007" "2008" "2009" "2010" "2011" "2012" "2013" "2014"))
(dcl-Grid-SetCellDropList RGI/Form4/Grid1 index 3 (nth index li12))
(setq index (1+ index)) 
)
(dcl-BinFile-Close RGI)
(setq RGI RGI)
)
)
)

;;Asociem date cerere curenta
(defun c:RGI/Form4/TextButton9#OnClicked (/)
(regapp "SIGMA")
(setq rand (car (dcl-Grid-GetCurCell RGI/Form4/Grid1)))
(setq an (dcl-Grid-GetCellText RGI/Form4/Grid1 rand 1))
(setq jud (dcl-Grid-GetCellText RGI/Form4/Grid1 rand 2))
(setq bcpi (dcl-Grid-GetCellText RGI/Form4/Grid1 rand 3))
(setq nrcerere (dcl-Grid-GetCellText RGI/Form4/Grid1 rand 4))
(if (zerop (strlen nrcerere))
(alert "The tabel data are incomplete!")
(progn
(dcl-Form-Hide RGI/Form4 T)
(setq obj (car (entsel "\nSelect a polyline to put xdata: ")))
(while (not obj)
(setq obj (car (entsel "\nSelect a polyline to put xdata: ")))
)
(if (/= nil (assoc -3 (entget obj)))
(LM:RemoveXData obj "SIGMA")
)

(setq e (entget obj))
(setq e1 (list (list -3 (list "SIGMA"
			  (cons 1000 an) (cons 1000 jud) (cons 1000 bcpi) (cons 1000 nrcerere)   
		))))
(append (entget obj) e1)
(entmod (entget obj))
(dcl-Form-Hide RGI/Form4 nil)
)
)
)

;;Incarcam date asociate
(defun c:RGI/Form4/TextButton7#OnClicked (/)
(dcl-Form-Hide RGI/Form4 T)
(prompt "Selectati poliliniile cu datele asociate")
(setq msel (ssget ":L" '((0 . "*POLYLINE") (-3 ("SIGMA")))))

)




;; | ----------------------------------------------------------------------------
;; | ST_PatternTokens
;; | ----------------------------------------------------------------------------
;; | Function : Tokenize a string based on a pattern delimiter string
;; | Argument : 'Str' - Text String to check
;; |            'Pat' - Pattern string to use for splitting into tokens
;; | Return   : A list of all strings formed by token splitting
;; | Update   : June 12, 2004
;; | e-mail   : rakesh.rao@4d-technologies.com 
;; | Web      : www.4d-technologies.com
;; | ----------------------------------------------------------------------------


(defun ST_PatternTokens ( Str Pat / patLen Lst len Str1 pos )

(setq
	patLen  (strlen Pat)
	Lst    '()
)

(while (setq pos (ST_FindPattern Str Pat))
	(setq
		len  (strlen Str)
		Str1 (substr Str 1 (1- pos))
		Lst  (cons Str1 Lst)
		Str  (substr Str (+ pos patLen))
	)
)

(if (/= Str "")
	(setq Lst (cons Str Lst))
)

(setq Lst (reverse Lst))
)

;; | ----------------------------------------------------------------------------
;; | ST_FindPattern
;; | ----------------------------------------------------------------------------
;; | Function : Returns the start of a given text pattern in a test string
;; | Argument : 'Str' - Text String to check
;; |            'Pat' - Pattern string to search
;; | Return   : The starting position of the first pattern string, if pattern is
;; |            found else returns nil.
;; | Update   : June 24, 2008
;; | e-mail   : rakesh.rao@4d-technologies.com 
;; | Web      : www.4d-technologies.com
;; | ----------------------------------------------------------------------------

(defun ST_FindPattern( Str Pat / len1 len2 pos Found _Str )
(setq
	len1  (strlen Str)
	len2  (strlen Pat)
	pos nil
)

(if (>= len1 len2)
(progn
	(setq
		Found nil
		pos 1
	)
	(while (not Found)
		(setq _Str (substr Str pos len2))
		(if (equal _Str Pat)
			(setq Found T)
			(setq pos (1+ pos))
		)
		(if (> pos len1)
			(setq
				Found T
				pos nil
			)
		)
	)
))
pos
)

(defun StringSubst ( new old str / inc len )
    (setq len (strlen new)
          inc 0
    )
    (while (setq inc (vl-string-search old str inc))
        (setq str (vl-string-subst new old str inc)
              inc (+ inc len)
        )
    )
    str
)

;;-------------------=={ Parse Numbers }==--------------------;;
;;                                                            ;;
;;  Parses a list of numerical values from a supplied string. ;;
;;------------------------------------------------------------;;
;;  Author: Lee Mac, Copyright © 2011 - www.lee-mac.com       ;;
;;------------------------------------------------------------;;
;;  Arguments:                                                ;;
;;  s - String to process                                     ;;
;;------------------------------------------------------------;;
;;  Returns:  List of numerical values found in string.       ;;
;;------------------------------------------------------------;;

(defun LM:ParseNumbers ( s )
  (
    (lambda ( l )
      (read
        (strcat 
          (vl-list->string
            (mapcar
              (function
                (lambda ( a b c )
                  (if
                    (or
                      (< 47 b 58)
                      (and (= 45 b) (< 47 c 58) (not (< 47 a 58)))
                      (and (= 46 b) (< 47 a 58) (< 47 c 58))
                    )
                    b 32
                  )
                )
              )
              (cons nil l) l (append (cdr l) (list nil))
            )
          )
         
        )
      )
    )
    (vl-string->list s)
  )
)

(defun LM:RemoveXData ( entity appID )
;; © Lee Mac ~ 26.05.10
(if (assoc -3 (entget entity (list appID)))
(entmod (list (cons -1 entity) (list -3 (list appID))))
)
)