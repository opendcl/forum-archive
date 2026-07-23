(defun c:Test_Form1_OnInitialize (/)
  (setq	EventLog (strcat EventLog
			 "start   "
			 "c:Test_Form1_OnInitialize"
			 "\n"
		 )
  )
  (dcl_Tree_AddParent test_Form1_TreeControl1 '(("Parent1")))
  (dcl_Grid_FillList test_Form1_Grid1 '(("Row1" "Label1")))
  (setq	EventLog (strcat EventLog
			 "end     "
			 "c:Test_Form1_OnInitialize"
			 "\n\n"
		 )
  )
  (princ)
)
(defun c:test_Form1_Grid1_OnBeginLabelEdit (Row Column /)
  (setq	EventLog (strcat EventLog
			 "start   "
			 "c:test_Form1_Grid1_OnBeginLabelEdit"
			 "\n"
		 )
  )
  (setq	EventLog (strcat EventLog
			 "end     "
			 "c:test_Form1_Grid1_OnBeginLabelEdit"
			 "\n\n"
		 )
  )
)
(defun c:test_Form1_Grid1_OnEndLabelEdit (Row Column /)
  (setq	EventLog (strcat EventLog
			 "start   "
			 "c:test_Form1_Grid1_OnEndLabelEdit"
			 "\n"
		 )
  )
  (setq	EventLog (strcat EventLog
			 "end     "
			 "c:test_Form1_Grid1_OnEndLabelEdit"
			 "\n\n"
		 )
  )
)
(defun c:test_Form1_TreeControl1_OnSelChanged (Label Key /)
  (setq	EventLog (strcat EventLog
			 "start   "
			 "c:test_Form1_TreeControl1_OnSelChanged"
			 "\n"
		 )
  )
  (setq	EventLog (strcat EventLog
			 "end     "
			 "c:test_Form1_TreeControl1_OnSelChanged"
			 "\n\n"
		 )
  )
)
(defun C:Test (/ EventLog)
  (setq EventLog "")
  (dcl_Project_Load "test.odcl" t)
  (dcl_Form_Show Test_Form1)
  (princ EventLog)
  (princ)
)