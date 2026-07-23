(defun c:vd (/ *error* current$ voltage$ condult_length$ PF$ CUAL$ phase$
             conduit$ sets$ AWG$
            )

  (defun *error* (msg)
    (while (< 0 (getvar "cmdactive"))
      (command)
    )
    ;; do error stuff
    (if (dcl_form_isactive vdrop_drop)
      (dcl_form_close vdrop_drop)
    )
    (princ
      (strcat "\nApplication Error: " (itoa (getvar "errno")) " :- " msg)
    )
    (princ)
  )

  (defun check ()
(print voltage$)
(print current$)
(print CUAL$)
    (if (and (/= current$ "")
             (/= voltage$ "")
             (/= condult_length$ "")
             (/= PF$ "")
             (/= CUAL$ "")
             (/= phase$ "")
             (/= conduit$ "")
             (/= sets$ "")
             (/= AWG$ "")
        )
      (dcl_Control_SetEnabled vdrop_Drop_btnOK T)
    )
  )

  (defun set_current (value / )
    (setq current$ value)
    (check)
  )

  (defun set_voltage (value / )
    (setq voltage$ value)
    (check)
  )

  (defun set_clength (value / )
    (setq clength$ value)
    (check)
  )

  (defun set_PF (value / )
    (setq PF$ value)
    (check)
  )

  (defun set_CUAL (value / )
    (setq CUAL$ value)
    (check)
  )

  (defun set_phase (value / )
    (setq phase$ value)
    (check)
  )

  (defun set_conduit (value / )
    (setq conduit$ value)
    (check)
  )

  (defun set_sets$ (value / )
    (setq sets$ value)
    (check)
  )

  (defun set_AWG$ (value / )
    (setq AWG$ value)
    (check)
  )


  (setq current$ "")
  (setq voltage$ "")
  (setq clength$ "")
  (setq PF$ "")
  (setq CUAL$ "")
  (setq phase$ "")
  (setq conduit$ "")
  (setq sets$ "")
  (setq AWG$ "")

  ;; Ensure OpenDCL Runtime is loaded (without echoing to command line)
  (setq cmdecho (getvar "cmdecho"))
  (setvar "cmdecho" 0)
  (command "_opendcl")
  (setvar "cmdecho" cmdecho)

  ;; Load the project
  (dcl_project_load "t:\vdrop.odcl" T)

  ;; show the main form
  (setq odcl_return (dcl_form_show vdrop_Drop))
  (princ)
)

(defun c:vdrop_Drop_ebCurrent_OnEditChanged (NewValue /)
  (set_current NewValue)
)

(defun c:vdrop_Drop_ebVoltage_OnEditChanged (NewValue /)
  (set_voltage NewValue)
)

(defun c:vdrop_Drop_ebLength_OnEditChanged (NewValue /)
  (set_clength NewValue)
)

(defun c:vdrop_Drop_ebPF_OnEditChanged (NewValue /)
  (set_PF NewValue)
)

(defun c:vdrop_Drop_obCopper_OnClicked (Value /)
  (set_CUAL "CU")
)

(defun c:vdrop_Drop_obAluminum_OnClicked (Value /)
  (set_CUAL "AL")
)

(defun c:vdrop_Drop_obSingle_OnClicked (Value /)
  (set_phase "1")
)

(defun c:vdrop_Drop_obThree_OnClicked (Value /)
  (set_phase "3")
)

(defun c:vdrop_Drop_obDC_OnClicked (Value /)
  (set_phase "DC")
)

(defun c:vdrop_Drop_obSteel_OnClicked (Value /)
  (set_conduit "steel")
)

(defun c:vdrop_Drop_obPVC_OnClicked (Value /)
  (set_conduit "PVC")
)

(defun c:vdrop_Drop_obCable_OnClicked (Value /)
  (set_conduit "cable")
)

(defun c:vdrop_Drop_ob1set_OnClicked (Value /)
  (set_sets$ "1")
)

(defun c:vdrop_Drop_ob2sets_OnClicked (Value /)
  (set_sets$ "2")
)

(defun c:vdrop_Drop_ob3sets_OnClicked (Value /)
  (set_sets$ "3")
)

(defun c:vdrop_Drop_ob4sets_OnClicked (Value /)
  (set_sets$ "4")
)

(defun c:vdrop_Drop_ob5sets_OnClicked (Value /)
  (set_sets$ "5")
)

(defun c:vdrop_Drop_ob6sets_OnClicked (Value /)
  (set_sets$ "6")
)

(defun c:vdrop_Drop_ob7sets_OnClicked (Value /)
  (set_sets$ "7")
)

(defun c:vdrop_Drop_obWS14_OnClicked (Value /)
  (set_AWG$ "WS14")
)

(defun c:vdrop_Drop_obWS12_OnClicked (Value /)
  (set_AWG$ "WS12")
)

(defun c:vdrop_Drop_obWS10_OnClicked (Value /)
  (set_AWG$ "WS10")
)

(defun c:vdrop_Drop_obWS8_OnClicked (Value /)
  (set_AWG$ "WS8")
)

(defun c:vdrop_Drop_obWS6_OnClicked (Value /)
  (set_AWG$ "WS6")
)

(defun c:vdrop_Drop_obWS4_OnClicked (Value /)
  (set_AWG$ "WS4")
)

(defun c:vdrop_Drop_obWS3_OnClicked (Value /)
  (set_AWG$ "WS3")
)

(defun c:vdrop_Drop_obWS2_OnClicked (Value /)
  (set_AWG$ "WS2")
)

(defun c:vdrop_Drop_obWS1_OnClicked (Value /)
  (set_AWG$ "WS1")
)

(defun c:vdrop_Drop_obWS0_OnClicked (Value /)
  (set_AWG$ "WS0")
)

(defun c:vdrop_Drop_obWS00_OnClicked (Value /)
  (set_AWG$ "WS00")
)

(defun c:vdrop_Drop_obWS000_OnClicked (Value /)
  (set_AWG$ "WS000")
)

(defun c:vdrop_Drop_obWS0000_OnClicked (Value /)
  (set_AWG$ "WS0000")
)

(defun c:vdrop_Drop_obWS250_OnClicked (Value /)
  (set_AWG$ "WS250")
)

(defun c:vdrop_Drop_obWS300_OnClicked (Value /)
  (set_AWG$ "WS300")
)

(defun c:vdrop_Drop_obWS350_OnClicked (Value /)
  (set_AWG$ "WS350")
)

(defun c:vdrop_Drop_obWS400_OnClicked (Value /)
  (set_AWG$ "WS400")
)

(defun c:vdrop_Drop_obWS500_OnClicked (Value /)
  (set_AWG$ "WS500")
)

(defun c:vdrop_Drop_obWS600_OnClicked (Value /)
  (set_AWG$ "WS600")
)

(defun c:vdrop_Drop_obWS750_OnClicked (Value /)
  (set_AWG$ "WS750")
)

(defun c:vdrop_Drop_obWS1000_OnClicked (Value /)
  (set_AWG$ "WS1000")
)
