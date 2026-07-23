;;;Descarrega o projeto
(defun c:JClean (/) (Dcl_Project_UnLoad "SimulatingPalette"))
;;; ----------------------------------------------------------------------------
;;;C/ QUADROS DOCKABLE
  (defun c:test	(/ nextDlg)
;;;    (command "_opendcl")
;;;Carrega o projeto
;;;Retirar T quando o projeto estiver pronto
    (dcl_Project_Load "SimulatingPalette.odcl" T)
;;;Test OnClose Dockable_Form1 
    (defun c:SimulatingPalette_Form1_OnClose (/)
      (if (= nextDlg 2)
	(progn
	  (setq nextDlg nil)
	  (dcl_Form_Show SimulatingPalette_Form2)
	) ;_ fim de progn
      ) ;_ fim de if
      (princ)
    ) ;_ fim de defun
;;;Test OnClose Dockable_Form2
    (defun c:SimulatingPalette_Form2_OnClose (/)
      (if (= nextDlg 1)
	(progn
	  (setq nextDlg nil)
	  (dcl_Form_Show SimulatingPalette_Form1)
	) ;_ fim de progn
      ) ;_ fim de if
      (princ)
    ) ;_ fim de defun
;;; ----------------------------------------------------------------------------
;;;Acoes de Teste
;;;Dockable_Form1
    (defun c:SimulatingPalette_Form1_Label1_OnClicked (/)
      (dcl_Form_Close SimulatingPalette_Form1)
      (setq nextDlg 2)
    ) ;_ fim de defun
;;;Dockable_Form2
    (defun c:Project-2-Dockable_Form2_Label1_OnClicked (/)
      (dcl_Form_Close SimulatingPalette_Form2)
      (setq nextDlg 1)
    ) ;_ fim de defun
;;; ----------------------------------------------------------------------------
;;;Inicializa o primerio Quadro
;;;  (defun c:SimulatingPalette_Form1_OnInitialize	(/)
;;;Pega Largura e Altura da Tela
;;;    (setq JoyScreenSize (dcl_GetScreenSize))
;;;Ajusta altura da Faixa de Controle
;;;    (dcl_Form_Resize SimulatingPalette_Form1 
;;;		     20
;;;		     800
;;;    ) ;_ fim de dcl_Control_SetPos
;;;  ) ;_ fim de defun
;;; ----------------------------------------------------------------------------
;;;Joga o quadro expandido na tela
    (dcl_Form_Show SimulatingPalette_Form2)
    (princ)
  ) ;_ fim de defun
;;; ----------------------------------------------------------------------------
;|«Visual LISP© Format Options»
(72 2 40 2 T "fim de " 60 16 0 0 2 T T nil T)
;*** DO NOT add text below the comment! ***|;
