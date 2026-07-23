;;;This method displays the image in Filename. The file can be a bitmap (.bmp), JPEG (.jpg), PNG (.png), Windows metafile (.wmf), or icon (.ico) file.
;;;If Stretch is T, the picture is enlarged uniformly as much as possible to still fit inside the control.
(defun c:TestImag ()
   (command "_.opendcl")
   (vl-load-com)
;;;
;;;Carrega o projeto
   (Dcl_Project_Load "LoadPictureFile" T)
;;;Test PaintPicture
   (defun c:LoadPictureFile_Form1_PictureBox1_OnPaint (HasFocus /)
      (dcl_PictureBox_PaintPicture LoadPictureFile_Form1_PictureBox1
				   (list (list 10 10 101 T T) ;_ .ico image
					 (list 10 40 100 T T) ;_ .bmp image
					 (list 10 70 102 T T) ;_ .png image
					 (list 10 100 103 T T) ;_ .jpg image
				   ) ;_ end of list
      ) ;_ end of dcl_PictureBox_PaintPicture
   ) ;_ end of defun
;;;
   (defun c:LoadPictureFile_Form1_OnInitialize (/)
      (setq initialize T)
   ) ;_ end of defun
;;;
   (dcl_Form_Show LoadPictureFile_Form1)
) ;_ end of defun
;|«Visual LISP© Format Options»
(80 3 80 2 T "end of " 80 80 0 0 2 T nil nil T)
;*** DO NOT add text below the comment! ***|;
