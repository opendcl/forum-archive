(defun C:trs ( / ) (command "OPENDCL")
(dcl_Project_Load "pruebatres" T) (dcl_Form_Show pruebatres_tres) (princ)

(defun c:pruebatres/tres/TextButton1#OnClicked (/)
  (dcl_Form_Close pruebatres_tres)
  )

  (defun c:pruebatres/tres/TextButton2#OnClicked (/)
  (dcl-MessageBox "TEE1: Ayuda en la inecion de Tee de manera individual" "Descripción de Comandos")
)
  
 (defun c:pruebatres/tres/GraphicButton1#OnClicked (/)
 (LOAD "CJTEE42")
 (CJT42)
)

)
