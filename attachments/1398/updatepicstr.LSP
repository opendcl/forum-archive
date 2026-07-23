(vl-load-com)
(command "OPENDCL")


(defun c:doit (/)
  
  (setq g:textValue "Original"
        g:val 0
  )
  
  (dcl_Project_Load "UpdatePicText" T)
  (dcl_Form_Show UpdatePicText_Form1)
  (dcl_Form_Center UpdatePicText_Form1)

  (princ)
)

(defun c:UpdatePicText_Form1_OnClose (UpperLeftX UpperLeftY /)  
  (setq g:textValue nil
          g:val nil )
)


(defun c:UpdatePicText_Form1_PictureBox1_OnPaint (HasFocus /)
  (dcl_PictureBox_DrawWrappedText UpdatePicText_Form1_PictureBox1
                                  (list (list 6 3 144 -19 -24 g:textValue 0))
  )
  (princ (strcat "\n OnPaint Fired :" (itoa (setq g:val (1+ g:val)) )))
)


(defun c:UpdatePicText_Form1_PictureBox1_OnMouseEntered (/)
  (dcl_Control_SetBackColor UpdatePicText_Form1_PictureBox1 2)
  
)
(defun c:UpdatePicText_Form1_PictureBox1_OnMouseMovedOff (/)
  (dcl_Control_SetBackColor UpdatePicText_Form1_PictureBox1 1)

)

(defun c:UpdatePicText_Form1_PictureBox1_OnClicked (/)
  (if
    (= (dcl_Control_GetToolTipTitle UpdatePicText_Form1_PictureBox1) "Old Text")
     (setq g:textValue "New Text")
     ;; else
     (setq g:textValue "Old Text")
  )
  (dcl_PictureBox_Refresh UpdatePicText_Form1_PictureBox1)
  (dcl_Control_SetToolTipTitle UpdatePicText_Form1_PictureBox1 g:textValue)
  (dcl_Form_Show UpdatePicText_Form2)
)

(defun c:UpdatePicText_Form2_OnMouseMovedOff (/) (dcl_Form_Close UpdatePicText_Form2))