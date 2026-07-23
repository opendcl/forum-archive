(defun c:Test ()
  (command "_.opendcl")
  (dcl-Project-Load "Test_Enabled.odcl" T)
;;;Enabled = True
  (defun c:Test_Enabled/Form1/Enabled#OnClicked (/)
    (foreach
              JoyControl
                        (list Test_Enabled/Form1/Label1
                              Test_Enabled/Form1/ComboBox1
                              Test_Enabled/Form1/PictureBox1
                              Test_Enabled/Form1/Label2
                              Test_Enabled/Form1/TextButton1
                              Test_Enabled/Form1/CheckBox1
                              Test_Enabled/Form1/OptionButton1
                              Test_Enabled/Form1/ListBox1
                        ) ;_ fim de Test_Enabled/Form1/Label1
      (dcl-Control-SetEnabled JoyControl T)
    ) ;_ fim de foreach
  ) ;_ fim de defun
;;;Enabled = Flase
  (defun c:Test_Enabled/Form1/Disabled#OnClicked (/)
    (foreach
              JoyControl
                        (list Test_Enabled/Form1/Label1
                              Test_Enabled/Form1/ComboBox1
                              Test_Enabled/Form1/PictureBox1
                              Test_Enabled/Form1/Label2
                              Test_Enabled/Form1/TextButton1
                              Test_Enabled/Form1/CheckBox1
                              Test_Enabled/Form1/OptionButton1
                              Test_Enabled/Form1/ListBox1
                        ) ;_ fim de Test_Enabled/Form1/Label1
      (dcl-Control-SetEnabled JoyControl NIL)
    ) ;_ fim de foreach
  ) ;_ fim de defun
  (dcl-Form-Show Test_Enabled/Form1)
) ;_ fim de defun
;|«Visual LISP© Format Options»
(120 2 1 2 T "fim de " 90 9 0 0 nil nil T nil T)
;*** DO NOT add text below the comment! ***|;


