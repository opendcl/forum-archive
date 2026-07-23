(defun c:proj (/ c:proj_form_OnInitialize c:proj_form_OnCancelClose c:proj_form_edt_element_OnReturnPressed
	         c:proj_form_lst_elements_OnMouseMove c:proj_form_lst_elements_OnKeyUp c:proj_form_pb_close
	         list_lines lstLastSelection)
  (command "opendcl")
  (dcl_project_load "proj")

  (defun list_lines (/ lstItems lstTexts strText intRow )
    (setq lstItems (dcl_ListView_GetSelectedNths proj_form_lst_elements))
    (cond
      ;; ohne Änderung
      ((equal lstItems lstLastSelection) nil)

      ;; es wurde etwas gewählt
      (lstItems
        (princ "\nIch prüfe die Auswahl\n")
        (setq lstLastSelection lstItems)
       
	(foreach intRow lstItems
	  (setq strText (dcl_listview_getitemtext proj_form_lst_elements intRow 0))
	  (if (/= strText "Nicht markierbar")
	    (setq lstTexts (cons (cons intRow strText) lstTexts))
	  ); if
	); foreach

        (setq lstItems (mapcar 'car (reverse lstTexts)))
	(if (not (equal lstItems lstLastSelection))
	  (progn
	    (dcl_ListView_SetCurSel proj_form_lst_elements -1)
	    (foreach intRow lstItems
	      (dcl_ListView_SetCurSel proj_form_lst_elements intRow)
	    ); foreach
	  ); progn
	); if
	(setq lstLastSelection lstItems)

	(if (setq lstTexts (reverse lstTexts))
	  (dcl_Control_SetCaption proj_form_txt_elements (apply 'strcat (mapcar '(lambda (x) (strcat (cdr x) " ")) lstTexts)))
	  (dcl_Control_SetCaption proj_form_txt_elements "Nichts markiert...")
	); if
        
       ); progncond

      ;; es wurde nichts gewählt
      (T (setq lstLastSelection nil) (dcl_Control_SetCaption proj_form_txt_elements "Nichts markiert..."))
    ); cond
  ); list_lines

  (defun c:proj_form_OnInitialize (/)
    (dcl_ListView_AddColumns proj_form_lst_elements (list (list "Col1" 0 100) (list "Col2" 0 50) (list "Col3" 0 50)))
    (dcl_ListView_FillList proj_form_lst_elements (list (list "Zelle 1" "Zelle 2" "Zelle 3") (list "Zelle 4" "Zelle 5" "Zelle 6")
							(list "Nicht markierbar" "" "") (list "Zelle 7" "Zelle 8" "Zelle 9")))
    (dcl_Control_SetText proj_form_edt_element "")
    (dcl_Control_SetCaption proj_form_txt_elements "Nichts markiert...")
  ); c:proj_form_OnInitialize

  (defun c:proj_form_OnCancelClose (intIsESC /) T)

  (defun c:proj_form_edt_element_OnReturnPressed (/ strText)
    (if (/= (setq strText (dcl_Control_GetText proj_form_edt_element)) "")
      (progn
	(setq intRow (dcl_ListView_AddItem proj_form_lst_elements strText))
	(dcl_Control_SetText proj_form_edt_element "")
	(dcl_ListView_SetCurSel proj_form_lst_elements intRow)
	(list_lines)
      ); progn
    ); if
  ); c:proj_form_edt_element_OnReturnPressed

  (defun c:proj_form_lst_elements_OnMouseMove (intFlags intX intY /)
    (if (not (equal (dcl_getfocus) '("proj" "form" "lst_elements")))
      (progn
	(princ "\nIch setze den Fokus\r") (princ)
	(dcl_control_setfocus proj_form_lst_elements)
      ); progn
      (list_lines)
    ); if
  ); c:proj_form_lst_elements_OnMouseMove

  (defun c:proj_form_lst_elements_OnMouseUp (intButton intFlags intX intY /) (list_lines))

  (defun c:proj_form_lst_elements_OnKeyUp (strCharacter intRepeatCount intFlags /) (list_lines))

  (defun c:proj_form_pb_close (/) (dcl_form_close proj_form))
  (dcl_form_show proj_form)

  (princ)
); proj