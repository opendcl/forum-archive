; Getvals multi allows multiple line inputs with an image must be a slide image
; By Alan H Oct 2019
; code examples



; (if (not AH:getvalsimg)(load "Multi Getvals img.lsp"))
; (setq ans (AH:getvalsimg "D:\\Acadtemp\\furntable" 40 (list "Enter table size" "Enter length" 5 4 "1200" "Enter width" 5 4 "900" "Table thickness" 5 4 "30" "Enter height" 5 4 "900" "Enter Leg size" 5 4 "100")))


(defun AH:getvalsimg (img_name siz dcllst / x y num fo fname keynum key_lst v_lst)
(setq num (/ (- (length dcllst) 1) 4))
(setq x 0)
(setq y 0)
(setq fo (open (setq fname (vl-filename-mktemp "" "" ".dcl")) "w"))
;(setq fo (open (setq fname "d:\\acadtemp\\alantest.dcl") "w"))
(write-line "getvalsimg : dialog {" fo)
(write-line (strcat "label =  " (chr 34) (nth 0 dcllst) (chr 34) "  ; ") fo)
(write-line " : row {" fo)
(write-line "spacer ;" fo)
(write-line "  : column {" fo)
(write-line "spacer ;" fo)
(write-line "  : icon_image { " fo)
(write-line (strcat "  width =" (rtos siz 2 0) " ;") fo)
(write-line "  aspect_ratio = 1.0 ;" fo)
(write-line  (strcat "key = " (chr 34)  "Ah_img"  (chr 34) " ;") fo)
(write-line "  }" fo)
(write-line "  }" fo)
(write-line " : boxed_column {" fo)
(write-line "  width = 22 ;" fo)
(write-line "spacer_1 ;" fo)
(repeat num
(write-line ": edit_box {" fo)
(setq keynum (strcat "key" (rtos (setq y (+ Y 1)) 2 0)))
(write-line (strcat "    key = " (chr 34) keynum (chr 34) ";") fo)
(write-line (strcat " label = " (chr 34) (nth (+ x 1) dcllst) (chr 34) ";") fo)
(write-line (strcat "     edit_width = " (rtos (nth (+ x 2) dcllst) 2 0) ";") fo)
(write-line (strcat "     edit_limit = " (rtos (nth (+ x 3) dcllst) 2 0) ";") fo)
(write-line "   is_enabled = true ;" fo)
(write-line "    }" fo)
(write-line "spacer_1 ;" fo)
(setq x (+ x 4))
)
(write-line "    }" fo)
(write-line "    }" fo)
(write-line "spacer_1 ;" fo)
(write-line "ok_only;}" fo)
(close fo)

  (setq dcl_id (load_dialog fname))
  (if (not (new_dialog "getvalsimg" dcl_id))
    (exit)
  )
  (setq x 0)
  (setq y 0)
  (setq v_lst '())
  (repeat num
    (setq keynum (strcat "key" (rtos (setq y (+ Y 1)) 2 0)))
    (setq key_lst (cons keynum key_lst))
    (set_tile keynum (nth (setq x (+ x 4)) dcllst))
    (mode_tile keynum 3)
  )

      (start_image "Ah_img")
      (slide_image  0 0 (- (dimx_tile "Ah_img") 1) (- (dimy_tile "Ah_img") 1) img_name)
      (end_image)

  (action_tile "accept" "(mapcar '(lambda (x) (setq v_lst (cons (get_tile x) v_lst))) key_lst)(done_dialog)")
  (start_dialog)
  (unload_dialog dcl_id)
  (vl-file-delete fname)

  (princ v_lst)
)

