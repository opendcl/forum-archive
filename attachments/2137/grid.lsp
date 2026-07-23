;;;
;;; GRID Beispiel
;;;
;;; Dieses Beispiel demonstriert das Datenblatt mit all seinen Ereignissen.
;;;

;; Hauptprogramm
(defun c:Grid (/ cmdecho)

  ;; Stellt sicher, dass die Laufzeitumgebung im Hintergrund geladen wird
  (setq cmdecho (getvar "CMDECHO"))
  (setvar "CMDECHO" 0)
  (command "_OPENDCL")
  (setvar "CMDECHO" cmdecho)

  ;; Lädt das Projekt
  (dcl-Project-Load "Grid.odcl" T)

;    (dcl-Grid-AddRow grid/Schriftinfo/Schriftinfo2 "ich" "du")

  ;; Zeigt den Hauptdialog an
  (dcl-Form-Show Grid/Schriftinfo)

    (dcl-Grid-AddString grid/Schriftinfo/Schriftinfo2 "OpenDCL\twww.opendcl.com" "\t")

  ;; Dies ist ein modaler Dialog, so dass das Programm nach (dcl-Form-Show)
  ;; erst fortfährt, wenn der Dialog geschlossen wurde. In der Zwischenzeit
  ;; behandeln die Ereignisse den Dialog.

  (princ)
)

;|«OpenDCL Event Handlers»|;

