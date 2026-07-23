;;;							;
;;;	Drawing Manager	v1.0				;
;;;							;

;;;							;
;;;	An OpenDCL sample project by:			;
;;;	James Buzbee					;
;;;							;

(vl-load-com)
(command "OpenDCL")
;;;							;
;;;	Load OpenDCL project				;
;;;							;

(if (not (vl-bb-ref 'kbdwgManager))
  (vl-bb-set
    'kbdwgManager
    (dcl_project_import
      '("YWt6Ay4UAABJRfEvBuKTJiURKitqgHi1CiVxrEo2um5N71RaIJb7JJ4zZmCq6NzzZPZRDd0oNNUI"
"dPppYfPJSVH3wb55quTeWFhY+IbeEUKEnnFOIL9uXLhOABWzR6MF0TDZZxS/ebEa4c3Bw6jA0IvT"
"zbCKSNBJ7ujgXDAddJ1WH+gbdEvC/GL+9aM+MeBrVIvpT/TDBmobKk76P0IyKxfXz8h5uU++CBdV"
"LZlGFYVWZduYftSCk5vR8h8UlNpzZw/6U0vyzjH3JEywVhW9l/Yr8K1iLwQoJ+0PeIfVztu6Bfsk"
"zOxCbCeTY+6VYMZiSF7DKKTjRfsC1Ozte8fNbwDe/IMWqxEJtahj5l5UHPA1BPLb8Bfi3MowF2vQ"
"b/ODrvPyA/bb0Abky1dimCKzh1inoOK3gx6ICkS8g0lMkZ1SrcThbBgGQVWNwhGYB7WeAlC4GfKi"
"Z4fJlrWS62SwQ/PQ0jcylSCr+SCplkKQVRI6Dsd1YNUA4amB+EsJJdBVrIG8tWsBGI6Z2IEH8YFo"
"hxWWsA49qM1dDMezO2Ae9/mkSii/RKEJ70ii0AaKOtrla0Acw0dB2GrVr2Q9DvdHp/OYGkFPjPFy"
"gKaeDXixUuc/aZYwZgIMF5/H1QxyDTiA3L8R5I8BI6QlbSGJhBS4oTKBIejww/eFM4GhgwQqoLzN"
"SL4bM98pg1a1kUwgS5+b954CGvRTk9MiHnZm2n95nmhvBaHZuMUFcsAeqE9ls+Xy7Yp76Gmqcxgm"
"UYxAe4nbIZEbpzG+/CBnmT+97MXCwiGOb/HBaYLqucV6gRKCiABRgS4mDKadk9yB2h+r5r+deEEf"
"zpu3MA0wfxFoJ+zTwqPXDhanJZ5+8Tacm3dCNf2rFsi/m4KnyrACBLCeyXMAox616UlyQBSOT/3h"
"ISnAW7kG3A1GN3lqudGMBzoVFZ6fMZzJUWXFecJqP7a1/J7LjFWet1u/dfhZkeeAfxE6boyYMb9h"
"hoAsdwfahJHki7jCpIdymJfee2CSYmisBPuJUntWjnvOvgTjjCdcB2jO3E986OA5sixPP7YsoyNl"
"6NRCHpdYCrisVVK3Axc5HuUbl5PtBjeN8gTEq2hiy+LG/CvN966pfKGX7eYLp50FO4D5v+ny0Qqe"
"NczQKwO7hDge0w320wsJkJi4KsvoFll0pZtcU5KKAVDMIMe2HBAnUKxFP5yq6olLmwDi5bKh7GKa"
"0SsMbmPJLQDKtz8qYI6blSW/6eAK3Z6p6J81iWazT7G2CP7/hPKzSESCUKLzBsqSZcoyTWKqZlTH"
"8AABgKnnFs1ctTLlm4qAhZlI1xAC7pAiLLyWx9MNiCqqqcWmNSCOoBgV9mKpMprOp+xMGsG5pXrx"
"5LauWCxWwHfvnGPKtsRw25HfEuCrXLmoimHfMgG2kh3xZ6E45B/N0e/IJ6WI67Lnmxkn+sjPR/Ie"
"JW45zjttv0qhlF5BLYdAzbFwXeQigX5nPv3E")
      )
    )
  )

;;;							;
;;;	Control Functions				;
;;;							;

;;;	OnInitialize event				;

(defun c:DwgManager/DwgManager#OnInitialize (/)
  (dcl-ListBox-Clear DwgManager/DwgManager/ListBox)
  (foreach x (kb:docnamelist)
  (dcl-ListBox-AddString DwgManager/DwgManager/ListBox x))
  (princ)(princ)
)

;;;	EnteringNoDocState event			;

(defun c:DwgManager/DwgManager#OnEnteringNoDocState (/)
  (dcl-Form-Close DwgManager/DwgManager)
)

;;;	DocActivated event				;

(defun c:DwgManager/DwgManager#OnDocActivated (/)
  (c:DwgManager/DwgManager#OnInitialize)
)

;;;	ListBox#OnSelChanged				;

(defun c:DwgManager/DwgManager/ListBox#OnSelChanged (ItemIndexOrCount Value /)
  (dcl-BlockView-DisplayDwg DwgManager/DwgManager/BlockView1 Value)
(princ value))

;;;	ListBox#OnDblClicked				;

(defun c:DwgManager/DwgManager/ListBox#OnDblClicked (/ ItemIndex docname docs)
  (setq ItemIndex(dcl-ListBox-GetCurSel DwgManager/DwgManager/ListBox)
        docname(dcl-ListBox-GetItemText DwgManager/DwgManager/ListBox ItemIndex)
        docs(vla-get-documents(vlax-get-acad-object))
       )
  (vla-activate(vla-item docs ItemIndex))
  (princ docname)(princ)
)
;(vlax-dump-Object docs t)
;;;							;
;;;	Sub Functions					;
;;;							;

(defun kb:docnamelist  (/ doc docs1)
  (vlax-for
         doc  (vla-get-documents (vlax-get-acad-object))
      (setq docs1 (cons (strcase (vla-get-fullname doc)) docs1)))
  (reverse docs1))

(defun kb:doclist  (/ doc docs1)
  (vlax-for
         doc  (vla-get-documents (vlax-get-acad-object))
    (if (= (vla-get-fullname doc) "")
      (setq docs1 (cons (strcase (vla-get-name doc)) docs1)
            docs1 (cons doc docs1))
      (setq docs1 (cons (strcase (vla-get-fullname doc)) docs1)
            docs1 (cons doc docs1))))
  (reverse docs1))
    
;;;							;
;;;	Command Interface				;
;;;							;

(defun c:kbDwgManager( / )
  (if (not (member "DwgManager" (dcl_GetProjects)))
    (dcl_Project_load "DwgManager")
    )
  (if dcl_HideErrorMsgBox
    (if (not(dcl_form_isactive DwgManager/DwgManager))
	      (dcl_Form_Show DwgManager/DwgManager))

    (alert "The OpenDCL arx module did not load!")
    )
  (princ)
  (princ)
  )

(if (dcl-Form-isactive DwgManager/DwgManager)
           (c:DwgManager/DwgManager#OnInitialize))