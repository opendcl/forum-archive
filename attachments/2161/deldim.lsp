(setvar "CMDECHO" 0)
(command "_OPENDCL")
(setvar "CMDECHO" 1)

(defun c:ddim (
                / c:deldim/Form1/cmdClose#OnClicked
                  c:deldim/Form1/cmdDelDim#OnClicked
                  c:deldim/Form1/cmdBDelDim#OnClicked
                  intResult
              )

  (defun c:deldim/Form1/cmdClose#OnClicked ()
    (dcl-Form-Close deldim/Form1 3)
  )

  (defun c:deldim/Form1/cmdDelDim#OnClicked ()
    (dcl-Form-Close deldim/Form1 4)
  )

  (defun c:deldim/Form1/cmdBDelDim#OnClicked ()
    (dcl-Form-Close deldim/Form1 5)
  )

  (setq intResult 100) ; Set intResult to 'big' dummy value.
  (dcl-Project-Load "deldim" T)
  (while (< 3 intResult) ; Keep (re)showing the dialog if intResult is 4 or 5.
    (setq intResult (dcl-Form-Show deldim/Form1))
    (cond
      ((= 4 intResult)
        (if (not c:DELDIM) (load "functions.lsp"))
        (c:DELDIM)
      )
      ((= 5 intResult)
        (if (not c:DELDIM) (load "functions.lsp"))
        (c:DELDIM)
      )
    )
  )
  (princ)
)
