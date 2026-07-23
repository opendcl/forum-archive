( DEFUN c:line1 ( / a b c p )


  (setq p (list 0 0))
  (setq a (polar p (*  90(/ pi 180)) 10)
	b (polar a (*  180(/ pi 180))0.15)
        c (polar b (*  270(/ pi 180))10)
        d (polar c (*    0(/ pi 180))10))

	(vl-cmdf "color" 3)
  ;(command "zoom" "e")
(command "PLINE" p a b c d "close")

(command "color" 2 "zoom" "e")
)
