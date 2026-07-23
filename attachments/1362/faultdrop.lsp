(defun c:efault (/ result sets AFC AWG volts clength)
  (command "_OPENDCL")
  (if (dcl_Project_Load "t:\faultdrop")
    (progn
      (setq Result (dcl_Form_Show faultdrop_faultbox))
      (if (= Result 1)
        (print "Done")
;        (DoSomething)
      )
    )
  )

  (defun c:faultdrop_faultbox_OnInitialize (/)
    (set_sets nil)
    (set_AWGs nil)
  )

  (defun c:AFC-data_OnEditChanged (NewValue /)
    (setq AFC NewValue)
  )

  (defun c:Voltage-data_OnEditChanged (NewValue /)
    (setq volts NewValue)
  )

  (defun c:Length-data_OnEditChanged (NewValue /)
    (setq clength NewValue)
  )

  (defun c:faultdrop_FaultBox_1SET_OnClicked (Value /)
    (setq sets Value)
  )

  (defun c:faultdrop_FaultBox_2SETS_OnClicked (Value /)
    (setq sets Value)
  )

  (defun c:faultdrop_FaultBox_3SETS_OnClicked (Value /)
    (setq sets Value)
  )

  (defun c:faultdrop_FaultBox_4SETS_OnClicked (Value /)
    (setq sets Value)
  )

  (defun c:faultdrop_FaultBox_5SETS_OnClicked (Value /)
    (setq sets Value)
  )

  (defun c:faultdrop_FaultBox_6SETS_OnClicked (Value /)
    (setq sets Value)
  )

  (defun c:faultdrop_FaultBox_7SETS_OnClicked (Value /)
    (setq sets Value)
  )

  (defun c:faultdrop_FaultBox_WS14_OnClicked (Value /)
    (setq AWG Value)
  )

  (defun c:faultdrop_FaultBox_WS12_OnClicked (Value /)
    (setq AWG Value)
  )

  (defun c:faultdrop_FaultBox_WS10_OnClicked (Value /)
    (setq AWG Value)
  )

  (defun c:faultdrop_FaultBox_WS8_OnClicked (Value /)
    (setq AWG Value)
  )

  (defun c:faultdrop_FaultBox_WS6_OnClicked (Value /)
    (setq AWG Value)
  )

  (defun c:faultdrop_FaultBox_WS4_OnClicked (Value /)
    (setq AWG Value)
  )

  (defun c:faultdrop_FaultBox_WS3_OnClicked (Value /)
    (setq AWG Value)
  )

  (defun c:faultdrop_FaultBox_WS2_OnClicked (Value /)
    (setq AWG Value)
  )

  (defun c:faultdrop_FaultBox_WS1_OnClicked (Value /)
    (setq AWG Value)
  )

  (defun c:faultdrop_FaultBox_WS0_OnClicked (Value /)
    (setq AWG Value)
  )

  (defun c:faultdrop_FaultBox_WS00_OnClicked (Value /)
    (setq AWG Value)
  )

  (defun c:faultdrop_FaultBox_WS000_OnClicked (Value /)
    (setq AWG Value)
  )

  (defun c:faultdrop_FaultBox_WS0000_OnClicked (Value /)
    (setq AWG Value)
  )

  (defun c:faultdrop_FaultBox_WS250_OnClicked (Value /)
    (setq AWG Value)
  )

  (defun c:faultdrop_FaultBox_WS300_OnClicked (Value /)
    (setq AWG Value)
  )

  (defun c:faultdrop_FaultBox_WS350_OnClicked (Value /)
    (setq AWG Value)
  )

  (defun c:faultdrop_FaultBox_WS400_OnClicked (Value /)
    (setq AWG Value)
  )

  (defun c:faultdrop_FaultBox_WS500_OnClicked (Value /)
    (setq AWG Value)
  )

  (defun c:faultdrop_FaultBox_WS600_OnClicked (Value /)
    (setq AWG Value)
  )

  (defun c:faultdrop_FaultBox_WS750_OnClicked (Value /)
    (setq AWG Value)
  )

  (defun c:faultdrop_FaultBox_WS1000_OnClicked (Value /)
    (setq AWG Value)
  )



  (defun c:faultdrop_faultbox_CloseButton_OnClicked (/)
    (dcl_Form_Close faultdrop_FaultBox)
  )

  (defun c:faultdrop_FaultBox_btnOK_OnClicked (/)
    (dcl_Form_Close faultdrop_FaultBox)
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

  (defun c:faultdrop_FaultBox_btnCancel_OnClicked (/)
    (dcl_Form_Close faultdrop_FaultBox)
  )

  (defun set_sets (sets / Control sets_list)
    (setq sets_list (LIST faultdrop_FaultBox_1SET
                          faultdrop_FaultBox_2SETS
                          faultdrop_FaultBox_3SETS
                          faultdrop_FaultBox_4SETS
                          faultdrop_FaultBox_5SETS
                          faultdrop_FaultBox_6SETS
                          faultdrop_FaultBox_7SETS
                    )
    )
    (foreach Control sets_list
      (dcl_Control_SetValue Control 0)
    )
    (if (/= sets nil)
      (dcl_Control_SetValue (nth sets_list (1- sets)) 1)
    )
  )

  (defun set_AWGs (AWG / Control AWG_index counter)
    (setq AWGs_list (list faultdrop_FaultBox_WS14
                          faultdrop_FaultBox_WS12
                          faultdrop_FaultBox_WS10
                          faultdrop_FaultBox_WS8
                          faultdrop_FaultBox_WS6
                          faultdrop_FaultBox_WS4
                          faultdrop_FaultBox_WS3
                          faultdrop_FaultBox_WS2
                          faultdrop_FaultBox_WS1
                          faultdrop_FaultBox_WS0
                          faultdrop_FaultBox_WS00
                          faultdrop_FaultBox_WS000
                          faultdrop_FaultBox_WS0000
                          faultdrop_FaultBox_WS250
                          faultdrop_FaultBox_WS300
                          faultdrop_FaultBox_WS350
                          faultdrop_FaultBox_WS400
                          faultdrop_FaultBox_WS500
                          faultdrop_FaultBox_WS600
                          faultdrop_FaultBox_WS750
                          faultdrop_FaultBox_WS1000
                    )
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

  (print "b")
)
