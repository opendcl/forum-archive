; another strange and vicious thing
; également avec les ControlBar
(defun c:go ()
  (command "OPENDCL")
  (dcl_Project_Load "AppBar" T)
  (dcl_Form_Show AppBar_Form1)
  (princ)
)
(defun c:DO (/ out gr)
  (dcl_TextBox_SetSel AppBar_Form1_TextBox1 0 0)
  (princ)
)
(defun c:Appbar_Form1_TextBox1_OnKillFocus (/ tmp)
;;;  (princ)					; doesn't causes the problem
;;;  (setq tmp 0)
  (dcl_Control_GetText Appbar_Form1_TextBox1)	; need something like that
)
