;;;======================================================================================
;;; ELP.lsp 
;;; William Sander
;;; Store Planning Studio
;;; Hallmark Cards, Inc.
;;; Ver 1.0 2009
;;; This routine will create a polyline that defines the overall size of the electrical
;;; panel, provide a note if requested by the user, and place a telephone panel if
;;; requested by the user. The ODCL form for this is created in OpenDCL Studio.
;;;
;;; The electrical panel and additional information are drawn to appear on separate layers,
;;; The electrical panel is created on the "WL" layer, and is colored "1" (red).
;;; The electrical panel is a polyline drawn as 14"x4".
;;; The electrical panel's ADA clearance is created on the "MD" layer, is colored "1" (red), and its
;;; linetype is hidden.
;;; The electrical panel's ADA clearance is a polyline drawn 14"x48".
;;; The electrical panel designation is created on the "EC" layer.
;;; The electrical panel designation "EP" is comprised of DTEXT justified middle center
;;; 7" from the insertion point.
;;; The electrical panel note is created on the "EC" layer.
;;; The electrical panel note is a 6-sided polygon, inscribed in a 6" radius circle.
;;; The electrical panel note is located 18" from the insertion point of the electrical panel.
;;; The electrical panel notes note is created on the "EC" layer.
;;; The electrical panel note's notation "2" comprised of DTEXT justified middle center
;;; 18" from the insertion point.
;;; The telephone panel is created on the "WL" layer, and is colored "1" (red).
;;; The telephone panel is a polyline drawn as 14"x4".
;;; The telephone panel is hatched.
;;; The telephone panel hatch is created on the "WL" layer, and is colored "1" (red).
;;; The telephone panel hatch is a user defined hatch, angled at 90 degrees, spaced at 1.
;;; The telephone panel's ADA clearance is created on the "MD" layer, is colored "1" (red), and its
;;; linetype is hidden.
;;; The telephone panel's ADA clearance is a polyline drawn 14"x48".
;;;======================================================================================
(COMMAND "_OPENDCL")                              ; Ensure that the appropriate OpenDCL ARX file is loaded

(DEFUN C:ELP (/)                                  ; Define a new function called ELP. You’ll need the user to select an entry point and an angle.
  (DCL_PROJECT_LOAD "ELP" T)                      ; Call the method to load the ELP.odcl file
  (DCL_FORM_SHOW ELP_frmELP)
  (COMMAND ".UNDO" "MARK")                        ; Set an UNDO mark
  (SETQ USER_OSMODE (GETVAR "OSMODE"))            ; Stores the user's OSNAP setting
  (SETQ USER_APERTURE (GETVAR "APERTURE"))        ; Stores the user's APERTURE setting
  (SETVAR "OSMODE" 512)                           ; Sets the snaps to Nearest or nothing
  (SETVAR "APERTURE" 3)                           ; Sets the aperture to prevent the program from choosing too many points
)

(DEFUN RTD (R)                                    ; Converts from radians to degrees
  (* 180.0 (/ R PI))
)                                                 ; DEFUN RTD

(DEFUN c:ELP_frmELP_cmdElectricPanelOnly_OnClicked (/)
  (DCL_FORM_CLOSE ELP_frmELP)
;;; Get input from the user
  (INITGET 1)                                     ; This prevents the user from supplying bad information
  (SETQ PT1 (GETPOINT "\nSelect centerpoint for panel location: "))
                                                  ; Ask the user for the insertion point
  (INITGET 1)                                     ; This prevents the user from supplying bad information
  (SETQ ANG1 (GETANGLE PT1 "\nSelect angle: "))   ; Ask the user to define the angle
  (SETQ ANG1 (RTD ANG1))                          ; Converts ANG1 from radians to degrees
;;; Draw the electrical panel
  (COMMAND ".-LAYER" "T" "WL" "")                 ; Verify the "WL" layer is thawed 
  (COMMAND ".PLINE" PT1 "@14<0" "@4<90" "@14<180" "C") ; Draw the polyline
  (COMMAND ".MOVE" "L" "" PT1 "@7<180")           ; Move the polyline
  (COMMAND ".ROTATE" "L" "" PT1 ANG1)             ; Rotate the panel into place
  (COMMAND ".CHPROP" "L" "" "C" "RED" "LA" "WL" "")
                                                  ; Change the polyline to red, on the WL layer
;;; Draw the electrical panel ADA clearance
  (COMMAND ".-LAYER" "T" "MD" "")                 ; Verify the "MD" layer is thawed 
  (COMMAND "._LINETYPE" "S" "HIDDEN" "")          ; Set the linetype to "Hidden"
  (COMMAND ".PLINE" PT1 "@14<0" "@48<90" "@14<180" "C") ; Draw the polyline
  (COMMAND ".MOVE" "L" "" PT1 "@7<180")           ; Move the polyline
  (COMMAND ".ROTATE" "L" "" PT1 ANG1)             ; Rotate the ADA into place
  (COMMAND ".CHPROP" "L" "" "C" "RED" "LT" "HIDDEN" "LA" "MD" "")
                                                  ; Change the polyline to red, hidden, on the MD layer
;;; Add the EP designation to the "EC" layer
  (COMMAND ".-LAYER" "T" "EC" "")                 ; Verify the "EC" layer is thawed 
  (COMMAND ".TEXT" "J" "M" PT1 "0" "EP" "")       ; Draw the "EP" text
  (COMMAND ".MOVE" "L" "" PT1 "@7<90")            ; Move the polyline
  (COMMAND ".ROTATE" "L" "" PT1 ANG1)             ; Rotate the "EP" into place
  (COMMAND ".CHPROP" "L" "" "LA" "EC" "")         ; Change the "EP" to the EC layer
;;; Return everything to the User's original settings
  (SETVAR "APERTURE" USER_APERTURE)               ; This line resets the user's original APERTURE setting
  (SETVAR "OSMODE" USER_OSMODE)                   ; This line resets the user's original OSNAP setting
  (PRINC)
)

(DEFUN c:ELP_frmELP_cmdElectricPanelWithNote_OnClicked (/)
  (DCL_FORM_CLOSE ELP_frmELP)
;;;  Get input from the user
  (INITGET 1)                                     ; This prevents the user from supplying bad information
  (SETQ PT1 (GETPOINT "\nSelect centerpoint for panel location: "))
                                                  ; Ask the user for the insertion point
  (INITGET 1)                                     ; This prevents the user from supplying bad information
  (SETQ ANG1 (GETANGLE PT1 "\nSelect angle: "))   ; Ask the user to define the angle
  (SETQ ANG1 (RTD ANG1))                          ; Converts ANG1 from radians to degrees
;;; Draw the electrical panel
  (COMMAND ".-LAYER" "T" "WL" "")                 ; Verify the "WL" layer is thawed 
  (COMMAND ".PLINE" PT1 "@14<0" "@4<90" "@14<180" "C") ; Draw the polyline
  (COMMAND ".MOVE" "L" "" PT1 "@7<180")           ; Move the polyline
  (COMMAND ".ROTATE" "L" "" PT1 ANG1)             ; Rotate the panel into place
  (COMMAND ".CHPROP" "L" "" "C" "RED" "LA" "WL" "")
                                                  ; Change the polyline to red, on the WL layer
;;; Draw the electrical panel ADA clearance
  (COMMAND ".-LAYER" "T" "MD" "")                 ; Verify the "MD" layer is thawed 
  (COMMAND "._LINETYPE" "S" "HIDDEN" "")          ; Set the linetype to "Hidden"
  (COMMAND ".PLINE" PT1 "@14<0" "@48<90" "@14<180" "C") ; Draw the polyline
  (COMMAND ".MOVE" "L" "" PT1 "@7<180")           ; Move the polyline
  (COMMAND ".ROTATE" "L" "" PT1 ANG1)             ; Rotate the ADA into place
  (COMMAND ".CHPROP" "L" "" "C" "RED" "LT" "HIDDEN" "LA" "MD" "")
                                                  ; Change the polyline to red, hidden, on the MD layer
;;; Add the EP designation to the "EC" layer
  (COMMAND ".-LAYER" "T" "EC" "")                 ; Verify the "EC" layer is thawed 
  (COMMAND ".TEXT" "J" "M" PT1 "0" "EP" "")       ; Draw the "EP" text
  (COMMAND ".MOVE" "L" "" PT1 "@7<90")            ; Move the polyline
  (COMMAND ".ROTATE" "L" "" PT1 ANG1)             ; Rotate the "EP" into place
  (COMMAND ".CHPROP" "L" "" "LA" "EC" "")         ; Change the "EP" to the EC layer
;;; Add the 1 designation to the "EC" layer
  (COMMAND ".TEXT" "J" "M" PT1 "0" "1" "")        ; Draw the "EP" text
  (COMMAND ".MOVE" "L" "" PT1 "@18<90")           ; Move the polyline
  (COMMAND ".ROTATE" "L" "" PT1 ANG1)             ; Rotate the "EP" into place
  (COMMAND ".CHPROP" "L" "" "LA" "EC" "")         ; Change the "EP" to the EC layer
;;; Draw the note hexagon
  (COMMAND "._LINETYPE" "S" "CONTINUOUS" "")      ; Set the linetype to "Continuous"
  (COMMAND ".POLYGON" "6" PT1 "C" "6")            ; Draw the polygon
  (COMMAND ".MOVE" "L" "" PT1 "@18<90")           ; Move the polygon
  (COMMAND ".ROTATE" "L" "" PT1 ANG1)             ; Rotate the polygon into place
  (COMMAND ".CHPROP" "L" "" "LA" "EC" "")         ; Change the polygon to the EC layer
;;; Return everything to the User's original settings
  (SETVAR "APERTURE" USER_APERTURE)               ; This line resets the user's original APERTURE setting
  (SETVAR "OSMODE" USER_OSMODE)                   ; This line resets the user's original OSNAP setting
  (PRINC)
)

(DEFUN c:ELP_frmELP_cmdTelephonePanel_OnClicked (/)
  (DCL_FORM_CLOSE ELP_frmELP)
;;; Get input from the user
  (INITGET 1)                                     ; This prevents the user from supplying bad information
  (SETQ PT1 (GETPOINT "\nSelect centerpoint for panel location: "))
                                                  ; Ask the user for the insertion point
  (INITGET 1)                                     ; This prevents the user from supplying bad information
  (SETQ ANG1 (GETANGLE PT1 "\nSelect angle: "))   ; Ask the user to define the angle
  (SETQ ANG1 (RTD ANG1))                          ; Converts ANG1 from radians to degrees
;;;Draw the electrical panel
  (COMMAND ".-LAYER" "T" "WL" "")                 ; Verify the "WL" layer is thawed 
  (COMMAND ".PLINE" PT1 "@14<0" "@4<90" "@14<180" "C") ; Draw the polyline
  (COMMAND ".MOVE" "L" "" PT1 "@7<180")           ; Move the polyline
  (COMMAND ".ROTATE" "L" "" PT1 ANG1)             ; Rotate the panel into place
  (COMMAND ".CHPROP" "L" "" "C" "RED" "LA" "WL" "")
                                                  ; Change the polyline to red, on the WL layer
;;;Draw the hatch pattern
  (COMMAND ".-hatch" "S" "L" "" "P" "U" "90" "1" "n" "")
                                                  ;The telephone panel hatch is a user defined hatch, angled at 90 degrees, spaced at 1.
  (COMMAND ".CHPROP" "L" "" "C" "RED" "LA" "WL" "")
                                                  ; Change the hatch to red, on the WL layer
;;;Draw the electrical panel ADA clearance
  (COMMAND ".-LAYER" "T" "MD" "")                 ; Verify the "MD" layer is thawed 
  (COMMAND "._LINETYPE" "S" "HIDDEN" "")          ; Set the linetype to "Hidden"
  (COMMAND ".PLINE" PT1 "@14<0" "@48<90" "@14<180" "C") ; Draw the polyline
  (COMMAND ".MOVE" "L" "" PT1 "@7<180")           ; Move the polyline
  (COMMAND ".ROTATE" "L" "" PT1 ANG1)             ; Rotate the ADA into place
  (COMMAND ".CHPROP" "L" "" "C" "RED" "LT" "HIDDEN" "LA" "MD" "")
                                                  ; Change the polyline to red, hidden, on the MD layer
;;;Add the MTTB designation to the "EC" layer
  (COMMAND ".-LAYER" "T" "EC" "")                 ; Verify the "EC" layer is thawed 
  (COMMAND ".TEXT" "J" "M" PT1 "0" "MTTB" "")     ; Draw the "MTTB" text
  (COMMAND ".MOVE" "L" "" PT1 "@7<90")            ; Move the polyline
  (COMMAND ".ROTATE" "L" "" PT1 ANG1)             ; Rotate the "MTTB" into place
  (COMMAND ".CHPROP" "L" "" "LA" "EC" "")         ; Change the "MTTB" to the EC layer
;;;Return everything to the User's original settings
  (SETVAR "APERTURE" USER_APERTURE)               ; This line resets the user's original APERTURE setting
  (SETVAR "OSMODE" USER_OSMODE)                   ; This line resets the user's original OSNAP setting
  (PRINC)
)

(DEFUN c:ELP_frmELP_cmdEXIT_OnClicked (/)         ; Define a function for the EXIT button in ODCL
  (DCL_FORM_CLOSE ELP_frmELP)
)                                                 ; cmdEXIT
;|«Visual LISP© Format Options»
(80 2 50 2 nil "end of " 80 50 2 0 2 nil nil nil T)
;*** DO NOT add text below the comment! ***|;
