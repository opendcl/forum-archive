;; Test OCX.

;; Get Float and String.

(command "_opendcl")

(princ "\nTEST ---> to Run!")

(defun c:TEST ( /  *TEST_ODCL_FORM *ODCL_Proj_Name )

   ;; ODCL 
   (setq *TEST_ODCL_Form (F:Sub_Import_TEST_ODCL_Form))
   (setq *ODCL_Proj_Name (dcl_project_import *TEST_ODCL_Form nil nil))

   (dcl_Form_Show TEST_Form)

   (princ)

) ;_ End of defun


(defun c:TEST_Form_OnInitialize ( / )

   (princ "\n c:TEST_Form_OnInitialize \r")
   
)


(defun c:TEST_form_OnCancel (/)
  (princ "\n c:TEST_form_OnCancel \r")
)


(defun c:TEST_form_OnClose (UpperLeftX UpperLeftY /)
  (princ "\n c:TEST_form_OnClose \r")
)


(defun c:TEST_form_OnOK (/)

   (princ "\n c:TEST_form_OnOK \r")
)

(defun c:TEST_form_OnCancelClose (Reason /)

   (princ "\n c:TEST_form_OnCancelClose \r")
   
   (setq *chk_Close (dcl_Form_Close TEST_form 5))

   ;;(alert (vl-princ-to-string Reason))
   (princ Reason)
   
)


(defun c:TEST_form_txt1_OnReturnPressed (/)
  (princ "\n c:TEST_form_txt1_OnReturnPressed \r")
)

(defun c:TEST_form_txt2_OnReturnPressed (/)
  (princ "\n c:TEST_form_txt2_OnReturnPressed \r")
)


(defun c:TEST_form_btn1_OnClicked (/)

   (princ "\n c:TEST_form_btn1_OnClicked \r")
)


;; 
(defun F:Sub_Import_TEST_ODCL_Form	(/ *TEST_ODCL)

   (setq *TEST_ODCL

'("YWt6A0IPAAAykiJBBuKTKDUxLT9qgLTd8v5RqvvE18843SoldOhknXxhdW4lzvdlbBw1lf2sWC7L"
"xB+dvDptCcTu4Z5NLzLyVaOWsGGevNv33EUdateZMhFF4/3b/FjOnkhNCcBHDeANsMcjIeZVvmdz"
"T2K5F7qefI7Qdya9dVwGLXZf9832ladxYfNu81AkC1zy/cqV3W88NNGCNq4gfj8EuXd7F7qX4igq"
"Hvc/RCmaNW9LMkLSXz9NNYrdPbX3bcs10cSWMubWdzw/Ez1J45c6fSQm1kjqYBL5DN9wsL0w2+67"
"RrjeoN7TypFiLv26kUJSPzOU6QBA7Eor/sU6GFOU5L4taKDkvl/qHEby7JwfOu6/L0xEPZhZ79gL"
"5BZtyijBUnflgSj8xBKPEyTm0dKTa2RTAaXywWFmwWmAI2/GoBu5lcefqY8CWI7KvjF7wFuaoWuG"
"2ftJUpobegMuB7+RCKcGKKKJMFUrqLhWOG22vz1ETIow7IJA5NE8w8swPJNP4LKsrjcmMfUYoBfh"
"6foP7Ojf/IYtbKg/631sTxxxTQglHCQED7dPzvkoR4QbN9IUahDIJB+mKFMSW90y5CLeimRb+Tne"
"YOUuF7XgdoI2+oTfvnF6wFEOzcZ05+RntY2oAMygPZ3CMIFK0/GvAnCUHCfw8OK0dEIo8NaVZemK"
"1t7Ze9BWd3GdRbywU/gA/A+qnhe4SfvhffhgG4Tir9mbA2+EGbQAaYdB97qFFIKvmUHdt7wgv8G1"
"lsGwii14cU+QbVsHLJ4A/wV7+BZ3zC4I9YYrarB24ryf9suMsO8H++094MzK3RifYm4UgqtFhXEw"
"/XjvEGv76RtSNRT/DK6ClWgncMusAd2/JKEM6711belnQKFTnC7VIoh3QRD2Rrp7QF0O0wwVaZeW"
"bSboHSyew7zhqbyABagHMcsoJDStHFVj2iW3L/1g2QvqGIDUMmqlFDtF9s6CXx+xcJXgawHvJgxx"
"F7QNZ5JJgqFZ6cnjcr4QWcln2fpBgaQgvJwA6KQgJAbZJAXXgyOA8ZMbdNWTe9WTG3eTW87WiNyB"
"E1LUw3ooKgWPvBBRUc+MpHVBwX+ZxJAv")
	 
	 
   ) ;_ End of setq

   *TEST_ODCL

) ;_ End of defun


