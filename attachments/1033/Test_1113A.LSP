
(vl-load-com)
(command "OPENDCL")

;; Test Code  
;; 20091113 kdub@work  

;|<<MAIN>>|;


;;;---------------------------------------------------------------------------
;;; (findfile "Test_1113A.ODCL")
;;;---------------------------------------------------------------------------
;;;
(defun c:test_1113a (/ dialogreturn)
  (dcl_project_load "Test_1113A.ODCL" t)
  ;; Show the main form  
  (setq dialogreturn (dcl_form_show test_1113a_main))
  ;;------  
  (princ)
)
;;;---------------------------------------------------------------------------
;;;
;|<<SUPPORT>>|;

;;;---------------------------------------------------------------------------
;;; 
;|<<OPENDCL Handlers Event>>|;

(defun c:test_1113a_main_oninitialize (/)
  (dcl_control_setvisible test_1113a_main_textbutton1 nil)
  (dcl_control_setvisible test_1113a_main_textbox1 nil)
  (dcl_control_setvisible test_1113a_main_textbutton2 nil)
  (dcl_control_setvisible test_1113a_main_textbox2 nil)
  ;;
  (dcl_control_setbackcolor test_1113a_main_picturebox1 8)
  (dcl_picturebox_drawcircle
    test_1113a_main_picturebox1
    (list (list 10 10 30 30 2) (list 30 30 20 40 6))
  )
  (dcl_PictureBox_StoreImage test_1113A_Main_PictureBox1)
  (dcl_slideview_fillimage test_1113a_main_slideview1
                           (list (list 30 30 25 25 3))
  )
  (dcl_slideview_endimage test_1113a_main_slideview1)
)
;;;-------------------------------------------
;;;
(defun c:test_1113a_main_picturebox1_onmousedown (button flags x y /)
  (dcl_control_setvisible test_1113a_main_textbutton1 t)
  (dcl_control_setvisible test_1113a_main_textbox1 t)
  ;;
  (dcl_picturebox_drawcircle
    test_1113a_main_picturebox1
    (list (list (- x 15) (- y 15)  30 30 3) )
  )
  (dcl_PictureBox_StoreImage test_1113A_Main_PictureBox1)
)
;;;-------------------------------------------
;;;
(defun c:test_1113a_main_slideview1_onmousedown (button flags x y /)
  (dcl_control_setvisible test_1113a_main_textbutton2 t)
  (dcl_control_setvisible test_1113a_main_textbox2 t)
  (setq xx x)
  (setq yy y)
  (dcl_slideview_fillimage test_1113a_main_slideview1
                           (list (list x y 10 20 3))
  )
  (dcl_slideview_endimage test_1113a_main_slideview1)
)
;;;---------------------------------------------------------------------------
;;;

(prompt "\n TEST_1113A to run.")
(princ)
 ;|«Visual LISP© Format Options»
(70 2 45 2 nil "end of " 70 60 1 1 0 nil nil nil T)
;*** DO NOT add text below the comment! ***|;
