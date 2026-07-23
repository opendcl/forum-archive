(defun c:vvv (/ *error*)
  (command "OPENDCL")
  (dcl_Project_Load "FindMS" T)
  (dcl_Form_Show FindMS_Form1)
  (princ)
  )


;; Error Trap
  (defun *error* ( msg )
    (if (not (wcmatch (strcase msg t) "*break,*cancel*,*exit*"))
      (princ (strcat "\nError: " msg))
      );if
    (princ)
    );error


;; Start Dialog box
(defun c:FindMS/Form1#OnInitialize (/)
  (if (not MS#)
    (setq MS# "")
    );if
  (if (not uOpt)
    (setq uOpt 1)
    );if  
  (dcl-Control-SetText FindMS/Form1/TextBox1 MS#)
  (dcl-OptionList-SetCurSel FindMS/Form1/OptionList1 uOpt)
)


;; OK Button
(defun c:FindMS/Form1/TextButton1#OnClicked (/)
  (setq MS# (dcl-Control-GetText FindMS/Form1/TextBox1)
	uOpt (dcl-OptionList-GetCurSel FindMS/Form1/OptionList1)
	);setq
  (command "_UnisolateObjects")
  (if (tblsearch "Layer" MS#)
    (if (setq SS (ssget "_X" (list (cons 8 MS#))))
	(command "Zoom" "_object" SS "")
	(alert (strcat "No Objects assigned to " MS#))
	);if
      (alert (strcat MS# " Not Found!"))
      );if
  (UserOption) ;; Option Button
  (princ)
  );defun


;; Cancel Button
(defun c:FindMS/Form1/TextButton2#OnClicked (/)
  (dcl_Form_Close FindMS_Form1)
)


;; Isloate Option
(defun UserOption (/)
  (cond
    ((= uOpt 0)(command "_IsolateObjects" "P" ""))
    ((= uOpt 1)(command "_UnisolateObjects"))
    );cond
  )


;; Run command with retrun key
(defun c:FindMS/Form1/TextBox1#OnReturnPressed (/)
  (dcl-sendstring "FindMS/Form1/TextButton1#OnClicked\r")
)


;; Keep dialog open when pressing return
(defun c:FindMS/Form1#OnCancelClose (Reason /)
  (/= intIsESC 1)
)

(defun c:FindMS_T/Form1/OptionList1#OnSelChanged (ItemIndexOrCount Value /)
  (cond
    ((= uOpt 0)(command "_IsolateObjects" "P" ""))
    ((= uOpt 1)(command "_UnisolateObjects"))
    );cond
)
