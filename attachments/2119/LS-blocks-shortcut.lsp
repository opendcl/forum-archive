;ls:9blocks
;v1.0 (2015/04/20)
;9 blocks interface insertion
;oname      : titlebar text
;olistblock : list of 9 couples with block name and scale (ex: (list (list "bloc1.dwg" 1) (list "bloc2.dwg" 2) ... (list "bloc9.dwg" (getvar "dimscale")))

;ex: (ls:9blocks "Bulle de Coupe"
      ;(list 
        ;(list "LSP_BLK\\imgCoupeHG.dwg" (getvar "dimscale"))
        ;(list "LSP_BLK\\imgCoupeH.dwg"  (getvar "dimscale"))
        ;(list "LSP_BLK\\imgCoupeHD.dwg" (getvar "dimscale"))
        ;(list "LSP_BLK\\imgCoupeG.dwg"  (getvar "dimscale"))
        ;(list "LSP_BLK\\imgCoupeC.dwg"  (getvar "dimscale"))
        ;(list "LSP_BLK\\imgCoupeD.dwg"  (getvar "dimscale"))
        ;(list "LSP_BLK\\imgCoupeBG.dwg" (getvar "dimscale"))
        ;(list "LSP_BLK\\imgCoupeB.dwg"  (getvar "dimscale"))
        ;(list "LSP_BLK\\imgCoupeBD.dwg" (getvar "dimscale"))
      ;)
     ;)
(defun ls:9blocks (oName olistblock / oloop cmdecho)
  ;; Load the project
  (defun ls:loadblockshortcut ()
    (setq cmdecho (getvar "CMDECHO"))
    (setvar "CMDECHO" 0)
    (command "_OPENDCL")
    (setvar "CMDECHO" cmdecho)
    (dcl-Project-Load (findfile "LS-blocks-shortcut.odcl"))
    ;; Show the main form
    (dcl-Form-Show LS-blocks-shortcut/9-blocks)
  )
  ;;oninitialize event
  (defun c:LS-blocks-shortcut/9-blocks#OnInitialize (/)
    (dcl-Control-SetTitleBarText LS-blocks-shortcut/9-blocks oName)
    ;; add blocks view
    (setq oloop 0)
      (foreach % olistblock
        (dcl-BlockView-LoadDwg (eval(read (strcat "LS-blocks-shortcut/9-blocks/Block" (itoa oloop)))) (findfile (car %)))
        (setq oloop (+ oloop 1))
      )
  )
  ;generate 9 onclick events for block insertion
  (setq oloop 0)
  (repeat 9
    (eval (read (strcat "(defun c:LS-blocks-shortcut/9-blocks/Block" (itoa oloop) "#OnClicked (/)(dcl-Project-Unload \"LS-blocks-shortcut\" T) (command \"insert\" (findfile(car(nth " (itoa oloop) " olistblock))) \"s\" (cadr(nth " (itoa oloop) " olistblock))))")))
    (setq oloop (+ oloop 1))
  )

(ls:loadblockshortcut)
(princ)
)
;sample
(defun c:9b ()
  (ls:9blocks "Bulle de Coupe"
    (list 
      (list "LSP_BLK\\imgCoupeHG.dwg" (getvar "dimscale"))
      (list "LSP_BLK\\imgCoupeH.dwg"  (getvar "dimscale"))
      (list "LSP_BLK\\imgCoupeHD.dwg" (getvar "dimscale"))
      (list "LSP_BLK\\imgCoupeG.dwg"  (getvar "dimscale"))
      (list "LSP_BLK\\imgCoupeC.dwg"  (getvar "dimscale"))
      (list "LSP_BLK\\imgCoupeD.dwg"  (getvar "dimscale"))
      (list "LSP_BLK\\imgCoupeBG.dwg" (getvar "dimscale"))
      (list "LSP_BLK\\imgCoupeB.dwg"  (getvar "dimscale"))
      (list "LSP_BLK\\imgCoupeBD.dwg" (getvar "dimscale"))
    )
  )
  (princ)
)