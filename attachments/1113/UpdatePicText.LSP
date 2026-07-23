(vl-load-com)
(command "OPENDCL")

(defun c:doit (/ cnt PDRaw_Loc PDRaw_Open ChrFilter_Open)
  (dcl_Project_Load "UpdatePicText" T)
  (dcl_Form_Show UpdatePicText_Form1)
  (dcl_Form_Center UpdatePicText_Form1)
  (princ)
  )

(defun c:UpdatePicText_Form1_PictureBox1_OnPaint (HasFocus /)
  (dcl_PictureBox_DrawWrappedText UpdatePicText_Form1_PictureBox1 (list (list 6 3 144 -19 -24 "Old Text" 0)))
  )

(defun c:UpdatePicText_Form1_PictureBox1_OnMouseEntered (/) (dcl_Control_SetBackColor UpdatePicText_Form1_PictureBox1 2))
(defun c:UpdatePicText_Form1_PictureBox1_OnMouseMovedOff (/) (dcl_Control_SetBackColor UpdatePicText_Form1_PictureBox1 1))

(defun c:UpdatePicText_Form1_PictureBox1_OnClicked (/)
  (if (= (dcl_Control_GetToolTipTitle UpdatePicText_Form1_PictureBox1) "Old Text")
    (progn
      (dcl_PictureBox_DrawWrappedText UpdatePicText_Form1_PictureBox1 (list (list 6 3 144 -19 -24 "New Text" 0)))
      (dcl_Control_SetToolTipTitle UpdatePicText_Form1_PictureBox1 "New Text")
      )
    (progn
      (dcl_PictureBox_DrawWrappedText UpdatePicText_Form1_PictureBox1 (list (list 6 3 144 -19 -24 "Old Text" 0)))
      (dcl_Control_SetToolTipTitle UpdatePicText_Form1_PictureBox1 "Old Text")
      ))
)