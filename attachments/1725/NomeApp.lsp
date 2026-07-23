(defun c:NomeApp ()
  (command "_opendcl")
  (dcl_Project_Load "NomeApp" T)
  (dcl_Form_Show NomeApp_NomeForm)
)

(defun c:NomeApp_NomeForm_OnInitialize ()
  (print "c:NomeApp_NomeForm_OnInitialize")
  (setq *ImageInitialize* T)
)

(defun c:NomeApp_NomeForm_PictureBox1_OnPaint (HasFocus /)
  (print "c:NomeApp_NomeForm_PictureBox1_OnPaint")
  (if *ImageInitialize*
    (c:ImageDraw)
  )
  (setq *ImageInitialize* nil)
)

(defun c:ImageDraw ( / CoordX CoordY LunghSettore)
  (setq CoordX 10)
  (setq CoordY 10)
  (setq LunghSettore 300)
  (if NomeApp_NomeForm_PictureBox1
    (progn
      (dcl_PictureBox_DrawRect NomeApp_NomeForm_PictureBox1 (list (list CoordX CoordY LunghSettore 20 1)))
      (dcl_PictureBox_StoreImage NomeApp_NomeForm_PictureBox1)
    )
    (print "Dialog is invisible. ")
  )
)

(defun c:ImageClear ()
  (if NomeApp_NomeForm_PictureBox1
    (dcl_PictureBox_Clear NomeApp_NomeForm_PictureBox1)
    (print "Dialog is invisible. ")
  )
)

(princ "\nUse NomeApp to start ")
(princ)
