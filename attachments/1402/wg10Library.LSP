;;12062010
(PRINC "\nwg10Library12062010 Loaded")
;SPRO loading
(defun c:dbspro()
; Check for AutoCAD 2000
(if (= "15.0" (getvar "acadver"))
  (if (not (member "sproarx2000.arx" (arx)))
   (if (findfile "sproarx2000.arx")
    (progn
     (arxload "sproarx2000")
     (PRINC "\nsproarx2000 loaded")
    )
   )
   (princ "\nsproarx2000 is already loaded")
  )
)
; Check for AutoCAD 2002
(if (= "15.06" (getvar "acadver"))
  (if (not (member "sproarx2002.arx" (arx)))
   (if (findfile "sproarx2002.arx")
    (progn
     (arxload "sproarx2002")
     (PRINC "\nsproarx2002 loaded")
    )
   )
   (princ "\nsproarx2002 is already loaded")
  )
)
; Check for AutoCAD 2004, or 2005
(if (= "16" (substr (getvar "acadver") 1 2))
 (if (not (member "sproarx2004.arx" (arx)))
  (if (findfile "sproarx2004.arx")
   (PROGN
    (arxload "sproarx2004")
    (PRINC "\nsproarx2004 loaded")
   )
  )
  (princ "\nsproarx2004 is already loaded")
 )
)
);dblib
; to unremark when necessary
;(c:dbspro)

;;;===========================================================================
;doslib loading
(defun c:dblip()
; Check for AutoCAD 2000, 2000i, or 2002
(if (= "15" (substr (getvar "acadver") 1 2))
  (if (not (member "doslib15.arx" (arx)))
   (if (findfile "doslib15.arx")
    (progn
     (arxload "doslib15")
     (PRINC "\ndoslib15 loaded")
    )
   )
   (princ "\ndoslib15 is already loaded")
  )

)
; Check for AutoCAD 2004, or 2005
(if (= "16" (substr (getvar "acadver") 1 2))
 (if (not (member "doslib16.arx" (arx)))
  (if (findfile "doslib16.arx")
   (PROGN
    (arxload "doslib16")
    (PRINC "\ndoslib16 loaded")
   )
  )
  (princ "\ndoslib16 is already loaded")
 )
)
);dblib
; to unremark when necessary
;(c:dblip)

;;;===========================================================================
;; example to use benchmark
;;(setq mylst '(1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 
;; 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 
;; 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 
;; 0))

;;(benchmark
;; '(
;;   (remove-duplicates-tony mylst)
;;   (apply 'append (remove-dup-se7en2 mylst))
;;   (remove_Dublicates-ASMI mylst)
;;   (RemoveDuplicates-mp1 mylst)
;;   (RemoveDuplicates-mp2 mylst)
;;   (remove_dup-se7en mylst)
;; ))
;; example

(defun Benchmark

    ;;=================================================================
    ;;
    ;;  Benchmark.lsp | 2005 Michael Puckett | All Rights Reserved
    ;;
    ;;=================================================================
    ;;
    ;;  Purpose:
    ;;
    ;;      Compare the performance of various statements.
    ;;
    ;;  Notes:
    ;;
    ;;      I make no claims that this is definitive benchmarking. I
    ;;      wrote this utility for my own purposes and thought I'd
    ;;      share it. Many considerations go into evaluating the
    ;;      performance or suitability of an algorythm for a given
    ;;      task. Raw performance as profiled herein is just one.
    ;;
    ;;      Please note that background dramatically affect results.
    ;;
    ;;  Disclaimer:
    ;;
    ;;      This program is flawed in one or more ways and is not fit
    ;;      for any particular purpose, stated or implied. Use at your
    ;;      own risk.
    ;;
    ;;=================================================================
    ;;
    ;;  Syntax:
    ;;
    ;;      (Benchmark statements)
    ;;
    ;;          Where statements is a quoted list of statements.
    ;;
    ;;=================================================================
    ;;
    ;;  Example:
    ;;
    ;;      (BenchMark
    ;;         '(
    ;;              (1+ 1)
    ;;              (+ 1 1)
    ;;              (+ 1 1.0)
    ;;              (+ 1.0 1.0)
    ;;          )
    ;;      )
    ;;
    ;;=================================================================
    ;;
    ;;  Output:
    ;;
    ;;      Elapsed milliseconds / relative speed for 32768 iteration(s):
    ;;
    ;;          (1+ 1)..........1969 / 1.09 <fastest>
    ;;          (+ 1 1).........2078 / 1.03
    ;;          (+ 1 1.0).......2125 / 1.01
    ;;          (+ 1.0 1.0).....2140 / 1.00 <slowest>    
    ;;
    ;;=================================================================

    (
        statements
        /
        _LSet
        _RSet
        _ToString
        _Eval
        _Princ
        _Main
    )

    ;;=================================================================
    ;;
    ;;  (_LSet text len fillChar)
    ;;
    ;;=================================================================

    (defun _LSet ( text len fillChar / padding result )

        (setq
            padding (list (ascii fillChar))
            result  (vl-string->list text)
        )

        (while
            (<  (length
                    (setq padding
                        (append padding padding)
                    )
                )
                len
            )
        )

        (while
            (<  (length
                    (setq result
                        (append result padding)
                    )
                )
                len
            )
        )

        (substr (vl-list->string result) 1 len)

    )

    ;;=================================================================
    ;;
    ;;  (_RSet text len fillChar)
    ;;
    ;;=================================================================

    (defun _RSet ( text len fillChar / padding result )

        (setq
            padding (list (ascii fillChar))
            result  (vl-string->list text)
        )

        (while
            (<  (length
                    (setq padding
                        (append padding padding)
                    )
                )
                len
            )
        )

        (while
            (<  (length
                    (setq result
                        (append padding result)
                    )
                )
                len
            )
        )

        (substr
            (vl-list->string result)
            (1+ (- (length result) len))
        )

    )

    ;;=================================================================
    ;;
    ;;  (_ToString x)
    ;;
    ;;=================================================================

    (defun _ToString ( x / result )
        (if
            (<  (strlen
                    (setq result
                        (vl-prin1-to-string x)
                    )
                )
                40
            )
            result
            (strcat (substr result 1 36) "..." (chr 41))
        )
    )

    ;;=================================================================
    ;;
    ;;  (_Eval statement iterations)
    ;;
    ;;=================================================================

    (defun _Eval ( statement iterations / start )

        (gc)
        (setq start (getvar "millisecs"))
        (repeat iterations (eval statement))
        (- (getvar "millisecs") start)

    )

    ;;=================================================================
    ;;
    ;;  (_Princ x)
    ;;
    ;;=================================================================

    (defun _Princ ( x )
        (princ x)
        (princ) ;; forces screen update
    )

    ;;=================================================================
    ;;
    ;;  (_Main statements)
    ;;
    ;;=================================================================

    (defun _Main

        (   statements
            /
            boundary
            iterations
            timings
            slowest
            fastest
            lsetLen
            rsetLen
            index
            count
        )

        (setq
            boundary   1000
            iterations 1
        )

        (_Princ "Benchmarking ...")

        (while
            (or
                (<  (apply 'max
                        (setq timings
                            (mapcar
                               '(lambda (statement)
                                    (_Eval statement iterations)
                                )
                                statements
                            )
                        )
                    )
                    boundary
                )
                (<  (apply 'min timings)
                    boundary
                )
            )
            (setq iterations
                (* 2 iterations)
            )
            (_Princ ".")
        )

        (_Princ
            (strcat
                "\rElapsed milliseconds / relative speed for "
                (itoa iterations)
                " iteration(s):\n\n"
            )
        )

        (setq
            slowest (float (apply 'max timings))
            fastest (apply 'min timings)
        )

        (setq lsetLen
            (+ 5
                (apply 'max
                    (mapcar 'strlen
                        (setq statements
                            (mapcar '_ToString
                                statements
                            )
                        )
                    )
                )
            )
        )

        (setq rsetLen
            (apply 'max
                (mapcar
                   '(lambda (ms) (strlen (itoa ms)))
                    timings
                )
            )
        )

        (setq
            index 0
            count (length statements)
        )

        (foreach pair

            (vl-sort
                (mapcar 'cons statements timings)
               '(lambda (a b) (< (cdr a) (cdr b)))
            )

            (   (lambda ( pair / ms )
                    (_Princ
                        (strcat
                            "    "
                            (_LSet (car pair) lsetLen ".")
                            (_RSet
                                (itoa (setq ms (cdr pair)))
                                rsetLen
                                "."
                            )
                            " / "
                            (rtos (/ slowest ms) 2 2)
                            (cond
                                ((eq 1 (setq index (1+ index))) " <fastest>")
                                ((eq index count) " <slowest>")
                                ("")
                            )
                            "\n"
                        )
                    )
                )
                pair
            )
        )

        (princ)

    )

    ;;=================================================================
    ;;
    ;;  Program is defined, let's rock and roll ...
    ;;
    ;;=================================================================

    (_Main statements)

)


;;;===========================================================================
;;
;; code from swamp
;; by gile
(defun remove_doubles (lst)
 (if lst
  (cons (car lst) (remove_doubles (vl-remove (car lst) lst)))
 )
) 

;;;===========================================================================
;; Written By: Peter Jamtgaard P.E
;; Parsing a textstring to a list. 
;; strText = text1,text2,text3,......
;; strChar = "" (delimiter character) can be anything
;; returns a list (text1 text2 text3 ....) without the delimiter
;;
(defun CSVStringToList (strText strChar / intPosition lstStrings) 
 (while (setq intPosition (vl-string-search strChar strText 0)) 
  (setq lstStrings (cons (substr strText 1 intPosition) lstStrings) 
        strText     (substr strText (+ intPosition 1 (strlen strChar))) 
  )
 ) 
 (reverse (cons strText lstStrings)) 
);CSVStringTolist


;;;===========================================================================
;; 
;; Function wg10:Read-dataVL
;; USAGE:
;; Argument
;; <fp> - the file open for reading
;; <delimiter> - the char for parsing the text to separate it into list
;;           (can be any character)
;; Returns:
;; <a list of textsstrings in a list>
;; or <nil> when at end of file
;;
(defun wg10:Read-dataVL (fp delimiter / Data txt)
  (if (setq txt (read-line fp))
   (progn
    (setq Data (CSVStringToList txt delimiter))
   )
   (progn
    (setq Data nil)
   )
  ); endif
);wg10:Read-dataVL

;;;===========================================================================
;; From David Stien Vlisp Bible
;; Add Xrecord into the dictionary object in dictionary collection
;; USAGE
;; Arguments
;; dict    -   :<string> dictionary object
;; name    -   :<string> name of the dictionary
;; data    -   :<List of dotted pairs>
;; eg           (list '(2000 . "A")'(2001 . "B")
;;                    '(2004 . "C")'(2003 . "D")
;;              )
;; 5-2-06
;;
(defun wg10:Xrecord-Add ( dict name data / dict xrec safDXFCodes safDXFValues 
                                     lstDXFCodes lstDXFValues 
                                     filter_codelist filter_valuelist 
                                     filter_code filter_value )
 (setq dict (vlax-invoke-method objDictionary "Add" dict)
       xrec (vla-AddXrecord dict name)
 )
 (if (not (listp data))(setq data (list data))) ; ensure list
; (vla-setXrecordData xrec 
;    (listToSafeArray 2 (wg10:List->CodesList data)) ;  2=vlax-vbInteger
;    (listToSafeArray 12 data)                  ; 12=vlax-vbVariant
;)
(print "data ")(princ data)
  (setq filter_codelist (mapcar '(lambda (x) (car x)) data) 
        filter_valuelist (mapcar '(lambda (x) (cdr x)) data) 
        filter_code (wg10:ListtoSafearray 2 filter_codelist)
        filter_value (wg10:ListtoSafearray 12 filter_valuelist)
  )
  (print "filter_codelist ")(princ filter_codelist)
  (print "filter_valuelist ")(princ filter_valuelist)
  (print "filter_code ")(princ filter_code)
  (print "filter_value ")(princ filter_value)
  (vla-setXrecordData xrec filter_code filter_value)
);defun wg10:Xrecord-Add

;;;===========================================================================
 (defun wg10:List->CodesList (lst / n)
  (setq n -1)
  (mapcar '(lambda(x) (setq n(1+ n))) lst)
 );wg10:List->CodesList

;;;===========================================================================
;;
;; From David Stien Vlisp Bible
;; 5-2-06
;; wg10:Xrecord-Delete
;;
(defun wg10:Xrecord-Delete ( dict name / dcs odc xr )
 (cond
  ((setq odc (wg10:CheckItemExist objDictionary dict))
    (cond
     ((setq xr (wg10:CheckItemExist odc name))
      (vla-delete xr)
      (vlax-release-object xr)
     );xr
    );cond
   (vlax-release-object odc)
  );odc
 );cond
);wg10:Xrecord-Delete

;;;===========================================================================
;;
;; Checkitem in collection
;;
;; From David Stien Vlisp Bible
;; 5-02-06
;; To Check if certain item in a collection exists
;;
(defun wg10:CheckItemExist( collection item / out)
 (if 
     (not
      (vl-catch-all-error-p 
       (setq out
         (vl-catch-all-apply 'vla-item (list collection item))
       )
      )
     )
     out ; return object or nil
 );if
); wg10:CheckItemExist

;;;===========================================================================
;; From David Stien Vlisp Bible
;;
(defun wg10:Xrecord-Rebuild( dict name data)
 (wg10:Xrecord-Delete dict name)
 (wg10:Xrecord-Add dict name data)
) ; wg10:Xrecord-Rebuild

;;;===========================================================================
;; objDictionary must be defined first in main program before calling
;; (setq objDictionary (vla-get-Dictionaries (vla-get-Activedocument (vlax-get-acad-object))))
;; From David Stien Vlisp Bible
;; Retrieve Xrecord from the dictionary object in dictionary collection
;; USAGE
;; Arguments
;; dict    -   :<string> 
;; name    -   :<string> 
;; Returns -   :<list dotted pairs (list '(lstDXFCodes . lstDXFValues) .....)>
;;
 (defun wg10:Xrecord-Get ( dict name / odc xrec safDXFCodes safDXFValues 
                                 lstDXFCodes lstDXFValues )
 (cond
  ((setq odc (wg10:CheckItemExist objDictionary dict))

   (cond
    ((setq xrec (wg10:CheckItemExist odc name))
     (vla-getXrecordData xrec  'safDXFCodes 'safDXFValues)
;     (vla-getXrecordsData xrec '#typ '#dat)
; (setq #type (vlax-safearray->list #typ)
;       #dat (vlax-safearray->list #dat)
; )
; (mapcar 'vlax-variant-value #dat)
;(print "safdxfcodes ")(princ safdxfcodes)
;(print "safdxfvalues ")(princ safdxfvalues)
     (if (and safDXFCodes
               safDXFValues
          )
          (progn
           (setq lstDXFCodes  (vlax-safearray->list safDXFCodes)
		 lstDXFValues  (mapcar 'variant-value (vlax-safearray->list safDXFValues)))
          )
      )
     (vlax-release-object xrec)
    );xrec
   );cond
   (vlax-release-object odc)
  ); odc
 );cond
;  (list lstDXFCodes lstDXFValues)
;(print "lstdxfcodes ")(princ lstdxfcodes)
;(print "lstdxfvalues ")(princ lstdxfvalues)
   (mapcar 'cons lstdxfcodes lstdxfvalues)
);wg10:Xrecord-Get


;;;===========================================================================
;; Convert a list into a safearray 
;; USAGE:
;; Argument:
;; <symVariableType>  - <type of variable>
;; <lstvalues>        - <list of values> (eg (x1 y1 z1 x2 y2 z2))
;; Returns:
;; safearray
  (defun wg10:ListToSafearray (symVariableType lstValues / safValues) 
    (setq safValues (vlax-make-safearray symVariableType 
                 (cons 0 (1- (length lstValues))))) 
    (vlax-safearray-fill safValues lstValues) 
  ) 

;;;===========================================================================
;; function to 
;; return a list of ( x1 y1 z1 x2 y2 z2 .....)
;; from a variant of array
;; note: variant may have no data
;;
  (defun wg10:SafearrayToList (obj)
    (if (> (vlax-safearray-get-u-bound (vlax-variant-value obj) 1) 0)
      (progn
       (vlax-safearray->list (vlax-variant-value obj))
      )
    )
  )

