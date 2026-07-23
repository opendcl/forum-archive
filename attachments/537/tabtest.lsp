;;;Descarrega o projeto
(defun c:Jclean ()
  (dcl_Project_Unload "TabTest" T)
) ;_ fim de defun
;;;
(defun c:Beta ()
;;;Funcao de restricao p/ TabStrip
  (defun c:TabTest_Form1_TabStrip1_OnSelChanging (ItemIndex /)
;;;  (if (null JoyErro)
;;;    (alert (rtos ItemIndex))
;;;  ) ;_ fim de if
    (/= 1
        (dcl_Control_GetValue (nth ItemIndex
                                   (list tabtest_Form1_CheckBox1
                                         tabtest_Form1_CheckBox2
                                         tabtest_Form1_CheckBox3
                                   ) ;_ fim de list
                              ) ;_ fim de nth
        ) ;_ fim de dcl_Control_GetValue
    ) ;_ fim de /=
  ) ;_ fim de defun
;;; ----------------------------------------------------------------------------
;;;Testanto Palette
  (defun c:joyPal ()
    (dcl_Form_Show tabtest_JoyPalette 10 0)
  ) ;_ fim de defun
;;; ----------------------------------------------------------------------------
;;;Testando imagem
  (defun c:tabtest_Form1_TextButton2_OnClicked (/)
    (dcl_PictureBox_LoadPictureFile
      tabtest_Form1_PictureBox1
      "C:\\SAINT-GOBAIN\\Projeto DuctilCAD\\Quadros\\Imagens\\base-488x56.jpg"
    ) ;_ fim de dcl_PictureBox_LoadPictureFile
  ) ;_ fim de defun
;;;Fecha o quadro
  (defun c:tabtest_Form1_TextButton1_OnClicked (/)
    (setq JoyForms (dcl_Project_GetForms "tabtest"))
    (dcl_Form_Close tabtest_Form1)
  ) ;_ fim de defun
;;; ----------------------------------------------------------------------------
;;;Carrega o Projeto
  (dcl_Project_Load "TabTest" T)
;;; ----------------------------------------------------------------------------
;;;Testando TabStrip - Antigo TabControl
;;;  (defun c:TabTest ()
    (dcl_Form_Show tabtest_form1)
;;;  ) ;_ fim de defun
) ;_ fim de defun
;|«Visual LISP© Format Options»
(80 2 50 2 T "fim de " 80 50 0 0 0 nil T T T)
;*** DO NOT add text below the comment! ***|;
