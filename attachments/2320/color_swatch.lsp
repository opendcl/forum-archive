(vl-load-com)

(setvar 'cmdecho 0)
(vl-cmdf "_Opendcl")
(setvar 'cmdecho 1)


;=======================================================
; change layer color mechanism
;=======================================================


(defun XYZ_laycmnd ( lyr / ss1 p1 idx)

  (if (and (tblsearch "LAYER" lyr)
           (setq ss1 (ssget "_I"))
      )
    							;;; if selection, change to layer
    (repeat (setq idx (sslength ss1))
      (vla-put-layer
        (vlax-ename->vla-object (ssname ss1 (setq idx (1- idx))))
        lyr
      )
    )
    							;;; if no selection, start drawing line on layer
    (progn
      (command "layer" "set" lyr "on" lyr "")
							;;;      (if (setq p1 (getpoint "LINE From point: "))
							;;;        (command "line" p1)
							;;;      ) ;if
    ) 							;;;  progn
  ) 							;;; if
)


;=======================================================
;change properties
;=======================================================



(defun c:Lac ( / ss)
  (if
    (setq ss
      (if (zerop (getvar 'pickfirst))
        (progn (sssetfirst nil nil) (ssget ":L"))
        (ssget "_:L-I")
      )
    )
    (command "_.laycur" ss "")
  )
  (princ)
)





(DEFUN C:LaC_byblock ( / )
  (setvar "cmdecho" 0)
  (setq ss2 (getvar "clayer"))
  (command "-layer" "on" ss2 "" "")
  (if (not (setq #ss (ssget "_I"))) (setq #ss (ssget)))
  (COMMAND "CHANGE" #ss "" "PROP" "co" "byblock" "")
  (setvar "cmdecho" 1)
  ;(setvar "clayer" ss2)
  (princ)
  )




(DEFUN C:LaC_bylayer ( / )
  (setvar "cmdecho" 0)
  (setq ss2 (getvar "clayer"))
  (command "-layer" "on" ss2 "" "") 
  (if (not (setq #ss (ssget "_I"))) (setq #ss (ssget)))
  (COMMAND "CHANGE" #ss "" "PROP" "co" "bylayer" "")
  (setvar "cmdecho" 1)
  ;(setvar "clayer" ss2)
  (princ)
  )

;=======================================================
;layercheck
;=======================================================




;=======================================================
;main
;=======================================================

(defun c:CSW ( / idx ret)
  (setq idx 0)
  (repeat 256
    (eval
      (read
        (strcat
          "(defun c:color_swatch/COLOR_SWATCH/COLOR" (itoa (setq idx (1+ idx))) "#OnClicked ()"
            "(ColorButtonOnClick " (itoa idx) ")"
          ")"
        )
      )
    )
  )
  (dcl-LoadProject "color_swatch")
  (setq ret (dcl-Form-Show color_swatch/COLOR_SWATCH))
  (cond
    ((= 1000 ret) ; Exit.
      nil
    )
    ((= 0 ret)
     (progn
      (princ "\nByBlock")
      (command "color" "byblock")
      (c:lac_byblock)
    )
     )
    ((= 256 ret)
     (progn
      (princ "\nByLayer")
      (command "color" "bylayer")
      (c:lac_bylayer)
      )
    )
    ((= 257 ret)
     (progn
      (princ "\nByLayer")
      (command "color" "bylayer")
      (PRINC "\nHI")
      )
    )

    (T
     (progn
         (princ "CSW menu loaded")
       )
     )
  );_cond
);_defun
    
;;;    (T
;;;     (progn
;;;      (setq itoaret (itoa ret))
;;;      (princ (strcat "\nACI " (itoa ret)))
;;;      (setq flag (tblsearch "LAYER" itoaret))
;;;      (if flag  (XYZ_laycmnd itoaret)
;;;          (progn (command "layer" "m" itoaret "c" itoaret "" "s" itoaret "") (XYZ_laycmnd itoaret)))
;;;      (c:lac)					    
;;;      )
;;;    )
;;;   )
;;;  (princ)
;;;)


    
(defun ColorButtonOnClick (idx)
    (setq itoaidx (itoa idx))
    (setq rtosidx (rtos (float idx) 2 0))

    
    (if (not (tblsearch "layer" rtosidx))  
        (progn
             	(setq oldcmdecho (getvar "cmdecho"))
                (setvar "cmdecho" 0)
                (command "layer" "m" rtosidx "c" rtosidx "" "s" rtosidx "")
        
        							    ;	(entmake ; fragment taken from LM's entmake functions
  								    ; 	(list 
  								    ;   (cons 0 "LAYER") (cons 100 "AcDbSymbolTableRecord") (cons 100 "AcDbLayerTableRecord") (cons 2 rtosidx) (cons 62 atoiidx)))
                (setvar "cmdecho" oldcmdecho)
            );end progn
	(progn
            (command "layer" "s" rtosidx "")
            );end progn
    )
       (c:lac)
)






(defun Layer (Nme Col Ltyp LWgt)
  (entmake (list (cons 0 "LAYER")
                 (cons 100 "AcDbSymbolTableRecord")
                 (cons 100 "AcDbLayerTableRecord")
                 (cons 2  Nme)
                 (cons 70 0)
                 (cons 62 Col)
                 (cons 370 LWgt)))
(princ (strcat "\n " Nme " created: "))
(princ)
)



 




(defun c:color_swatch/COLOR_SWATCH/EXITBUTTON#OnClicked ()
  (dcl-Form-Close color_swatch/COLOR_SWATCH 1000)
)

(defun c:color_swatch/COLOR_SWATCH/BBLOCK#OnClicked ()
  ;(dcl-Form-Close color_swatch/COLOR_SWATCH 0)
    (c:lac_byblock)
)

(defun c:color_swatch/COLOR_SWATCH/BLAYER#OnClicked ()
  ;(dcl-Form-Close color_swatch/COLOR_SWATCH 256)
    (c:lac_bylayer)
)


;; copied from FormMover


(defun c:color_swatch/COLOR_SWATCH/cmdExpand#OnClicked ( / );_ expand and collapse the view
	(if (= (Car (dcl-Form-GetControlArea color_swatch/COLOR_SWATCH)) 750)
		(progn
			(dcl-Form-Resize color_swatch/COLOR_SWATCH 751 420)
			(dcl-Control-SetPicture color_swatch/COLOR_SWATCH/cmdExpand 100)
		) ;_progn
            	(progn
			(dcl-Form-Resize color_swatch/COLOR_SWATCH 750 20)
			(dcl-Control-SetPicture color_swatch/COLOR_SWATCH/cmdExpand 101)
		) ;_progn
            );_ if
    

)

(princ)



;|«Visual LISP© Format Options»
(80 4 50 2 nil "end of " 80 50 0 0 2 nil nil nil T)
;*** DO NOT add text below the comment! ***|;
