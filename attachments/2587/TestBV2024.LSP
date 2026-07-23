(defun c:test ()

  (dcl_project_load "d:/TestBV2024" T)


  (defun c:TestBV2024/Form1/TextButton1#OnClicked (/)
    (dcl-BlockView-Clear TestBV2024/Form1/BlockView1)
  )

  (defun c:TestBV2024/Form1/TextButton2#OnClicked (/)
    (dcl_BlockView_DisplayDwg TestBV2024/Form1/BlockView1 "d:/TestBV2024.dwg" 0 0.95)
  )

  (dcl_form_show TestBV2024/Form1)
)

(c:test)


