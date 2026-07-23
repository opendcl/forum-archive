(defun c:ef (/ result sets AFC AWG volts clength)
  (vl-bt)
  (command "_OPENDCL")
  (if (dcl_Project_Load "t:\faultdrop" T)
    (progn
      (setq Result (dcl_Form_Show faultdrop_faultbox))
      (print result)
      (print "AFC")
      (print AFC)
      (print "volts")
      (print volts)
      (print "clength")
      (print clength)
      (print "sets")
      (print sets)
      (print "AWG")
      (print AWG)
    )
  )
  (princ)
)


  (defun c:faultdrop_FaultBox_OnInitialize (/)
    (dcl_Control_SetText faultdrop_FaultBox_ebAFC "060")
    (dcl_Control_SetText faultdrop_FaultBox_ebVoltage "808")
    (dcl_Control_SetText faultdrop_FaultBox_ebLength "222")
    (set_sets 2)
    (set_AWGs "WS0000")
  )

  (defun c:faultdrop_FaultBox_ebAFC_OnEditChanged (NewValue /)
    (setq AFC NewValue)
  )

  (defun c:faultdrop_FaultBox_ebVoltage_OnEditChanged (NewValue /)
    (setq volts NewValue)
  )

  (defun c:faultdrop_FaultBox_ebLength_OnEditChanged (NewValue /)
    (setq clength NewValue)
  )

  (defun c:faultdrop_FaultBox_ob1set_OnClicked (Value /)
    (setq sets 1)
  )

  (defun c:faultdrop_FaultBox_ob2SETS_OnClicked (Value /)
    (setq sets 2)
  )

  (defun c:faultdrop_FaultBox_ob3SETS_OnClicked (Value /)
    (setq sets 3)
  )

  (defun c:faultdrop_FaultBox_ob4SETS_OnClicked (Value /)
    (setq sets 4)
  )

  (defun c:faultdrop_FaultBox_ob5SETS_OnClicked (Value /)
    (setq sets 5)
  )

  (defun c:faultdrop_FaultBox_ob6SETS_OnClicked (Value /)
    (setq sets 6)
  )

  (defun c:faultdrop_FaultBox_ob7SETS_OnClicked (Value /)
    (setq sets 7)
  )

  (defun c:faultdrop_FaultBox_obWS14_OnClicked (Value /)
    (setq AWG "WS14")
  )

  (defun c:faultdrop_FaultBox_obWS12_OnClicked (Value /)
    (setq AWG "WS12")
  )

  (defun c:faultdrop_FaultBox_obWS10_OnClicked (Value /)
    (setq AWG "WS10")
  )

  (defun c:faultdrop_FaultBox_obWS8_OnClicked (Value /)
    (setq AWG "WS8")
  )

  (defun c:faultdrop_FaultBox_obWS6_OnClicked (Value /)
    (setq AWG "WS6")
  )

  (defun c:faultdrop_FaultBox_obWS4_OnClicked (Value /)
    (setq AWG "WS4")
  )

  (defun c:faultdrop_FaultBox_obWS3_OnClicked (Value /)
    (setq AWG "WS3")
  )

  (defun c:faultdrop_FaultBox_obWS2_OnClicked (Value /)
    (setq AWG "WS2")
  )

  (defun c:faultdrop_FaultBox_obWS1_OnClicked (Value /)
    (setq AWG "WS1")
  )

  (defun c:faultdrop_FaultBox_obWS0_OnClicked (Value /)
    (setq AWG "WSo")
  )

  (defun c:faultdrop_FaultBox_obWS00_OnClicked (Value /)
    (setq AWG "WS00")
  )

  (defun c:faultdrop_FaultBox_obWS000_OnClicked (Value /)
    (setq AWG "WS000")
  )

  (defun c:faultdrop_FaultBox_obWS0000_OnClicked (Value /)
    (setq AWG "WS0000")
  )

  (defun c:faultdrop_FaultBox_obWS250_OnClicked (Value /)
    (setq AWG "WS250")
  )

  (defun c:faultdrop_FaultBox_obWS300_OnClicked (Value /)
    (setq AWG "WS300")
  )

  (defun c:faultdrop_FaultBox_obWS350_OnClicked (Value /)
    (setq AWG "WS350")
  )

  (defun c:faultdrop_FaultBox_obWS400_OnClicked (Value /)
    (setq AWG "WS400")
  )

  (defun c:faultdrop_FaultBox_obWS500_OnClicked (Value /)
    (setq AWG "WS500")
  )

  (defun c:faultdrop_FaultBox_obWS600_OnClicked (Value /)
    (setq AWG "WS600")
  )

  (defun c:faultdrop_FaultBox_obWS750_OnClicked (Value /)
    (setq AWG "WS750")
  )

  (defun c:faultdrop_FaultBox_obWS1000_OnClicked (Value /)
    (setq AWG "WS1000")
  )



  (defun c:faultdrop_faultbox_CloseButton_OnClicked (/)
    (dcl_Form_Close faultdrop_FaultBox 1)
  )

  (defun c:faultdrop_FaultBox_btnOK_OnClicked (/)
    (dcl_Form_Close faultdrop_FaultBox 1001)
  )

  (defun c:faultdrop_FaultBox_btnCancel_OnClicked (/)
    (dcl_Form_Close faultdrop_FaultBox 2)
  )

  (defun set_sets (sets /)
    (cond
      ((= sets 1) (dcl_Control_SetValue faultdrop_FaultBox_ob1set 1))
      ((= sets 2) (dcl_Control_SetValue faultdrop_FaultBox_ob2sets 1))
      ((= sets 3) (dcl_Control_SetValue faultdrop_FaultBox_ob3sets 1))
      ((= sets 4) (dcl_Control_SetValue faultdrop_FaultBox_ob4sets 1))
      ((= sets 5) (dcl_Control_SetValue faultdrop_FaultBox_ob5sets 1))
      ((= sets 6) (dcl_Control_SetValue faultdrop_FaultBox_ob6sets 1))
      ((= sets 7) (dcl_Control_SetValue faultdrop_FaultBox_ob7sets 1))
    )
  )

  (defun set_AWGs (AWG /)
    (cond
      ((= AWG "WS14") (dcl_Control_SetValue faultdrop_FaultBox_obWS14 1))
      ((= AWG "WS12") (dcl_Control_SetValue faultdrop_FaultBox_obWS12 1))
      ((= AWG "WS10") (dcl_Control_SetValue faultdrop_FaultBox_obWS10 1))
      ((= AWG "WS8") (dcl_Control_SetValue faultdrop_FaultBox_obWS8 1))
      ((= AWG "WS6") (dcl_Control_SetValue faultdrop_FaultBox_obWS6 1))
      ((= AWG "WS4") (dcl_Control_SetValue faultdrop_FaultBox_obWS4 1))
      ((= AWG "WS3") (dcl_Control_SetValue faultdrop_FaultBox_obWS3 1))
      ((= AWG "WS2") (dcl_Control_SetValue faultdrop_FaultBox_obWS2 1))
      ((= AWG "WS1") (dcl_Control_SetValue faultdrop_FaultBox_obWS1 1))
      ((= AWG "WS0") (dcl_Control_SetValue faultdrop_FaultBox_obWS0 1))
      ((= AWG "WS00") (dcl_Control_SetValue faultdrop_FaultBox_obWS00 1))
      ((= AWG "WS000") (dcl_Control_SetValue faultdrop_FaultBox_obWS000 1))
      ((= AWG "WS0000") (dcl_Control_SetValue faultdrop_FaultBox_obWS0000 1))
      ((= AWG "WS250") (dcl_Control_SetValue faultdrop_FaultBox_obWS250 1))
      ((= AWG "WS300") (dcl_Control_SetValue faultdrop_FaultBox_obWS300 1))
      ((= AWG "WS350") (dcl_Control_SetValue faultdrop_FaultBox_obWS350 1))
      ((= AWG "WS400") (dcl_Control_SetValue faultdrop_FaultBox_obWS400 1))
      ((= AWG "WS500") (dcl_Control_SetValue faultdrop_FaultBox_obWS500 1))
      ((= AWG "WS600") (dcl_Control_SetValue faultdrop_FaultBox_obWS600 1))
      ((= AWG "WS750") (dcl_Control_SetValue faultdrop_FaultBox_obWS750 1))
      ((= AWG "WS1000") (dcl_Control_SetValue faultdrop_FaultBox_obWS1000 1))
    )
    (foreach Control sets_list
      (dcl_Control_SetValue Control 0)
    )
    (if (/= AWG nil)
      (progn
        (setq AWG_index (list "WS14"   "WS12"   "WS10"   "WS8"    "WS6"    "WS4"
                              "WS3"    "WS2"    "WS1"    "WS0"    "WS00"   "WS000"
                              "WS0000" "WS250"  "WS300"  "WS350"  "WS400"  "WS500"
                              "WS600"  "WS750"  "WS1000"
                        )
        )
        (setq counter 0)
        (while (/= AWG (nth AWG_index counter))
          (setq counter (1+ counter))
        )
      )
      (dcl_Control_SetValue (nth AWGs_list counter) 1)
    )
  )
