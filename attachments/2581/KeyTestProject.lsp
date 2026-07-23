(defun c:keytest(/ c:KeyTestProject/KeyTextDialog#OnInitialize)

  (defun c:KeyTestProject/KeyTextDialog#OnInitialize (/)
    (dcl-Control-SetText KeyTestProject/KeyTextDialog/edtKey "Event\tChar\tASCII\tRepeat\tFlags")
    (dcl-Control-SetText KeyTestProject/KeyTextDialog/edtInput "")
    (dcl-Control-SetFocus KeyTestProject/KeyTextDialog/edtInput)
    (dcl-Form-Resize KeyTestProject/KeyTextDialog 408 192)
  ); c:KeyTestProject/KeyTextDialog#OnInitialize

  (defun add_line (strType strChar intRpt intFlg / cnt line)
    (setq cnt (dcl-TextBox-GetLineCount KeyTestProject/KeyTextDialog/edtKey))
    (setq line (strcat strType "\t" strChar "\t" (itoa (ascii strChar)) "\t" (itoa intRpt) "\t" (itoa intFlg)))
    (dcl-Control-SetText KeyTestProject/KeyTextDialog/edtKey (strcat (dcl-Control-GetText KeyTestProject/KeyTextDialog/edtKey) "\r\n" line))
    (dcl-TextBox-LineScroll KeyTestProject/KeyTextDialog/edtKey (1+ cnt))
  ); add_line

  
  
  (command "_opendcl")
  (dcl-project-load "d:/KeyTestProject.odcl" T)
  (dcl-Form-Show KeyTestProject/KeyTextDialog)
  (princ)
); keytest


(defun add_line (strType strChar intRpt intFlg / cnt line)
  (setq cnt (dcl-TextBox-GetLineCount KeyTestProject/KeyTextDialog/edtKey))
  (setq line (strcat strType "= Char: " strChar ", Repeat: " (itoa intRpt) ", Flags: " (itoa intFlg)))
  (dcl-Control-SetText KeyTestProject/KeyTextDialog/edtKey (strcat (dcl-Control-GetText KeyTestProject/KeyTextDialog/edtKey) "\r\n" line))
  (dcl-TextBox-LineScroll KeyTestProject/KeyTextDialog/edtKey (1+ cnt))
); add_line

(defun c:KeyTestProject/KeyTextDialog/edtInput#OnKeyDown (strCharacter intRepeatCount intFlags /) (add_line "Down" strCharacter intRepeatCount intFlags) (princ))

(defun c:KeyTestProject/KeyTextDialog/edtInput#OnKeyUp (strCharacter intRepeatCount intFlags /) (add_line "Up" strCharacter intRepeatCount intFlags) (princ))