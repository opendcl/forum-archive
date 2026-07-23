;;;This method displays the image in Filename. The file can be a bitmap (.bmp), JPEG (.jpg), PNG (.png), Windows metafile (.wmf), or icon (.ico) file.
;;;If Stretch is T, the picture is enlarged uniformly as much as possible to still fit inside the control.
(defun c:Test ()
   (command "_.opendcl")
   (vl-load-com)
;;;Carrega o projeto
   (Dcl_Project_Load "LoadPictureFile" T)
;;;
   (defun c:LoadPictureFile_Form1_OnInitialize (/)
      (dcl_PictureBox_LoadPictureFile LoadPictureFile_Form1_PictureBox1
                                      "c:\\background.bmp"
                                     T ;_ {Stretch [as Boolean]}
      ) ;_ end of dcl_PictureBox_LoadPictureFile
   ) ;_ end of defun
;;;
   (dcl_Form_Show LoadPictureFile_Form1)
) ;_ end of defun
