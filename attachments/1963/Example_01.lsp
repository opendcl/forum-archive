
(defun c:tst (/)
 (cond
  ;;((not (dcl-Project-Load "Example_01.odcl"))
  ;; (dcl_MessageBox (strcat "Project not found: \n \n [" "Example_01.odcl" "]") "error dialogue DCL" 2 4)
  ;;)
  ((not (_ODCL_Proyect_Import))
   (dcl_MessageBox  "Project not Import" "error dialogue DCL" 2 4)
  )
  ((not (dcl_Form_IsActive (vl-doc-ref 'Example_01_Form1)))
   (dcl_Form_Show (vl-doc-ref 'Example_01_Form1))
  )
 )
)

(defun c:Example_01_Form1_OnEnteringNoDocState (/)
 ;(dcl-Form-CloseAll (+ 64 4 2))
 (dcl_Form_CloseAll (+ 64 4 2))
)

(defun _ODCL_Proyect_Import ( / project)
 (setq project
	'("YWt6A3AKAADOZ1sXBuKzKjUVLT9qgBCl2j3yLvR0VDa+NKNqjBYS7BvPUMpxYXVv+q6Kn90XVCtK"
	"xg+XPKnEDpl9jyO/efb8GtuevNt1Af7eKykj9krgTbezogI6/VyWw7KzAg2w4oeY4o3b2cQkOwM6"
	"OC64WpgPfDuyXvFGbI5+wpN4XB/n9i2hanhP83II9rXSsnmaJW65/LKq7MvNcvh6WxvYVSePN1xb"
	"3cgFOCAFFitd2BvJ0GhaGBMJdBdfTBNdWBpLU83SuvK1RV5VN2U9MfO1FCzcGbrBbS8bVT/Vvlhm"
	"cWPWQQwyFmlozlbJNb7CPNER18Xmg5aM6Ur2RxkBko0/fOTNdoUYGxAwbQD/bnzx10inhdnuPdWK"
	"mJ8Wm0//7AbrDjSS9UZYzV1maYUwZy1GXpXtqBhUkEq1yKnP07aywlkIGXYJBPOlJMgxowD1YW0A"
	"PIZvn/VqgUyfTJ/OqfKx3aXx25tNJQEkRD1FIUkHvBIJssC19hCo8ftnkPa2zmo8bUX5LzeINzcT"
	"laCW/heiSq5poeqXC9QFaSsYvIcRL2JcgBVXTS+8NarpCbcA4Y5DvHF2OVYg+4bp5CxqY+3Q9bdG"
	"VCMp6klYwybq0Eq5ZQ+Sg7J8n4e4w8Nrs61ip/X6fWOCMI9LnAv9BqEIgJVqoQ9G2IZsh2HaQmp2"
	"oVqBi1DgROTDcNFWwD6FEd8nLym2wPGcY1iFKwkhU/4nC4fPAkAtwOhlC9STgTZEhpyMEYNBS2oo"
	"vQPKAeWdiTiTnQqhQ9qGL7wd+gltGOOILcB9xINUXWTvsWR1DdIlndULJqolgH2zgDzdhOEfDHAR"
	"KrJkY9wkzdjptoDukLTkEtkfqIKB1J8ZUBG1lGGuijXKrpo2g+GnmbNkE9m/c4twj4nNWO0q+T9E"
	"gS5l84juQzsHGHPZl8IB1h+1Qd6fmaAhrg7ojInl5KiZeU/ZMlw=")
 )
 (dcl_project_import project nil nil)
)
(princ)
