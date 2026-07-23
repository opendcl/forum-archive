(defun c:test (/ nextDlg)
;;;Carrega o projeto
  (dcl_Project_Load "Project-2-Dockable" T)
;;; ----------------------------------------------------------------------------
;;;Dockable_Form1
  (defun c:Project-2-Dockable_Form1_Label1_OnClicked (/)
    (dcl_Form_Close Project-2-Dockable_Form1)
    (setq nextDlg 2)
  ) ;_ fim de defun
;;;Dockable_Form2
  (defun c:Project-2-Dockable_Form2_Label1_OnClicked (/)
    (dcl_Form_Close Project-2-Dockable_Form2)
    (setq nextDlg 1)
  ) ;_ fim de defun
;;; ----------------------------------------------------------------------------
  (setq nextDlg 1)
  (while (/= nextDlg nil)
    (cond
      ((= nextDlg 1)
       (setq nextDlg nil)
       (dcl_Form_Show Project-2-Dockable_Form1)
      )
      ((= nextDlg 2)
       (setq nextDlg nil)
       (dcl_Form_Show Project-2-Dockable_Form2)
      )
    ) ;_ fim de cond
  ) ;_ fim de while
) ;_ fim de defun

