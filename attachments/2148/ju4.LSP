(command "opendcl")


(defun c:ju4 (/ c:slidertest/SliderTest#OnInitialize c:slidertest/SliderTest/Slider#OnScroll)
  ;(dcl_project_load "slidertest" t)
  (dcl_project_load "D:/Service/Support/OpenDCL/150812/slidertest.odcl")

  (defun c:slidertest/SliderTest#OnInitialize (/)
    (dcl-control-setvalue slidertest/SliderTest/Slider 50)
    (dcl-Control-SetText slidertest/SliderTest/TextBox "50")
  ); c:slidertest/SliderTest#OnInitialize

  (defun c:slidertest/SliderTest/Slider#OnScroll (Value / nValue)
    (setq nValue (dcl-Control-GetValue slidertest/SliderTest/Slider))
    (dcl_Control_SetText slidertest/SliderTest/TextBox (itoa nValue))
  ); c:slidertest/SliderTest/Slider#OnScroll
  
  (dcl_form_show slidertest_SliderTest)
  (princ)

)





