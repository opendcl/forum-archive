;;;######################################################################
;;;######### Bereich Systemeinstellungen ################################
;;;######################################################################
;; Beschreibung: (definieren und) laden der ODCL-Daten; nicht anzeigen
(defun spdrs_odcl_project_loader ( / )
    ;; aktive / fertige Entwicklung 
    ;;-----------------------------------------
    ;; Version a): Load the project from ODCL
    (dcl_Project_Load "test.odcl" T)
    (princ)
); ende spdrs_odcl_project_loader
;;;######################################################################
;;; Dialog schliessen, wenn alle Zeichnungen zu sind
(defun c:spdrs_Haupt_OnEnteringNoDocState ( / )
    (dcl_Form_Close spdrs_Haupt)
)
;;;######################################################################
;;; Beim Schliessen des Dialogs aktuelle Auswahl im Baum merken
(defun c:spdrs_haupt#OnCancel ()
    (alert "Cancel")
    (setq baumstatus (dcl-Tree-GetSelectedItem spdrs_Haupt_tree))
    (dcl_Form_Close spdrs_Haupt)
    (princ "\n1")
    (alert "zu")
)
;;;######################################################################
;;; Beim Schliessen des Dialogs aktuelle Auswahl im Baum merken
(defun c:spdrs_haupt#OnClose ()
    (alert "Close")
    (setq baumstatus (dcl-Tree-GetSelectedItem spdrs_Haupt_tree))
    (dcl_Form_Close spdrs_Haupt)
    (princ "\n1")
    (alert "zu")
)
;;;######################################################################
;;; Beim Schliessen des Dialogs aktuelle Auswahl im Baum merken
(defun c:spdrs_haupt#OnCancelClose ()
    (alert "CancelClose")
    (setq baumstatus (dcl-Tree-GetSelectedItem spdrs_Haupt_tree))
    (dcl_Form_Close spdrs_Haupt)
    (princ "\n1")
    (alert "zu")
)

;;;######################################################################
;;;; Tabwechsel beobachten, bei Tab 4 Dialog schliessen
(defun c:spdrs_haupt_Karteikarten1#OnChanged (tabnummer) ; Null-basiert!
    (if (= tabnummer 3) 
        (progn
;            (setq baumstatus (dcl-Tree-GetSelectedItem spdrs_Haupt_tree))
            (dcl_Form_Close spdrs_Haupt)
        )
    )
)
;;;######################################################################
;;;; Einstellungen beim Start, Optionen auslesen
(defun c:spdrs_Haupt_OnInitialize   (/ )

    (dcl_Tree_AddParent spdrs_Haupt_tree "Symbole" "P00" 9 -1 9)

    (dcl_Tree_AddChild spdrs_Haupt_tree "P00" "Abbruch" "P10" 0 -1 1)
    (dcl_Tree_AddChild spdrs_Haupt_tree
        '(
            ("P10" "links" "10" 3 3)
            ("P10" "rechts" "20" 3 3)
        )
    )

    (dcl_Tree_AddChild spdrs_Haupt_tree "P00" "Betriebsartenstecker" "P20" 0 -1 1)
    (dcl_Tree_AddChild spdrs_Haupt_tree
        '(
            ("P20" "von oben" "30" 3 3)
            ("P20" "von unten" "40" 3 3)
        )
    )

; Auswahl im Baum auch ohne Fokus hervorheben
    (dcl-Control-SetShowSelectAlways spdrs_Haupt_tree T)
; Auswahl im Baum aktivieren, soferne gespeichert
    (if baumstatus
        (dcl-Tree-selectitem spdrs_Haupt_tree baumstatus)
    )
); on_initialize

;;;######################################################################
;;;######### Bereich Hauptprogramm  #####################################
;;;######################################################################
;; [Beschreibung] Hauptprogramm; Grunddefinitionen, ODCL-Loader aufrufen und Zusatzeinstellungen für ODCL
(defun c:test ( / )
    (setq spdrs_routinename "SpDrS - Zeichnungszentrale"
          routinedaten "Version Beta 1 / 15.11.2014")
          
    (spdrs_odcl_project_loader)
    ;; Show the main form
    (dcl_Form_Show spdrs_Haupt)
); defun

;;;######################################################################
;;;######### Bereich Events #############################################
;;;######################################################################

;;;######################################################################
;; Register "Blöcke
;;;######################################################################

(defun c:spdrs/haupt/Bildschaltfläche2#OnClicked ()
    (alert "Button")
    (setq x (setq baumstatus (dcl-Tree-GetSelectedItem spdrs_Haupt_tree)))
    (dcl_Form_Close spdrs_Haupt)
    (alert "done")
)    
; Bei Wechsel im Baum: Identität über Key festlegen, damit arbeiten
(defun spdrs_Haupt_tree_OnSelChanged (strLabel uKey /)
    ; lege je nach übermitteltem uKey den Blockname fest
    (setq selBlock nil
          visWert nil)
    (cond 
            ((member uKey (list "P10" "10" "20"))
                (setq selBlock "Abbruch")
            )
            ((member uKey (list "P20" "30" "40"))
                (setq selBlock "Betriebsartenstecker")
            )
            ((member uKey (list "P30" "50" "60" "70"))
                (setq selBlock "Kondensator")
            )
            ( t
                (setq selBlock nil)
            )
    )
    ; speichere den strLabel als Sichtbarkeitswert, ausser er entspricht einem Blocknamen (also Überschrift)
    (if (and strLabel
             (/= strLabel selBlock))
        (setq visWert strLabel)
    )
    (princ)
)
(vl-load-com)
(princ)
(c:test)

