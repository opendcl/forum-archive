(defun sqlbiblio (SQLStatement / result)
  (if (not ADOLISP_ConnectToDB)
    (load "ADOLISP_Library.lsp")
    )
  ;; Connecting to the database ...
  (if (dos_isacad64)
    (setq ConnectString (strcat "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" biblio_mdb ";Persist Security Info=False;"))
    (setq ConnectString (strcat "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" biblio_mdb ";Persist Security Info=False;"))
    ;(setq ConnectString (strcat "Provider=MSDASQL;Driver={Microsoft Access Driver (*.mdb)};DBQ=" biblio_mdb))
    )
  ;(setq ConnectString (strcat "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" biblio_mdb ";Persist Security Info=False;"))
  ;; If we got a connection ...
  (if (not (setq ConnectionObject (ADOLISP_ConnectToDB ConnectString "admin" "")))
    (progn
      (prompt (strcat "\n\nConnecting to the database using \n\"" ConnectString "\""))
      (prompt "\nConnection failed!")
      (ADOLISP_ErrorPrinter)
      )
    (progn
      ;(setq SQLStatement SQLStatement)
      (if (null (setq Result (ADOLISP_DoSQL ConnectionObject SQLStatement)))
        (ADOLISP_ErrorPrinter)
        )
      ;; Disconnect
      (ADOLISP_DisconnectFromDB ConnectionObject)
      )
    )
  
  result
  )

(defun C:biblio ();/ dwgfile pdffile sel_type );sqlexec)
  ;c:Biblio_Frmbiblio_OnInitialize c:Biblio_Frmbiblio_DwgPreview_OnDragnDropToAutoCAD
  ;c:Biblio_Frmbiblio_DwgList_OnFolderChanged c:Biblio_Frmbiblio_TextButton_query_OnClicked
  ;c:Biblio_Frmbiblio_TextButton_clear_OnClicked c:Biblio_Frmbiblio_TextButton_open_OnClicked
  ;c:Biblio_Frmbiblio_TextButton_xref_OnClicked c:Biblio_Frmbiblio_Button_OK_OnClicked
  ;c:Biblio_Frmbiblio_OnClose c:Biblio_Frmbiblio_TextButton_copyproj_OnClicked
  ;c:Biblio_Frmbiblio_Grid_OnSelChanged c:Biblio_Frmbiblio_DwgList_OnSelChanged)
  
  (defun c:Biblio_Frmbiblio_OnInitialize (/ sqlsleutels sleutels)
    ;(dcl_MessageBox "To Do: code must be added to event handler\r\nc:Biblio_Frmbiblio_OnInitialize" "To do")
    
    ;(setq biblio_mdb "C:\\PSO\\bestanden_cad_bib.mdb")
    (setq biblio_mdb "K:\\IN\\BIB\\_Overzicht\\bestanden_cad_bib.mdb")
    ;(setq biblio_pad "C:\\PSO\\")
    (setq biblio_pad "K:\\IN\\BIB\\CAD-BIB\\")
    (if (null biblio_startpad)   (setq biblio_startpad biblio_pad))
    
    (dcl_Control_setText Biblio_Frmbiblio_TextBox_filters "")
    ;(dcl_ComboBox_AddList Biblio_Frmbiblio_ComboBox_sleutel (list "key1" "key2" "key3"))
    ;(setq keys nil)
    (setq sqlsleutels (sqlbiblio "SELECT DISTINCT sleutel.Sleutel FROM sleutel ORDER BY sleutel.Sleutel;"))
    (foreach name (cdr sqlsleutels)
      (setq sleutels (cons (car name) sleutels)))
    (dcl_ComboBox_AddList Biblio_Frmbiblio_ComboBox_sleutel (reverse sleutels))
    (dcl_DWGPreview_LoadDwg Biblio_Frmbiblio_DwgPreview biblio_pad)
    (dcl_DWGList_Dir Biblio_Frmbiblio_DwgList biblio_startpad)
    (sqlexec)
    )
  
  (defun c:Biblio_Frmbiblio_DwgList_OnFolderChanged (FolderPath /)
    (dcl_Control_SetText Biblio_Frmbiblio_ComboBox_sleutel "")
    )
  (defun c:Biblio_Frmbiblio_DwgList_OnSelChanged (Count Value /)
    (if (wcmatch (strcase value) "*.DWG")
      (progn
        (setq sel_type "Dwglist")
        (if (setq dwgfile (findfile (strcat (DCL_DWGLIST_GETDIR Biblio_Frmbiblio_DwgList) "\\" Value)))
          (dcl_DWGPreview_LoadDwg Biblio_Frmbiblio_DwgPreview dwgfile))
        )
      (if (not (equal (DCL_DWGLIST_GETDIR Biblio_Frmbiblio_DwgList) (strcat (DCL_DWGLIST_GETDIR Biblio_Frmbiblio_DwgList) "\\" Value)))
        (dcl_DWGList_Dir Biblio_Frmbiblio_DwgList (strcat (DCL_DWGLIST_GETDIR Biblio_Frmbiblio_DwgList) "\\" Value))))
    )
  (defun c:Biblio_Frmbiblio_TextButton_query_OnClicked (/)
    ;(print "c:Biblio_Frmbiblio_TextButton_query_OnClicked")
    (if (= sel_type "Grid") (setq sel_type nil dwgfile nil pdffile nil))
    (dcl_Control_SetText Biblio_Frmbiblio_TextBox_filters "")
    (IF (= (DCL_COMBOBOX_GETEBTEXT Biblio_Frmbiblio_ComboBox_sleutel) "")
      (PROGN
        (setq biblio_startpad (DCL_DWGLIST_GETDIR Biblio_Frmbiblio_DwgList))
        )
      (PROGN
        ;(ALERT (DCL_COMBOBOX_GETEBTEXT Biblio_Frmbiblio_ComboBox_sleutel))
        (IF (NULL keys)
          (SETQ keys
                 (LIST (list (dcl_Control_GetValue Biblio_Frmbiblio_CheckBox_not)
                             (DCL_COMBOBOX_GETEBTEXT Biblio_Frmbiblio_ComboBox_sleutel)))
                )
          (SETQ keys
                 (CONS
                   (list
                     (dcl_Control_GetValue Biblio_Frmbiblio_CheckBox_not)
                     (DCL_COMBOBOX_GETEBTEXT Biblio_Frmbiblio_ComboBox_sleutel)
                     )
                   keys
                   )
                )
          )
        )
      )
    (sqlexec)
    )
  
  
  (defun c:Biblio_Frmbiblio_TextButton_clear_OnClicked (/)
    (dcl_Control_setText Biblio_Frmbiblio_TextBox_filters "")
    (setq biblio_startpad biblio_pad
          sel_type nil
          dwgfile nil
          pdffile nil)
    (setq keys nil)
    (dcl_DWGPreview_LoadDwg Biblio_Frmbiblio_DwgPreview biblio_pad)
    (dcl_DWGList_Dir Biblio_Frmbiblio_DwgList biblio_pad)
    (dcl_Grid_Clear Biblio_Frmbiblio_Grid)
    )
  (defun c:Biblio_Frmbiblio_TextButton_copyproj_OnClicked (/)
    (dcl_MessageBox "To Do: code must be added to event handler\r\nc:Biblio_Frmbiblio_TextButton_copyproj_OnClicked" "To do")
    )
  (defun c:Biblio_Frmbiblio_TextButton_copyproj1_OnClicked (/)
    (cond
      ((= sel_type "Grid")
       (setq resultfile (findfile (dcl_Grid_GetCellText Biblio_Frmbiblio_Grid (nth 0 (dcl_Grid_GetCurCell Biblio_Frmbiblio_Grid)) 0)))
       )
      ((= sel_type "Dwglist")
       (setq resultfile (findfile dwgfile))
       )
      )
    (if resultfile
      (if (setq destfile (getfiled "Bestandsnaam:" (strcat (getvar "dwgprefix") (vl-filename-base resultfile) (vl-filename-extension resultfile)) (substr (vl-filename-extension resultfile) 2) (+ 0 1)))
        (progn
          (vl-file-delete destfile)
          (if (null (vl-file-copy (findfile (dcl_Grid_GetCellText Biblio_Frmbiblio_Grid (nth 0 (dcl_Grid_GetCurCell Biblio_Frmbiblio_Grid)) 0)) destfile))
            (dcl_MessageBox (strcat "Kan bestand niet kopieren!" "\n" resultfile "\n" destfile) "Error kopieren")
            (dcl_MessageBox "Bestand gekopiëerd" destfile)
            )
          )
        )
      )
    )
  
  (defun c:Biblio_Frmbiblio_TextButton_copyproj_OnClicked (/ resultfile destfile projpad)
    (cond
      ((= sel_type "Grid")
       (setq resultfile (findfile (dcl_Grid_GetCellText Biblio_Frmbiblio_Grid (nth 0 (dcl_Grid_GetCurCell Biblio_Frmbiblio_Grid)) 0)))
       )
      ((= sel_type "Dwglist")
       (setq resultfile (findfile dwgfile))
       )
      )
    (if resultfile
      (if (setq destfile (getfiled "Bestandsnaam:" (strcat (getvar "dwgprefix") (vl-filename-base resultfile) (vl-filename-extension resultfile)) (substr (vl-filename-extension resultfile) 2) (+ 0 1)))
        (progn
          (vl-file-delete destfile)
          (if (null (vl-file-copy (findfile (dcl_Grid_GetCellText Biblio_Frmbiblio_Grid (nth 0 (dcl_Grid_GetCurCell Biblio_Frmbiblio_Grid)) 0)) destfile))
            (dcl_MessageBox (strcat "Kan bestand niet kopieren!" "\n" resultfile "\n" destfile) "Error kopieren")
            (dcl_MessageBox "Bestand gekopiëerd" destfile)
            )
          )
        )
      )
    )
  (defun c:Biblio_Frmbiblio_Button_Insert_OnClicked (/)    
    (cond
      ((= sel_type "Grid")
       (progn
         (if (setq resultfile (findfile (dcl_Grid_GetCellText Biblio_Frmbiblio_Grid (nth 0 (dcl_Grid_GetCurCell Biblio_Frmbiblio_Grid)) 0)))
           (progn
             ;(setq biblio_pt (dcl_Form_Close Biblio_Frmbiblio))
             (setvar "cmdecho" 1)
             (initdia)
             (command "-insert" (findfile (dcl_Grid_GetCellText Biblio_Frmbiblio_Grid (nth 0 (dcl_Grid_GetCurCell Biblio_Frmbiblio_Grid)) 0)))
             )
           (princ (strcat "\nFile niet gevonden (" (dcl_Grid_GetCellText Biblio_Frmbiblio_Grid Row 0) ")."))
           )
         )
       )
      ((= sel_type "Dwglist")
       (progn
         ;(dcl_Form_Close Biblio_Frmbiblio)
         (setvar "cmdecho" 1)
         (initdia)         
         (command "-insert" (findfile dwgfile))
         )
       )
      )
    )

  (defun c:Biblio_Frmbiblio_TextButton_open_OnClicked (/ resultfile)
    (cond
      ((= sel_type "Grid")
       (if (setq resultfile (findfile (dcl_Grid_GetCellText Biblio_Frmbiblio_Grid (nth 0 (dcl_Grid_GetCurCell Biblio_Frmbiblio_Grid)) 0)))
         (progn
           (if (= (vl-filename-extension resultfile) ".DWG")
             (vla-Open (vla-get-Documents (vlax-get-Acad-Object))
                       (findfile (dcl_Grid_GetCellText Biblio_Frmbiblio_Grid (nth 0 (dcl_Grid_GetCurCell Biblio_Frmbiblio_Grid)) 0))
                       (if ReadOnly :vlax-true :vlax-false)
                       )
             (startapp "explorer.exe" resultfile)
             )
           )
         (princ (strcat "\nFile niet gevonden (" (dcl_Grid_GetCellText Biblio_Frmbiblio_Grid Row 0) ")."))
         )
       )
      ((= sel_type "Dwglist")
       (progn
         (vla-Open (vla-get-Documents (vlax-get-Acad-Object))
                   (findfile dwgfile)
                   (if ReadOnly :vlax-true :vlax-false)
                   )
         )
       )
      (T
       (princ "\nNog niets geselecteerd."))
      )
    )
  (defun c:Biblio_Frmbiblio_TextButton_xref_OnClicked (/)
    (dcl_MessageBox "To Do: code must be added to event handler\r\nc:Biblio_Frmbiblio_TextButton_xref_OnClicked" "To do")
    )
  (defun c:Biblio_Frmbiblio_Button_OK_OnClicked (/)
    (cond
      ((= sel_type "Grid")
       (progn
         (if (setq resultfile (findfile (dcl_Grid_GetCellText Biblio_Frmbiblio_Grid (nth 0 (dcl_Grid_GetCurCell Biblio_Frmbiblio_Grid)) 0)))
           (progn
             ;(setq biblio_pt (dcl_Form_Close Biblio_Frmbiblio))
             (initdia)
             (command "-insert" (findfile (dcl_Grid_GetCellText Biblio_Frmbiblio_Grid (nth 0 (dcl_Grid_GetCurCell Biblio_Frmbiblio_Grid)) 0)))
             )
           (princ (strcat "\nFile niet gevonden (" (dcl_Grid_GetCellText Biblio_Frmbiblio_Grid Row 0) ")."))
           )
         )
       )
      ((= sel_type "Dwglist")
       (progn
         (initdia)
         (command "-insert" (findfile dwgfile))
         )
       )
      )
    )
  ;;;  (defun c:Biblio_Frmbiblio_OnClose (UpperLeftX UpperLeftY /)
  ;;;    (setq biblio_pt (list UpperLeftX UpperLeftY))
  ;;;    )
  
  (defun c:Biblio_Frmbiblio_Grid_OnSelChanged (Row Column / resultfile)
    ;(alert (strcat (itoa row) " - " (itoa column)))
    ;(dcl_Grid_GetCurCell Biblio_Frmbiblio_Grid)
    ;(alert (dcl_Grid_GetCellText Biblio_Frmbiblio_Grid Row Column ))
    ;(print (dcl_Grid_GetCellText Biblio_Frmbiblio_Grid Row 0))
    (if (setq resultfile (findfile (dcl_Grid_GetCellText Biblio_Frmbiblio_Grid Row 0)))
      (progn
        (setq sel_type "Grid")
        (cond
          ((= (strcase (vl-filename-extension resultfile)) ".DWG")
           (progn
             (setq dwgfile resultfile
                   pdffile nil)
             (dcl_DWGPreview_LoadDwg Biblio_Frmbiblio_DwgPreview dwgfile))
           )
          ((= (strcase (vl-filename-extension resultfile)) ".PDF")
           (progn
             (setq pdffile resultfile)
             (setq dwgfile (findfile (strcat (vl-filename-directory resultfile) "\\" (vl-filename-base resultfile) ".DWG")))
             (if dwgfile (dcl_DWGPreview_LoadDwg Biblio_Frmbiblio_DwgPreview dwgfile))
             )
           )
          )
        )
      (progn
        (princ (strcat "\nFile niet gevonden (" (dcl_Grid_GetCellText Biblio_Frmbiblio_Grid Row 0) ")."))
        (setq sel_type nil
              dwgfile nil
              pdffile nil)
        )
      )
    )
  (defun c:Biblio_Frmbiblio_OnSize (NewWidth NewHeight /)
    (dcl_Control_SetColumnWidthList Biblio_Frmbiblio_Grid (list (- NewWidth 5)))
    )
  
  (defun sqlexec (/ sqltext sqlresult)
    (dcl_Control_SetText Biblio_Frmbiblio_TextBox_filters (substr biblio_startpad (1+ (strlen biblio_pad))))
    (setq sqltext "")
    (cond
      ((null keys)
       (progn
         (setq sqltext (strcat "SELECT bestanden.[filenaam] FROM bestanden WHERE (((bestanden.[filetype])='.DWG' OR (bestanden.[filetype])='.PDF') AND ((bestanden.[filenaam]) Like '" biblio_startpad "%'))"))
         )
       )
      (T
       (progn
         (setq sqltext (strcat "SELECT bestanden.[filenaam] FROM bestanden WHERE (((bestanden.[filetype])='.DWG' OR (bestanden.[filetype])='.PDF') AND ((bestanden.[filenaam]) Like '" biblio_startpad "%')"))
         (foreach keysql keys
           (if (= (car keysql) 0)
             (progn
               (setq sqltext (strcat sqltext " AND ((bestanden.[filenaam]) Like '%" (cadr keysql) "%')"))
               (dcl_Control_SetText Biblio_Frmbiblio_TextBox_filters (strcat (dcl_Control_GetText Biblio_Frmbiblio_TextBox_filters) " +" (cadr keysql)))
               )
             (progn
               (setq sqltext (strcat sqltext " AND ((bestanden.[filenaam]) NOT Like '%" (cadr keysql) "%')"))
               (dcl_Control_SetText Biblio_Frmbiblio_TextBox_filters (strcat (dcl_Control_GetText Biblio_Frmbiblio_TextBox_filters) " -" (cadr keysql)))
               )
             )
           )
         (setq sqltext (strcat sqltext ");"))
         ;"
         ;"SELECT bestanden.[filenaam] FROM bestanden WHERE (((bestanden.[filetype])="".DWG"") AND ((bestanden.[filenaam]) Like '*type*'));"
         )
       )
      )
    ;(print sqltext)
    (setq sqlresult (sqlbiblio sqltext))
    (if sqlresult
      (progn
        (setq sqlresult (cdr sqlresult))
        (if (and  sqlresult Biblio_Frmbiblio_Grid)
          (dcl_Grid_FillList Biblio_Frmbiblio_Grid sqlresult))
        )
      )
    )
  
  
  ;;;(cond
  ;;;    ((member (getenv "CADVERSIE") (list "2007" "2008" "2009"))
  ;;;     (setq file_ "OpenDCL.17.arx")
  ;;;     )
  ;;;    ((member (getenv "CADVERSIE") (list "2010" "2011"))
  ;;;     (if (< (strlen(vl-prin1-to-string (vlax-get-acad-object))) 40)
  ;;;       (setq file_ "OpenDCL.18.arx")
  ;;;       (setq file_ "OpenDCL.x64.18.arx")
  ;;;       )
  ;;;     )
  ;;;    )
  ;;;  (if file_
  ;;;    (progn
  ;;;      (vl-file-copy (strcat (getenv "TECHCAD") "\\data-files\\Sup\\" file_) (strcat "c:/tempcad/" file_))
  ;;;      (setq file_ (arxload (strcat (getenv "TECHCAD") "\\data-files\\Sup\\" file_) T))
  ;;;      )
  ;;;    )
  ;;;  (if (null file_)
  ;;;    (princ "\nOpenDCLDosLIB is niet geladen.\nGelieve contact op te nemen met uw CAD coördinator")
  ;;;    )
  
  
  
  (command "OPENDCL")
  
  ; (alert biblio_pad)
  (dcl_Project_Load "Biblio" T)
  ;(if biblio_pt
  ;(dcl_Form_Show Biblio_Frmbiblio (nth 0 biblio_pt) (nth 0 biblio_pt))
  (dcl_Form_Show Biblio_Frmbiblio)
  ;)
  (princ)
  )
;;;
;;;;;-------------------=={ Directory Dialog }==-----------------;;
;;;;;                                                            ;;
;;;;;  Displays a dialog prompting the user to select a folder   ;;
;;;;;------------------------------------------------------------;;
;;;;;  Author: Lee McDonnell, 2010                               ;;
;;;;;                                                            ;;
;;;;;  Copyright © 2010 by Lee McDonnell, All Rights Reserved.   ;;
;;;;;  Contact: Lee Mac @ TheSwamp.org, CADTutor.net             ;;
;;;;;------------------------------------------------------------;;
;;;;;  Arguments:                                                ;;
;;;;;  msg  - message to display at top of dialog                ;;
;;;;;  dir  - root directory (or nil)                            ;;
;;;;;  flag - bit coded flag specifying dialog display settings  ;;
;;;;;------------------------------------------------------------;;
;;;;;  Returns:  Selected folder filepath, else nil              ;;
;;;;;------------------------------------------------------------;;
;;;
;;;(defun LM:DirectoryDialog ( msg dir flag / Shell HWND Fold Self Path ac )
;;;  (vl-load-com)
;;;  ;; © Lee Mac 2010
;;;
;;;  (setq Shell (vla-getInterfaceObject (setq ac (vlax-get-acad-object)) "Shell.Application")
;;;        HWND  (vl-catch-all-apply 'vla-get-HWND (list ac))
;;;        Fold  (vlax-invoke-method Shell 'BrowseForFolder (if (vl-catch-all-error-p HWND) 0 HWND)  msg flag dir))
;;;  (vlax-release-object Shell)
;;;  
;;;  (if Fold
;;;    (progn
;;;      (setq Self (vlax-get-property Fold 'Self) Path (vlax-get-property Self 'Path))
;;;      (vlax-release-object Self)
;;;      (vlax-release-object Fold)      
;;;      
;;;      (and (= "\\" (substr Path (strlen Path)))
;;;           (setq Path (substr Path 1 (1- (strlen Path)))))
;;;    )
;;;  )
;;;  Path
;;;)

;; detect if computer is 64-bit
(if (vl-string-search "64" (getenv "PROCESSOR_ARCHITECTURE"))
  (setq OpenDCLFilename (strcat "OpenDCL.x64." (substr (vlax-product-key) (1+ (vl-string-search "1" (vlax-product-key))) 2) ".arx"))
  (setq OpenDCLFilename (strcat "OpenDCL."     (substr (vlax-product-key) (1+ (vl-string-search "1" (vlax-product-key))) 2) ".arx"))
  )

;; detect if ARX is already loaded
(if (not (member OpenDCLFilename (arx)))
  (arxload (strcat (getenv "TECHCAD") "\\data-files\\Sup\\" OpenDCLFilename))
  )
(setq OpenDCLFilename nil
      )


(defun c:Biblio_Frmbiblio_DwgList_OnDblClicked (/)
  (dcl_MessageBox "To Do: code must be added to event handler\r\nc:Biblio_Frmbiblio_DwgList_OnDblClicked" "To do")
)


