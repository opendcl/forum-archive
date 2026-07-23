;;;Descarrega o projeto
(defun c:JClean (/) (Dcl_Project_UnLoad "DuctilCAD"))
;;; -------------------------------------------------------------------------------------------------------------------
;;;Funcao principal
(defun c:test (/ OldCmedecho)
;;;Carrega as funcoes de VisualLisp
  (vl-load-com)
  (setq OldCmedecho (getvar "cmdecho"))
  (setvar "cmdecho" 0)
;;;Load OpenDCL
  (command "_.opendcl")
  (setvar "cmdecho" OldCmedecho)
;;; -------------------------------------------------------------------------------------------------------------------
  (defun JoyExpandorCollapse
         (JoyWidth JoyPictureHelp JoyPictureSeta JoyToolTip)
;;;redimensiona a largura do quadro
    (dcl_Form_Resize DuctilCAD_DuctilCAD_MainForm JoyWidth 498)
;;;Imagem do botao Ajuda
    (dcl_Control_SetPicture DuctilCAD_DuctilCAD_MainForm_Ajuda JoyPictureHelp)
;;;Imagem do botao seta
    (dcl_Control_SetPicture DuctilCAD_DuctilCAD_MainForm_Expand JoyPictureSeta)
;;;Tooltip do botao seta
    (dcl_Control_SetToolTipTitle DuctilCAD_DuctilCAD_MainForm_Expand JoyToolTip)
;;;Refresh Logo superior
    (dcl_PictureBox_Refresh DuctilCAD_DuctilCAD_MainForm_Logo_SaintGobain)
;;;Refresh Logo Inferior
    (dcl_PictureBox_Refresh DuctilCAD_DuctilCAD_MainForm_Logo_DuctilCAD)
  ) ;_ end of defun
;;; -------------------------------------------------------------------------------------------------------------------
;;;Load Project
  (dcl_Project_Load "DuctilCAD.odcl")
;;; -------------------------------------------------------------------------------------------------------------------
;;;Controls MainForm
;;;Close MainForm
  (defun c:DuctilCAD_DuctilCAD_MainForm_Fechar_OnClicked (/)
    (dcl_Form_Close DuctilCAD_DuctilCAD_MainForm)
  ) ;_ fim de defun
;;;
  (defun c:DuctilCAD_DuctilCAD_MainForm_Ajuda_OnClicked (/)
    (dcl_MessageBox
      "To Do: code must be added to event handler\r\nc:DuctilCAD_DuctilCAD_MainForm_Ajuda_OnClicked"
      "To do"
    ) ;_ end of dcl_MessageBox
  ) ;_ end of defun
;;; -------------------------------------------------------------------------------------------------------------------
;;;DuctilCAD_MainForm_Expand_OnClicked -> Expand or Collapse the form
  (defun c:DuctilCAD_DuctilCAD_MainForm_Expand_OnClicked (/)
    (if (= (car (dcl_Form_GetControlArea DuctilCAD_DuctilCAD_MainForm)) 490) ;_ fim de =
;;;EXPAND FORM
      (progn
        (JoyExpandorCollapse 743 130 126 "Less Options")
        (dcl_Control_SetPicture DuctilCAD_DuctilCAD_MainForm_Lateral_Dir 101)
        (setq JoyExpand T)
      ) ;_ fim de progn
;;;COLLAPSE FORM
      (progn (JoyExpandorCollapse 490 129 125 "More Options")
             (dcl_Control_SetPicture DuctilCAD_DuctilCAD_MainForm_Lateral_Dir -1)
             (setq Joyexpand NIL)
      ) ;_ end of progn
    ) ;_ end of if
;;;Centraliza o quadro
    (dcl_Form_Center DuctilCAD_DuctilCAD_MainForm)
  ) ;_ end of defun
;;; -------------------------------------------------------------------------------------------------------------------
;;;Initialize Main Form
  (defun c:DuctilCAD_DuctilCAD_MainForm_OnInitialize (/)
;;;Centraliza o quadro
    (dcl_Form_Center DuctilCAD_DuctilCAD_MainForm)
  ) ;_ end of defun
;;; -------------------------------------------------------------------------------------------------------------------
;;;Load MainForm
  (dcl_Form_Show DuctilCAD_DuctilCAD_MainForm)
  (princ)
) ;_ fim de defun
;;; -------------------------------------------------------------------------------------------------------------------






















;|«Visual LISP© Format Options»
(80 2 50 2 T "end of " 80 50 0 0 2 nil nil nil T)
;*** DO NOT add text below the comment! ***|;
