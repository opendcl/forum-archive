;;;                                   Copyright© 2012 by Nick Haury                                        ;;;
;;;********************************************************************************************************;;;
;;;                                         Start Routine                                                  ;;;
(defun c:smc (/ *error* shape mbrs ch cl custDepth
                memshna memstyna p1 p2 p3 p4
                p5 sp s_cmd s_orth s_osm custWidth
                x1 x2 x3 y1 y2
             )
  (setq CL (getvar "CLAYER")       ; Stores Current Layer     
        S_CMD  (getvar "CMDECHO")  ; Stores Command Mode State
        S_ORTH (getvar "ORTHOMODE"); Stores Orthomode State   
        S_OSM  (getvar "OSMODE")   ; Stores Object Snap State 
        mbrs   1
  )                                ; End setq                 
  (setvar "CMDECHO" 1)             ; No echo                  
  (setvar "ORTHOMODE" 1)           ; Ortho on                 
  (setvar "OSMODE" 0)              ; Snap None                
  (command "_OPENDCL")             ; Start ODCL               
  (dcl_Project_Load "Structural Member Creator.odcl" T)
  (dcl_Form_Show SMC)
  (princ)


;;;                                          Initilize                                                     ;;;
; (defun c:SMC_OnInitialize (/)
;   (dcl_MessageBox "Hello, look at this, this section works, so far.")
; )
;;;                                            Width                                                       ;;;
 (defun c:CustomWidth_OnEditChanged (NewValue /)
	 (if (distof NewValue)(setq custWidth (distof NewValue)))
	 (princ)
 ); end defun
;;;                                            Depth                                                       ;;;
 (defun c:CustomDepth_OnEditChanged (NewValue /)
	 (if (distof NewValue)(setq custDepth (distof NewValue)))
	 (princ)
 ); end defun
;;;                                      Member Shape Name                                                 ;;;
 (defun c:MemShapeName_OnEditChanged (NewValue /)
   (setq memshna NewValue)
   (princ)
 ); end defun
;;;                                             Member Style Name                                          ;;;
 (defun c:MemStyleName_OnEditChanged (NewValue /)
   (setq memstyna NewValue)
   (princ)
 ); end defun
;;;                                      Members                                                           ;;;
 (defun c:MemStyleQty_OnSelChanged (ItemIndexOrCount Value /)
	 (setq mbrs ItemIndexOrCount)
	 (princ)
 ); end defun
;;;                                              Create Member                                             ;;;
 (defun c:create_OnClicked (/)
;;;             Check to see if shape already exist in Dictionary                                          ;;;
  (setq shapes (kcs_getkeys "AECS_MEMBER_NODE_SHAPE")); Returns a list of existing shapes
  (if (not (member memshna shapes))                   ; if shape doesn't exist, make it  
   (progn                                             ; Creates shape                    
;     (defun membershape ()
     (setq custWidth2 (* custWidth 2)
           custWidth3 (* custWidth 3)
     ); End setq 
;;;                               Error check before proceeding                                            ;;;
     (if (and; All the following must be true or (not nill)
          (> custWidth 0)
          (> custWidth2 0)
          (> custWidth3 0)
          (> custDepth 0)
          (/= "" memshna)
         ); then do this next progn
;;;                                           Do the Math                                                  ;;;
      (progn
       (setq sp '(0 0); Assign Temp Starting Point for Member Profile
             x1 (car sp)
             x2 (+ x1 (/ custWidth 2.0))
             x3 (+ x1 custWidth)            
             y1 (cadr sp)
             y2 (+ y1 custDepth)
       ); End setq
;;;                                        Point Assignment                                                ;;;
       (setq p1 (list x1 y1)
             p2 (list x2 y1)
             p3 (list x3 y1)
             p4 (list x3 y2)
             p5 (list x1 y2)
       ); End setq
;;;                                  Lets Draw Member Profile                                              ;;;
       (command "_.pline" p1 p3 p4 p5 "c"); End command
       (command
        "_-AecsMemberShapeDefine" "_New" memshna "_Graphics"
        "_Low" (entlast) "" p2 "_Medium" (entlast) p2 "_High"
         (entlast) p2 "" "" ""
       ); End command
       (entdel (entlast))
      ); End progn
     ); End if
;     ); End defun
    ); End progn
  ); End if
;;;                                 Define the Multi-Member Shapes & Styles                                ;;;
  (progn
;;;         Let's Define the Single Member Shape & Style           ;;;
   (cond
    ((= mbrs 1)
     (command
      "-MemberStyle" "_New"	memstyna "_Component"
		  "_Edit"	"1" "_Name"	"Section" "STart"
		  "_SHape" memshna ""	"_ENd" "_SHape"
		  memshna "" "" "" "" ""
	   ); End command  
    ); End predicate1
;;;         Let's Define the Double Multi-Member Shape & Style     ;;;
    ((= mbrs 2)
     (progn
	    (command 
	     "-MemberStyle" "_New" memstyna "_Component"
		   "_Edit" "1" "_Name"	"Section" "STart"
		   "_SHape" memshna "" "_ENd"	"_SHape"
		   memshna "" "" "_Add" "_Edit"
		   "2" "_Name" "Section" "_Start" "_SHape"
		   memshna   "_Offset" ""	custWidth ""
		   "" "_ENd" "_SHape"	memshna "_Offset"
		   ""	"" ""	"" "" ""	"" ""	""
		  ); End command
     ); End progn    
    ); End predicate2
;;;       Let's Define the Tripple Multi-Member Shape & Style      ;;;
    ((= mbrs 3)
     (progn
	    (command
	     "-MemberStyle" "_New" memstyna "_Component"
		   "_Edit" "1" "_Name"	"Section" "STart"
		   "_SHape" memshna ""	"_ENd" "_SHape"
		   memshna "" ""	"_Add" "_Edit"
		   "2" "_Name" "Section" "_Start" "_SHape"
		   memshna "_Offset" ""	custWidth ""
		   ""	"_ENd" "_SHape"	memshna "_Offset"
		   ""	"" ""	"" ""
		   "_Add" "_Edit" "3"	"_Name"	"Section"
		   "_STart" "_SHape" memshna "_Offset" ""
		   custWidth2	"" ""	"_ENd" "_SHape"
		   memshna "_Offset" ""	"" ""
		   ""	"" ""	"" ""
		  ); End command
     ); End progn    
    ); End predicate3
;;;      Let's Define the Quadruple Multi-Member Shape & Style     ;;;
    ((= mbrs 4)
     (progn
	    (command
	     "-MemberStyle" "_New" memstyna "_Component"
	     "_Edit" "1" "_Name"	"Section" "STart"
		   "_SHape" memshna "" "_ENd" "_SHape"
		   memshna ""	"" "_Add" "_Edit"
		   "2" "_Name" "Section" "_Start" "_SHape"
		   memshna "_Offset" ""	custWidth	""
		   ""	"_ENd" "_SHape"	memshna	"_Offset"
		   ""	"" ""	"" ""
		   "_Add" "_Edit" "3"	"_Name"	"Section"
		   "_STart" "_SHape"  memshna "_Offset" ""
		   custWidth2 "" ""	"_ENd" "_SHape"
		   memshna "_Offset" ""	"" ""
		   ""	"" "_Add"	"_Edit" "4"
		   "_Name" "Section" "_STart"	"_SHape" memshna
		   "_Offset" "" custWidth3	"" ""
		   "_ENd" "_SHape" memshna "_Offset" ""
		   ""	"" "" "" "" ""	""
		  ); End command
     ); End progn    
    ); End predicate4
   ); End cond        
  ); End progn
;   (dcl_Form_Close SMC) ; Close the form.
  (princ)
 ); end defun
;   (setvar "CMDECHO" S_CMD); Restores Stored Command Echo
;   (setvar "OSMODE" S_OSM); Restores Stored Object Snap
;   (command "-LAYER" "s" CL ""); Restores Current Layer State

;;;                                        Exit                                                            ;;;
  (defun c:cancel_OnClicked (/)
    (dcl_Form_Close SMC) ; Close the form.
    (princ)
  )
;;;                                         Help                                                           ;;;

;;;                                         Info                                                           ;;;
;   (defun f:info ()
;     (dcl_messagebox (strcat
;       "This \"Wood Beams for AEC\"  module is a collaborative effort "
;       "between Krupa CADD Solutions and AEC Design Services.  Others "
;       "are available or in the works. \n\n"
;       "Krupa CADD Solutions also offers the \"KCS Productivity Pack for "
;       "AEC\", as well as custom solutions to make your AutoCAD work "
;       "more productive and efficient. Visit KCS at www.krupacadd.com, "
;       "or email kcs@krupacadd.com \n\n"
;       "AEC Design Services specializes in the design or remodel of "
;       "residential homes, bringing a wealth of construction knowledge "
;       "and AutoCAD Architecture expertise to this collaboration.  "
;       "Their services include design and drafting, 3D modeling and "
;       "rendering, material lists for pricing, custom MVBlocks, and more.  "
;       "Visit AEC Design Services at www.AECDesignSVCS.com, or email "
;       "aecds@AECDesignSVCS.com  "
;       ) 
;       (strcat " Wood Beams for AEC - v" kcs#WoodBeamVer) 2 2
;     )
;   );f:info
;;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Create Member~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;;;
; (defun c:create_OnClicked (/)
;   (dcl_MessageBox (strcat "   " memshna " " memstyna))
; )
)