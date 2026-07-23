;;;-----------------------------------------------------------------------
;;;									  
;;; Legend Version 1.1 				29/04/2009                
;;;									  
;;;-----------------------------------------------------------------------

;;;---------------------------------------------------------- Main ----------------------------------------------------

(defun c:legend	()
  (vl-load-com)
  (if (not runonce)
    (progn
      (command "blockicon" "")
      (setq runonce "T")
    )
  )
  (dcl_Project_Load "legend" T)
  (dcl_Form_Show Legend_Form1)
)

;;;---------------------------------------------------------- Subroutines----------------------------------------------


;;;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ Dialogue Box ++++++++++++++++++++++++++++++++++++++++++++


(defun c:Legend_Form1_TextButton1_OnClicked (/)							    ;OK Button
  (dcl_Form_Close Legend_Form1)
  (setq legend_list (dcl_Control_GetList Legend_Form1_ListBox1))
  (princ legend_list)
)

(defun c:Legend_Form1_TextButton2_OnClicked (/)							    ; Select All Button
  (setq block_count_all (dcl_BlockList_GetCount Legend_Form1_BlockList1))
  (dcl_BlockList_SetCurSel Legend_Form1_BlockList1 -1)
  (print block_count_all)
)

(defun c:Legend_Form1_TextButton3_OnClicked (/)							    ; Cancel Button
  (dcl_Form_Close Legend_Form1)
)

(defun c:Legend_Form1_ListBox1_OnSelChanged (ItemIndex Value /)
  (dcl_Control_SetSorted Legend_Form1_ListBox1 T)
)

(defun c:Legend_Form1_TextButton4_OnClicked (/)							    ; Add to list button
  (setq blocks_to_add (dcl_BlockList_GetSelectedItems Legend_Form1_BlockList1))
  (dcl_ListBox_AddList Legend_Form1_ListBox1 blocks_to_add)
)

(defun c:Legend_Form1_TextButton5_OnClicked (/)							    ; Remove from list button
  (setq blocks_to_remove (dcl_ListBox_GetCurSel Legend_Form1_ListBox1))
  (dcl_ListBox_DeleteItem Legend_Form1_ListBox1 blocks_to_remove)
)


 ;|«Visual LISP© Format Options»
(120 2 100 2 nil "end of " 100 15 0 0 0 T T nil T)
;*** DO NOT add text below the comment! ***|;
