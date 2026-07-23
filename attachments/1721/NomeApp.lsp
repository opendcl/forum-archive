(defun c:NomeApp ( / c:NomeApp_NomeForm_OnInitialize c:NomeApp_NomeForm_PictureBox1_OnPaint CoordX CoordY LunghSettore pictureIsDoneP)

  (defun c:NomeApp_NomeForm_OnInitialize ()
    (print "c:NomeApp_NomeForm_OnInitialize")
  )

  (defun c:NomeApp_NomeForm_PictureBox1_OnPaint (HasFocus /)
    (print "c:NomeApp_NomeForm_PictureBox1_OnPaint")
    (if pictureIsDoneP
      (print "Using stored picture")
      (progn
        (dcl_PictureBox_DrawRect NomeApp_NomeForm_PictureBox1 (list (list CoordX CoordY LunghSettore 20.0 1)))
        (dcl_PictureBox_StoreImage NomeApp_NomeForm_PictureBox1) ; Storing the image is a good idea for large images.
        (setq pictureIsDoneP T)
        (print "Picture painted and stored")
      )
    )
  )

  (setq LunghSettore 300)
  (setq CoordX 10)
  (setq CoordY 10)
  (command "_opendcl")
  (dcl_Project_Load "NomeApp" T)
  (dcl_Form_Show NomeApp_NomeForm)
)
