(defun LoadRunTime ( / )
    ;; Demand load the OpenDCL.##.ARX. This requires the OpenDCL Runtime or Studio to be installed on each PC first.
    (cond
      ( (= 'EXRXSUBR (type dcl_getversionex)) )
      ( (= 2 (boole 1 (getvar "DEMANDLOAD") 2))
        (command "OpenDCL")
        (if (/= 'EXRXSUBR (type dcl_getversionex))
          (progn
            (alert "The OpenDCL Runtime module failed to load. Please repair the OpenDCL installation and try again.")
            (exit)
          )
        )
      )
      ( (progn
          (alert "The OpenDCL Runtime module cannot be loaded because demand loading is disabled.\nLoad the OpenDCL ARX file manually, or enable demand loading for commands by setting the DEMANDLOAD system variable to 2 or 3.\nSee the \"ManualLoading.lsp\" example for a demonstration.")
          (exit)
        )
      )
    )
)
(defun LoadODCLProj (proj / fn)
    ;; Call (dcl_PROJECT_LOAD with the ProjectFileName. No re-load, no ProjectAliasName
    ;; Note that without the re-load flag the ODCL is only loaded once, each time (dcl_PROJECT_LOAD is called it tests first if the sProject is already loaded.
    (cond
      ;; Search the support paths for the .ODCL file & load it.
       ( (if (setq fn (findfile proj))
           (dcl_PROJECT_LOAD fn t)
       ))
      ;; Load the .ODCL file from the default installed "Examples" folder.
       ( (if 
           (or
             (setq fn (vl-registry-read "HKEY_LOCAL_MACHINE\\SOFTWARE\\OpenDCL" "RootFolder")) ;_ 32-bit location
             (setq fn (vl-registry-read "HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\OpenDCL" "RootFolder")) ;_ 64-bit location
           )
           (dcl_PROJECT_LOAD (strcat fn "Examples\\" proj) t)
       ))
      ;; The project failed to load, so report or log the error exit now (or take corrective action and try again)
      (T (alert (strcat "\"" proj "\" failed to load, you may need to add it to an Acad support path for it to load correctly!"))
        (EXIT)
      )
    )
)

(vl-load-com)
(defun c:try()
  (LoadRunTime)
  (if (= (vl-position "ComFrame" (dcl_GetProjects)) nil)
      (LoadODCLProj "GRIDtime.odcl")
  )
  (if (not (dcl_Form_IsActive ComFrame_ComFrame))
      (dcl_Form_Show "GRIDtime" "TESTGRID")
  )
)
(defun c:GRID1_TESTGRID_OnInitialize ( /)
  (dcl_Grid_AddRow GRIDtime_TESTGRID_Grid1 (LIST "1"  "2008-3-4"))
  (dcl_Grid_AddRow GRIDtime_TESTGRID_Grid1 (LIST "2"  "2008-3-5"))
  (dcl_Grid_AddRow GRIDtime_TESTGRID_Grid1 (LIST "3"  "2008-3-6"))
  (dcl_Grid_SetItemStyle GRIDtime_TESTGRID_Grid1 0 1 15)
  (dcl_Grid_SetItemStyle GRIDtime_TESTGRID_Grid1 1 1 15)
  (dcl_Grid_SetItemStyle GRIDtime_TESTGRID_Grid1 2 1 15)
)
(defun c:GRIDtime_TESTGRID_OK_OnClicked ( /)
  (dcl_Form_Close "GRIDtime" "TESTGRID")
  (princ)
)
