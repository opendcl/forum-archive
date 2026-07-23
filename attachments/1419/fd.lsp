(defun c:fd ( /
            )

  (defun *error* (msg)
    (while (< 0 (getvar "cmdactive"))
      (command)
    )
    ;; do error stuff
    (if (dcl_form_isactive faultdrop_FaultBox)
      (dcl_form_close faultdrop_FaultBox)
    )
    (princ
      (strcat "\nApplication Error: " (itoa (getvar "errno")) " :- " msg)
    )
    (princ)
  )

  (defun check ()
    (if (and (/= AFC$ "")
             (/= voltage$ "")
             (/= conduit_length$ "")
             (/= PFactor$ "")
             (/= conductor_temperature$ "")
             (/= load_current$ "")
             (/= conductor_type$ "")
             (/= phase$ "")
             (/= conduit_type$ "")
             (/= sets$ "")
             (/= AWG$ "")
        )
      (dcl_Control_SetEnabled faultdrop_FaultBox_btnOK T)
    )
    (if (> (atof PFactor$) 1.0)
      (progn
        (setq PFactor$ "")
        (dcl_Control_SetText faultdrop_FaultBox_ebPFactor "")
        (dcl_Control_SetBackColor faultdrop_FaultBox_ebPFactor 50)
        (dcl_Control_SetFocus faultdrop_FaultBox_ebPFactor)
      )
      (dcl_Control_SetBackColor faultdrop_FaultBox_ebPFactor -6)
    )
  )

  (defun c:faultdrop_FaultBox_OnInitialize (/)

    (dcl_Control_SetText faultdrop_FaultBox_ebAFC AFC$)
    (dcl_Control_SetText faultdrop_FaultBox_ebVoltage voltage$)
    (dcl_Control_SetText faultdrop_FaultBox_ebLength conduit_length$)
    (dcl_Control_SetText faultdrop_FaultBox_ebPFactor PFactor$)
    (dcl_Control_SetText faultdrop_FaultBox_ebCondTemp conductor_temperature$)
    (dcl_Control_SetText faultdrop_FaultBox_ebLoad load_current$)
    (if (= conductor_type$ "AL")
      (dcl_Control_SetValue faultdrop_FaultBox_obAluminum 1)
      (dcl_Control_SetValue faultdrop_FaultBox_obCopper 1)
    )
    (if (= conduit_type$ "cable")
      (dcl_Control_SetValue faultdrop_FaultBox_obCable 1)
      (if (= conduit_type$ "steel")
        (dcl_Control_SetValue faultdrop_FaultBox_obSteel 1)
        (dcl_Control_SetValue faultdrop_FaultBox_obPVC 1)
      )
    )
    (if (= phase$ "single")
      (dcl_Control_SetValue faultdrop_FaultBox_obSingle 1)
      (dcl_Control_SetValue faultdrop_FaultBox_obThree 1)
    )
    (cond
      ((= sets$ "7") (dcl_Control_SetValue faultdrop_FaultBox_ob7sets 1))
      ((= sets$ "6") (dcl_Control_SetValue faultdrop_FaultBox_ob6sets 1))
      ((= sets$ "5") (dcl_Control_SetValue faultdrop_FaultBox_ob5sets 1))
      ((= sets$ "4") (dcl_Control_SetValue faultdrop_FaultBox_ob4sets 1))
      ((= sets$ "3") (dcl_Control_SetValue faultdrop_FaultBox_ob3sets 1))
      ((= sets$ "2") (dcl_Control_SetValue faultdrop_FaultBox_ob2sets 1))
      ((= sets$ "1") (dcl_Control_SetValue faultdrop_FaultBox_ob1set 1))
    )
    (cond
      ((= AWG$ "WS1000") (dcl_Control_SetValue faultdrop_FaultBox_obWS1000 1))
      ((= AWG$ "WS750")  (dcl_Control_SetValue faultdrop_FaultBox_obWS750 1))
      ((= AWG$ "WS600")  (dcl_Control_SetValue faultdrop_FaultBox_obWS600 1))
      ((= AWG$ "WS500")  (dcl_Control_SetValue faultdrop_FaultBox_obWS500 1))
      ((= AWG$ "WS400")  (dcl_Control_SetValue faultdrop_FaultBox_obWS400 1))
      ((= AWG$ "WS350")  (dcl_Control_SetValue faultdrop_FaultBox_obWS350 1))
      ((= AWG$ "WS300")  (dcl_Control_SetValue faultdrop_FaultBox_obWS300 1))
      ((= AWG$ "WS250")  (dcl_Control_SetValue faultdrop_FaultBox_obWS250 1))
      ((= AWG$ "WS0000") (dcl_Control_SetValue faultdrop_FaultBox_obWS0000 1))
      ((= AWG$ "WS000")  (dcl_Control_SetValue faultdrop_FaultBox_obWS000 1))
      ((= AWG$ "WS00")   (dcl_Control_SetValue faultdrop_FaultBox_obWS00 1))
      ((= AWG$ "WS0")    (dcl_Control_SetValue faultdrop_FaultBox_obWS0 1))
      ((= AWG$ "WS1")    (dcl_Control_SetValue faultdrop_FaultBox_obWS1 1))
      ((= AWG$ "WS2")    (dcl_Control_SetValue faultdrop_FaultBox_obWS2 1))
      ((= AWG$ "WS3")    (dcl_Control_SetValue faultdrop_FaultBox_obWS3 1))
      ((= AWG$ "WS4")    (dcl_Control_SetValue faultdrop_FaultBox_obWS4 1))
      ((= AWG$ "WS6")    (dcl_Control_SetValue faultdrop_FaultBox_obWS6 1))
      ((= AWG$ "WS8")    (dcl_Control_SetValue faultdrop_FaultBox_obWS8 1))
      ((= AWG$ "WS10")   (dcl_Control_SetValue faultdrop_FaultBox_obWS10 1))
      ((= AWG$ "WS12")   (dcl_Control_SetValue faultdrop_FaultBox_obWS12 1))
      ((= AWG$ "WS14")   (dcl_Control_SetValue faultdrop_FaultBox_obWS14 1))
    )
  )

  (defun c:faultdrop_FaultBox_ebAFC_OnKillFocus (/)
    (set_AFC (dcl_Control_GetText faultdrop_FaultBox_ebAFC))
  )

  (defun set_AFC ( / )
    (setq AFC$ value)
    (check)
  )

  (defun c:faultdrop_FaultBox_ebVoltage_OnKillFocus (/)
    (set_Voltage (dcl_Control_GetText faultdrop_FaultBox_ebVoltage))
  )

  (defun set_Voltage (value / )
    (setq voltage$ value)
    (check)
  )

  (defun c:faultdrop_FaultBox_ebLength_OnKillFocus (/)
    (set_length (dcl_Control_GetText faultdrop_FaultBox_ebLength))
  )

  (defun set_Length (value / )
    (setq conduit_length$ value)
    (check)
  )

  (defun c:faultdrop_FaultBox_ebPFactor_OnKillFocus (/)
    (set_PFactor (dcl_Control_GetText faultdrop_FaultBox_ebPFactor))
  )

  (defun set_PFactor (value / )
    (setq PFactor$ value)
    (check)
  )

  (defun c:faultdrop_FaultBox_ebCondTemp_OnKillFocus (/)
    (set_CondTemp (dcl_Control_GetText faultdrop_FaultBox_ebCondTemp))
  )

  (defun set_CondTemp (value / )
    (setq conductor_temperature$ value)
    (check)
  )

  (defun c:faultdrop_FaultBox_ebLoad_OnKillFocus (/)
    (set_Load (dcl_Control_GetText faultdrop_FaultBox_ebLoad))
  )

  (defun set_Load (value / )
    (setq load_current$ value)
    (check)
  )

  (defun c:faultdrop_FaultBox_obCopper_OnClicked (Value /)
    (set_conductor_type "CU")
  )

  (defun c:faultdrop_FaultBox_obAluminum_OnClicked (Value /)
    (set_conductor_type "AL")
  )

  (defun set_conductor_type (value / )
    (setq conductor_type$ value)
    (check)
  )

  (defun c:faultdrop_FaultBox_obSingle_OnClicked (Value /)
    (set_phase "single")
  )

  (defun c:faultdrop_FaultBox_obThree_OnClicked (Value /)
    (set_phase "three")
  )

  (defun set_phase (value / )
    (setq phase$ value)
    (check)
  )

  (defun c:faultdrop_FaultBox_obSteel_OnClicked (Value /)
    (set_conduit_type "steel")
  )

  (defun c:faultdrop_FaultBox_obPVC_OnClicked (Value /)
    (set_conduit_type "PVC")
  )

  (defun c:faultdrop_FaultBox_obCable_OnClicked (Value /)
    (set_conduit_type "cable")
  )

  (defun set_conduit_type (value / )
    (setq conduit_type$ value)
    (check)
  )

  (defun c:faultdrop_FaultBox_ob1set_OnClicked (Value /)
    (set_sets "1")
  )

  (defun c:faultdrop_FaultBox_ob2sets_OnClicked (Value /)
    (set_sets "2")
  )

  (defun c:faultdrop_FaultBox_ob3sets_OnClicked (Value /)
    (set_sets "3")
  )

  (defun c:faultdrop_FaultBox_ob4sets_OnClicked (Value /)
    (set_sets "4")
  )

  (defun c:faultdrop_FaultBox_ob5sets_OnClicked (Value /)
    (set_sets "5")
  )

  (defun c:faultdrop_FaultBox_ob6sets_OnClicked (Value /)
    (set_sets "6")
  )

  (defun c:faultdrop_FaultBox_ob7sets_OnClicked (Value /)
    (set_sets "7")
  )

  (defun set_sets (value / )
    (setq sets$ value)
    (check)
  )

  (defun c:faultdrop_FaultBox_obWS14_OnClicked (Value /)
    (set_AWG "WS14")
  )

  (defun c:faultdrop_FaultBox_obWS12_OnClicked (Value /)
    (set_AWG "WS12")
  )

  (defun c:faultdrop_FaultBox_obWS10_OnClicked (Value /)
    (set_AWG "WS10")
  )

  (defun c:faultdrop_FaultBox_obWS8_OnClicked (Value /)
    (set_AWG "WS8")
  )

  (defun c:faultdrop_FaultBox_obWS6_OnClicked (Value /)
    (set_AWG "WS6")
  )

  (defun c:faultdrop_FaultBox_obWS4_OnClicked (Value /)
    (set_AWG "WS4")
  )

  (defun c:faultdrop_FaultBox_obWS3_OnClicked (Value /)
    (set_AWG "WS3")
  )

  (defun c:faultdrop_FaultBox_obWS2_OnClicked (Value /)
    (set_AWG "WS2")
  )

  (defun c:faultdrop_FaultBox_obWS1_OnClicked (Value /)
    (set_AWG "WS1")
  )

  (defun c:faultdrop_FaultBox_obWS0_OnClicked (Value /)
    (set_AWG "WS0")
  )

  (defun c:faultdrop_FaultBox_obWS00_OnClicked (Value /)
    (set_AWG "WS00")
  )

  (defun c:faultdrop_FaultBox_obWS000_OnClicked (Value /)
    (set_AWG "WS000")
  )

  (defun c:faultdrop_FaultBox_obWS0000_OnClicked (Value /)
    (set_AWG "WS0000")
  )

  (defun c:faultdrop_FaultBox_obWS250_OnClicked (Value /)
    (set_AWG "WS250")
  )

  (defun c:faultdrop_FaultBox_obWS300_OnClicked (Value /)
    (set_AWG "WS300")
  )

  (defun c:faultdrop_FaultBox_obWS350_OnClicked (Value /)
    (set_AWG "WS350")
  )

  (defun c:faultdrop_FaultBox_obWS400_OnClicked (Value /)
    (set_AWG "WS400")
  )

  (defun c:faultdrop_FaultBox_obWS500_OnClicked (Value /)
    (set_AWG "WS500")
  )

  (defun c:faultdrop_FaultBox_obWS600_OnClicked (Value /)
    (set_AWG "WS600")
  )

  (defun c:faultdrop_FaultBox_obWS750_OnClicked (Value /)
    (set_AWG "WS750")
  )

  (defun c:faultdrop_FaultBox_obWS1000_OnClicked (Value /)
    (set_AWG "WS1000")
  )

  (defun set_AWG (value / )
    (setq AWG$ value)
    (check)
  )

  (defun c:faultdrop_FaultBox_btnOK_OnClicked (/)
    (dcl_Form_Close faultdrop_FaultBox 100)                          ; return 100 to signal completion
  )

  (defun c:faultdrop_FaultBox_btnCancel_OnClicked (/)
    (dcl_Form_Close faultdrop_FaultBox 200)                          ; return 200 to signal cancellation
  )

  (defun c:faultdrop_FaultBox_OnClose (UpperLeftX UpperLeftY /)
    (dcl_Form_Close faultdrop_FaultBox)                              ; automatically returns 2
  )

  (defun printit ()
    (print "AFC$")
    (print AFC$)
    (print "voltage$")
    (print voltage$)
    (print "conduit_length$")
    (print conduit_length$)
    (print "PFactor$")
    (print PFactor$)
    (print "conductor_temperature$")
    (print conductor_temperature$)
    (print "load_current$")
    (print load_current$)
    (print "conductor_type$")
    (print conductor_type$)
    (print "phase$")
    (print phase$)
    (print "conduit_type$")
    (print conduit_type$)
    (print "sets$")
    (print sets$)
    (print "AWG$")
    (print AWG$)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (setq AFC$ "")
  (setq voltage$ "")
  (setq conduit_length$ "")
  (setq PFactor$ "0.85")
  (setq conductor_temperature$ "75")
  (setq load_current$ "")
  (setq conductor_type$ "CU")
  (setq phase$ "three")
  (setq conduit_type$ "PVC")
  (setq sets$ "1")
  (setq AWG$ "WS0000")


  (setvar "cmdecho" 0)
  (setq old_ortho (getvar "orthomode"))
  (setvar "orthomode" 0)
  (setq old_osmode (getvar "osmode"))
  (setvar "osmode" 64)
  (setq insert_point (getpoint "\nSelect existing entry or insertion point ... "))
  (setq lastpt insert_point)                                         ; store the insertion point
  (setq insert_x (car insert_point))
  (setq insert_y (cadr insert_point))
  (setvar "OSMODE" 0)                                                ; turn off osnaps

  ;; Ensure OpenDCL Runtime is loaded (without echoing to command line)
  (setq cmdecho (getvar "cmdecho"))
  (setvar "cmdecho" 0)
  (command "_opendcl")
  (setvar "cmdecho" cmdecho)
  ;; Load the project
  (dcl_project_load "t://faultdrop.odcl" T)
  ;; show the main form
  (setq odcl_return (dcl_form_show faultdrop_FaultBox))
  (printit)
  (princ)
)
