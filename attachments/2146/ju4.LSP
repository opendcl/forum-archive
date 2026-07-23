(command "opendcl")

(defun c:ju4()
  (dcl_project_load "slidertest" t)
  (dcl_form_show slidertest_SliderTest)
  (princ)

  )


(defun c:slidertest/SliderTest/Slider#OnScroll (Value /)
  (setq nValue (dcl-Control-GetValue slidertest/SliderTest/Slider))
  (princ nValue)
    (dcl_Control_SetText slidertest_SliderTest_TextBox (itoa nValue))
  (princ)
)


