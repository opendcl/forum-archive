;;Istoricul programului

;;Versiunea 3.1
;;-modificarea interfetei programului din cauza unui bug din runtime
;;-toate operatiunile se fac acum in fereastra principala

;;Versiunea 3.0
;;-operarea si manipularea datelor se face prin ferestre de dialog
;;-datele se pot salva intr-un fisier cu extensia .dlc
;;-datele pot fi incarcate dintr-un fisier avand extensia .dlc
;;-proprietarul poate fi acum si persoana juridica sau reprezentant al statului
;;-programul suporta acum pana la 3 acte de proprietate
;;-renuntarea la comenzi distincte si inglobarea acestora intr-o singura functie apelabila din fereastra principala
;;-modificarea unor algoritmi de interpretare
;; *Nota: pentru functionarea corecta a programului, este necesara instalarea OpenDCL Runtime arx

;;Versiunea 2.9.1
;;-fisierul cpxml este deschis mai repede

;;versiunea 2.9
;;-optimizarea functiei de generare a fisierului cp (acum ruleaza de 5-10 ori mai repede)

;;versiunea 2.8.9
;;-acum se poate lucra si cu enclave
;;-schimbarea functiei "Schema drumuirii"

;;Versiunea 2.8.8
;;-optimizarea functiei de generare CP
;;-modificarea generarii PAD-ului
;;-adaugarea scarii 1/5000

;;Versiunea 2.8.7
;;-scara planului este calculata automat si pentru schema drumuirii
;;-corectarea unei erori in functia de generare CP

;;Versiunea 2.8.6
;;-cateva fix-uri si corectari de bug-uri

;;Versiunea 2.8.5
;;-scara planului este calculata automat pentru PAD

;;Versiunea 2.8
;;-programul genereaza si fisierul CP

;;Versiunea 2.7.1
;;-cateva modificari in anexele programului

;;Versiunea 2.7
;;-programul genereaza acum si anexa cu fotografiile imobilului

;;Versiunea 2.6
;;-introducerea comenzii "sd" care genereaza schema drumuirii
;;-programul suporta acum 2 proprietari

;;Versiunea 2.5.2
;;-modificarea pozitiei textelor in tabelul parcelar
;;-modificarea anexelor GPS
;;-generarea de entitati Mtext in loc de text in PAD, pentru manipularea mai usoara a lor
;;-mici modificari pentru anexa 2 si tabelul de miscare parcelara

;;Versiunea 2.5.1
;;-corectarea erorilor din versiunea 2.5
;;-generarea memoriului tehnic si pentru lucrarile facute cu GPS-ul


;;Versiunea 2.5
;;-anexa 1 este generata si in cazul in care pad-ul este deja creat
;;-programul genereaza si anexa 2
;;-programul genereaza anexa 5 si anexa 1 noua
;;-programul genereaza memoriu tehnic si tabel de miscare parcelara

;;Versiunea 2.4
;;-datele despre constructii sunt create dinamic, in functie de numarul de constructii
;;-corectarea pozitiei textelor pentru formatul landscape

;;Versiunea 2.3
;;-datele despre teren sunt create dinamic, in functie de numarul de parcele
;;-corectarea pozitiei textelor pentru formatul landscape

;;Versiunea 2.2
;;-padul poate fi creat acum si in format Landscape
;;-plansa se poate scala si pentru A3

;;Versiunea 2.1
;;-padul este creat acum pentru orice scara
;;-programul preia informatiile doar din atributele din blocul "df"

;;Versiunea 2
;;-programul suporta acum pana la 5 parcele si 5 constructii
;;-reducerea si optimizarea codului sursa

;;Versiunea 1.0
;;-programul creeaza un PAD simplu

(command "OPENDCL")
(defun c:doc ()
(dcl_Project_Load "Documentatii" T)
(dcl_Form_Show Documentatii_Form1)
(princ)
)
(defun ReadCSV ( filename / _replacequotes _csv->lst file line lst)

;;elementele unei liste sunt afisate in linia de comanda intre ghilimele 
;;aceasta functie sterge acele ghilimele 

    (defun _replacequotes ( str / pos )

        (setq pos 0)

        (while (setq pos (vl-string-search  "\"\"" str pos))

            (setq str (vl-string-subst "\"" "\"\"" str pos)

                  pos (1+ pos)

            )

        )

        str

    )

 
;;aceasta functie creeaza o lista cu elementele unei linii din fisierul csv
    (defun _csv->lst ( str pos / s )

        (cond

            (   (null (setq pos (vl-string-position 44 str pos)))

                (if (wcmatch str "\"*\"")

                    (list (_replacequotes (substr str 2 (- (strlen str) 2))))

                    (list str)

                )

            )

            (   (wcmatch (setq s (substr str 1 pos)) "\"*\"")

                (cons

                    (_replacequotes (substr str 2 (- pos 2)))

                    (_csv->lst (substr str (+ pos 2)) 0)

                )

            )

            (   (wcmatch s "\"*[~\"]")

                (_csv->lst str (+ pos 2))

            )

            (   (cons s (_csv->lst (substr str (+ pos 2)) 0)))

        )

    )


    (if (setq file (open filename "r"))

        (progn
            (while
			(setq line (read-line file))
                (setq lst (cons (_csv->lst line 0) lst))										

            )			

            (close file)

        )
		)
;;Aceasta este lista cu toate liniile din fisierul "Siruta.csv"		
(reverse lst)
;;Pentru a mari viteza de citire, fiecare judet are o variabila posf distincta, astfel incat citirea in fisier sa se faca direct de la judetul respectiv si nu de la inceputul fisierului
(while (< posf (length lst))
;;Vedem cat e numarul judetului in tabel
(setq jn2 (caddr (cdr (cdr (nth posf lst)))))
;;Daca numarul de ordine al judetului corespunde cu nr. din tabel
(if (= jn2 jnr)
(progn
(setq siruta (car (nth posf lst)))
(setq sirsup (cadr (nth posf lst)))
(setq string2 (caddr (cdr (nth posf lst))))
;;Daca avem un UAT si nu un sat
(if (<= (strlen sirsup) 3)
(dcl_ComboBox_AddString Documentatii_Form1_ComboBox5 string2)
)
)
)
(setq posf (1+ posf))
)
)
(setq csv (findfile "Siruta.csv"))


;;butonul OK din prima forma
(defun c:Documentatii_Form1_TextButton5_OnClicked ()
(setq tarla (dcl_Control_GetText Documentatii_Form1_TextBox2))
(setq parcf1 (dcl_Control_GetText Documentatii_Form1_TextBox3))
(setq ar1 (dcl_Control_GetText Documentatii_Form1_TextBox21)) 
(setq parcf2 (dcl_Control_GetText Documentatii_Form1_TextBox4))
(setq ar2 (dcl_Control_GetText Documentatii_Form1_TextBox22))
(setq parcf3 (dcl_Control_GetText Documentatii_Form1_TextBox5))
(setq ar3 (dcl_Control_GetText Documentatii_Form1_TextBox23))
(setq parcf4 (dcl_Control_GetText Documentatii_Form1_TextBox6))
(setq ar4 (dcl_Control_GetText Documentatii_Form1_TextBox24))
(setq parcf5 (dcl_Control_GetText Documentatii_Form1_TextBox7))
(setq ar5 (dcl_Control_GetText Documentatii_Form1_TextBox25))
(if (= (dcl_Control_GetValue Documentatii_Form1_CheckBox5) 1)
(dcl_Control_SetEnabled Documentatii_Form1_ComboBox6 nil)
)
;;Procesam datele despre acte
(setq act1 (dcl_Control_GetText Documentatii_Form1_ComboBox1))
(setq nract1 (dcl_Control_GetText Documentatii_Form1_TextBox8))
(setq dataact1 (dcl_Control_GetText Documentatii_Form1_TextBox9))
(setq aut1 (dcl_Control_GetText Documentatii_Form1_TextBox10))
(setq act2 (dcl_Control_GetText Documentatii_Form1_ComboBox2))
(setq nract2 (dcl_Control_GetText Documentatii_Form1_TextBox27))
(setq dataact2 (dcl_Control_GetText Documentatii_Form1_TextBox28))
(setq aut2 (dcl_Control_GetText Documentatii_Form1_TextBox29))
(setq act3 (dcl_Control_GetText Documentatii_Form1_ComboBox3))
(setq nract3 (dcl_Control_GetText Documentatii_Form1_TextBox30))
(setq dataact3 (dcl_Control_GetText Documentatii_Form1_TextBox31))
(setq aut3 (dcl_Control_GetText Documentatii_Form1_TextBox32))
(setq sact (dcl_Control_GetText Documentatii_Form1_TextBox26))
(setq prop1 (dcl_Control_GetText Documentatii_Form1_TextBox15))
(setq cnp1 (dcl_Control_GetText Documentatii_Form1_TextBox14))
(setq serieci1 (dcl_Control_GetText Documentatii_Form1_TextBox13))
(setq nrci1 (dcl_Control_GetText Documentatii_Form1_TextBox12))
(setq prop2 (dcl_Control_GetText Documentatii_Form1_TextBox20))
(setq cnp2 (dcl_Control_GetText Documentatii_Form1_TextBox19))
(setq serieci2 (dcl_Control_GetText Documentatii_Form1_TextBox18))
(setq nrci2 (dcl_Control_GetText Documentatii_Form1_TextBox17))
(defun c:Documentatii_Form1_OnInitialize ()
(setq tarla (dcl_Control_SetText Documentatii_Form1_TextBox2 tarla))
(setq parcf1 (dcl_Control_SetText Documentatii_Form1_TextBox3 parcf1))
(setq ar1 (dcl_Control_SetText Documentatii_Form1_TextBox21 ar1)) 
(setq parcf2 (dcl_Control_SetText Documentatii_Form1_TextBox4 parcf2))
(setq ar2 (dcl_Control_SetText Documentatii_Form1_TextBox22 ar2))
(setq parcf3 (dcl_Control_SetText Documentatii_Form1_TextBox5 parcf3))
(setq ar3 (dcl_Control_SetText Documentatii_Form1_TextBox23 ar3))
(setq parcf4 (dcl_Control_SetText Documentatii_Form1_TextBox6 parcf4))
(setq ar4 (dcl_Control_SetText Documentatii_Form1_TextBox24 ar4))
(setq parcf5 (dcl_Control_SetText Documentatii_Form1_TextBox7 parcf5))
(setq ar5 (dcl_Control_SetText Documentatii_Form1_TextBox25 ar5))
(setq act1 (dcl_Control_SetText Documentatii_Form1_ComboBox1 act1))
(setq nract1 (dcl_Control_SetText Documentatii_Form1_TextBox8 nract1))
(setq dataact1 (dcl_Control_SetText Documentatii_Form1_TextBox9 dataact1))
(setq aut1 (dcl_Control_SetText Documentatii_Form1_TextBox10 aut1))
(setq act2 (dcl_Control_SetText Documentatii_Form1_ComboBox2 act2))
(setq nract2 (dcl_Control_SetText Documentatii_Form1_TextBox27 nract2))
(setq dataact2 (dcl_Control_SetText Documentatii_Form1_TextBox28 dataact2))
(setq aut2 (dcl_Control_SetText Documentatii_Form1_TextBox29 aut2))
(setq act3 (dcl_Control_SetText Documentatii_Form1_ComboBox3 act3))
(setq nract3 (dcl_Control_SetText Documentatii_Form1_TextBox30 nract3))
(setq dataact3 (dcl_Control_SetText Documentatii_Form1_TextBox31 dataact3))
(setq aut3 (dcl_Control_SetText Documentatii_Form1_TextBox32 aut3))
(setq sact (dcl_Control_SetText Documentatii_Form1_TextBox26 sact))
(setq prop1 (dcl_Control_SetText Documentatii_Form1_TextBox15 prop1))
(setq cnp1 (dcl_Control_SetText Documentatii_Form1_TextBox14 cnp1))
(setq serieci1 (dcl_Control_SetText Documentatii_Form1_TextBox13 serieci1))
(setq nrci1 (dcl_Control_SetText Documentatii_Form1_TextBox12 nrci1))
(setq prop2 (dcl_Control_SetText Documentatii_Form1_TextBox20 prop2))
(setq cnp2 (dcl_Control_SetText Documentatii_Form1_TextBox19 cnp2))
(setq serieci2 (dcl_Control_SetText Documentatii_Form1_TextBox18 serieci2))
(setq nrci2 (dcl_Control_SetText Documentatii_Form1_TextBox17 nrci2))
(if (or (> (strlen c1) 0) (> (strlen c2) 0) (> (strlen c3) 0) (> (strlen c4) 0) (> (strlen c5) 0))
(dcl_Control_SetValue Documentatii_Form1_CheckBox1 1)
)
(dcl_PictureBox_LoadPictureFile Documentatii_Form1_PictureBox1 pic1 T)
(dcl_PictureBox_LoadPictureFile Documentatii_Form1_PictureBox2 pic2 T)
(dcl_PictureBox_LoadPictureFile Documentatii_Form1_PictureBox3 pic3 T)
)
(dcl_Form_Close Documentatii_Form1)
)
;;butonul Anuleaza din prima forma
(defun c:Documentatii_Form1_TextButton6_OnClicked (/)
(dcl_Form_Close Documentatii_Form1)
(defun c:Documentatii_Form1_OnInitialize ()
(setq tarla (dcl_Control_SetText Documentatii_Form1_TextBox2 (dcl_Control_GetText Documentatii_Form1_TextBox2)))
(setq parcf1 (dcl_Control_SetText Documentatii_Form1_TextBox3 (dcl_Control_GetText Documentatii_Form1_TextBox3)))
(setq ar1 (dcl_Control_SetText Documentatii_Form1_TextBox21 (dcl_Control_GetText Documentatii_Form1_TextBox21)))
(setq parcf2 (dcl_Control_SetText Documentatii_Form1_TextBox4 (dcl_Control_GetText Documentatii_Form1_TextBox4)))
(setq ar2 (dcl_Control_SetText Documentatii_Form1_TextBox22 (dcl_Control_GetText Documentatii_Form1_TextBox22)))
(setq parcf3 (dcl_Control_SetText Documentatii_Form1_TextBox5 (dcl_Control_GetText Documentatii_Form1_TextBox5)))
(setq ar3 (dcl_Control_SetText Documentatii_Form1_TextBox23 (dcl_Control_GetText Documentatii_Form1_TextBox23)))
(setq parcf4 (dcl_Control_SetText Documentatii_Form1_TextBox6 (dcl_Control_GetText Documentatii_Form1_TextBox6)))
(setq ar4 (dcl_Control_SetText Documentatii_Form1_TextBox24 (dcl_Control_GetText Documentatii_Form1_TextBox24))) 
(setq parcf5 (dcl_Control_SetText Documentatii_Form1_TextBox7 (dcl_Control_GetText Documentatii_Form1_TextBox7)))
(setq ar5 (dcl_Control_SetText Documentatii_Form1_TextBox25 (dcl_Control_GetText Documentatii_Form1_TextBox25)))
(setq act1 (dcl_Control_SetText Documentatii_Form1_ComboBox1 (dcl_Control_GetText Documentatii_Form1_ComboBox1)))
(setq nract1 (dcl_Control_SetText Documentatii_Form1_TextBox8 (dcl_Control_GetText Documentatii_Form1_TextBox8)))
(setq dataact1 (dcl_Control_SetText Documentatii_Form1_TextBox9 (dcl_Control_GetText Documentatii_Form1_TextBox9)))
(setq aut1 (dcl_Control_SetText Documentatii_Form1_TextBox10 (dcl_Control_GetText Documentatii_Form1_TextBox10)))
(setq act2 (dcl_Control_SetText Documentatii_Form1_ComboBox2 (dcl_Control_GetText Documentatii_Form1_ComboBox2)))
(setq nract2 (dcl_Control_SetText Documentatii_Form1_TextBox27 (dcl_Control_GetText Documentatii_Form1_TextBox27)))
(setq dataact2 (dcl_Control_SetText Documentatii_Form1_TextBox28 (dcl_Control_GetText Documentatii_Form1_TextBox28)))
(setq aut2 (dcl_Control_SetText Documentatii_Form1_TextBox29 (dcl_Control_GetText Documentatii_Form1_TextBox29)))
(setq act3 (dcl_Control_SetText Documentatii_Form1_ComboBox3 (dcl_Control_GetText Documentatii_Form1_ComboBox3)))
(setq nract3 (dcl_Control_SetText Documentatii_Form1_TextBox30 (dcl_Control_GetText Documentatii_Form1_TextBox30)))
(setq dataact3 (dcl_Control_SetText Documentatii_Form1_TextBox31 (dcl_Control_GetText Documentatii_Form1_TextBox31)))
(setq aut3 (dcl_Control_SetText Documentatii_Form1_TextBox32 (dcl_Control_GetText Documentatii_Form1_TextBox32)))
(setq sact (dcl_Control_SetText Documentatii_Form1_TextBox26 (dcl_Control_GetText Documentatii_Form1_TextBox26)))
(setq prop1 (dcl_Control_SetText Documentatii_Form1_TextBox15 (dcl_Control_GetText Documentatii_Form1_TextBox15)))
(setq cnp1 (dcl_Control_SetText Documentatii_Form1_TextBox14 (dcl_Control_GetText Documentatii_Form1_TextBox14)))
(setq serieci1 (dcl_Control_SetText Documentatii_Form1_TextBox13 (dcl_Control_GetText Documentatii_Form1_TextBox13)))
(setq nrci1 (dcl_Control_SetText Documentatii_Form1_TextBox12 (dcl_Control_GetText Documentatii_Form1_TextBox12)))
(setq prop2 (dcl_Control_SetText Documentatii_Form1_TextBox20 (dcl_Control_GetText Documentatii_Form1_TextBox20)))
(setq cnp2 (dcl_Control_SetText Documentatii_Form1_TextBox19 (dcl_Control_GetText Documentatii_Form1_TextBox19)))
(setq serieci2 (dcl_Control_SetText Documentatii_Form1_TextBox18 (dcl_Control_GetText Documentatii_Form1_TextBox18)))
(setq nrci2 (dcl_Control_SetText Documentatii_Form1_TextBox17 (dcl_Control_GetText Documentatii_Form1_TextBox17))) 
)
)
;;Lista de optiuni pentru primul proprietar
(setq ItemIndexOrCount 0)
(defun c:Documentatii_Form1_OptionList1_OnSelChanged (ItemIndexOrCount Value /)
(cond
((= ItemIndexOrCount 0)
(dcl_Control_SetVisible Documentatii_Form1_Label18 T)
(dcl_Control_SetCaption Documentatii_Form1_Label18 "Nume si prenume proprietar")
(dcl_Control_SetCaption Documentatii_Form1_Label19 "CNP")
(dcl_Control_SetVisible Documentatii_Form1_TextBox15 T)
(dcl_Control_SetVisible Documentatii_Form1_Label22 T)
(dcl_Control_SetVisible Documentatii_Form1_Label19 T)
(dcl_Control_SetVisible Documentatii_Form1_Label20 T)
(dcl_Control_SetVisible Documentatii_Form1_Label21 T)
(setq prop1 (dcl_Control_GetText Documentatii_Form1_TextBox15))
(setq cnp1 (dcl_Control_GetText Documentatii_Form1_TextBox14))
(dcl_Control_SetVisible Documentatii_Form1_TextBox13 T)
(setq serieci1 (dcl_Control_GetText Documentatii_Form1_TextBox13))
(dcl_Control_SetVisible Documentatii_Form1_TextBox12 T)
(setq nrci1 (dcl_Control_GetText Documentatii_Form1_TextBox12))
)
((= ItemIndexOrCount 1)
(dcl_Control_SetVisible Documentatii_Form1_Label18 T)
(dcl_Control_SetCaption Documentatii_Form1_Label18 "Denumirea persoanei juridice")
(dcl_Control_SetVisible Documentatii_Form1_TextBox15 T)
(dcl_Control_SetVisible Documentatii_Form1_Label22 T)
(dcl_Control_SetVisible Documentatii_Form1_Label19 T)
(setq prop1 (dcl_Control_GetText Documentatii_Form1_TextBox15))
(dcl_Control_SetCaption Documentatii_Form1_Label19 "CUI")
(dcl_Control_SetVisible Documentatii_Form1_TextBox14 T)
(setq cnp1 (dcl_Control_GetText Documentatii_Form1_TextBox14))
(dcl_Control_SetVisible Documentatii_Form1_Label20 nil)
(dcl_Control_SetVisible Documentatii_Form1_TextBox13 nil)
(dcl_Control_SetVisible Documentatii_Form1_Label21 nil)
(dcl_Control_SetVisible Documentatii_Form1_TextBox12 nil)
)
((= ItemIndexOrCount 2)
(dcl_Control_SetCaption Documentatii_Form1_Label18 "Denumirea institutiei")
(setq prop1 (dcl_Control_GetText Documentatii_Form1_TextBox15))
(dcl_Control_SetVisible Documentatii_Form1_Label19 nil)
(dcl_Control_SetVisible Documentatii_Form1_TextBox14 nil)
(dcl_Control_SetVisible Documentatii_Form1_Label20 nil)
(dcl_Control_SetVisible Documentatii_Form1_TextBox13 nil)
(dcl_Control_SetVisible Documentatii_Form1_Label21 nil)
(dcl_Control_SetVisible Documentatii_Form1_TextBox12 nil)
)
(T nil)
)
)
;;Optiunile pentru cel de-al doilea proprietar
(setq ItemIndexOrCount2 0)
(defun c:Documentatii_Form1_OptionList2_OnSelChanged (ItemIndexOrCount2 Value /)
(cond
((= ItemIndexOrCount2 0)
(dcl_Control_SetVisible Documentatii_Form1_Label23 T)
(dcl_Control_SetCaption Documentatii_Form1_Label23 "Nume si prenume proprietar")
(dcl_Control_SetVisible Documentatii_Form1_Label24 T)
(dcl_Control_SetCaption Documentatii_Form1_Label24 "CNP")
(dcl_Control_SetVisible Documentatii_Form1_TextBox19 T)
(dcl_Control_SetVisible Documentatii_Form1_Label25 T)
(dcl_Control_SetVisible Documentatii_Form1_TextBox18 T)
(dcl_Control_SetVisible Documentatii_Form1_Label26 T)
(dcl_Control_SetVisible Documentatii_Form1_TextBox17 T)
(setq prop2 (dcl_Control_GetText Documentatii_Form1_TextBox20))
(setq cnp2 (dcl_Control_GetText Documentatii_Form1_TextBox19))
(setq serieci2 (dcl_Control_GetText Documentatii_Form1_TextBox18))
(setq nrci2 (dcl_Control_GetText Documentatii_Form1_TextBox17))
)
((= ItemIndexOrCount2 1)
(dcl_Control_SetCaption Documentatii_Form1_Label23 "Denumirea persoanei juridice")
(dcl_Control_SetVisible Documentatii_Form1_Label24 T)
(dcl_Control_SetVisible Documentatii_Form1_TextBox19 T)
(setq prop2 (dcl_Control_GetText Documentatii_Form1_TextBox20))
(dcl_Control_SetCaption Documentatii_Form1_Label24 "CUI")
(setq cnp2 (dcl_Control_GetText Documentatii_Form1_TextBox19))
(dcl_Control_SetVisible Documentatii_Form1_Label25 nil)
(dcl_Control_SetVisible Documentatii_Form1_TextBox18 nil)
(dcl_Control_SetVisible Documentatii_Form1_Label26 nil)
(dcl_Control_SetVisible Documentatii_Form1_TextBox17 nil) 
)
((= ItemIndexOrCount2 2)
(dcl_Control_SetCaption Documentatii_Form1_Label23 "Denumirea institutiei")
(setq prop2 (dcl_Control_GetText Documentatii_Form1_TextBox20))
(dcl_Control_SetVisible Documentatii_Form1_Label24 nil)
(dcl_Control_SetVisible Documentatii_Form1_TextBox19 nil)
(dcl_Control_SetVisible Documentatii_Form1_Label25 nil)
(dcl_Control_SetVisible Documentatii_Form1_TextBox18 nil)
(dcl_Control_SetVisible Documentatii_Form1_Label26 nil)
(dcl_Control_SetVisible Documentatii_Form1_TextBox17 nil)
)
(T nil)
)
)


;;Checkboxul din prima forma
(defun c:Documentatii_Form1_CheckBox1_OnClicked (Value /)
(dcl_Form_Show Documentatii_Form2)
)
;;Butonul OK din a doua forma 
(defun c:Documentatii_Form2_TextButton1_OnClicked (/)
(dcl_Form_Close Documentatii_Form2)
(setq c1 (dcl_Control_GetText Documentatii_Form2_TextBox3))
(setq ariec1 (dcl_Control_GetText Documentatii_Form2_TextBox1))
(setq c2 (dcl_Control_GetText Documentatii_Form2_TextBox2))
(setq ariec2 (dcl_Control_GetText Documentatii_Form2_TextBox7))
(setq c3 (dcl_Control_GetText Documentatii_Form2_TextBox4))
(setq ariec3 (dcl_Control_GetText Documentatii_Form2_TextBox8))
(setq c4 (dcl_Control_GetText Documentatii_Form2_TextBox5))
(setq ariec4 (dcl_Control_GetText Documentatii_Form2_TextBox9))
(setq c5 (dcl_Control_GetText Documentatii_Form2_TextBox6))
(setq ariec5 (dcl_Control_GetText Documentatii_Form2_TextBox10))
(dcl_Control_SetValue Documentatii_Form1_CheckBox1 1)
(if (and (< (strlen c1) 1) (< (strlen c2) 1) (< (strlen c3) 1) (< (strlen c4) 1) (< (strlen c5) 1))
(dcl_Control_SetValue Documentatii_Form1_CheckBox1 0)
)
)
;;Butonul Anuleaza din a doua forma
(defun c:Documentatii_Form2_TextButton3_OnClicked (/)
(dcl_Form_Close Documentatii_Form2)
(dcl_Control_SetValue Documentatii_Form1_CheckBox1 0)
)
;;Pentru prima imagine
(defun c:Documentatii_Form1_PictureBox1_OnClicked (/)
(setq pic1 (dcl_Form_Show Documentatii_Form3))
(dcl_PictureBox_LoadPictureFile Documentatii_Form1_PictureBox1 pic1 T)
(dcl_PictureBox_StoreImage Documentatii_Form1_PictureBox1)
)
;;Pentru a doua imagine
(defun c:Documentatii_Form1_PictureBox2_OnClicked (/)
(setq pic2 (dcl_Form_Show Documentatii_Form4))
(dcl_PictureBox_LoadPictureFile Documentatii_Form1_PictureBox2 pic2 T)
(dcl_PictureBox_StoreImage Documentatii_Form1_PictureBox2)
)
(defun c:Documentatii_Form1_PictureBox3_OnClicked (/)
(setq pic3 (dcl_Form_Show Documentatii_Form5))
(dcl_PictureBox_LoadPictureFile Documentatii_Form1_PictureBox3 pic3 T)
)

;;Setam adresa imobilului
(defun c:Documentatii_Form1_ComboBox4_OnSelChanged (ItemIndexOrCount Value /)
(cond
((= ItemIndexOrCount 0)
(setq jnr "1")
(setq posf 16310)
(setq posf2 16310)
(setq posf3 16310)
(dcl_ComboBox_Clear Documentatii_Form1_ComboBox5)
(ReadCSV csv)
)
((= ItemIndexOrCount 1)
(setq jnr "2")
(setq posf 15615)
(setq posf2 15615)
(setq posf3 15615)
(dcl_ComboBox_Clear Documentatii_Form1_ComboBox5)
(ReadCSV csv)
)
(T nil)
)
)



