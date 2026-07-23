;;;MID:SI-LBE-PUB-41/09 25. November 09
;;;OpenDCL_LanguageFile_Sample_f2/3
;;;dcl_xt_LibPart
;;;=====================================================================================================
;;;	Slavko Solutions for AutoCAD									
;;;	ArchiTools, LandTools, ToolsPlus, LBE								
;;;	PROGRAM © by SLAVKO IVANOVIC 									
;;;	slavko.ivanovich@gmail.com									
;;;	www.SlavkoSolutions.com										
;;;-----------------------------------------------------------------------------------------------------
;;; License Agreement (Author's request)								
;;;													
;;; * You are free to use, modify this programs and code segments under following conditions:		
;;;		1. If you applying some changes on this code, save file with different name,		
;;;		   so original file content can always be traceable.					
;;;		2. If you are re-publishing original file, or partial content, leave Copyright Header.	
;;;		3. Don't expect from me any kind of support, but you can email me though.		
;;;-----------------------------------------------------------------------------------------------------
;;; * Content:												
;;;													
;;; This file contains some of functions that are part of My DCL Extented Functions (dcl_xt) library.  	
;;;													
;;; They are referenced with my -OpenDCL Language File Demo- so I decided to provide them Open as well. 
;;;													
;;; But then, this file is also Sample by its self, so i will add description header. 			
;;;=====================================================================================================





;;;=====================================================================================================
;;;  ***												
;;;    Description:											
;;;													
;;;  Loading Odcl Project, user actually "fill" Acad namespace with Enames - OpenDCL Control Pointers.	
;;;  When Project is loaded, in runtime enviorment you can change almost everything in Project.		
;;;													
;;;  To make life easier to programer, OpenDCL automaticly (rhythmically) generate Symbol_Names		
;;;  and bound with specific ENAME handle, somelike (setq Symbol Value), and after set that symbol 	
;;;  name to NIL (recycle) when acces to Control is "no longer needed".					
;;;  													
;;;  For example:											
;;;	   In case of Project (MyProject.odcl), with one form (Form1), with one button (Button1),	
;;;  By defailt, OpenDCL do following:									
;;;    (Dcl_Project_Load "MyProject.odcl") 								
;;;	-> This loads project and return string, but also allocate "first set" of Symbol_Names,		
;;;	   to enable access to Forms. In this example symbol is one >> MyProject_Form1.			
;;;	   Note that exposed Forms through symbols remain exposed.					
;;;    (Dcl_Form_Show MyProject_Form1)									
;;;	-> This show a Form1, but also allocate set of symbols for each Control in a Form,		
;;;	   in this example symbol is one >> MyProject_Form1_Button1.					
;;;	   Note that after (Dcl_Form_Close MyProject_Form1) this symbol is nil.				
;;;													
;;;  When Form is active, you can catch this handle, iex (setq SaveMeControl MyProject_Form1_Button1),	
;;;  but what if you want to access ALL Controls and theirs Properties without Showing Forms?		
;;;-----------------------------------------------------------------------------------------------------
;;;  													
;;;  Functions in this Example File demonstrate powerful possibility to access and manipilate		
;;;  with Forms, Controls, Properties and Events immediately after calling (Dcl_Project_Load)		
;;;													
;;;  OpenDCL Runtime Enviorment provide few but Essential functions (methods) to Start digging		
;;;  OpenDCL Control Pointers that are represented as a ENAMEs.						
;;;													
;;;  For better understanding of this functions important is to note:					
;;;	* Both (Forms and Controls) are actually Controls.						
;;;	* Both (Properties and Events) are actually Properties.						
;;;													
;;;  - this kind of Opendcl handling is good for:							
;;;	- TRANSLATION, DIAGNOSTIC, MULTIPLE CONTORLS EDITING (check function dcl_Project_SaveAs),	
;;;	  VLX NAMESPACE HANDLING, ERROR TRAPPING, ... ... and expanding ideas ;)			
;;;													
;;;							Slavko Ivanovic, designer/drafter/programmer	
;;; Included (dcl_xt) Functions : 									
;;;						========================================================
;;;	dcl_Project_GetControls			
;;;	dcl_Project_GetControlsSpecial		
;;;	dcl_Project_ExposeControls		
;;;	dcl_Control_PropertyAvlb-p		
;;;	dcl_Control_FilterCommon		
;;;	dcl_Control_FilterExclusive		
;;;	dcl_Control_Type			
;;;	dcl_Control_GetAvlbProperties		
;;;	Dcl_Control_GetForm			
;;;	dcl_Control_GetEvents			
;;;	dcl_Lng_PrepareFromat			
;;;	dcl_Lng_ReadFile			
;;;						
;;;=============================================


;;; tip : put *** in Find String field in your Editor to jump partial.


;;;=====================================================================================================
;;;*** loading "LNGF-DEMO.odcl" project for testing (dcl_xt) functios	(if not loaded)			
;;;(OR (AND (VL-CMDF "OpenDCL") (MEMBER "LNGF-DEMO" (DCL_GETPROJECTS)))
;;;     (SETQ TestPoject (DCL_PROJECT_LOAD "LNGF-DEMO.odcl" T)) ; save project name in locvar TestPoject
;;;)
(SETQ TestPoject "LNGF-DEMO")
;;;=====================================================================================================





;;;
;;;=====================================================================================================
;;;*** dcl_Project_GetControls										
;;; Function retrieve all Controls (forms and controls) from loaded Project, in a single list.		
;;;-----------------------------------------------------------------------------------------------------
;;; Author: Slavko Ivanovic, www.SlavkoSolutions.com							
;;; Arguments:												
;;;	<ProjectName> 	  as STRING									
;;;	[ProjectPassword] as STR (in case that project have password),					
;;;			  or NIL (if no password)							
;;; Return:												
;;;	ENAME LIST as single list with all control pointers (forms and controls)			
;;;-----------------------------------------------------------------------------------------------------
(DEFUN dcl_Project_GetControls (<ProjectName> [ProjectPassword] / ~ac ~flat)
    (si-lst-CreateOrAppend "~ac"
                           (IF [ProjectPassword]
                               (DCL_PROJECT_GETFORMS <ProjectName> [ProjectPassword])
                               (DCL_PROJECT_GETFORMS <ProjectName>)
                           )
    )
    (si-lst-CreateOrAppend "~ac" (MAPCAR 'DCL_FORM_GETCONTROLS (CAR ~ac)))
    (si-lst-DigLists "~flat" ~ac)
)
;;; ;; Example:
;;;(dcl_Project_GetControls TestPoject nil)
;;;													
;;;=====================================================================================================
;;;





;;;
;;;=====================================================================================================
;;;*** dcl_Project_GetControlsSpecial									
;;; Function retrieve all Controls (forms and controls) from loaded Project, in a category list,	
;;; with strings as identifiers.									
;;;-----------------------------------------------------------------------------------------------------
;;; Author: Slavko Ivanovic, www.SlavkoSolutions.com							
;;; Arguments:												
;;;	<ProjectName> as STR										
;;;	[ProjectPassword] as STR (in case that project have password),					
;;;			  or NIL (if no password)							
;;; Return:												
;;;	LIST as category list with all handlers and strings as identifiers (forms and controls)		
;;;-----------------------------------------------------------------------------------------------------
(DEFUN dcl_Project_GetControlsSpecial (<ProjectName> [ProjectPassword] / ~af)
    (SETQ ~af (dcl_Control_FilterCommon (IF [ProjectPassword]
                                            (DCL_PROJECT_GETFORMS <ProjectName> [ProjectPassword])
                                            (DCL_PROJECT_GETFORMS <ProjectName>)
                                        )
                                        '("(Name)")
              )
    )
    (MAPCAR '(LAMBDA (f / ~fn)
                 (LIST (LIST (SETQ ~fn (DCL_CONTROL_GETNAME f)) f)
                       (MAPCAR '(LAMBDA (c) (LIST (STRCAT ~fn "_" (DCL_CONTROL_GETNAME c)) c))
                               (DCL_FORM_GETCONTROLS f)
                       )
                 )
             )
            ~af
    )
)
;;; ;; Example:
;;;(dcl_Project_GetControlsSpecial TestPoject nil)
;;;													
;;;=====================================================================================================
;;;





;;;
;;;=====================================================================================================
;;;*** dcl_Project_ExposeControls									
;;; Functions construct symbol names and assign control handle, same like OpenDCL 			
;;; ProjectKey_FormName_ControlName, but for all controls in all forms regardless of dcl_Form_Show.	
;;; You can set [DoUndo] argument to nil, to release symbols.						
;;;-----------------------------------------------------------------------------------------------------
;;; Author: Slavko Ivanovic, www.SlavkoSolutions.com							
;;; Arguments:												
;;;	<ProjectName> as STRING										
;;;	[ProjectPassword] as STR (in case that project have password),					
;;;			  or NIL (if no password)							
;;;	[DoUndo] as T (assign all)									
;;;		 or NIL (release all)									
;;; Return:												
;;;	T or NIL											
;;;-----------------------------------------------------------------------------------------------------
(DEFUN dcl_Project_ExposeControls (<ProjectName> [ProjectPassword] [DoUndo] / ~all)
    (SETQ ~all (dcl_Project_GetControlsSpecial <ProjectName> [ProjectPassword]))
    (FOREACH ~f ~all
        (MAPCAR '(LAMBDA (c)
                     (SET (READ (STRCAT <ProjectName> "_" (CAR c)))
                          (IF [DoUndo]
                              (CADR c)
                              nil
                          )
                     )
                 )
                (CADR ~f)
        )
    )
    [DoUndo]
)
;;; ;; Example:
;;;(dcl_Project_ExposeControls TestPoject nil T)     ; chk val: LNGF-DEMO_Form1_TextButton1
;;;(dcl_Project_ExposeControls TestPoject nil nil)   ; chk val: LNGF-DEMO_Form1_TextButton1
;;;													
;;;=====================================================================================================
;;;





;;;
;;;=====================================================================================================
;;;*** dcl_Control_PropertyAvlb-p									
;;; Functon check is DCL Property available (exist) for given Control, and fix Case of Property Name.	
;;;-----------------------------------------------------------------------------------------------------
;;; Author: Slavko Ivanovic, www.SlavkoSolutions.com							
;;; Arguments:												
;;;	<Control> as ENAME Control handle								
;;;	<Property> as STRING										
;;; Return:												
;;;	1. If property exist return -  Fixed cASEseNSiTIVe property name as :STRING			
;;; 	2. NIL If not exist 										
;;;-----------------------------------------------------------------------------------------------------
(DEFUN dcl_Control_PropertyAvlb-p (<Control> <Property>)
    (CAR (si-lst-GetSameStrings (DCL_CONTROL_GETPROPERTIES <Control>)
                                (LIST <Property>)
                                nil
         )
    )
)
;;; ;; Example:
;;;(SETQ some_form (CAR (DCL_PROJECT_GETFORMS TestPoject)))
;;;(IF (SETQ prop (dcl_Control_PropertyAvlb-p some_form "TitleBarText"))
;;;    (DCL_CONTROL_SETPROPERTY some_form prop "This is a changed Text")
;;;)
;;;(dcl_Control_GetAvlbProperties some_form '("TitleBarText")) ; check
;;;(DCL_FORM_SHOW some_form)
;;;													
;;;=====================================================================================================
;;;





;;;
;;;=====================================================================================================
;;; *** dcl_Control_FilterCommon									
;;; Function takes Control list and return only Controls that have at lest one of the given Properties.	
;;;-----------------------------------------------------------------------------------------------------
;;; Author: Slavko Ivanovic, www.SlavkoSolutions.com							
;;; Arguments:												
;;;	<Controls> as ENAME LIST									
;;;	[Properties] as STR LIST (List od Properties) - not case sensitive				
;;; Return:												
;;;	1. ENAME LIST - filtered controls								
;;;	2. NIL - no given properties in controls							
;;;-----------------------------------------------------------------------------------------------------
(DEFUN dcl_Control_FilterCommon (<Controls> [Properties])
    (IF [Properties]
        (VL-REMOVE-IF-NOT '(LAMBDA (x)
                               (si-lst-GetSameStrings (DCL_CONTROL_GETPROPERTIES x) [Properties] nil)
                           )
                          <Controls>
        )
        <Controls>
    )
)
;;; ;; Example:
;;;(SETQ filteredC (dcl_Control_FilterCommon (dcl_Project_GetControls TestPoject nil)
;;;                                          '("Caption" "BorderStyle")
;;;                )
;;;)
;;;(MAPCAR 'dcl_Control_Type filteredC)              ; check what is filtered
;;;													
;;;=====================================================================================================
;;;





;;;
;;;=====================================================================================================
;;; *** dcl_Control_FilterExclusive									
;;; Function takes Control list and return only Controls that have all of the given Properties.		
;;;-----------------------------------------------------------------------------------------------------
;;; Author: Slavko Ivanovic, www.SlavkoSolutions.com							
;;; Arguments:												
;;;	<Controls> as ENAME LIST									
;;;	[Properties] as STR LIST (List od Properties) - not case sensitive				
;;; Return:												
;;;	1. ENAME LIST - filtered controls								
;;;	2. NIL - no given properties in controls							
;;;-----------------------------------------------------------------------------------------------------
(DEFUN dcl_Control_FilterExclusive (<Controls> [Properties])
    (IF [Properties]
        (VL-REMOVE-IF-NOT '(LAMBDA (x)
                               (SETQ props (DCL_CONTROL_GETPROPERTIES x))
                               (VL-EVERY '(LAMBDA (n) n)
                                         (MAPCAR '(LAMBDA (p) (AND (si-lst-GetSameStrings (LIST p) props nil)))
                                                 [Properties]
                                         )
                               )
                           )
                          <Controls>
        )
        <Controls>
    )
)
;;; ;; Example:
;;;(SETQ filteredE (dcl_Control_FilterExclusive (dcl_Project_GetControls TestPoject nil)
;;;                                          '("Caption" "BorderStyle")
;;;                )
;;;)
;;;(MAPCAR 'dcl_Control_Type filteredE)              ; check what is filtered
;;;													
;;;=====================================================================================================
;;;





;;;
;;;=====================================================================================================
;;; *** dcl_Control_Type										
;;; Returns the type of a specified Control. 								
;;;-----------------------------------------------------------------------------------------------------
;;; Author: Slavko Ivanovic, www.SlavkoSolutions.com							
;;; Arguments:												
;;;	<Control> as ENAME Control handle								
;;; Return:												
;;;	 One of the atoms listed.									
;;;	'(MODAL_DIALOG    MODELESS_DIALOG CONTROL_BAR     OPTIONS_TAB     FILE_DIALOG     PALETTE	
;;;	  LABEL           TEXT_BUTTON     GRAPHIC_BUTTON  FRAME           TEXT_BOX        CHECK_BOX	
;;;	  OPTION_BUTTON   COMBO_BOX       LIST_BOX        SCROLL_BAR      SLIDER          PICTURE_BOX	
;;;	  TAB_STRIP       CALENDAR        TREE            RECTANGLE       PROGRESS_BAR    SPIN_BUTTON	
;;;	  HYPERLINK       ANGLE_SLIDER    BLOCK_VIEW      SLIDE_VIEW      HTML            DWG_PREVIEW	
;;;	  LIST_VIEW       BLOCK_LIST      OPTION_LIST     ACTIVEX_CONTROL DWG_LIST        ANIMATION	
;;;	  IMAGE_COMBO_BOX GRID            SPLITTER        HATCH           FILE_EXPLORER	  UNKNOWN	
;;;	 )												
;;;-----------------------------------------------------------------------------------------------------
(DEFUN dcl_Control_Type (<Control> / ~funnel ~t)
    ;; scheme by Properties, and In Order for testing.
    (SETQ ~funnel (LIST (LIST 'Options_Tab '("OptionsTabCaption")) ; 1
                        (LIST 'Palette '("DockableSides" "TitleBarIcon")) ; 2
                        (LIST 'Control_Bar '("DockableSides")) ;3
                        (LIST 'Modeless_Dialog '("EnteringNoDocState")) ; 4
                        (LIST 'Modal_Dialog '("TitleBarText" "TitleBarIcon")) ; 5
                        (LIST 'File_Dialog '("TitleBarText")) ; 6
                        (LIST 'Block_View '("BlockName"))
                        (LIST 'Calendar '("GetDayState"))
                        (LIST 'DWG_List '("InsertOrXref"))
                        (LIST 'Grid '("AlternatingColor"))
                        (LIST 'Hatch '("HatchScale"))
                        (LIST 'HTML '("NavigationComplete"))
                        (LIST 'Hyperlink '("Hyperlink"))
                        (LIST 'Image_Combo_Box '("ListImages"))
                        (LIST 'Label '("Justification" "Caption"))
                        (LIST 'List_Box '("MultiColumn"))
                        (LIST 'File_Explorer '("FileExplorerStyle"))
                        (LIST 'Graphic_Button '("GraphicButtonStyle"))
                        (LIST 'List_View '("ListViewStyle"))
                        (LIST 'Block_List '("BlockListStyle"))
                        (LIST 'Combo_Box '("ComboBoxStyle"))
                        (LIST 'Tab_Strip '("TabStyle"))
                        (LIST 'Text_Box '("FilterStyle"))
                        (LIST 'Option_Button '("BeginGroup"))
                        (LIST 'Option_List '("ButtonCaptionList"))
                        (LIST 'Picture_Box '("AutoSize"))
                        (LIST 'Progress_Bar '("LegendType"))
                        (LIST 'Spin_Button '("AutoWrap"))
                        (LIST 'Splitter '("ClosestInside"))
                        (LIST 'Tree '("SingleClickExpand"))
                        (LIST 'Slider '("ShowTicks")) ; 1
                        (LIST 'Scroll_Bar '("Scrolled")) ; 2
                        (LIST 'Angle_Slider '("Scroll")) ; 3
                        (LIST 'Check_Box '("Caption" "Value")) ; 1
                        (LIST 'Text_Button '("Caption" "Clicked")) ; 2
                        (LIST 'Frame '("Caption")) ; 3
                        (LIST 'Slide_View '("MouseEntered")) ; 1
                        (LIST 'DWG_Preview '("DragnDropToAutoCAD")) ; 2
                        (LIST 'Rectangle '("BackColor")) ; 3
                        (LIST 'Animation '("BorderStyle")) ; 4
                        (LIST 'ActiveX_Control '("(Name)")) ; 5
                        (LIST 'UNKNOWN nil)
                  )
          x       T
    )
    (WHILE x
        (SETQ x (CAR ~funnel))
        (IF (dcl_Control_FilterExclusive (LIST <Control>) (CADR x))
            (SETQ ~t (CAR x)
                  x  nil
            )
            (SETQ ~funnel (CDR ~funnel))
        )
    )
    ~t
)
;;; ;; Example:
;;;(setq all_controls (dcl_Project_GetControls TestPoject nil))
;;;(dcl_Control_Type (CAR all_controls))
;;; ;; change Captions in all forms but only for Text Buttons
;;;(FOREACH ctrl all_controls
;;;    (IF (EQ (dcl_Control_Type ctrl) 'TEXT_BUTTON)
;;;        (DCL_CONTROL_SETCAPTION ctrl "ChangedCaption")
;;;    )
;;;)
;;;(DCL_FORM_SHOW (CAR all_controls))
;;;													
;;;=====================================================================================================
;;;





;;;
;;;=====================================================================================================
;;; *** dcl_Control_GetAvlbProperties	(special function)						
;;; Function list available Properties and Values, and return only for Controls that have given Properties.
;;;-----------------------------------------------------------------------------------------------------
;;; Author: Slavko Ivanovic, www.SlavkoSolutions.com							
;;; Arguments:												
;;;	<Control*s>  as ENAME LIST, (controls)								
;;;		     or as single ENAME	(one control)   						
;;;	<Properties> as STR LIST (List od Properties),							
;;;		     or symbol 'All (for all Available properties)					
;;; Return:												
;;;	1. if list of controls -> LIST ((ENAME1 (("prop1" val1)("prop2" val2)...)) (ENAME2 ...)...)	
;;;	2. if single control   -> LIST (("prop1" val1)("prop2" val2)...)				
;;;	3. NIL if no Properties										
;;;-----------------------------------------------------------------------------------------------------
(DEFUN dcl_Control_GetAvlbProperties (<Control*s> <Properties> / ~c ~a ~out)
    (OR (LISTP <Control*s>)
        (SETQ <Control*s> (LIST <Control*s>)
              ~c          T
        )
    )
    (AND (EQ <Properties> 'all) (SETQ ~a T))
    (SETQ ~out (MAPCAR '(LAMBDA (x)
                            (AND ~a (SETQ <Properties> (DCL_CONTROL_GETPROPERTIES x)))
                            (LIST x
                                  (VL-REMOVE nil
                                             (MAPCAR '(LAMBDA (p)
                                                          (IF (SETQ p (dcl_Control_PropertyAvlb-p x p))
                                                              (LIST p (DCL_CONTROL_GETPROPERTY x p))
                                                              nil
                                                          )
                                                      )
                                                     <Properties>
                                             )
                                  )
                            )
                        )
                       <Control*s>
               )
    )
    (IF ~c
        (CADAR ~out)
        (VL-REMOVE-IF-NOT '(LAMBDA (x) (CADR x)) ~out)
    )
)
;;; ;; Example:
;;;(SETQ all_controls (dcl_Project_GetControls TestPoject nil))
;;;(SETQ one_control (CAR all_controls))
;;;(dcl_Control_GetAvlbProperties all_controls 'all) ; all data from all Forms and Controls
;;;(dcl_Control_GetAvlbProperties all_controls '("(nAmE)" "Width" "Height")) ; specific from List of Controls
;;;(dcl_Control_GetAvlbProperties one_control 'all)  ; all properties from Single Control		
;;;(dcl_Control_GetAvlbProperties one_control '("(nAmE)" "Width" "Height")) ;specific from Single Control
;;;													
;;;=====================================================================================================
;;;





;;;
;;;=====================================================================================================
;;; *** Dcl_Control_GetForm										
;;; Function return Form for given Control. If Control is a form return that form.			
;;;-----------------------------------------------------------------------------------------------------
;;; Author: Slavko Ivanovic, www.SlavkoSolutions.com							
;;; Arguments:												
;;;	<Control> as ENAME Control handler								
;;;	<ProjectName> as :STR										
;;;	[ProjectPassword] as STR (in case that project have password), or NIL (if no password)		
;;; Return:												
;;;	LIST in format ("FormName" <Entity name: xxxxx>)						
;;;-----------------------------------------------------------------------------------------------------
(DEFUN Dcl_Control_GetForm (<Control> <ProjectName> [ProjectPassword] / ~all ~fn ~fc ~out)
    (SETQ ~all (dcl_Project_GetControlsSpecial <ProjectName> [ProjectPassword]))
    (FOREACH ~f ~all
        (SETQ ~fn (CAR ~f)
              ~fc (CADR ~f)
        )
        (IF (EQUAL (CADR ~fn) <Control>)
            (SETQ ~out ~fn)
            (FOREACH ~c ~fc
                (IF (EQUAL (CADR ~c) <Control>)
                    (SETQ ~out ~fn)
                )
            )
        )
    )
    ~out
)
;;; ;; Example:
;;;(SETQ all_controls (dcl_Project_GetControls TestPoject nil))
;;;(SETQ one_control (CAR all_controls))
;;;(setq some_control (nth 9 all_controls))
;;;(Dcl_Control_GetForm one_control TestPoject nil)
;;;(Dcl_Control_GetForm some_control TestPoject nil)
;;;(MAPCAR '(LAMBDA (x) (Dcl_Control_GetForm x TestPoject nil)) all_controls) ; for all
;;;													
;;;=====================================================================================================
;;;





;;;
;;;=====================================================================================================
;;;*** dcl_Control_GetEvents										
;;; Functon returns all Event properties for given control or list of controls				
;;;-----------------------------------------------------------------------------------------------------
;;; Author: Slavko Ivanovic, www.SlavkoSolutions.com							
;;; Arguments:												
;;;	<Control*s>  as ENAME LIST, or as single ENAME	   						
;;; Return:												
;;;	1. for list of controls - LIST ((ENAME1 ((prop1 val1)(prop2 val2)...)) (ENAME2 ...)...)		
;;;	2. for single control - LIST ((prop1 val1)(prop2 val2)...)					
;;;-----------------------------------------------------------------------------------------------------
(DEFUN dcl_Control_GetEvents (<Control*s> / ~evl)
    (SETQ ~evl '("BeginLabelEdit"    "BeginLabelEdit"    "BeginLabelEdit"    "ButtonClicked"
                 "Cancel"            "CancelClose"       "Changed"           "Clicked"
                 "Close"             "ColumnClick"       "DblClicked"        "DblClicked"
                 "DblClicked"        "DeleteItem"        "DocActivated"      "DragnDropBegin"
                 "DragnDropFromControl"                  "DragnDropFromOther"
                 "DragnDropToAutoCAD"                    "DropDown"          "EditChanged"
                 "EndLabelEdit"      "EnteringNoDocState"                    "FolderChanged"
                 "GetDayState"       "Help"              "INITIALIZE"        "ItemExpanded"
                 "ItemExpanding"     "KeyDown"           "KeyUp"             "KillFocus"
                 "MaxText"           "MouseDblClick"     "MouseDown"         "MouseEntered"
                 "MouseMove"         "MouseMovedOff"     "MouseUp"           "MouseWheel"
                 "NavigationComplete"                    "OK"                "OptionsApply"
                 "OptionsCancel"     "OptionsHelp"       "OptionsOk"         "Paint"
                 "RightClick"        "RightDblClick"     "ReleasedCapture"   "ReturnPressed"
                 "Scroll"            "Scrolled"          "SelChanged"        "SelChanged"
                 "SelChanged"        "SelChanged"        "SelChanging"       "Select"
                 "SetFocus"          "Show"              "Size"              "SplitterMove"
                 "TypeChanged"       "Update"
                )
    )
    (dcl_Control_GetAvlbProperties <Control*s> ~evl)
)
;;; ;; Example:
;;;(SETQ all_controls (dcl_Project_GetControls TestPoject nil))
;;;(SETQ one_control (CAR all_controls))
;;;(dcl_Control_GetEvents all_controls)	; list all events for all controls
;;;(dcl_Control_GetEvents some_control) ; for one
;;;													
;;;=====================================================================================================
;;;





;;;
;;;=====================================================================================================
;;;*** dcl_Lng_PrepareFromat										
;;; This function put tranlatable OpenDCL controls data in specific format. For Writing or Reading.	
;;;-----------------------------------------------------------------------------------------------------
;;; Author: Slavko Ivanovic, www.SlavkoSolutions.com							
;;; Arguments:												
;;;	<ProjectName> as :STR										
;;;	[ProjectPassword] as STR (in case that project have password),					
;;;			  or NIL (if no password)							
;;;	[write/read] 	as T - prepare list for writing	to .lng						
;;;			or NIL - prepare list with handles						
;;; Return:												
;;;	1. if T   -> LIST in format: (("#ControlName;" "$PropertyName;" "PropertyValue")(... ... )...)	
;;;	2. if nil -> (("ControlName" <Entity name: xxxxxx>)(... ...)...)				
;;;-----------------------------------------------------------------------------------------------------
(DEFUN dcl_Lng_PrepareFromat (<ProjectName> [ProjectPassword] [write/read] / transp flat filter prepare)
    (SETQ transp '("TitleBarText" "Caption" "TabCaptionList" "ButtonCaptionList"))
    (DEFUN flat (~cts / ~c)
        (FOREACH ~mem (MAPCAR '(LAMBDA (x) (APPEND (LIST (CAR x)) (REVERSE (CADR x)))) ~cts)
            (MAPCAR '(LAMBDA (x) (si-lst-CreateOrAppend "~c" x)) ~mem)
        )
        ~c
    )
    (DEFUN filter (~cts)
        (VL-REMOVE-IF-NOT '(LAMBDA (x) (dcl_Control_FilterCommon (CDR x) transp)) ~cts)
    )
    (DEFUN prepare (~cts)
        (MAPCAR '(LAMBDA (x)
                     (SETQ props (dcl_Control_GetAvlbProperties (CADR x) transp))
                     (LIST (STRCAT "#" (CAR x) "; ")
                           (STRCAT "$" (CAAR props) "; ")
                           (VL-PRIN1-TO-STRING (CADAR props))
                     )
                 )
                ~cts
        )
    )
    (SETQ ~out (filter (flat (dcl_Project_GetControlsSpecial <ProjectName> [ProjectPassword]))))
    (IF [write/read]
        (prepare ~out)
        ~out
    )
)
;;; ;;Example:
;;;(dcl_Lng_PrepareFromat TestPoject nil T)
;;;(dcl_Lng_PrepareFromat TestPoject nil nil)
;;;													
;;;=====================================================================================================
;;;





;;;
;;;=====================================================================================================
;;;*** dcl_Lng_ReadFile											
;;; This Function read (lng) data from files which contains data from (dcl_Lng_PrepareFromat) output.	
;;; Fuction have consistency data check.								
;;;-----------------------------------------------------------------------------------------------------
;;; Author: Slavko Ivanovic, www.SlavkoSolutions.com							
;;; Arguments:												
;;;	<FileName> as :STR										
;;; Return:												
;;;	1. LIST in format: (("ControlName" "PropertyName" PropertyValue)(... ... ...)...)		
;;;	2. NIL if can not read file or data corrupted							
;;;-----------------------------------------------------------------------------------------------------
(DEFUN dcl_Lng_ReadFile (<FileName> / ConsChk ~d)
    (DEFUN ConsChk (~data)
        (VL-EVERY '(LAMBDA (x) x)
                  (MAPCAR '(LAMBDA (d / ~1 ~2 ~3)
                               (AND (EQ 'LIST (TYPE d))
                                    (= (VL-LIST-LENGTH d) 3)
                                    (SETQ ~1 (CAR d)
                                          ~2 (CADR d)
                                          ~3 (CADDR d)
                                    )
                                    (EQ 'STR (TYPE ~1))
                                    (OR (AND (MEMBER ~2 '("TabCaptionList" "ButtonCaptionList"))
                                             (EQ 'LIST (TYPE ~3))
                                             (VL-EVERY '(LAMBDA (s) (EQ 'STR (TYPE s))) ~3)
                                        )
                                        (AND (MEMBER ~2 '("TitleBarText" "Caption")) (EQ 'STR (TYPE ~3)))
                                    )
                               )
                           )
                          ~data
                  )
        )
    )
    (SETQ ~d (MAPCAR '(LAMBDA (f)
                          (MAPCAR '(LAMBDA (l / ~s)
                                       (SETQ l  (VL-STRING-LEFT-TRIM " " (VL-STRING-RIGHT-TRIM " " l))
                                             ~s (SUBSTR l 1 1)
                                       )
                                       (COND ((MEMBER ~s '("#" "$")) (SUBSTR l 2))
                                             ((MEMBER ~s '("\"" "(")) (READ l))
                                       )
                                   )
                                  f
                          )
                      )
                     (MAPCAR '(LAMBDA (s) (si-str-BreakByDelims s '(";")))
                             (VL-REMOVE-IF-NOT '(LAMBDA (x) (= (SUBSTR x 1 1) "#"))
                                               (si-file-Read <FileName>)
                             )
                     )
             )
    )
    (IF (AND ~d (ConsChk ~d))
        ~d
    )
)
;;; ;;Example:
;;;(dcl_Lng_ReadFile (FINDFILE "LNGF-DEMO.ENU.lng"))
;;;(dcl_Lng_ReadFile (FINDFILE "acad.exe"))
;;;													
;;;=====================================================================================================
;;;




;; note loaded
;;-----------------------------------------
(OR **by-loader**
    (PROMPT "\n*** DCL Extended Functions (dcl_xt) by Slavko Ivanovic loaded.")
)
;;-----------------------------------------





;;;=====================================================================================================
;; This are some of Functions that are part of Slavko Ivanovic Extented Functions (si-xt) library	
;; that are referenced with (dcl_xt) functions, so i provide them as well in this sample file.		
;;;=====================================================================================================


;;;-----------------------------------------------------------------------------------------------------
(DEFUN si-str-BreakByDelims (<STR:> <STRLI:Delimeters> / ~c ~l ~li ~s ~ch ~w)
    (SETQ ~l (STRLEN <STR:>)
          ~c 1
          ~s ""
    )
    (REPEAT ~l
        (SETQ ~ch (SUBSTR <STR:> ~c 1)
              ~c  (1+ ~c)
        )
        (IF (NOT (MEMBER ~ch <STRLI:Delimeters>))
            (SETQ ~s (STRCAT ~s ~ch))
            (SETQ ~w  T
                  ~li (APPEND ~li (LIST ~s))
                  ~s  ""
            )
        )
    )
    (IF (NOT (EQUAL ~s ""))
        (SETQ ~li (APPEND ~li (LIST ~s)))
    )
    ~li
)
;;;-----------------------------------------------------------------------------------------------------
(DEFUN si-lst-CreateOrAppend (<STR:VarName> <ANY:Value>)
    (SET (READ <STR:VarName>)
         (APPEND (VL-SYMBOL-VALUE (READ <STR:VarName>))
                 (SET (READ <STR:VarName>) (LIST <ANY:Value>))
         )
    )
)
;;;-----------------------------------------------------------------------------------------------------
(DEFUN si-lst-DigLists (<STR:VarName> <LI:>)
    (FOREACH m <LI:>
        (IF (LISTP m)
            (si-lst-DigLists <STR:VarName> m)
            (si-lst-CreateOrAppend <STR:VarName> m)
        )
    )
    (VL-SYMBOL-VALUE (READ <STR:VarName>))
)
;;;-----------------------------------------------------------------------------------------------------
(DEFUN si-lst-ClearDuplicates (<LI:> / ~lst ~t)
    (FOREACH ~t <LI:>
        (IF (NOT (MEMBER ~t ~lst))
            (SETQ ~lst (CONS ~t ~lst))
        )
    )
    (REVERSE ~lst)
)
;;;-----------------------------------------------------------------------------------------------------
(DEFUN si-lst-GetSameStrings (<STRLI:1> <STRLI:2> [CaseSens] / ~lst ~t)
    (FOREACH ~t <STRLI:1>
        (IF (IF [CaseSens]
                (MEMBER ~t <STRLI:2>)
                (MEMBER (STRCASE ~t) (MAPCAR 'STRCASE <STRLI:2>))
            )
            (SETQ ~lst (CONS ~t ~lst))
        )
    )
    (SETQ ~lst (REVERSE ~lst))
    (si-lst-ClearDuplicates ~lst)
)
;;;-----------------------------------------------------------------------------------------------------
(DEFUN si-file-Read (<STR:FileName> / ~f ~all ~l)
    (SETQ ~f (OPEN <STR:FileName> "r"))
    (IF (EQ (TYPE ~f) 'FILE)
        (PROGN (WHILE (SETQ ~l (READ-LINE ~f)) (si-lst-CreateOrAppend "~all" ~l))
               (CLOSE ~f)
               ~all
        )
    )
)
;;-----------------------------------------------------------------------------------------------------
(OR *lastdir* (SETQ *lastdir* ""))
(DEFUN si-file-Open (<STR:DialLabel> <STR:Extension> / ~t)
    (SETQ ~t (GETFILED <STR:DialLabel> *lastdir* <STR:Extension> 8))
    (IF ~t
        (PROGN (SETQ *lastdir*
                        (STRCAT (VL-STRING-RIGHT-TRIM "\\" (VL-FILENAME-DIRECTORY (SETQ ~t (FINDFILE ~t))))
                                "\\"
                        )
               )
        )
    )
    ~t
)
;;-----------------------------------------------------------------------------------------------------
(DEFUN si-file-SaveAs (<STR:DialLabel> <STR:Extension> / ~t)
    (SETQ ~t (GETFILED <STR:DialLabel> *lastdir* <STR:Extension> 1))
    (IF ~t
        (PROGN
            (SETQ *lastdir* (STRCAT (VL-STRING-RIGHT-TRIM "\\" (VL-FILENAME-DIRECTORY ~t)) "\\"))
        )
    )
    ~t
)
;;-----------------------------------------------------------------------------------------------------
(DEFUN si-utl-GetString (<STR:Prompt> <STR:Dflt> / ~t)
    (PRINC (STRCAT "\n" <STR:Prompt> " <" <STR:Dflt> ">: "))
    (SETQ ~t (VL-CATCH-ALL-APPLY 'GETSTRING (LIST T)))
    (IF (VL-CATCH-ALL-ERROR-P ~t)
        (SETQ ~t nil)
    )
    (IF (/= ~t "")
        ~t
        <STR:Dflt>
    )
)
;;-----------------------------------------------------------------------------------------------------
(DEFUN si-get-AcadLanguage (/ ~cmd)
    ;; alternative to system variable "locale" (getvar "LOCALE")
    (SETQ ~cmd (GETCNAME "_CIRCLE"))
    (COND ((= ~cmd "CIRCLE") "ENU")
          ((= ~cmd "KREIS") "DEU")
          ((= ~cmd "CERCLE") "FRA")
          ((= ~cmd "CERCHIO") "ITA")
          ((= ~cmd "CIRCULO") "ESP")
          ((= ~cmd "KRU\216NICE") "CSY")
          ((= ~cmd "\312\320\323\303") "RUS")
          (T "UNKNOWN")
    )
)
;;;													
;;;=====================================================================================================
;;;


;|«Visual LISP© Format Options»
(110 4 50 2 nil "end of " 80 50 2 0 0 nil nil nil T)
;*** DO NOT add text below the comment! ***|;
