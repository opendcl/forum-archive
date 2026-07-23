;;;							;
;;;	BlockView Control Test				;
;;;	include files:					;
;;;							;
;;;							;
;;;							;

(vl-load-com)

(if (not (vl-bb-ref 'jbBlockViewTest))
  (vl-bb-set
    'jbBlockViewTest
    (dcl_project_import
      '("YWt6A/MLAAD+cPlzBuKz6zUxaj9uuRUIP3qpFjY+Q+7u9q+1WLVMknRJb3BUcWvdr+aefLU9qFuP"
"N8YGKJ0vcbjx3tx3QJyv7aCCfgB8b4vceWFSgZCX2BmG8Sdtdw9IQ6OF5dTk1OSUlOr2KihUCFpN"
"rFAnjz6hqfcSTzHDHhC1n6dmOCg4215nNzV5kJ0m2bv52FE70nTsrWwUS1RtrHfnd9IMrlOU6wAl"
"OyeKjyGPUK5CyqyG6X2Ny7sPR9YTebHqkzCCAlPtv+0I8kIoZ4/sLGEMqCCz/FY+bGg+Xt+aa4DT"
"nS3p2YpqBLaWRN2HdqRLWKNsmhM6hUxcPSzoIOc7IvlO0LRK0mpOaW/vTC73Zhb3Sa753ypQPcNS"
"7Ux2/f+vH46+4kyI/2PCbz8zj4jxHjIVmXQsvAOgpoW3iJhmw+s41wxXzwnvqhUKLBSoNcPvJIWp"
"TdavA7loUT5RXeEo3ZnyIE4kGoq1Rx+hxkmclPBgl6m34O8oR/OKau+rKEf7h3Ts2GpwRs2hThKD"
"Sx3I6ExPiymh/Qp56NMjW+qcYhEZyr6WT91Z8mBPRL2WUN0l8pBOxLOWUt0N8rARGhdbGhUmnNiF"
"PmGvEGrUD+voTiw9MNSo3tki3LHGHmRm+3SnVPh0B7/eFSKQiacobYULot/ReEMOyNKqdyjCuX9T"
"DYQopvex0sa69OGKQ1yruCwhBmWQDRak3j/5aHNEuPSD8nhmYxvK4R1yk51bD4XGfw2sjpDmAyKp"
"ceErUZa/EOCl8nMlJI2jzZ+yTsTKaPCJoyqDUjUjGmqtcRwIBLLIoCeTRvUYVEYA+K+HNAwm2A6C"
"1p2z4PPlqm4ADj3Oi24UdtFylAgW8T8HoGdlp0i07x4sfbYpVbjqsCR3lSCiWcuWFZmizPdUqgpQ"
"tmFFMmFw4wvRg8XYrVKlqFUYRwjhoWat5ERGiLCBwSUnkT2jFMmJ8aNUuaC5Ss5Q6NSgrbypVKKk"
"M24="))))

(defun jb:ListBlocks  (/ llist)
  (vlax-for
         x  (vla-get-blocks (vla-get-ActiveDocument (vlax-get-acad-object)))
    (if (and(= (vlax-get-property x 'isxref) :vlax-false)
            (= (vlax-get-property x 'islayout) :vlax-false)
            (not(vl-string-search "|"(vla-get-name x)))
            (not(vl-string-search "*"(vla-get-name x)))
            )
      (setq llist (append llist (list (vlax-get-property x 'name))))))
  llist)

(defun c:012_00_OnInitialize ( /)
     (dcl_ListBox_AddList 012_00_ListBox 
	 (jb:ListBlocks))
)

(defun c:012_00_OnDocActivated ( /)
  (dcl_listbox_clear 012_00_ListBox)
  (dcl_BlockView_Clear 012_00_BlockView)
     (c:012_00_OnInitialize)
)

(defun c:012_00_OnEnteringNoDocState ( /)
     (dcl_Form_Close 012_00)
)


(defun c:012_00_ListBox_OnSelChanged (nSelection sSelText /)
     (dcl_BlockView_DisplayBlock 012_00_BlockView sSelText 0 1.0)
)




;;;							;
;;;	Command Interface				;
;;;							;
;;;	assumes OpenDCL.arx is loaded			;
;;;							;
(defun c:test	 (/)
  (if (not (member "012" (dcl_GetProjects)))
    (dcl_Project_load "012"))
  (if dcl_HideErrorMsgBox
    (progn
      (if (not (dcl_Form_IsActive 012_00))
	(dcl_Form_Show 012_00)
	 )
      
      )
    (alert "The OpenDCL arx module did not load!")
    )
  (princ)
  (princ))


;;;							;
;;;		Floating Form				;
;;;		Document Opened				;
;;;							;

(defun jb:012_IsFloating  (/)
  (if dcl_HideErrorMsgBox
    (progn (if (dcl_Form_IsActive 012_00)
	     (c:012_00_OnDocActivated)))
    (alert "The OpenDCL arx module did not load!"))
  (princ)
  (princ))


(jb:012_IsFloating)
