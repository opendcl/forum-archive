; ; ; ;  *********************************************
; ; ; ; Änderungen: 
; ; ; ; 
; ; ; ; 
; ; ; ;  *********************************************

; ########### Initialisieren ########################
; schreibe die schon vorher erstellte Datenliste der INI in die Tabelle
(defun c:combo_box/main#OnInitialize (/ )
    ; bereite alle Daten vor
    
    ; Linienbreite
    (setq style0 (list "Style 0 - a" "Style 0 - b"))

    (dcl-ComboBox-Clear combo_box/main/style0)
    (dcl-ComboBox-AddList combo_box/main/style0 style0)



    ; Linienbreite
    (setq style1 (list "Style 1 - a" "Style 1 - b"))

    (dcl-ComboBox-Clear combo_box/main/style1)
    (dcl-ComboBox-AddList combo_box/main/style1 style1)


    ; Linienbreite
    (setq style2 (list "Style 2 - a" "Style 2 - b"))

    (dcl-ComboBox-Clear combo_box/main/style2)
    (dcl-ComboBox-AddList combo_box/main/style2 style2)
)
; ########### Hauptprogramm ########################
; Hauptprogramm, Dialogverwaltung
(defun c:combo_box (/ cmdecho currentini)

    ;; Ensure OpenDCL Runtime is (quietly) loaded
    (setq cmdecho (getvar "CMDECHO"))
    (setvar "CMDECHO" 0)
    (command "_OPENDCL")
    (setvar "CMDECHO" cmdecho)
        

    ;; Load the project
    (dcl-Project-Load "combo_box.odcl" T)
    

    ;; Hauptdialog in Schleife, ausgenommen Abbruchcodes
    (setq result 101)
    (while (> result 100)
        (setq result (dcl-Form-Show combo_box/main))
        ; damit kommt der Dialog bei close immer wieder, ausser ein Code <= 100 wird mitgegeben
        (if (= result 102) ; vom Messen-Button
            (messen)
        )
    )
    (princ "\nProgramm wurde beendet.\n")
    (princ)
)
; ########### Messen Befehl ########################
; Schliesst Dialog, Hauptprogramm holt Sub und startet dann wieder
(defun c:combo_box/main/messen#OnClicked (/)
    (dcl-form-close combo_box/main 102)
)
; ########### Messen Routine ########################
; Anwender zeigt zwei Punkte, Programm berechnet Abstand und Parkplatzzahl
(defun messen ()
    (setq p1_m (getpoint "\nClick first point: ")
          p2_m (getpoint p1_m "\nClick second point: ")
          messlaenge (distance p1_m p2_m) ; Distanz der geklickten Punkte
    )
)
; ########### aendern_w Routine ########################
; ########### Abbrechen ########################
; ########### Abbrechen ########################
(defun c:combo_box/main/beenden#OnClicked (/)
    (dcl-Form-Close combo_box/main)
    (princ "\nProgramm wurde beendet.\n")
)
; ########### OnCancel etc. ########################
(defun c:combo_box/main/Beenden#OnClicked ( / )
    (dcl-Form-Close combo_box/main)
)
(defun c:combo_box/main#OnCancel ( / )
    (dcl-Form-Close combo_box/main)
)
(defun c:combo_box/main#OnCancelClose ( / )
    (dcl-Form-Close combo_box/main)
)
(defun c:combo_box/main#OnClose (intUpperLeftX intUpperLeftY / )
    (dcl-Form-Close combo_box/main)
)
(princ)
