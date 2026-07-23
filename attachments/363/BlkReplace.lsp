(Defun TBList (TABLE / TDATA LST)
  (while (setq TDATA (tblnext TABLE (not TDATA)))
	(setq LST (append LST (list (cdr (assoc 2 TDATA)))))
  )
);


(Defun c:BlkReplace (/)
   (command "OPENDCL")
   (dcl_Project_Load "BlkReplace" T)  
   (setq ID (dcl_Form_Show BlkReplace_BlkReplace)) 
   (princ);
);

(Defun c:BlkReplace_BlkReplace_OnInitialize ( /)
        (setq BLKS (TBLIST "BLOCK")
	      OLD (car BLKS)
	      NEW (nth 1 BLKS)
	      OLDLIST (vl-remove NEW BLKS)
	      NEWLIST (vl-remove OLD BLKS)
        );
  	(dcl_ComboBox_AddList BlkReplace_BlkReplace_Old_ComboBox OLDLIST)  	
  	(dcl_ComboBox_AddList BlkReplace_BlkReplace_New_ComboBox NEWLIST)
  	(dcl_Control_SetText BlkReplace_BlkReplace_New_ComboBox NEW);
  	(dcl_Control_SetText BlkReplace_BlkReplace_Old_ComboBox OLD);
);

(Defun c:BlkReplace_BlkReplace_Ok_Button_OnClicked ( /)
     (dcl_Form_Close BlkReplace_BlkReplace)
     (setq OLD (dcl_Control_GetText BlkReplace_BlkReplace_Old_ComboBox)
	   NEW (dcl_Control_GetText BlkReplace_BlkReplace_New_ComboBox));
     (prompt "Ok Pressed")
);

(Defun c:BlkReplace_BlkReplace_Cancel_Button_OnClicked ( /)
     (dcl_Form_Close BlkReplace_BlkReplace)
);

