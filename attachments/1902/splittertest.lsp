(defun C:splittertest (/ Result)
  (if (dcl_Project_Load "splittertest.odcl" T)
	  (setq result (dcl_Form_Show splittertest_Form1))
  )
(princ));d

