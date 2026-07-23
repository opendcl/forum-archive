; Ensure the appropriate OpenDCL ARX file is loaded
(command "OPENDCL")
(defun c:s203 ()


; Listen mit den Auswahlmöglichkeiten erstellen
(setq s203Breite '("  624 (2 Schuppengläser)"
                   "  924 (3 Schuppengläser)"
                   "1224 (4 Schuppengläser)"
                   "1524 (5 Schuppengläser)"
                   "1824 (6 Schuppengläser)"
                   "2124 (7 Schuppengläser)"
                   "2424 (8 Schuppengläser)"
                   "2724 (9 Schuppengläser)"
                   "3024 (10 Schuppengläser)"
                   "3324 (11 Schuppengläser)"
                   "3724 (12 Schuppengläser)")
      s203Achsen '("0" "1" "2" "3")
      s203Glastyp '("VSG/ESG"
                    "Heat Mirror"
                    "ESG/ESG (nur CH!)")
      )

; call the method to load the s203.odcl file.
(dcl_Project_Load "s203" T)

; call the method to show the s:203 dialog box
(dcl_Form_Show s203_Form1)
  
(defun c:s203_Form1_OnInitialize (/)
  (dcl_ListBox_AddList s203_Form1_RIM-H s203Breite)
  (dcl_ListBox_AddList s203_Form1_AnzahlMittelAchsen s203Achsen)
  (dcl_ListBox_AddList s203_Form1_GlasTyp s203Glastyp)
)
  


(defun c:s203_Form1_OK_Button_OnClicked (/)
  (setq Val_RIM-B (atof (dcl_Control_GetText s203_Form1_RIM-B)))
  (setq Val_RIM-H (dcl_ListBox_GetSelectedItems s203_Form1_RIM-H))
  (setq Val_AnzahlMittelAchsen (dcl_ListBox_GetSelectedItems s203_Form1_AnzahlMittelAchsen))
  (setq Val_GlasTyp (dcl_ListBox_GetSelectedItems s203_Form1_GlasTyp))
  (if (or
       (< Val_RIM-B 400.)
       (> Val_RIM-B 5200.)
       (= Val_RIM-H NIL)
       (= Val_AnzahlMittelAchsen NIL)
       (= Val_GlasTyp NIL))
    (dcl_messagebox "Es muss in jedem Feld ein Wert angeklickt sein, ausserdem muss die Breite minimal 400 mm / maximal 5200 sein. Bitte korrigieren Sie Ihre Eingabe")
    (dcl_Form_Close s203_Form1)
    )
  )


;--------------- Ende Startdialog -----------------------
;--------------- Start Konstanten s:203 -----------------



;Differenzmasse für Vertikalschnitt ausgehend von RIM

(setq VS_RAM 177.0		;Differenz VS RAM - RIM
      VS_Holz 50.0		;Differenz VS Holzöffnung iL - RIM
      VS_SSt -123.0		;Differenz VS Schubstange - RIM
      VS_EDRi 73.0		;Differenz VS Eindeckrahmen innen - RIM
      )

;Differenzmasse für Horizontalschnitt ausgehend von RIM (Lichtmass, ab Motoren-Innenseite)

(setq HS_RAM 297.0		;Differenz HS RAM - RIM
      HS_RIB 120.0		;Differenz HS RahmeninnenBreite - RIM
      HS_IED 193.0		;Differenz HS Innenmass Eindeckrahmen - RIM
      HS_GLA 224.0		;Differenz HS Glasbreite aussen - RIM
      HS_SPA 140.0		;Differenz HS Sparrenöffnung - RIM
      )

;konstruktive Konstanten

(setq B_Achse 60.0		;Breite Mittelachsen
      )


;Blocknamen für Vertikalschnitt

(setq D_VS ""			;Blockname des Vertikalschnitts Standard ohne Beschattung
      )


;Blocknamen für Horizontalschnitt

(setq D_HS_L "D_HS_s203_LI.dwg"				;Blockname des Horizontalschnitts Linke Achse Standard ohne Beschattung
      D_HS_M "D_HS_s203_M.dwg"				;Blockname des Horizontalschnitts Mittlere Achse Standard ohne Beschattung
      D_HS_R "D_HS_s203_RE.dwg"				;Blockname des Horizontalschnitts Rechte Achse Standard ohne Beschattung
      )


;Blocknamen für die sonstigen Zeichnungselemente

(setq D_RAHMEN "Zeichnungsrahmen_D.dwg"			;Blockname des Standard-Zeichnungsrahmens A3 mit Schriftfeld
      D_AS_LR "D s203 Anschluss links rechts.dwg"	;Blockname des Standard-Schnitts für die Anschlüsse links und rechts
      D_AS_OU "D s203 Anschluss oben unten.dwg"		;Blockname des Standard-Schnitts für die Anschlüsse unten und oben
      )


;--------------- Ende Konstanten s:203-------------------
;--------------- Start Geometrie ------------------------

;Testsequenz für Listen mit Variablen
;(setq test1 '(0. 0. 0.))
;(setq test2 (list Val_RIM-B 0. 0.))
;
;(command "_line" test1 test2 "")
;(princ Val_RIM-B)
;
;(princ test1)
;(princ test2)



;Einfügepunkt für Zeichnung abfragen

(setq Startpunkt NIL)
(while (= Startpunkt NIL)
  (setq Startpunkt
         (getpoint "Bitte wähle einen Einfügepunkt in der Zeichnung...")
        )
  (if (= Startpunkt NIL)
    (dcl_messagebox "Das war keine Position in der Zeichnung! Bitte klicke mit der linken Maustaste auf die gewünschte Einfügeposition in der Zeichnung!")
    ()
    )
  )

  
;Zeichnungsrahmen positionieren

(command "_insert" D_RAHMEN Startpunkt "" "" "")
(command "_zoom" "_e")


;von Startpunkt aus Einfügepunkt Vertikalschnitt berechnen und Schnitt einfügen

  
  )