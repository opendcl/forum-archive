;;;Ensure the appropriate OpenDCL ARX file is loaded
(command "_OPENDCL")
;;;Load Visual LISP functions
(vl-load-com)
;;;Main function
(defun c:partlib (/)
  ;call the method to load the partlibmain.odcl file
  (dcl_Project_Load "partlibmain" T)
  ;call the method to show the PartLibMain dialog box
  (dcl_Form_Show partlibmain_PartLibMain)
);end defun


;;;execute when main dialog initializes
(defun c:partlibmain_PartLibMain_OnInitialize (/ P1 dirname Pname)
  ;;add SOMAR logo to slides
  (dcl_SlideView_Load partlibmain_PartLibMain_Slide1 "G:/Will/Lisp/Part Libraries Project/Logo1.sld")
  (dcl_SlideView_Load partlibmain_PartLibMain_Slide2 "G:/Will/Lisp/Part Libraries Project/Logo2.sld")
  (dcl_SlideView_Load partlibmain_PartLibMain_Slide3 "G:/Will/Lisp/Part Libraries Project/Logo3.sld")
  (dcl_SlideView_Load partlibmain_PartLibMain_Slide4 "G:/Will/Lisp/Part Libraries Project/Logo4.sld")
  (dcl_SlideView_Load partlibmain_PartLibMain_Slide5 "G:/Will/Lisp/Part Libraries Project/Logo5.sld")
  (dcl_SlideView_Load partlibmain_PartLibMain_Slide6 "G:/Will/Lisp/Part Libraries Project/Logo6.sld")
  (dcl_SlideView_Load partlibmain_PartLibMain_Slide7 "G:/Will/Lisp/Part Libraries Project/Logo7.sld")
  (dcl_SlideView_Load partlibmain_PartLibMain_Slide8 "G:/Will/Lisp/Part Libraries Project/Logo8.sld")
  (dcl_SlideView_Load partlibmain_PartLibMain_Slide9 "G:/Will/Lisp/Part Libraries Project/Logo9.sld")
  (dcl_SlideView_Load partlibmain_PartLibMain_Slide10 "G:/Will/Lisp/Part Libraries Project/Logo10.sld")
  (dcl_SlideView_Load partlibmain_PartLibMain_Slide11 "G:/Will/Lisp/Part Libraries Project/Logo11.sld")
  (dcl_SlideView_Load partlibmain_PartLibMain_Slide12 "G:/Will/Lisp/Part Libraries Project/Logo12.sld")
  ;;Save list of directory names under "g:/blocks"
  (setq P1 (vl-directory-files "G:/Blocks" nil -1))
  ;;remove "." and ".." from directory list
  (setq P1 (vl-remove "." P1))
  (setq P1 (vl-remove ".." P1))
  ;;create a list of lists for each directory name
  (foreach dirname P1 
     (setq Pname (dcl_Tree_AddParent partlibmain_PartLibMain_Tree1 dirname))
     (dcl_Tree_AddChild partlibmain_PartLibMain_Tree1 Pname "Not Loaded Yet")
  );end foreach
);end defun

;;;Add children when a particular main directory is clicked in the treeview
(defun c:partlibmain_PartLibMain_Tree1_OnItemExpanding (PLabel PKey / C1 Cname)
  (setq C1 (vl-directory-files (strcat "G:/Blocks/" PLabel) nil -1))
  ;;remove "." and ".." from directory list
  (setq C1 (vl-remove "." C1))
  (setq C1 (vl-remove ".." C1))
  (if (= (dcl_Tree_GetItemLabel partlibmain_PartLibMain_Tree1 (dcl_Tree_GetFirstChildItem partlibmain_PartLibMain_Tree1 PKey)) "Not Loaded Yet")
    (progn
      (dcl_Tree_DeleteItem partlibmain_PartLibMain_Tree1 (dcl_Tree_GetFirstChildItem partlibmain_PartLibMain_Tree1 PKey))
      (foreach Cname C1
	 (dcl_Tree_AddChild partlibmain_PartLibMain_Tree1 PKey Cname)
      );end foreach
    );end progn
  );end if
);end defun

;;;define actions when one of the categories is selected in the TreeView
(defun c:partlibmain_PartLibMain_Tree1_OnSelChanged (SLabel SKey / Dwgname Slidelist Slideview indexmax index)
  ;;Save the name of the selected category for future use
  (setq Child SLabel)
  ;;determine if selected category has a parent, if so, save the parent name
  (if (setq Parent (dcl_Tree_GetParentItem partlibmain_PartLibMain_Tree1 SKey))
     (setq Parent (dcl_Tree_GetItemLabel partlibmain_PartLibMain_Tree1 Parent))
  );end if
  ;;obtain list of drawing files in category folder (if any)
  (if Parent
     (setq Dwgnames (vl-directory-files (strcat "G:/Blocks/" Parent "/" Child) "*.dwg" 1))
     (setq Dwgnames (vl-directory-files (strcat "G:/Blocks/" Child) "*.dwg" 1))
  );end if
  ;;Strip ".dwg" extension off list of drawing files
  (if Dwgnames
    (setq Dwgnames (mapcar '(lambda (Dwgname)
			      (vl-filename-base Dwgname)
			    );end lambda
			   Dwgnames
	           );end mapcar
    );end setq
  );end if
  ;;Clear the "Block Description" Listbox
  (dcl_Listbox_Clear partlibmain_PartLibMain_ListBox1)
  ;;Populate the "Block Description" Listbox with the drawing file names
  (dcl_ListBox_AddList partlibmain_PartLibMain_ListBox1 Dwgnames)
  ;;Create list containing handles for each of the slide view controls
  (setq Slidelist (list
		    partlibmain_PartLibMain_Slide1
		    partlibmain_PartLibMain_Slide2
		    partlibmain_PartLibMain_Slide3
		    partlibmain_PartLibMain_Slide4
		    partlibmain_PartLibMain_Slide5
		    partlibmain_PartLibMain_Slide6
		    partlibmain_PartLibMain_Slide7
		    partlibmain_PartLibMain_Slide8
		    partlibmain_PartLibMain_Slide9
		    partlibmain_PartLibMain_Slide10
		    partlibmain_PartLibMain_Slide11
		    partlibmain_PartLibMain_Slide12
		  );end list
  );end setq
  ;;clear all slide views
  (foreach Slideview Slidelist
    (dcl_SlideView_Clear Slideview)
  );end foreach
  ;set index value to preliminary value of zero
  (setq index 0)
  ;;set the maximum allowable index value to the length of the shorter of the two lists "Slidelist" or "Dwgnames"
  (if Dwgnames
    (if (<= (length Slidelist) (length Dwgnames))
      (setq indexmax (- (length Slidelist) 1))
      (setq indexmax (- (length Dwgnames) 1))
    );end if
  );end if
  ;;add slide image to each slideview control up to the maximum no. of drawings available in the list "Dwgnames"
  (if Dwgnames
    (if Parent
       (while (<= index indexmax)
	  (dcl_SlideView_Load (nth index Slidelist) (strcat "G:/Blocks/" Parent "/" Child "/" (nth index Dwgnames) ".sld"))
	  (setq index (+ index 1))
       );end while
       (while (<= index indexmax)
          (dcl_SlideView_Load (nth index Slidelist) (strcat "G:/Blocks/" Child "/" (nth index Dwgnames) ".sld"))
	  (setq index (+ index 1))
       );end while
    );end if
  );end if
  ;;clear Block Description
  (dcl_Control_SetText partlibmain_PartLibMain_TextBox1 "")
);end defun

;;;Define actions when one of the Block Names are clicked in the "Block Name" listbox
(defun c:partlibmain_PartLibMain_ListBox1_OnSelChanged (ItemIndex Value / Dwgname myDoc blkdescrip)
  (dcl_SlideView_SetHighlight partlibmain_PartLibMain_Slide2 1)
  ;;extract the path of the drawing selected
  (if Parent
    (setq Dwgname (strcat "G:\\Blocks\\" Parent "\\" Child "\\" Value ".dwg"))
    (setq Dwgname (strcat "G:\\Blocks\\" Child "\\" Value ".dwg"))
  );end if
  ;;get interface object and set it to the dwg whose path is stored in the "Dwgname" variable
  (setq myDoc (vla-GetInterfaceObject (vlax-Get-Acad-Object) (strcat "ObjectDBX.AxDbDocument." (substr (getvar "AcadVer") 1 2))))
  (vla-open myDoc Dwgname)
  ;;extract block description, unless there are no blocks in the drawing, in that case set "blkdescrip" equal to nil
  (if (<= (vla-get-count (vla-get-blocks myDoc)) 2)
    (setq blkdescrip nil)
    (setq blkdescrip (vla-get-comments (vla-item (vla-get-blocks myDoc) 2)))
  );end if
  ;;update block description in the dialog box, use the dwg name if the block description does not exist or if there are no blocks in the drawing
  (if
    (or (= blkdescrip nil)
	 (= blkdescrip "")
    );end or
    (dcl_Control_SetText partlibmain_PartLibMain_TextBox1 Value)
    (dcl_Control_SetText partlibmain_PartLibMain_TextBox1 blkdescrip)
  );end if
  (setq myDoc (i:CloseDBXDoc myDoc))
);end defun

;;;subroutine for releasing open drawing database
(defun i:CloseDBXDoc (dbxDoc)
  (vl-catch-all-apply 'vlax-Release-Object (list dbxDoc))
  (setq dbxDoc nil)
);end defun




