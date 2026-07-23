;;; --------------------------------------------------------------------------------------------------------------------
(defun c:Htm (/ OldCmdecho)
;;;Carrega as funcoes de VisualLisp
  (vl-load-com)
  (setq OldCmdecho (getvar "cmdecho"))
  (setvar "cmdecho" 0)
;;;Load OpenDCL
  (command "_.opendcl")
  (setvar "cmdecho" OldCmdecho)
;;; --------------------------------------------------------------------------------------------------------------------
;;;<<OpenDCL Event Handlers>>
;;;  
;;;Show MyHtm_BorderTest
  (defun c:MyHtm_Form1_TextButton1_OnClicked (/)
    (dcl_Form_Show MyHtm_BorderTest)
  ) ;_ end of defun
;;;Close form Form1
  (defun c:MyHtm_Form1_Close_OnClicked (/)
    (dcl_Form_Close MyHtm_Form1)
  ) ;_ end of defun
;;;Close form MyHtm_BorderTest
  (defun c:MyHtm_BorderTest_Fechar_OnClicked (/)
    (dcl_Form_Close MyHtm_BorderTest)
  ) ;_ end of defun
;;;
;;; --------------------------------------------------------------------------------------------------------------------
;;;Load Project
  (dcl_Project_Load "MyHtm.odcl" T) ;_ just for developing
;;; --------------------------------------------------------------------------------------------------------------------
;;;Initialization functions
  (defun c:MyHtm_BorderTest_OnInitialize (/)
;;;Centraliza a forma
    (dcl_Form_Center MyHtm_BorderTest)
    (dcl_Html_Navigate MyHtm_BorderTest_Html1 "http://www.opendcl.com")
  ) ;_ fim de defun
;;; --------------------------------------------------------------------------------------------------------------------
;;;Show form
;;;  (dcl_Form_Show MyHtm_BorderTest)
  (dcl_Form_Show MyHtm_Form1)
;;;  (princ)
) ;_ fim de defun


