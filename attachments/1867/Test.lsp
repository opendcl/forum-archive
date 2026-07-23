(defun C:PMCON (/ Result)
(command "_OPENDCL")
  (if (dcl_Project_Load (strcat (proghome) "ODCL\\PMControl.odcl") T)
  (progn
	  (setq result (dcl_Form_Show PMcontrol_PMATFORM))
  );p
  )
(princ));d

(defun C:UPMCON ( )
(if (member "PMControl" (dcl_GetProjects)) (dcl_Project_Unload "PMControl"));i
(princ))



(defun pmcon:columninfo ( )
(list
'("Piecemk" 2 90 0)
'("Quant" 2 65 1)
'("Type" 2 55 2)
'("Size" 2 180 3)
'("Length" 2 80 4)
'("Grade" 2 65 5)
'("Notes" 2 60 6)
'("REF:" 2 150 7)
);list
);d



(defun c:PMControl_PMATFORM_OnInitialize (/)
;(dcl_ComboBox_Clear MControl_Main_ComboBoxjobs)
;(dcl_ComboBox_AddList MControl_Main_ComboBoxjobs (vl-sort (get-directories (jobs-dir) "####  *") '> ))
(dcl_ListView_AddColumns PMControl_PMATFORM_ListView_pmat (cons (cons "" (cdr (car (pmcon:columninfo)))) (cdr (pmcon:columninfo))))
(princ))





(defun pmcon:populatelistview ( matfile filter / partdata columndata)
(dcl_ListView_Clear PMControl_PMATFORM_ListView_pmat)
(setq columndata (mapcar '(lambda (x)(strcase x T)) (mapcar 'car (pmcon:columninfo))))

(if (setq partdata (file-to-list matfile (lambda (x) (wcmatch x filter))))
 (foreach part partdata 
  (dcl_ListView_AddItem PMControl_PMATFORM_ListView_pmat (odcl:buildrowitem part columndata))
 )
);i

(dcl_ListView_AddItem PMControl_PMATFORM_ListView_pmat "+")
(princ))



;;Test for above function (add items without all the programs)
(defun test1 ( / columndata)
(dcl_ListView_Clear PMControl_PMATFORM_ListView_pmat)
(setq columndata (mapcar '(lambda (x)(strcase x T)) (mapcar 'car (pmcon:columninfo))))
(mapcar '(lambda (x) (dcl_ListView_AddItem PMControl_PMATFORM_ListView_pmat x)) (list '("7AA" "2" "L" "4x4x3/8" "20'-0" "A36" " " "12/S13.1") '("7AB" "2" "FB" "1/2x2" "6" "A36" " " "12/S13.1")))
(dcl_ListView_AddItem PMControl_PMATFORM_ListView_pmat "+")
(princ))




