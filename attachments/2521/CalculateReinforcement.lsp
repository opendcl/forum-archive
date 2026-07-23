(dcl_Project_Load "CalculateReinforcement" T)
(defun c:gtbr () 
    (setq gtc:CalculateReinforcement_data       T
          gtc:CalculateReinforcement_h          "450"
          gtc:CalculateReinforcement_hf         "150"
          gtc:CalculateReinforcement_b          "200"
          gtc:CalculateReinforcement_bf         "1000"
          gtc:CalculateReinforcement_a1         "25"
          gtc:CalculateReinforcement_a2         "25"
          gtc:CalculateReinforcement_fis        "8"
          gtc:CalculateReinforcement_ns         "2"
          gtc:CalculateReinforcement_steel      "B500"
          gtc:CalculateReinforcement_conc       "C25/30"
          gtc:CalculateReinforcement_conc_list  (list "C16/20" "C20/25" "C25/30" "C30/37" "C35/45")
          gtc:CalculateReinforcement_steel_list (list "B500" "B400")
          gtc:CalculateReinforcement_my         "100"
    )
    (dcl_Form_Show CalculateReinforcement/Zginanie)
    (princ)
)


(defun c:CalculateReinforcement/Zginanie#OnInitialize (/) 
    (dcl-ComboBox-Clear CalculateReinforcement/Zginanie/ComboBox2)
    (dcl-ComboBox-Clear CalculateReinforcement/Zginanie/ComboBox1)
    (dcl-Control-SetList CalculateReinforcement/Zginanie/ComboBox1 gtc:CalculateReinforcement_conc_list)
    (dcl-Control-SetList CalculateReinforcement/Zginanie/ComboBox2 gtc:CalculateReinforcement_steel_list)
    (dcl-ComboBox-SelectString CalculateReinforcement/Zginanie/ComboBox2 gtc:CalculateReinforcement_steel)
    (dcl-ComboBox-SelectString CalculateReinforcement/Zginanie/ComboBox1 gtc:CalculateReinforcement_conc)
    (dcl-ComboBox-SelectString CalculateReinforcement/Zginanie/ComboBox4 gtc:CalculateReinforcement_fis)
    (dcl-ComboBox-SelectString CalculateReinforcement/Zginanie/ComboBox3 gtc:CalculateReinforcement_ns)
    (dcl-Control-SetText CalculateReinforcement/Zginanie/TextBox2 gtc:CalculateReinforcement_b)
    (dcl-Control-SetText CalculateReinforcement/Zginanie/TextBox3 gtc:CalculateReinforcement_h)
    (dcl-Control-SetText CalculateReinforcement/Zginanie/TextBox1 gtc:CalculateReinforcement_a1)
    (dcl-Control-SetText CalculateReinforcement/Zginanie/TextBox9 gtc:CalculateReinforcement_a2)
    (dcl-Control-SetText CalculateReinforcement/Zginanie/TextBox6 gtc:CalculateReinforcement_my)
    (dcl-Control-SetText CalculateReinforcement/Zginanie/TextBox7 gtc:CalculateReinforcement_bf)
    (dcl-Control-SetText CalculateReinforcement/Zginanie/TextBox8 gtc:CalculateReinforcement_hf)
    (dcl-Control-SetEnabled CalculateReinforcement/Zginanie/ComboBox4 nil)
    (dcl-Control-SetEnabled CalculateReinforcement/Zginanie/ComboBox3 nil)
    (dcl-Control-SetEnabled CalculateReinforcement/Zginanie/TextBox7 nil)
    (dcl-Control-SetEnabled CalculateReinforcement/Zginanie/TextBox8 nil)
    (dcl-Control-SetPicture CalculateReinforcement/Zginanie/ZginanieIMG 103)
    (princ)
)


(defun c:CalculateReinforcement/Zginanie/TextBox3#OnKillFocus (/) 
    (setq gtc:CalculateReinforcement_b (dcl-Control-GetText CalculateReinforcement/Zginanie/TextBox3))
)
(defun c:CalculateReinforcement/Zginanie/TextBox1#OnKillFocus (/) 
    (setq gtc:CalculateReinforcement_h (dcl-Control-GetText CalculateReinforcement/Zginanie/TextBox1))
)
(defun c:CalculateReinforcement/Zginanie/TextBox4#OnKillFocus (/) 
    (setq gtc:CalculateReinforcement_a1 (dcl-Control-GetText CalculateReinforcement/Zginanie/TextBox4))
)
(defun c:CalculateReinforcement/Zginanie/TextBox5#OnKillFocus (/) 
    (setq gtc:CalculateReinforcement_a2 (dcl-Control-GetText CalculateReinforcement/Zginanie/TextBox5))
)
(defun c:CalculateReinforcement/Zginanie/TextBox6#OnKillFocus (/) 
    (setq gtc:CalculateReinforcement_b (dcl-Control-GetText CalculateReinforcement/Zginanie/TextBox6))
)

(defun c:CalculateReinforcement/Zginanie/TabStrip1#OnChanged (ItemIndex /) 
    (cond 
        ((= ItemIndex 0)
         (dcl-Control-SetEnabled CalculateReinforcement/Zginanie/ComboBox4 nil)
         (dcl-Control-SetEnabled CalculateReinforcement/Zginanie/ComboBox3 nil)
         (dcl-Control-SetEnabled CalculateReinforcement/Zginanie/TextBox7 nil)
         (dcl-Control-SetEnabled CalculateReinforcement/Zginanie/TextBox8 nil)
         (dcl-Control-SetEnabled CalculateReinforcement/Zginanie/TextBox9 T)
         (dcl-Control-SetEnabled CalculateReinforcement/Zginanie/TextBox1 T)
         (dcl-Control-SetPicture CalculateReinforcement/Zginanie/ZginanieIMG 103)
        )
        ((= ItemIndex 1)
         (dcl-Control-SetEnabled CalculateReinforcement/Zginanie/ComboBox4 nil)
         (dcl-Control-SetEnabled CalculateReinforcement/Zginanie/ComboBox3 nil)
         (dcl-Control-SetEnabled CalculateReinforcement/Zginanie/TextBox7 T)
         (dcl-Control-SetEnabled CalculateReinforcement/Zginanie/TextBox8 T)
         (dcl-Control-SetEnabled CalculateReinforcement/Zginanie/TextBox9 nil)
         (dcl-Control-SetEnabled CalculateReinforcement/Zginanie/TextBox1 T)
         (dcl-Control-SetPicture CalculateReinforcement/Zginanie/ZginanieIMG 101)
        )
        ((= ItemIndex 2)
         (dcl-Control-SetEnabled CalculateReinforcement/Zginanie/ComboBox4 T)
         (dcl-Control-SetEnabled CalculateReinforcement/Zginanie/ComboBox3 T)
         (dcl-Control-SetEnabled CalculateReinforcement/Zginanie/TextBox7 nil)
         (dcl-Control-SetEnabled CalculateReinforcement/Zginanie/TextBox8 nil)
         (dcl-Control-SetEnabled CalculateReinforcement/Zginanie/TextBox9 nil)
         (dcl-Control-SetEnabled CalculateReinforcement/Zginanie/TextBox1 nil)
         (dcl-Control-SetPicture CalculateReinforcement/Zginanie/ZginanieIMG 102)
        )
    )
    (princ)
)


