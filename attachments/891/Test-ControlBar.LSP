;;;Descarrega o projeto
(defun c:JClean (/) (Dcl_Project_UnLoad "Test-ControlBar"))
;;;
;;; ----------------------------------------------------------------------------------------------------------------------------------
(defun c:JcBar (/ NextDlg)
  (command "_opendcl")
;;;Carrega o projeto
  (dcl_Project_Load "Test-ControlBar")
;;; ----------------------------------------------------------------------------------------------------------------------------------
;;;Controla a abertura dos quadros
  (defun JoyOpenForm (NextForm)
    (cond
      ((= NextForm "MaxForm")
       (dcl_Form_Show Test-ControlBar_MaxForm)
      )
      ((= NextForm "MinForm")
       (dcl_Form_Show Test-ControlBar_MinForm)
      )
    ) ;_ fim de cond
  ) ;_ fim de defun
;;; ----------------------------------------------------------------------------------------------------------------------------------
;;;Acao dos controles
  (defun c:Test-ControlBar_MaxForm_PictureMin_OnClicked	(/)
    (dcl_Form_Close Test-ControlBar_MaxForm)
    (JoyOpenForm "MinForm")
  ) ;_ fim de defun
;;; ----------------------------------------------------------------------------------------------------------------------------------
  (defun c:Test-ControlBar_MinForm_PictureMax_OnClicked	(/)
    (dcl_Form_Close Test-ControlBar_MinForm)
    (JoyOpenForm "MaxForm")
  ) ;_ fim de defun
;;; ----------------------------------------------------------------------------------------------------------------------------------
;;;Exibe o quadro
  (JoyOpenForm "MaxForm")
) ;_ fim de defun


