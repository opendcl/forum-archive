; ; ; ;  *********************************************
; ; ; ; Änderungen: 
; ; ; ; 
; ; ; ; 
; ; ; ;  *********************************************

; ########### Initialisieren ########################
; schreibe die schon vorher erstellte Datenliste der INI in die Tabelle
(defun c:combo_select/main#OnInitialize (/ )
    ; Style 0
    (setq style0 (list "Style 0 - a" "Style 0 - b"))
    (dcl-ComboBox-Clear combo_select/main/style0)
    (dcl-ComboBox-AddList combo_select/main/style0 style0)
    (dcl-ComboBox-SelectString combo_select/main/style0 "Style 0 - b")

    ; Style 2
    (setq style2 (list "Style 2 - a" "Style 2 - b"))
    (dcl-ComboBox-Clear combo_select/main/style2)
    (dcl-ComboBox-AddList combo_select/main/style2 style2)
    (dcl-ComboBox-SelectString combo_select/main/style2 "Style 2 - b")

    ; List
    (setq list1 (list "List - a" "List- b"))
    (dcl-ListBox-AddList combo_select/main/Listenfeld1 list1)
    (dcl-ListBox-SelectString combo_select/main/Listenfeld1 "List - b")

)
; ########### Hauptprogramm ########################
; Hauptprogramm, Dialogverwaltung
(defun c:combo_select (/ cmdecho currentini)

    ;; Ensure OpenDCL Runtime is (quietly) loaded
    (setq cmdecho (getvar "CMDECHO"))
    (setvar "CMDECHO" 0)
    (command "_OPENDCL")
    (setvar "CMDECHO" cmdecho)
        

    ;; Load the project
    (dcl-Project-Load "combo_select.odcl" T)
    

    ;; Hauptdialog in Schleife, ausgenommen Abbruchcodes
    (setq result 101)
    (while (> result 100)
        (setq result (dcl-Form-Show combo_select/main))
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
(defun c:combo_select/main/messen#OnClicked (/)
    (dcl-form-close combo_select/main 102)
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
(defun c:combo_select/main/beenden#OnClicked (/)
    (dcl-Form-Close combo_select/main)
    (princ "\nProgramm wurde beendet.\n")
)
; ########### OnCancel etc. ########################
(defun c:combo_select/main/Beenden#OnClicked ( / )
    (dcl-Form-Close combo_select/main)
)
(defun c:combo_select/main#OnCancel ( / )
    (dcl-Form-Close combo_select/main)
)
(defun c:combo_select/main#OnCancelClose ( / )
    (dcl-Form-Close combo_select/main)
)
(defun c:combo_select/main#OnClose (intUpperLeftX intUpperLeftY / )
    (dcl-Form-Close combo_select/main)
)
(princ)
