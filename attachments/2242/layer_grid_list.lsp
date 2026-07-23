; ; ; ;  *********************************************
; ; ; ; Änderungen: 
; ; ; ; 
; ; ; ; 
; ; ; ;  *********************************************

; ########### Initialisieren ########################
; schreibe die schon vorher erstellte Datenliste der INI in die Tabelle
(defun c:layer_grid_list/main#OnInitialize (/ )
    ; Style 0
     (setq layerliste '()
        layerdata (tblnext "LAYER" T))
        (while layerdata
          (setq layerliste (append layerliste (list (cdr (assoc 2 layerdata))))
                layerdata (tblnext "layer")
            )
        )

    (dcl-ComboBox-Clear layer_grid_list/main/style0)
    (dcl-ComboBox-AddList layer_grid_list/main/style0 layerliste)

    (dcl-ComboBox-Clear layer_grid_list/main/style2)
    (dcl-ComboBox-AddList layer_grid_list/main/style2 layerliste)

    (dcl-Grid-AddString layer_grid_list/main/Datenblatt1 
                                    (strcat
                                        "123"   ; Variablenname, unsichtbare Spalte
                                         "\t"           
                                        "please select" ; Name
                                    )
                                    "\t")
)
; ########### Hauptprogramm ########################
; Hauptprogramm, Dialogverwaltung
(defun c:layer_grid_list (/ cmdecho currentini)

    ;; Ensure OpenDCL Runtime is (quietly) loaded
    (setq cmdecho (getvar "CMDECHO"))
    (setvar "CMDECHO" 0)
    (command "_OPENDCL")
    (setvar "CMDECHO" cmdecho)
        

    ;; Load the project
    (dcl-Project-Load "d:\\xxx\\layer_grid_list.odcl" T)
    
    (setq result (dcl-Form-Show layer_grid_list/main))
    (princ "\nProgramm wurde beendet.\n")
    (princ)
)
; ########### Abbrechen ########################
(defun c:layer_grid_list/main/beenden#OnClicked (/)
    (dcl-Form-Close layer_grid_list/main)
    (princ "\nProgramm wurde beendet.\n")
)
; ########### OnCancel etc. ########################
(defun c:layer_grid_list/main/Beenden#OnClicked ( / )
    (dcl-Form-Close layer_grid_list/main)
)
(defun c:layer_grid_list/main#OnCancel ( / )
    (dcl-Form-Close layer_grid_list/main)
)
(defun c:layer_grid_list/main#OnCancelClose ( / )
    (dcl-Form-Close layer_grid_list/main)
)
(defun c:layer_grid_list/main#OnClose (intUpperLeftX intUpperLeftY / )
    (dcl-Form-Close layer_grid_list/main)
)
(princ)


