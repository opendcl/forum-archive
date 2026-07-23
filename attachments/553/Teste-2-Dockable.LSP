(defun c:test (/ nextDlg)
;;;Carrega o projeto
  (dcl_Project_Load "Project-2-Dockable" T)
;;; ----------------------------------------------------------------------------
;;;Dockable_Form1
  (defun c:Project-2-Dockable_Form1_Label1_OnClicked (/)
    (dcl_Form_Close Project-2-Dockable_Form1)
    (OpenNext 2)
  ) ;_ fim de defun
;;;Dockable_Form2
  (defun c:Project-2-Dockable_Form2_Label1_OnClicked (/)
    (dcl_Form_Close Project-2-Dockable_Form2)
    (OpenNext 1)
  ) ;_ fim de defun
;;; ----------------------------------------------------------------------------


(defun OpenNext (nextDlg / )
	(cond
  	((= nextDlg 1)
       (dcl_Form_Show Project-2-Dockable_Form1)
    )
    ((= nextDlg 2)
       (dcl_Form_Show Project-2-Dockable_Form2)
    )
  ) ;_ fim de cond

)

  
  (OpenNext 1)
  (princ)
) ;_ fim de defun

