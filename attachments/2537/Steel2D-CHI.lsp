(command "OPENDCL")

(defun c:ttt (/)
   (dcl_Project_Load "Steel2D" T)
   (dcl_Form_Show Steel2D_Form1)
   (princ)
)

(defun c:Chinese|Steel2D/Form1#OnInitialize ()
  (dcl-ListBox-AddList Steel2D/Form1/ListBox1 (list "HM" "HN" "HW" "I" "HT" "TM" "TN" "TW" "C" "L" "CHS" "RHS" "SHS"))
  (dcl-ListBox-SetCurSel Steel2D/Form1/ListBox1 0)
  (dcl-ComboBox-AddList Steel2D/Form1/ComboBox_Placement (list "Center" "Top Left" "Top Center" "Top Right" "Bottom Left" "Bottom Center" "Bottom Right"))
  (dcl-ComboBox-SetCurSel Steel2D/Form1/ComboBox_Placement 0)
  (Load_List)
  (dcl-ListBox-AddList Steel2D/Form1/ListBox2 Display_List)
  (princ)
  )

;; Get Type
(defun c:Steel2D/Form1/ListBox1#OnSelChanged (ItemIndexOrCount Value /)
  (setq Sel_Type (dcl-ListBox-GetItemText Steel2D/Form1/ListBox1 (dcl-ListBox-GetCurSel Steel2D/Form1/ListBox1)))
  (dcl-ListBox-Clear Steel2D/Form1/ListBox2)
  (Load_List)
  (dcl-ListBox-AddList Steel2D/Form1/ListBox2 Display_List)
  (princ)
  )

;; Get Size
(defun c:Steel2D/Form1/ListBox2#OnSelChanged (ItemIndexOrCount Value /)
  (setq Sel_Size (dcl-ListBox-GetItemText Steel2D/Form1/ListBox2 (dcl-ListBox-GetCurSel Steel2D/Form1/ListBox2)))
)

;; Hatch Checkbox
(defun c:Steel2D/Form1/CheckBox_Hatch#OnClicked ( nValue /)
  (if (= nValue 1)
    (dcl-Control-SetEnabled Steel2D/Form1/Hatch_Rotation T)
    (dcl-Control-SetEnabled Steel2D/Form1/Hatch_Rotation nil)
    );if
  (princ)
  )

;; Defaults Button
(defun c:Steel2D/Form1/Button_Defaults#OnClicked (/)
  (alert "Coming soon to a screen near you!")
  (princ)
  )

;; Ok Button
(defun c:Steel2D/Form1/Button_Ok#OnClicked (/)
  (dcl_Form_Close Steel2D_Form1)
  
  (princ)
  )

;; Cancel Button
(defun c:Steel2D/Form1/Button_Cancel#OnClicked (/)
  (dcl_Form_Close Steel2D_Form1)
  (princ)
  )

;; Load SDF Data
(defun Load_Data (/)
  (if (= Sel_Type "HM")
    (setq SDF_File (open (findfile "CHI_HM.SDF") "r"))
    );if
  (if (= Sel_Type "HN")
  (setq SDF_File (open (findfile "CHI_HN.SDF") "r"))
  );if
  (if (= Sel_Type "HW")
    (setq SDF_File (open (findfile "CHI_HW.SDF") "r"))
    );if
  (if (= Sel_Type "I")
    (setq SDF_File (open (findfile "CHI_I.SDF") "r"))
    );if
  (if (= Sel_Type "HT")
    (setq SDF_File (open (findfile "CHI_HT.SDF") "r"))
    );if
    (if (= Sel_Type "TM")
    (setq SDF_File (open (findfile "CHI_TM.SDF") "r"))
    );if
    (if (= Sel_Type "TN")
    (setq SDF_File (open (findfile "CHI_TN.SDF") "r"))
    );if
    (if (= Sel_Type "TW")
    (setq SDF_File (open (findfile "CHI_TW.SDF") "r"))
    );if
    (if (= Sel_Type "C")
    (setq SDF_File (open (findfile "CHI_C.SDF") "r"))
    );if
    (if (= Sel_Type "L")
    (setq SDF_File (open (findfile "CHI_L.SDF") "r"))
    );if
    (if (= Sel_Type "CHS")
    (setq SDF_File (open (findfile "CHI_CHS.SDF") "r"))
    );if
    (if (= Sel_Type "RHS")
    (setq SDF_File (open (findfile "CHI_RHS.SDF") "r"))
    );if
    (if (= Sel_Type "SHS")
    (setq SDF_File (open (findfile "CHI_SHS.SDF") "r"))
    );if
  );defun

;; Read SDF File and display in ListBox1
(defun Load_List (/ A AA)
  (setq A "")
  (Load_Data)
  (while (/= A NIL)
    (setq A (read-line SDF_File))
    (if (/= A NIL)
      (progn
        (setq A  (nth 0 (read A))
	      AA (append AA (list A))
	      );setq
	);progn
      );if
    );while
  (setq Display_List AA)
  (close SDF_File)
  (mapcar 'add_list Display_List)
  (end_list)
)

