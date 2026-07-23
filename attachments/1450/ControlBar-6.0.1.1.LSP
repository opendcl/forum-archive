;;; -----------------------------------------------------------------------------------------------------------------------------
;;;Descarrega o projeto
;;;(defun c:JClean (/) (Dcl_Project_UnLoad "SimulatingPalette"))
(defun c:JClean	(/)
  (if (member "ControlBar-6.0.1.1" (dcl_GetProjects))
    (Dcl_Project_UnLoad "ControlBar-6.0.1.1")
  ) ;_ fim de if
) ;_ fim de defun
;;; -----------------------------------------------------------------------------------------------------------------------------
;;;C/ QUADROS DOCKABLE
  (defun c:Test (/ nextDlg)
;;;Carrega as funcoes de VisualLisp
    (vl-load-com)
    (command "_.opendcl")
;;;Controles
;;;Acao do PictureBox
    (defun c:ControlBar-6_Form1_PictureBox1_OnClicked (/)
;;;LArgura do quadro
      (setq JoyLarg (dcl_Control_GetWidth ControlBar-6_Form1))
;;;Altura do quadro
      (setq JoyAlt (dcl_Control_GetHeight ControlBar-6_Form1))
;;;Diminui a largura do quadro
      (dcl_Control_SetWidth ControlBar-6_Form1 25)
    ) ;_ fim de defun
;;; -----------------------------------------------------------------------------------------------------------------------------
;;;Carrega o projeto
    (Dcl_Project_Load "ControlBar-6.0.1.1" T)
;;;Funcaos de inicializacao
    (defun c:ControlBar-6_Form1_OnInitialize (/)
;;;Ajusta a altura do PicutreBox lateral
      (dcl_Control_SetHeight
	ControlBar-6_Form1_PictureBox1
	(dcl_Control_GetHeight ControlBar-6_Form1)
      ) ;_ fim de dcl_Control_SetHeight
    ) ;_ fim de defun
;;; -----------------------------------------------------------------------------------------------------------------------------
;;;Joga o quadro na tela
    (dcl_Form_Show ControlBar-6_Form1)
  ) ;_ fim de defun
;;; -----------------------------------------------------------------------------------------------------------------------------
;|«Visual LISP© Format Options»
(72 2 40 2 T "fim de " 60 16 0 0 2 T T nil T)
;*** DO NOT add text below the comment! ***|;
