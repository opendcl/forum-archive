
(vl-load-com)
(command "OPENDCL")

;; Test Code  
;; 20091117 kdub@home

(defun c:doit () (c:test_1113B))

 ;|<<MAIN>>|;


;;;---------------------------------------------------------------------------
;;; (findfile "Test_1113B.ODCL")
;;;---------------------------------------------------------------------------
;;;
(defun c:test_1113B (/ dialogreturn)
  (dcl_project_load "Test_1113B.ODCL" t)
  ;; Show the main form  
  (setq dialogreturn (dcl_form_show test_1113B_main))
  ;;------  
  (princ)
)
;;;---------------------------------------------------------------------------
;;;
;|<<SUPPORT>>|;
(defun _ManageSlideView (button flags x y / Sector)
  ;;
  ;; Slide control is set at 120x120
  (dcl_Control_SetText test_1113B_Main_XLocation (itoa X))
  (dcl_Control_SetText test_1113B_Main_YLocation (itoa Y))
  ;;Determine Sector
  ;; assume divisions 3 wide, 2 divisions high
  (cond ((< Y 60)                            ; The top half
         (cond ((< X 40) (setq Sector 1))
               ((< X 90) (setq Sector 2))
               (T (setq Sector 3))
         )
        )
        (T                                   ; Bottom Half
         (cond ((< X 40) (setq Sector 11))
               ((< X 80) (setq Sector 12))
               (T (setq Sector 13))
         )
        )
  )
  (dcl_Control_SetText test_1113B_Main_SectorText
                       (strcat "SlideSector " (itoa Sector))
  )
  ;; 
  (dcl_control_setvisible test_1113B_main_textbutton2 t)
  (dcl_control_setvisible test_1113B_main_textbox2 t)
  ;;
  (dcl_slideview_fillimage test_1113B_main_slideview1
                           (list (list (- x 5) (- y 10) 10 20 3))
  )
  (dcl_slideview_endimage test_1113B_main_slideview1)
)
;;;-------------------------------------------
;;;
(defun _ManagePiccy (button flags x y / Sector)
  (dcl_control_setvisible test_1113B_main_textbutton1 t)
  (dcl_control_setvisible test_1113B_main_textbox1 t)
  ;;
  (dcl_picturebox_drawcircle test_1113B_main_picturebox1
                             (list (list (- x 15) (- y 15) 30 30 3))
  )
  (dcl_PictureBox_StoreImage test_1113B_Main_PictureBox1)
  ;;
  ;;
  ;; Piccy control is set at 120x120
  (dcl_Control_SetText test_1113B_Main_XLocation (itoa X))
  (dcl_Control_SetText test_1113B_Main_YLocation (itoa Y))
  ;;Determine Sector
  ;; assume divisions 3 wide, 2 divisions high
  (cond ((< Y 60)                            ; The top half
         (cond ((< X 40) (setq Sector 1))
               ((< X 90) (setq Sector 2))
               (T (setq Sector 3))
         )
        )
        (T                                   ; Bottom Half
         (cond ((< X 40) (setq Sector 11))
               ((< X 80) (setq Sector 12))
               (T (setq Sector 13))
         )
        )
  )
  (dcl_Control_SetText test_1113B_Main_SectorText
                       (strcat "PiccySector " (itoa Sector))
  )
)
;;;---------------------------------------------------------------------------
;;; 
;|<<OPENDCL Handlers Event>>|;

(defun c:test_1113B_main_oninitialize (/)
  (dcl_control_setvisible test_1113B_main_textbutton1 nil)
  (dcl_control_setvisible test_1113B_main_textbox1 nil)
  (dcl_control_setvisible test_1113B_main_textbutton2 nil)
  (dcl_control_setvisible test_1113B_main_textbox2 nil)
  ;;
  (dcl_control_setbackcolor test_1113B_main_picturebox1 8)
)
;;;-------------------------------------------
;;;
(defun c:test_1113B_main_picturebox1_onmousedown (button flags x y /)
  (_ManagePiccy button flags x y)
)
;;;-------------------------------------------
;;;
(defun c:test_1113B_main_slideview1_onmousedown (button flags x y /)
  (_ManageSlideView button flags x y)
)
;;;-------------------------------------------
;;;
(defun c:test_1113B_Main_BtnReset_OnClicked (/)
  (dcl_control_setvisible test_1113B_main_textbutton1 nil)
  (dcl_control_setvisible test_1113B_main_textbox1 nil)
  (dcl_control_setvisible test_1113B_main_textbutton2 nil)
  (dcl_control_setvisible test_1113B_main_textbox2 nil)
  ;;
  (dcl_PictureBox_Clear test_1113B_Main_PictureBox1)
  (dcl_SlideView_Clear test_1113B_Main_SlideView1)
  ;;
  (dcl_Control_SetText test_1113B_Main_SectorText "")
  (dcl_Control_SetText test_1113B_Main_XLocation "")
  (dcl_Control_SetText test_1113B_Main_YLocation "")
)
;;;-------------------------------------------
;;;
(defun c:test_1113B_Main_ShowButtons_OnClicked (/)
  (dcl_control_setvisible test_1113B_main_textbutton1 T)
  (dcl_control_setvisible test_1113B_main_textbox1 T)
  (dcl_control_setvisible test_1113B_main_textbutton2 T)
  (dcl_control_setvisible test_1113B_main_textbox2 T)
)

;;;-------------------------------------------
;;;

;;;---------------------------------------------------------------------------
;;;

(prompt "\n Test_1113B ...  DoIt to run.")
(princ)
 ;|«Visual LISP© Format Options»
(70 2 45 2 nil "end of " 70 60 0 0 0 nil nil nil T)
;*** DO NOT add text below the comment! ***|;
