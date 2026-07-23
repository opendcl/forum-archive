(defun c:FormEventTester()


(defun c:FormEventTester/MyForm#OnInitialize (/)
  (dcl-MessageBox "Form was created and is ready to be shown.\r\nc:FormEventTester/MyForm#OnInitialize" "Ereignisfunktion")
)


(defun c:FormEventTester/MyForm#OnCancelClose (intIsESC /)
   (if (= intIsEsc 1)
     (dcl-MessageBox "ESC was pressed!\r\nc:FormEventTester/MyForm#OnCancelClose" "Ereignisfunktion")
     (dcl-MessageBox "Form is about to close\r\nc:FormEventTester/MyForm#OnCancelClose" "Ereignisfunktion")
   ); if
   (if (zerop (dcl-Control-GetValue FormEventTester/MyForm/chbCloseAtEnter))
     (/= intIsESC 1)
     nil
   ); if
)


(defun c:FormEventTester/MyForm#OnCancel (/)
  (dcl-MessageBox "Form is about to be cancelled.\r\nc:FormEventTester/MyForm#OnCancel" "Ereignisfunktion")
)


(defun c:FormEventTester/MyForm#OnOK (/)
  (dcl-MessageBox "Form was about to be closed after accepting.\r\nc:FormEventTester/MyForm#OnOK" "Ereignisfunktion")
)


(defun c:FormEventTester/MyForm#OnClose (intUpperLeftX intUpperLeftY /)
   (dcl-MessageBox "Form is finally going to be closed. Last call to get information.\r\nc:FormEventTester/MyForm#OnClose" "Ereignisfunktion")
)


(defun c:FormEventTester/MyForm#OnHelp (/)
  (dcl-MessageBox "Help should be shown here.\r\nc:FormEventTester/MyForm#OnHelp" "Ereignisfunktion")
)


(defun c:FormEventTester/MyForm/pbCancel#OnClicked (/)
  (dcl-form-close FormEventTester/MyForm 2)
)


(defun c:FormEventTester/MyForm/pbOk#OnClicked (/)
  (dcl-form-close FormEventTester/MyForm 1)
)

(command "_opendcl")
(dcl-project-load "D:\\FormEventTester.odcl" T)
(setq intRet (dcl-form-show FormEventTester/MyForm))

(dcl-MessageBox (strcat "Return value of dcl-form-show: " (itoa intRet)) "Ereignisfunktion")


(princ)

); FormEventTester