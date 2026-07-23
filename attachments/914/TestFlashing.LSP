(defun c:NewForm ()
;;;Carrega o Projeto
  (dcl_Project_Load "TestFlashing" T)
;;;Funcao de inicializacao
  (defun c:Joy_OnInitialize (/)
    (dcl_Form_Center TestFlashing_MainForm)
  ) ;_ fim de defun
  (dcl_Form_Show TestFlashing_MainForm)
) ;_ fim de defun
