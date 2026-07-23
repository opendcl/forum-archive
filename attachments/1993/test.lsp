(command "opendcl")

(DEFUN C:TEST()
(dcl-Project-Load "TEST")
(dcl-Form-Show TEST/Form1)

(defun c:TEST/Form1/EXIT_BUTTON#OnClicked (/)
(dcl-Form-Close TEST/Form1)
)

)
