
(defun c:t33 ()


;;;   (dcl_suppressmessages T)

   (dcl-project-import (F:Sub_Import_Test_Form) nil nil)
   (dcl-Form-Show CnMTest/Form )

   (princ)
   
)

(defun c:CnMTest/Form#OnInitialize (/)

   (princ "\n Form Starts...")
   (dcl-ComboBox-Clear CnMTest/Form/cboRBListNew)
   (dcl-ComboBox-AddList CnMTest/Form/cboRBListNew (list "TBlock"))

   (princ)
)



;; button click 1 .
(defun c:CnMTest/Form/btnALMLT#OnClicked ( / *TP *Tmp_TBlock_Name )

   (setq *Tmp_TBlock_Name "TBlock")
   (setq *TP (getpoint "\n Block Point : ]"))
   (command "-insert" *Tmp_TBlock_Name *TP "1" "" "0") ;; <- this makes "Can't reenter LISP. Invalid point.
   ;;(command "-insert" *Tmp_TBlock_Name pause "1" "" "0") ;;-> this line makes no messages.
   (princ)
   
)


;; mouse move 2 .
(defun c:CnMTest/Form/btnALMLT#OnMouseMove (Flags X Y / *Tmp_TBlock_Name)

   (princ "\n Show this block : ")
   (setq *Tmp_TBlock_Name "TBlock")
   (dcl-BlockView-DisplayBlock CnMTest/Form/blvShowBlock *Tmp_TBlock_Name 0 0.9)
   (princ)
   
)

(defun c:CnMTest/Form/TextButton1#OnMouseMove (Flags X Y /)

   (dcl-BlockView-Clear CnMTest/Form/blvShowBlock)
   
)


(defun c:CnMTest/Form/btnDRMRR#OnClicked (/)
  (dcl-MessageBox "To Do: code must be added to event handler\r\nc:CnMTest/Form/btnDRMRR#OnClicked" "To do")
)

   

;; ODCL load.
(defun F:Sub_Import_Test_Form ( / )

   
   '("YWt6A6wQAABV5wmHBuK7KTcVKj9ugFgV1d36Nvze+Xf3tT8zWETkBk1Q3hiiL2pv4k/3rxp46bqe"
"P7/1xv9pc/TWaXH0NXppjloEr+VBvmFe0Gl3/DXSlLcywYBsGWypSYoFgwsLKSkpqakjLU+KA3a9"
"2wJnLPYdTaQObvlufI7MYubWa2+pSxxvCF1XW/gIh7A9PJTFr1LL+4wwHM+q5DuoWAbgNmjfd3Ms"
"aB3/qqXbqPoWGMRfq6b+I8gpPDRs8wjy8PAk80+H1Dirz640bVytpx2saG3jL2fZZDRvyDi0fbL+"
"d992vfEyLcxsF2I+SbINKhil+UXm81a3SNd0DbIAko0kqudf6hu7FMlHPIZMnxH6BXdBax198dcK"
"jUMvgvSEYYiOilrovqHYBBrpKfULXCdb2y2kRbtNI4xAXIMyD7Yhm11J1cucf5/5+pFtQD0oiG2A"
"PMbxDie2uSEXaRTDc1Kz0E50HRaaddFZsmIZF/2qvLssxxefIvD1V3cPLTSip1tQpFttyt5rJbob"
"E0ZCFNJqv5pCzrCzzToP59kEzC1kzxRdMA9X014ywGcOwM5No10C6YShXwLljlO8bbepYu9XEVuf"
"Rkj3i+XOOdKR7CF6tZujf81J2bkEvNp3CZlCamQqWJNdB2mffm3YV8A+CChHh0u7lWNA2YbKybAn"
"h+YsEaWE2tN7Q4xAWpNX99By/Zz8BBo65dOLVAFI7hOh45OoyHHK6IlHYRgCgOjcit2N85OBcJtg"
"0N2PTaOCV+vRCwbdnEu6sSi8D7zVd/2weRirEqT1frWE2vpZttWhvHgYJ0ZXuQgksipkCqTzJkUg"
"+OMsElYw3TDALRSHnKScz7gLXnDVTjRi0D6mzd0uIigd7KmBZ4/nHVU4jGSk9Yf/w60LDRJ7HNt4"
"ANIiu4Hxa60/ma9qvAJQjsdvRilAl8e8mXDhNSU3gRe8a/oJbhhQaZwAX1Btib2rjMQQD512kFpa"
"WgUT7tj7T1P8rOxWk1W24z5ojTgDyuGI1roPPXs/0EtXUAp5a5wkW5MHcbeN4pNrjkdqr2bBmrgV"
"W7bnVfSx7QMHRh+LeUZP/kG+9w8OnsYcwI1ZbZhi/5ECwJ1HeZ5F4UcO6I63fGJHOwZln5OB5z1E"
"hPi7XZBh7beM6LSTbenMB0Kih6IBSmqaOGRdTMPXtRLo09rytkrvPohut5txr6EZqiYR0bmwpIm0"
"gqzhgaGG21KVHBAZTITYbZilUnFt5Z9Nj3qAU22Tt5pNz1gBqLbf6rdpI3qWwa1BsKMPovn9Hcdx"
"AxCpgLT0ObfugUy9i4d/SLV2eA==")


)