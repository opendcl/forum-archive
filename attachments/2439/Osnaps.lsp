; =========================================================================================== ;
; Odczyt/Zapis danych w rejestrze / Reads/Writes data to the registry                         ;
;  Key  [STR]     - klucz rejestru / registry key                                             ;
;  Name [STR]     - wartosc wpisu w rejestrze / value of a registry entry                     ;
;  Data [STR/nil] - nil = odczyt danych / read data                                           ;
;                   STR = dane do zapisu / data to write                                      ;
; =========================================================================================== ;
; (cd:SYS_RW "CADPL\\Tools\\MakeBlock" "Version" "1.0")                                       ;
; =========================================================================================== ;
(defun cd:SYS_RW (Key Name Data / loc)
  (setq loc (strcat "HKEY_CURRENT_USER\\Software\\" Key))
  (cond
    ( (and Name Data)
      (vl-registry-write loc Name Data)
    )
    ( Data
      (vl-registry-write loc nil Data)
    )
    ( T
      (vl-registry-read loc Name)
    )
  )
)
; =========================================================================================== ;
(if (setq *OsnapsOnColor* (cd:SYS_RW "Tools\\Osnaps" "OnColor" nil))
  *OsnapsOnColor*
  (setq *OsnapsOnColor* (cd:SYS_RW "Tools\\Osnaps" "OnColor" "27435682"))
)
(if (setq *OsnapsOffColor* (cd:SYS_RW "Tools\\Osnaps" "OffColor" nil))
  *OsnapsOffColor*
  (setq *OsnapsOffColor* (cd:SYS_RW "Tools\\Osnaps" "OffColor" "22172242"))
)

; http://www.opendcl.com/forum/index.php?topic=2446.msg12212#msg12212
; Author: Roy Klein Gebbinck (www.b-k-g.nl)

(setvar 'cmdecho 0)
(vl-cmdf "_Opendcl")
(setvar 'cmdecho 1)

; 20180417
; ODCL check.
(if (not dcl-Project-Load)
  (progn
    (princ "\nError: OpenDCL runtime not available ")
    (exit)
  )
)

; 20180417
; Dialog check.
(if (not (findfile "Osnaps.odcl"))
  (progn
    (princ "\nError: \"Osnaps.odcl\" file not found ")
    (exit)
  )
)

(vl-load-com)

; 20170125
(defun Osnaps-CadWindow ( / cad lft top)
  (setq cad (vlax-get-acad-object))
  (list
    (list
      (setq lft (vla-get-windowleft cad))
      (setq top (vla-get-windowtop cad))
    )
    (list
      (+ lft (vla-get-width cad))
      (+ top (vla-get-height cad))
    )
  )
)

; 20170118: Moved update functions to Osnaps-FormStateRestore.
; 20170117: Added support for Osnaps-FormStateRestore and Save.
; 20170117: Added :vlr-sysvarwillchange event.
; 20161126: Using revised update functions.
; 20161116: Udated code for hiding GCE button.
; 20161112
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
      (:vlr-sysvarchanged    . Osnaps-CallBackSysvarChanged)
      (:vlr-sysvarwillchange . Osnaps-CallBackSysvarWillChange)
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
  (Osnaps-FormStateRestore 1)
  (Osnaps-FormStateSave 0)
  ;; Hide the GCE (Geometric CEnter) button in older versions of BricsCAD and AutoCAD:
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
  (princ)
)

; 20170117: Revised.
; 20161126: Revised.
; 20161112
(defun Osnaps-CallBackSysvarChanged (rea lst)
  (cond
    ((= "OSMODE" (car lst))
      (Osnaps-UpdateOsmode nil)
    )
    ((= "OSNAPZ" (car lst))
      (Osnaps-UpdateOsnapz nil)
    )
    ((= "WSCURRENT" (car lst))
      (Osnaps-FormStateRestore 0)
    )
  )
)

; 20170117
(defun Osnaps-CallBackSysvarWillChange (rea lst)
  (if (= "WSCURRENT" (car lst))
    (Osnaps-FormStateSave 0)
  )
)

; 20161126: Revised.
; 20161112
(defun Osnaps-CallBackDocumentBecameCurrent (rea lst)
  (Osnaps-UpdateForm   nil)
  (Osnaps-UpdateOsmode nil)
  (Osnaps-UpdateOsnapz nil)
)

; 20170117: Added support for Osnaps-FormStateSave.
; 20161126: Revised.
; 20161112
(defun Osnaps-CallBackDocumentToBeDeactivated (rea lst)
  (Osnaps-FormStateSave 0)
  (Osnaps-UpdateForm    T)
  (Osnaps-UpdateOsmode  T)
  (Osnaps-UpdateOsnapz  T)
)

; 20161126: Revised.
; 20161112
(defun Osnaps-CallBackCommandCancelled (rea lst)
  (if (vl-position (car lst) '("OPEN" "QNEW"))
    (progn
      (Osnaps-UpdateForm   nil)
      (Osnaps-UpdateOsmode nil)
      (Osnaps-UpdateOsnapz nil)
    )
  )
)

; 20161126: Revised.
; 20161112
(defun Osnaps-CallBackCommandWillStart (rea lst)
  (if (vl-position (car lst) '("OPEN" "QNEW"))
    (progn
      (Osnaps-UpdateForm   T)
      (Osnaps-UpdateOsmode T)
      (Osnaps-UpdateOsnapz T)
    )
  )
)

; 20170125: Introduced function to validate the position from the registry.
; 20170118: Function now enables the form and updates the buttons.
; 20170118: Changed the key.
; 20170117
(defun Osnaps-FormStateRestore (opt / key nme) ; Opt: 1=show; 0=read value from registry.
  (setq key "HKEY_CURRENT_USER\\Software\\BKG_Software\\Osnaps\\Dialogs")
  (setq nme (strcat "Main-WS-" (strcase (getvar 'wscurrent))))
  (cond
    ((not Osnaps/Main)
      nil
    )
    ((setq val (vl-registry-read key nme))
      (setq val (read val))
      (if (or (= 1 opt) (= "show" (car val)))
        (progn
          (if (not (dcl-Form-IsActive Osnaps/Main))
            (dcl-Form-Show Osnaps/Main)
          )
          (apply
            'dcl-Control-SetPos
            (cons Osnaps/Main (Osnaps-FormPosCheck (list (cadr val) (caddr val))))
          )
          (dcl-Form-Enable Osnaps/Main T)
          (Osnaps-UpdateOsmode nil)
          (Osnaps-UpdateOsnapz nil)
        )
        (if (dcl-Form-IsActive Osnaps/Main)
          (dcl-Form-Close Osnaps/Main)
        )
      )
    )
    (T
      (dcl-Form-Show Osnaps/Main)
      (dcl-Form-Enable Osnaps/Main T)
      (Osnaps-UpdateOsmode nil)
      (Osnaps-UpdateOsnapz nil)
    )
  )
)

; 20170129: Form position now relative to the CAD window.
; 20170118: Changed the key.
; 20170117
(defun Osnaps-FormStateSave (opt / key nme val) ; Opt: 0=read value from form; -1=hide.
  (setq key "HKEY_CURRENT_USER\\Software\\BKG_Software\\Osnaps\\Dialogs")
  (setq nme (strcat "Main-WS-" (strcase (getvar 'wscurrent))))
  (cond
    ((not Osnaps/Main)
      nil
    )
    ((dcl-Form-IsActive Osnaps/Main)
      (vl-registry-write
        key
        nme
        (vl-prin1-to-string
          (cons
            (if (= -1 opt) "hide" "show")
            (mapcar
              '-
              (dcl-Control-GetPos Osnaps/Main)
              (car (Osnaps-CadWindow)) ; TL of CAD window.
            )
          )
        )
      )
    )
    ((setq val (vl-registry-read key nme))
      (vl-registry-write
        key
        nme
        (vl-prin1-to-string (cons "hide" (cdr (read val))))
      )
    )
  )
)

; 20170118
(defun Osnaps-FormDisplay (opt) ; ; Opt: 1=show; 0=toggle; -1=hide.
  (cond
    ((dcl-Form-IsActive Osnaps/Main)
      (if (/= 1 opt)
        (progn
          (Osnaps-FormStateSave -1)
          (dcl-Form-Close Osnaps/Main)
        )
      )
    )
    (Osnaps/Main
      (if (/= -1 opt)
        (progn
          (Osnaps-FormStateRestore 1)
          (Osnaps-FormStateSave 0)
        )
      )
    )
    (T
      (princ "\nError: dialog not found ")
    )
  )
  (princ)
)

; 20170129: Form position now relative to the CAD window.
; 20170129: Renamed from Osnaps-FormPosition.
; 20170125
; See: http://www.opendcl.com/forum/index.php?topic=1625.0
(defun Osnaps-FormPosCheck (pos / cadWnd wid hgt); Pos: Relative to TL of CAD window.
  (setq cadWnd (Osnaps-CadWindow)) ; Format: (TL BR).
  (setq pos (mapcar '+ pos (car cadWnd)))
  (setq wid (dcl-Control-GetWidth Osnaps/Main))
  (setq hgt (dcl-Control-GetHeight Osnaps/Main))
  (if
    (and
      (< (caar cadWnd) (car pos) (caadr cadWnd))
      (< (caar cadWnd) (+ wid (car pos)) (caadr cadWnd))
      (< (cadar cadWnd) (cadr pos) (cadadr cadWnd))
      (< (cadar cadWnd) (+ hgt (cadr pos)) (cadadr cadWnd))
    )
    pos
    (mapcar
      '(lambda (coord cadDim formDim) (+ coord (/ cadDim 2) (/ formDim -2)))
      (car cadWnd)
      (apply 'mapcar (cons '- (reverse cadWnd))) ; (Width Height) of cad window.
      (list wid hgt) ; (Width Height) of form.
    )
  )
)

; 20161126
(defun Osnaps-UpdateForm (disableP)
  (if (dcl-Form-IsActive Osnaps/Main)
    (dcl-Form-Enable Osnaps/Main (not disableP))
  )
)

; 20161126 : A separate function handles the form.
; 20161126 : Renamed from (Osnaps-UpdateButtons).
; 20161114B: Now using boole instead of logand.
; 20161114 : Button NON added.
; 20161112
(defun Osnaps-UpdateOsmode (disableP / osm)
  (setq osm (getvar 'osmode))
  (mapcar
    '(lambda (bit btn)
      (if (setq btn (eval (read (strcat "Osnaps/Main/btn" btn))))
        (cond
          ((= 0 bit)
            (dcl-Control-SetBackColor
              btn
              (cond
                (disableP                -16)
                ((zerop osm) *OsnapsOnColor*)
                (T          *OsnapsOffColor*)
              )
            )
          )
          ((= 16384 bit)
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
                (dcl-Control-SetBackColor btn 32285301)
                (dcl-Control-SetForeColor btn 0)
              )
            )
          )
          (T
            (dcl-Control-SetBackColor
              btn
              (cond
                (disableP                              -16)
                ((= bit (boole 1 osm bit)) *OsnapsOnColor*)
                (T                        *OsnapsOffColor*)
              )
            )
          )
        )
      )
    )
    '(    0     1     2     4     8    16    32    64   128   256   512  1024  2048  4096  8192   16384)
    '("Non" "End" "Mid" "Cen" "Nod" "Qua" "Int" "Ins" "Per" "Tan" "Nea" "Gce" "App" "Ext" "Par" "OnOff")
  )
)

; 20161126
; Button does not update properly in BricsCAD V14 (vlr-sysvar-reactor does not work for OSNAPZ).
(defun Osnaps-UpdateOsnapz (disableP / btn)
  (if (setq btn Osnaps/Main/btnOsnapz)
    (cond
      (disableP
        (dcl-Control-SetBackColor btn -16)
        (dcl-Control-SetForeColor btn -19)
      )
      ((zerop (getvar 'osnapz))
        (dcl-Control-SetBackColor btn 0)
        (dcl-Control-SetForeColor btn 7)
      )
      (T
        (dcl-Control-SetBackColor btn 32285301)
        (dcl-Control-SetForeColor btn 0)
      )
    )
  )
)

; 20170117 : Added support for Osnaps-FormStateSave.
; 20161202 : Event handler for OSNAPZ revised. Now GRIDMODE is also changed.
; 20161126 : Button OZ (OSNAPZ) added.
; 20161116B: Event handlers for INT and APP were not correct.
; 20161116 : Event handlers revised.
;           (boole 2 (getvar 'osmode) 16384) added to match the BricsCAD 'Entity Snaps' toolbar.
; 20161114 : Event handlers revised. Button NON added.
; 20161112
; OSMODE:
(defun c:Osnaps/Main/btnNon#OnClicked    () (setvar 'osmode 0) (princ))
(defun c:Osnaps/Main/btnEnd#OnClicked    () (setvar 'osmode (boole 6 (boole 2 (getvar 'osmode) 16384)    1)) (princ))
(defun c:Osnaps/Main/btnMid#OnClicked    () (setvar 'osmode (boole 6 (boole 2 (getvar 'osmode) 16384)    2)) (princ))
(defun c:Osnaps/Main/btnCen#OnClicked    () (setvar 'osmode (boole 6 (boole 2 (getvar 'osmode) 16384)    4)) (princ))
(defun c:Osnaps/Main/btnNod#OnClicked    () (setvar 'osmode (boole 6 (boole 2 (getvar 'osmode) 16384)    8)) (princ))
(defun c:Osnaps/Main/btnQua#OnClicked    () (setvar 'osmode (boole 6 (boole 2 (getvar 'osmode) 16384)   16)) (princ))
(defun c:Osnaps/Main/btnInt#OnClicked    ()
  (setvar 'osmode
    (if (zerop (boole 1 (getvar 'osmode) 32)) ; INT is off.
      (boole 2                                ; Switch APP (2048) off.
        (boole 7 (getvar 'osmode) 32)         ; Switch INT on.
        (+ 2048 16384)
      )
      (boole 2 (getvar 'osmode) (+ 32 16384)) ; Switch INT off.
    )
  )
  (princ)
)
(defun c:Osnaps/Main/btnIns#OnClicked    () (setvar 'osmode (boole 6 (boole 2 (getvar 'osmode) 16384)   64)) (princ))
(defun c:Osnaps/Main/btnPer#OnClicked    () (setvar 'osmode (boole 6 (boole 2 (getvar 'osmode) 16384)  128)) (princ))
(defun c:Osnaps/Main/btnTan#OnClicked    () (setvar 'osmode (boole 6 (boole 2 (getvar 'osmode) 16384)  256)) (princ))
(defun c:Osnaps/Main/btnNea#OnClicked    () (setvar 'osmode (boole 6 (boole 2 (getvar 'osmode) 16384)  512)) (princ))
(defun c:Osnaps/Main/btnGce#OnClicked    () (setvar 'osmode (boole 6 (boole 2 (getvar 'osmode) 16384) 1024)) (princ))
(defun c:Osnaps/Main/btnApp#OnClicked    ()
  (setvar 'osmode
    (if (zerop (boole 1 (getvar 'osmode) 2048)) ; APP is off.
      (boole 2                                  ; Switch INT (32) off.
        (boole 7 (getvar 'osmode) 2048)         ; Switch APP on.
        (+ 32 16384)
      )
      (boole 2 (getvar 'osmode) (+ 2048 16384)) ; Switch APP off.
    )
  )
  (princ)
)
(defun c:Osnaps/Main/btnExt#OnClicked    () (setvar 'osmode (boole 6 (boole 2 (getvar 'osmode) 16384) 4096)) (princ))
(defun c:Osnaps/Main/btnPar#OnClicked    () (setvar 'osmode (boole 6 (boole 2 (getvar 'osmode) 16384) 8192)) (princ))
(defun c:Osnaps/Main/btnOnOff#OnClicked  () (setvar 'osmode (boole 6 (getvar 'osmode) 16384)) (princ))
; OSNAPZ:
(defun c:Osnaps/Main/btnOsnapz#OnClicked () (setvar 'gridmode (setvar 'osnapz (boole 6 (getvar 'osnapz) 1))) (princ))
; OTHER:
(defun c:Osnaps/Main/btnClose#OnClicked  ()
  (Osnaps-FormStateSave -1)
  (dcl-Form-Close Osnaps/Main)
  (princ)
)

; 20170118: Revised.
; 20170117
; Toggles the display of the form.
(defun c:Osnaps-FormToggle ()
  (Osnaps-FormDisplay 0)
  (princ)
)

; 20170118
; Toggles the osnaps (the 16384 bit) and changes the display of the form to match.
(defun c:Osnaps-Toggle ()
  (setvar 'osmode (boole 6 (getvar 'osmode) 16384))
  (Osnaps-FormDisplay (if (zerop (boole 1 (getvar 'osmode) 16384)) 1 -1))
  (princ)
)

(Osnaps-OnLoad) ; Starts the reactors, loads the ODCL and updates the dialog.
(princ)
