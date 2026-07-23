(defun c:cadtool_Main_TextButton1_OnClicked ( / purBlockP purDimP)
  (if (= (dcl_Control_Getvalue cadtool_Main_Chbpurbloc) 1)
    (setq purBlockP T)
  )
  (if (= (dcl_Control_Getvalue cadtool_Main_Chbpurdim) 1)
    (setq purDimP T)
  )
  ; etc.
  (dcl_Form_Close cadtool_Main)
  (if purBlockP
    (command "-purge" "B" "*" "N")
  )
  (if purDimP
    (command "-purge" "D" "*" "N")
  )
  ; etc.
)

(defun c:cadtool ()
  (princ "\nLoading... ")
  (setvar 'cmdecho 0)
  (command "OPENDCL")
  (setvar 'cmdecho 1)
  (dcl_Project_Load "cadtool" T)
  (dcl_Form_Show cadtool_Main)
  (princ)
)
