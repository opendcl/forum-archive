
;; loading the odclfile :

(dcl_project_load "ControlFormTest.odcl" T)



;;; ------------------------------------------------------------
;;; command used to display the controlbar :			
;;; ------------------------------------------------------------

(defun c:crtlBar ()
  (defun c:ControlFormtest_TestControlForm_FooButton_OnClicked (/)
    (c:foo)
  )
  (dcl_Form_Show ControlFormtest_TestControlForm)
  (dcl_setcmdbarfocus)
  (princ)

)


;;; ------------------------------------------------------------
;;; the foo command (displays the modeless and does something ):
;;; ------------------------------------------------------------


(defun c:foo ()

  (dcl_Form_Show ControlFormtest_FooModelessForm)
  (dcl_setcmdbarfocus)

  ;; processing :
  (initget 1)
  (setq pt1 (getpoint "\nSpecify first point :"))
  (initget 1)
  (setq pt2 (getpoint pt1 "\nSpecify first point :"))

  ;; crash section :
  (entmake (list '(0 . "LINE") (cons 10 pt1) (cons 11 pt2)))


  (dcl_Form_Close ControlFormtest_FooModelessForm)
  (princ)
)


;; EOF