; Author: Roy Klein Gebbinck (www.b-k-g.nl)

(setvar 'cmdecho 0)
(vl-cmdf "_Opendcl")
(setvar 'cmdecho 1)

; 20161116: Udated code for hiding GCE button.
; 20161112

; 20161124 Added code for m2p, .xy and osnapZ - not linked to reactors - Scott CD
; 20161124 Modified button colours - Scott CD

(defun Osnaps-OnLoad ()
  ;; Remove existing reactors:
  (mapcar
    '(lambda (rea)
      (if (= "OSNAPS" (vlr-data rea))
        (vlr-remove rea)
      )
    )
    (apply 'append (mapcar 'cdr (vlr-reactors)))
  )
  ;; Create new reactors:
  (vlr-sysvar-reactor
    "OSNAPS"
    '(
      (:vlr-sysvarchanged . Osnaps-CallBackSysvarChanged)
    )
  )
  (vlr-docmanager-reactor
    "OSNAPS"
    '(
      (:vlr-documentbecamecurrent   . Osnaps-CallBackDocumentBecameCurrent)
      (:vlr-documenttobedeactivated . Osnaps-CallBackDocumentToBeDeactivated)
    )
  )
  (vlr-command-reactor
    "OSNAPS"
    '(
      (:vlr-commandcancelled . Osnaps-CallBackCommandCancelled)
      (:vlr-commandfailed    . Osnaps-CallBackCommandCancelled)
      (:vlr-commandwillstart . Osnaps-CallBackCommandWillStart)
    )
  )
  ;; Load ODCL and show dialog:
  (if (not (vl-position "Osnaps" (dcl-GetProjects)))
    (dcl-Project-Load "Osnaps")
  )
  (dcl-Form-Show Osnaps/Main)
  ;; Hide the GCE (Geometric CEnter) button for older versions of BricsCAD and AutoCAD:
  ;; http://autocadinsider.autodesk.com/my_weblog/2015/04/autocad-2016-geometric-center-osnap.html
  (if
    (and
      Osnaps/Main/btnGce ; To be absolutely safe.
      (dcl-Control-GetVisible Osnaps/Main/btnGce)
      (if (= "BRICSCAD" (strcase (getvar 'product)))
        (> 16 (atoi (getvar '_vernum)))
        (> 2016 (atoi (substr (ver) 13))) ; https://www.theswamp.org/index.php?topic=36606.msg416136#msg416136
      )
    )
    (progn
      (dcl-Control-SetVisible Osnaps/Main/btnGce nil)
      (dcl-Control-SetWidth Osnaps/Main (- (dcl-Control-GetWidth Osnaps/Main) 32)) ; 32 is the button distance.
    )
  )
  ;; Update the buttons:
  (Osnaps-UpdateButtons nil)
  (princ)
)

; 20161112
(defun Osnaps-CallBackSysvarChanged (rea lst)
  (if (= "OSMODE" (car lst))
    (Osnaps-UpdateButtons nil)
  )
)

; 20161112
(defun Osnaps-CallBackDocumentBecameCurrent (rea lst)
  (Osnaps-UpdateButtons nil)
)

; 20161112
(defun Osnaps-CallBackDocumentToBeDeactivated (rea lst)
  (Osnaps-UpdateButtons T)
)

; 20161112
(defun Osnaps-CallBackCommandCancelled (rea lst)
  (if (vl-position (car lst) '("OPEN" "QNEW"))
    (Osnaps-UpdateButtons nil)
  )
)

; 20161112
(defun Osnaps-CallBackCommandWillStart (rea lst)
  (if (vl-position (car lst) '("OPEN" "QNEW"))
    (Osnaps-UpdateButtons T)
  )
)

; 20161114B: Now using boole instead of logand.
; 20161114 : Button "Non" added.
; 20161112
(defun Osnaps-UpdateButtons (disableP / osm)
  (if (dcl-Form-IsActive Osnaps/Main)
    (dcl-Form-Enable Osnaps/Main (not disableP))
  )
  (setq osm (getvar 'osmode))
  (mapcar
    '(lambda (bit btn)
      (if (setq btn (eval (read (strcat "Osnaps/Main/btn" btn))))
        (cond
          ((= 0 bit)
            (dcl-Control-SetBackColor
              btn
              (cond
                (disableP    -16)
                ((zerop osm)   26738091);3 Light Green
                (T             32238571);1 Grey
              )
            )
          )
          ((= 16384 bit) ;16384
            (cond
              (disableP
                (dcl-Control-SetCaption btn "?")
                (dcl-Control-SetBackColor btn -16)
                (dcl-Control-SetForeColor btn -19)
              )
              ((zerop osm)
                (dcl-Control-SetCaption btn "OFF")
                (dcl-Control-SetBackColor btn 0)
                (dcl-Control-SetForeColor btn 7)
              )
              ((= bit (boole 1 osm bit))
                (dcl-Control-SetCaption btn "OFF")
                (dcl-Control-SetBackColor btn 8)
                (dcl-Control-SetForeColor btn 7)
              )
              (T
                (dcl-Control-SetCaption btn "ON")
                (dcl-Control-SetBackColor btn 7)
                (dcl-Control-SetForeColor btn 0)
              )
            )
          )
          (T
            (dcl-Control-SetBackColor
              btn
              (cond
                (disableP                  -16)
                ((= bit (boole 1 osm bit))   26738091) ;3 Light Green
                (T                           32238571) ;1 Grey
              )
            )
          )
        )
      )
    )
    '(    0     1     2     4     8    16    32    64   128   256   512  1024  2048  4096  8192   16384 32768)
    '("Non" "End" "Mid" "Cen" "Nod" "Qua" "Int" "Ins" "Per" "Tan" "Nea" "Gce" "App" "Ext" "Par" "OnOff" "OsnapZ")
  )
)

; 20161116B: Event handlers for "Int" and "App" were not correct.
; 20161116 : Event handlers revised.
;           (boole 2 (getvar 'osmode) 16384) added to match the BricsCAD 'Entity Snaps' toolbar.
; 20161114 : Event handlers revised. Button "Non" added.
; 20161112
(defun c:Osnaps/Main/btnClose#OnClicked () (dcl-Form-Close Osnaps/Main) (princ))
(defun c:Osnaps/Main/btnNon#OnClicked   () (setvar 'osmode 0) (princ))
(defun c:Osnaps/Main/btnEnd#OnClicked   () (setvar 'osmode (boole 6 (boole 2 (getvar 'osmode) 16384)    1)) (princ))
(defun c:Osnaps/Main/btnMid#OnClicked   () (setvar 'osmode (boole 6 (boole 2 (getvar 'osmode) 16384)    2)) (princ))
(defun c:Osnaps/Main/btnCen#OnClicked   () (setvar 'osmode (boole 6 (boole 2 (getvar 'osmode) 16384)    4)) (princ))
(defun c:Osnaps/Main/btnNod#OnClicked   () (setvar 'osmode (boole 6 (boole 2 (getvar 'osmode) 16384)    8)) (princ))
(defun c:Osnaps/Main/btnQua#OnClicked   () (setvar 'osmode (boole 6 (boole 2 (getvar 'osmode) 16384)   16)) (princ))
(defun c:Osnaps/Main/btnInt#OnClicked   ()
  (setvar 'osmode
    (if (zerop (boole 1 (getvar 'osmode) 32)) ; Int is off.
      (boole 2                                ; Switch App (2048) off.
        (boole 7 (getvar 'osmode) 32)         ; Switch Int on.
        (+ 2048 16384)
      )
      (boole 2 (getvar 'osmode) (+ 32 16384)) ; Switch Int off.
    )
  )
  (princ)
)
(defun c:Osnaps/Main/btnIns#OnClicked   () (setvar 'osmode (boole 6 (boole 2 (getvar 'osmode) 16384)   64)) (princ))
(defun c:Osnaps/Main/btnPer#OnClicked   () (setvar 'osmode (boole 6 (boole 2 (getvar 'osmode) 16384)  128)) (princ))
(defun c:Osnaps/Main/btnTan#OnClicked   () (setvar 'osmode (boole 6 (boole 2 (getvar 'osmode) 16384)  256)) (princ))
(defun c:Osnaps/Main/btnNea#OnClicked   () (setvar 'osmode (boole 6 (boole 2 (getvar 'osmode) 16384)  512)) (princ))
(defun c:Osnaps/Main/btnGce#OnClicked   () (setvar 'osmode (boole 6 (boole 2 (getvar 'osmode) 16384) 1024)) (princ))
(defun c:Osnaps/Main/btnApp#OnClicked   ()
  (setvar 'osmode
    (if (zerop (boole 1 (getvar 'osmode) 2048)) ; App is off.
      (boole 2                                  ; Switch Int (32) off.
        (boole 7 (getvar 'osmode) 2048)         ; Switch App on.
        (+ 32 16384)
      )
      (boole 2 (getvar 'osmode) (+ 2048 16384)) ; Switch App off.
    )
  )
  (princ)
)
(defun c:Osnaps/Main/btnExt#OnClicked   () (setvar 'osmode (boole 6 (boole 2 (getvar 'osmode) 16384) 4096)) (princ))
(defun c:Osnaps/Main/btnPar#OnClicked   () (setvar 'osmode (boole 6 (boole 2 (getvar 'osmode) 16384) 8192)) (princ))
(defun c:Osnaps/Main/btnOnOff#OnClicked () (setvar 'osmode (boole 6 (getvar 'osmode) 16384)) (princ))

(defun c:Osnaps/Main/btnXY#OnClicked (/) ; Added SCD 24/11/2016
  ".XY"
)

(defun c:Osnaps/Main/btnm2p#OnClicked (/) ; Added SCD 24/11/2016
  "_m2p"
)

(defun c:Osnaps/Main/btnOsnapZ#OnClicked (/) ; Added SCD 24/11/2016
  (setvar 'osnapz (boole 6 (getvar 'osnapz) 1))
  (if (eq 0 (getvar "osnapz"))
    (dcl-Control-SetBackColor Osnaps/Main/btnOsnapZ 32238571)
    (dcl-Control-SetBackColor Osnaps/Main/btnOsnapZ 26738091)
  )
)

(Osnaps-OnLoad) ; Starts the reactors, loads the ODCL and updates the dialog.
(princ)
;|«Visual LISP© Format Options»
(110 2 70 2 nil "end of " 70 9 0 0 0 T T nil T)
;*** DO NOT add text below the comment! ***|;
