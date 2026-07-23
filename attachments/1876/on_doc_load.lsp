(acad-Push-DbMod)
(setvar "cmdecho" 0)
(command "undefine" "open")

(defun MsgBox (strPrompt strTitle lngFlags intTimeout / app rVal)
  (setq app (vlax-create-object "WScript.Shell"))
  (setq rVal (vlax-invoke app 'Popup strPrompt intTimeout strTitle lngFlags))
  (vlax-release-object app)
  rVal
)

(defun c:open ( / item name new_file)
  (vlax-for item (vla-get-documents (vlax-get-acad-object))                              ; for all open drawings..  .
    (if (or (= (getvar "dbmod") 0)                                                       ; has drawing been modified?                             
            (= (vla-get-saved item) :vlax-true)                                          ; has drawing been saved?
        )    
      (vla-close item :vlax-false)                                                       ; automatic close if not modified 
      (progn                                                                             ; drawings has been modified...
        (setq name (vla-get-fullname item))                                              ; get the drawing's name
        (if (= name "")                                                                  ; if drawing has not been nemed...      
          (setq name "Drawing1.dwg")                                                     ; name it
        )
        (vla-activate item)                                                              ; make drawing current
        (setq val (msgbox (strcat "Save changes to " name " ?") "Bricscad" 35 0))        ; show save box
        (cond ((= val 2)
                (exit)
              )  
              ((= val 6)        
                (vla-close item :vlax-true)                                              ; save and close 
              )   
              (t 
                (vla-close item :vlax-false)                                             ; close, no save 
              )   
        )
      )
    )
  )  
  (setq new_file (getfiled "Open Drawing" "" "dwg" 16))                                  ; call file open dialog
  (if (vl-file-rename new_file new_file)
    (vla-activate                                                                        ; open and activate the new drawing
      (vla-open (vla-get-documents (vlax-get-acad-object)) new_file)
    )
    (progn
      (setq val (msgbox                                                                  ; show save box
                  (strcat "File " new_file " is already open. Open as Read Only?") 
                  "Bricscad" 
                  35 
                  0
                )
      )
      (if (= val 6)        
        (vla-activate                                                                    ; open and activate the new drawing
          (vla-open (vla-get-documents (vlax-get-acad-object)) new_file :vlax-true)
        )
      )  
    )     
  )  
  (princ)
)

(setvar "cmdecho" 0)
(princ "\nSetup files loading...")
(load "c:/CADmaster/ddchtext.lsp")
(princ "\nddchtext.lsp has been loaded...")
(load "c:/CADmaster/enco express V13.lsp")
(princ "\nC:\CADmaster\enco express V13.lsp has been loaded...")
(load "c:/CADmaster/encoutils V13.lsp")
(princ "\nC:\CADmaster\encoutils V13.lsp has been loaded...")
(command "-style" "romans" "romans.shx" "0.0" "1.0" "0.0" "N")
(while (> (getvar "cmdactive") 0)
  (command "N")
)
(command "-style" "enco_romans" "enco_romans.shx" "0.0" "1.0" "0.0" "N")
(while (> (getvar "cmdactive") 0)
  (command "N")
)
(command "-style" "enco_romand" "enco_romand.shx" "0.0" "1.0" "0.0" "N")
(while (> (getvar "cmdactive") 0)
  (command "N")
)
(command "-style" "enco_bold" "enco_bold.shx" "0.0" "1.0" "0.0" "N")
(while (> (getvar "cmdactive") 0)
  (command "N")
)
(command "-style" "enco-thin" "enco-t.shx" "0.0" "1.0" "0.0" "N")
(while (> (getvar "cmdactive") 0)
  (command "N")
)
(command "-style" "enco-medium" "enco-m.shx" "0.0" "1.0" "0.0" "N")
(while (> (getvar "cmdactive") 0)
  (command "N")
)
(command "-style" "enco-bold" "enco-b.shx" "0.0" "1.0" "0.0" "N")
(while (> (getvar "cmdactive") 0)
  (command "N")
)
(command "-style" "enco3" "enco3.shx" "0.0" "1.0" "0.0" "N")
(while (> (getvar "cmdactive") 0)
  (command "N")
)
(SETVAR "AUNITS" 0)
(SETVAR "AUPREC" 8)
(SETVAR "LUNITS" 2)
(SETVAR "LUPREC" 8)
(SETVAR "ANGBASE" 0)
(SETVAR "ANGDIR" 0)
(SETVAR "VISRETAIN" 1)
(SETVAR "EXPERT" 1)
(SETVAR "MIRRTEXT" 0)
(SETVAR "BLIPMODE" 0)
(SETVAR "UCSICON" 0)
(SETVAR "gridmode" 0)
(SETVAR "snapmode" 0)
(command "viewres" "Y" 2500)
(SETVAR "splinesegs" 100)
(setvar "isavebak" 1)
(setvar "isavepercent" 0)
(setvar "proxynotice" 0)
(setvar "dragp1" 100)
(setvar "dragp2" 100)
(setvar "osmode" 0)
(setvar "filletrad" 0.0)
(setvar "highlight" 1)
(GRAPHSCR)
(if (null (tblsearch "layer" "power"))
  (command "-layer" "make" "power" "color" "cyan" "power" "")
)
(setvar "clayer" "power")
(set_scale_icon)
(startapp "\"C:\\CADMaster\\AutoHotKey.exe\""
          "\"C:\\CADMaster\\enco_keys_bc.ahk\""
)
(setvar "cmdecho" 1)
(print "Initial setup is complete.")
(acad-Pop-DbMod)
(princ)
