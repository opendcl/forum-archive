(prompt "           ")(terpri)
(prompt "[------로우코리아 속성편집기툴 로딩 완료--------]")(terpri)
(prompt "[-------------  Type MSK --------------]") (terpri)

(defun c:msk (/)
  (command "opendcl")
  (dcl_project_load "attchanger" t)
   
  (dcl_Form_Show attchanger_Mdwg )
  (princ)
  );main함수
  

  
  (defun c:attchanger_Mdwg_OnInitialize (/)

(dcl_Control_SetEventInvoke attchanger_Mdwg_textbutton2 1)

(dcl_Control_SetEventInvoke attchanger_Mdwg_dwglist 1);이상태여야만 명령실행됨..
(dcl_Control_SetEventInvoke attchanger_Mdwg_ListBox1 1);이상태여야만 명령실행됨..
(dcl_Control_SetEventInvoke attchanger_Mdwg_TextButton1 1);이상태여야만 명령실행됨..
(dcl_Control_SetEventInvoke attchanger_Mdwg_seetouser 1);이상태여야만 명령실행됨..
(dcl_Control_SetEventInvoke attchanger_Mdwg_onefolder 1);이상태여야만 명령실행됨..
(dcl_Control_SetEventInvoke attchanger_Mdwg_clear 1);이상태여야만 명령실행됨..
(dcl_Control_SetEventInvoke attchanger_Mdwg_singleUpdate 1);단일객체속성값업뎃
(dcl_Control_SetEventInvoke attchanger_Mdwg_Multiple  1);복수객체속성값업뎃
(dcl_Control_SetEventInvoke attchanger_Mdwg_oldtag 1)
(dcl_Control_SetEventInvoke attchanger_Mdwg_oldatt 1)
(dcl_Control_SetEventInvoke attchanger_Mdwg_newatt 1)
(dcl_Control_SetEventInvoke attchanger_Mdwg_Grid1 1);그리드로 속성테이블값던지기..
(dcl_Control_SetEventInvoke attchanger_Mdwg_OneShot 1)

)

(defun c:attchanger_Mdwg_textbutton2_OnClicked (/ subfolderlist path1 dwglist filecnt filenamelist flng ttstring)

(setq path1 (acet-ui-pickdir))
     (gc)
     (setq subfolderlist (getsubfolders path1));call function getsubfolders 
	   (setq dwglist (getdwglist subfolderlist));call function dwglist from each subfolders.
	   (setq filecnt 0);반복문 처음 지정.. 
           (setq filenamelist 
             (mapcar '(lambda (y)
                        (vl-string-subst "" ".dwg" y))
			                             (filename subfolderlist))
);end filenamelist 

(setq flng (length dwglist))
(setq flng (rtos flng 2 0 ))

(setq ttstring (strcat "Total  " flng " dwg files Seleted ."))
(dcl_ListBox_Clear attchanger_Mdwg_dwglist)
(dcl_ListBox_AddList attchanger_Mdwg_dwglist dwglist)
(dcl_Control_SetText attchanger_Mdwg_seetouser ttstring)

);end defun 

;단일폴더 로드함수..
(defun c:attchanger_Mdwg_onefolder_OnClicked (/ onefolder )
(setq onefolder (dcl_Form_Show attchanger_opendwg "C:\\" "select dwg" ))
(setq onesee (length onefolder))
(setq onesee (rtos onesee 2 0))
(setq onestring (strcat "Total  " onesee " dwg files Seleted ."))
(dcl_ListBox_Clear attchanger_Mdwg_dwglist);도면리스트목록을 지우고..
(dcl_ListBox_AddList attchanger_Mdwg_dwglist onefolder);
(dcl_Control_SetText attchanger_Mdwg_seetouser onestring);사용자에게 선택된 파일 화면 출력..
)
;;;목록지우기..
(defun c:attchanger_Mdwg_clear_OnClicked ( / )
(setq cleartext "Completed Clear all Dwgs.")
(dcl_Control_SetText attchanger_Mdwg_seetouser cleartext);사용자에게 선택된 파일 화면 출력..
(dcl_ListBox_Clear attchanger_Mdwg_dwglist)
(dcl_ListBox_Clear attchanger_Mdwg_ListBox1)
 (dcl_Grid_Clear attchanger_Mdwg_Grid1);그리드리스트삭제후 새로운값입력
(dcl_Control_SetText attchanger_Mdwg_oldtag "Cleared")
(dcl_Control_SetText attchanger_Mdwg_oldatt "Cleared")
(dcl_Control_SetText attchanger_Mdwg_newatt "Cleared")
)
;;;;;dwglist 리스트박스가 선택값이 바뀌면 이벤트발생 .
 (defun c:attchanger_Mdwg_dwglist_OnSelChanged (nselect seltext / lsttag lsttxt alllist tagcnt gridcnt )
 
(setq single (dcl_ListBox_GetItemText attchanger_Mdwg_dwglist (dcl_ListBox_GetCurSel attchanger_Mdwg_dwglist)))

 (setq DBXstr (if (< (atof (getvar "ACADVER")) 16.0) "ObjectDBX.AxDbDocument" (strcat "ObjectDBX.AxDbDocument." (itoa (atoi (getvar "AcadVer")))))
	DBXDoc (vla-getinterfaceobject (vlax-get-acad-object) DBXstr)
  );end define dbxstr and dbxdoc
     	 
	     (setq dwg single)
          (vla-open DBXDoc dwg ) ;vla객체 불러오기
		   (vlax-for upc_blkobj
			 (vla-get-modelspace DBXDoc) ;seperate Modelspace and paperspace 
                (if (and (= (vla-get-objectname upc_blkobj) "AcDbBlockReference") (= (vla-get-hasattributes upc_blkobj) :vlax-true))
		        (progn
                            (setq lst
			  (mapcar  '(lambda (Att)
		                                   (cons (vla-get-tagstring att) (vla-get-TextString Att) ));end lambda
                                                            (vlax-invoke upc_blkobj 'GetAttributes)
                                      );end mapcar
				   	  );end setq
				 
			   (setq lsttag (mapcar '(lambda (txt) (car txt)) lst) );;;att문자값리스트 저장변수에서 속성문자값뽑아오기.
			     (setq lsttxt (mapcar '(lambda (txt) (cdr txt)) lst) ) 
			
               		  
		
			  (dcl_ListBox_Clear attchanger_Mdwg_ListBox1);리스트박스값 삭제.후 리스트 넘김..
		      (dcl_ListBox_AddList attchanger_Mdwg_ListBox1 lsttag);속성태그리스트 리스트박스1로넘김..
			  (dcl_Grid_Clear attchanger_Mdwg_Grid1);그리드리스트삭제후 새로운값입력
			  (setq lsttag (reverse lsttag)
			        lsttxt (reverse lsttxt)
					)
			  (setq tagcnt 0)
			  (setq grid (list (list (nth 0 lsttag) (nth 0 lsttxt))))
			  (setq tagcnt (+ 1 tagcnt))
			  (setq gridcnt (length lsttag))
			  (repeat (- gridcnt 1)
			  (setq grid (cons (list (nth tagcnt lsttag) (nth tagcnt lsttxt)) grid)) ;연속적으로 그리드값 리스트로 만들기
			  (setq tagcnt (+ 1 tagcnt))
			   );repeat 완료
			 
			 (dcl_Grid_FillList attchanger_Mdwg_Grid1 grid); 그리드에값넣기.
			 
			 
			 
			  
			  );end progn
		  );end if

			 );vlax-for 모형탭 종료
			 
			 (vlax-for upc_blkobj
			 (vla-get-paperspace DBXDoc) ;seperate Modelspace and paperspace 
                (if (and (= (vla-get-objectname upc_blkobj) "AcDbBlockReference") (= (vla-get-hasattributes upc_blkobj) :vlax-true))
		        (progn
                            (setq lst
			  (mapcar  '(lambda (Att)
		                                   (cons (vla-get-tagstring att) (vla-get-TextString Att) ));end lambda
                                                            (vlax-invoke upc_blkobj 'GetAttributes)
                                      );end mapcar
				   	  );end setq
				 
			   (setq lsttag (mapcar '(lambda (txt) (car txt)) lst) );;;att문자값리스트 저장변수에서 속성문자값뽑아오기.
			     
               		  
			  
			  (dcl_ListBox_Clear attchanger_Mdwg_ListBox1);리스트박스값 삭제.후 리스트 넘김..
		      (dcl_ListBox_AddList attchanger_Mdwg_ListBox1 lsttag);속성태그리스트 리스트박스1로넘김..
			 
			  
			  );end progn
		  );end if

			 );vlax-for 배치탭 종료
			 
			 
	 
		 
	 (vlax-release-object dbxdoc);;도면닫기...	
	
  );end defunc 
  
  
  
  ;태그리스트에서 속성값 가져오기...

(defun c:attchanger_Mdwg_ListBox1_OnSelChanged (nselect seltext / oldtag)

  (setq lsttxt (mapcar '(lambda (txt) (cdr txt)) lst) );;;att문자값리스트 저장변수에서 속성문자값뽑아오기.   
    
(setq oldtag  (dcl_ListBox_GetItemText attchanger_Mdwg_ListBox1  (dcl_ListBox_GetCurSel attchanger_Mdwg_ListBox1)))
(dcl_Control_SetText attchanger_Mdwg_oldtag oldtag)  ;기존태그값설정..
		      (setq lsttxtcnt (dcl_ListBox_GetCurSel attchanger_Mdwg_ListBox1));리스트박스에서 텍스트박스로넘길시.값..
              (setq oldatt (nth lsttxtcnt lsttxt))			  
			   (dcl_Control_SetText attchanger_Mdwg_oldatt oldatt); 기존속성값 저장.
                (dcl_Control_SetText attchanger_Mdwg_newatt "")						 
               									 
	     	 					 );end  defunc
   
(defun c:attchanger_Mdwg_OneShot_OnClicked (/)

(updateAll )

)


   
  ;;;;;;;;;;;;;단일속성객체 업데이트..함수..
  (defun c:attchanger_Mdwg_singleUpdate_OnClicked (/ dwgsingle)
  (setq dwgsingle (dcl_ListBox_GetSelectedItems attchanger_Mdwg_dwglist));선택된 도면경로저장..
  (DBXSingle dwgsingle);단일 객체 돌리기 실행..
  
)



;복수객체 실행하기..
(defun c:attchanger_Mdwg_Multiple_OnClicked (/ dwgcnt Mlist)
(setq dwgcnt (dcl_ListBox_GetCount attchanger_Mdwg_dwglist))
(setq Mlist (dcl_Control_GetList attchanger_Mdwg_dwglist))
(DBXMultiple Mlist)

)


  (defun DBXSingle (DbxSingle / )
  
  (setq DBXstr (if (< (atof (getvar "ACADVER")) 16.0) "ObjectDBX.AxDbDocument" (strcat "ObjectDBX.AxDbDocument." (itoa (atoi (getvar "AcadVer")))))
	DBXDoc (vla-getinterfaceobject (vlax-get-acad-object) DBXstr)
  )
  
    (setq dwgname DbxSingle);dwg이름을 경로로 설정
    (vla-open dbxdoc dwgname) ;dbx로 도면 열기 실행
    (vlax-for upc_blkobj (vla-get-modelspace DBXDoc)
      (if (and (= (vla-get-objectname upc_blkobj) "AcDbBlockReference") (= (vla-get-hasattributes upc_blkobj) :vlax-true))
	(progn
	  (setq attlist (vlax-invoke upc_blkobj 'GetAttributes))
	  (foreach upc_att attlist
	 
	    (if (= (vla-get-tagstring upc_att) (dcl_Control_GetText attchanger_Mdwg_oldtag));속성태그값 입력후 속성리스트에서 같은값이있으면 실행
	      ;(vlax-put-property upc_att 'TextString (cdr (assoc "DI_DRWNO" td_dwgcode)))
    	          (progn
     	     (vla-put-textString upc_att (dcl_Control_GetText attchanger_Mdwg_newatt) )
									
                (moveatt upc_att)
				);end 1 progn
				); end 1 if
				);end foreach 1
			);큰 progn종료..
     );end if  큰 if문 종료
    );end vlax-for 모형탭종료
	
	(vlax-for upc_blkobj (vla-get-paperspace DBXDoc)
      (if (and (= (vla-get-objectname upc_blkobj) "AcDbBlockReference") (= (vla-get-hasattributes upc_blkobj) :vlax-true))
	(progn
	  (setq attlist (vlax-invoke upc_blkobj 'GetAttributes))
	  (foreach upc_att attlist
	 
	    (if (= (vla-get-tagstring upc_att) (dcl_Control_GetText attchanger_Mdwg_oldtag));속성태그값 입력후 속성리스트에서 같은값이있으면 실행
	      ;(vlax-put-property upc_att 'TextString (cdr (assoc "DI_DRWNO" td_dwgcode)))
    	          (progn
     	     (vla-put-textString upc_att (dcl_Control_GetText attchanger_Mdwg_newatt) )
									
                (moveatt upc_att)
				);end 1 progn
				); end 1 if
				);end foreach 1
			);큰 progn종료..
     );end if  큰 if문 종료
    );end vlax-for 배치탭종료
	
	
    ;(setq dwgname1 (strcat (substr dwgname 1 (- (strlen dwgname) 4)) "-1.dwg"))
    (vla-saveas dbxdoc dwgname)

  (vlax-release-object dbxdoc)
  (princ)
);end defun


 
 ;;;;;;;;;;;;;;;;;;;복수로 파일값 돌려받을때.......쓰는함수.....

  
  (defun DBXMultiple (DbxMultiple / )
  
  (setq DBXstr (if (< (atof (getvar "ACADVER")) 16.0) "ObjectDBX.AxDbDocument" (strcat "ObjectDBX.AxDbDocument." (itoa (atoi (getvar "AcadVer")))))
	DBXDoc (vla-getinterfaceobject (vlax-get-acad-object) DBXstr)
  )
    
  (foreach dwg DbxMultiple  ;큰 foreach문 ..
	   
    (setq dwgname dwg);dwg이름을 경로로 설정
    (vla-open dbxdoc dwgname) ;dbx로 도면 열기 실행
    (vlax-for upc_blkobj (vla-get-modelspace DBXDoc)
      (if (and (= (vla-get-objectname upc_blkobj) "AcDbBlockReference") (= (vla-get-hasattributes upc_blkobj) :vlax-true))
	(progn
	  (setq attlist (vlax-invoke upc_blkobj 'GetAttributes))
	  (foreach upc_att attlist
	 
	    (if (= (vla-get-tagstring upc_att) (dcl_Control_GetText attchanger_Mdwg_oldtag));속성태그값 입력후 속성리스트에서 같은값이있으면 실행
	     
    	          (progn
     	     (vla-put-textString upc_att (dcl_Control_GetText attchanger_Mdwg_newatt) )
									
                (moveatt upc_att)
				);end 1 progn
				); end 1 if
				);end foreach 1
			);큰 progn종료..
     );end if  큰 if문 종료
	 
    );end vlax-for 모형탭종료
	
	    (vlax-for upc_blkobj (vla-get-paperspace DBXDoc)
      (if (and (= (vla-get-objectname upc_blkobj) "AcDbBlockReference") (= (vla-get-hasattributes upc_blkobj) :vlax-true))
	(progn
	  (setq attlist (vlax-invoke upc_blkobj 'GetAttributes))
	  (foreach upc_att attlist
	 
	    (if (= (vla-get-tagstring upc_att) (dcl_Control_GetText attchanger_Mdwg_oldtag));속성태그값 입력후 속성리스트에서 같은값이있으면 실행
	     
    	          (progn
     	     (vla-put-textString upc_att (dcl_Control_GetText attchanger_Mdwg_newatt) )
									
                (moveatt upc_att)
				);end 1 progn
				); end 1 if
				);end foreach 1
			);큰 progn종료..
     );end if  큰 if문 종료
	 
    );end vlax-for 배치탭종료
	
	
	
	(vla-saveas dbxdoc dwgname)
	);end big foreach
    
    

  (vlax-release-object dbxdoc)
  (princ)
);end defun



;get dwglist파일 가져오기
(defun getdwglist (folderlist)
(apply 'append
(mapcar '(lambda (f)
(mapcar '(lambda (name)
(strcat f "\\" name)
)
(vl-directory-files f "*.dwg")
)
)
folderlist)
)
)

;파일이름 가져오기...		 
(defun filename (folderlist)
(apply 'append
(mapcar '(lambda (g)
(mapcar '(lambda (name)
(strcat name)
)
(vl-directory-files g "*.dwg")
)
)
folderlist)
)
)		 


;getsubfolder list 가져오기..
(defun getsubfolders (folder / tree)
(defun vl-dir-tree (p / dirs)
(setq dirs (vl-remove-if '(lambda (x)
(or (eq "." x)
(eq ".." x))
)
(vl-directory-files p nil -1))
)
(foreach f dirs
(vl-dir-tree (strcat p "\\" f))
(setq tree (cons (strcat p "\\" f) tree))
)
)
(setq tree (list folder))
(vl-dir-tree folder)
)


;태그문자값 위치 변경수정..
(defun moveatt ( att / cenpt inspt minpt maxpt twidth newpt )
  (if (/= (vla-get-textstring att) "")
    (progn
      (setq cenpt (vla-get-textalignmentpoint att))
      (setq inspt (vla-get-insertionpoint att))
      (setq cenpt (vlax-safearray->list (vlax-variant-value cenpt)))
      (setq inspt (vlax-safearray->list (vlax-variant-value inspt)))
      (vla-getboundingbox att 'minp 'maxp)
      (setq minpt (vlax-safearray->list minp))
      (setq maxpt (vlax-safearray->list maxp))
      (setq twidth (abs (- (car maxpt) (car minpt))))
      (setq newpt (list (- (car cenpt) (/ twidth 2)) (cadr inspt) (cadr inspt)))
      (vla-put-insertionpoint att (vlax-3d-point newpt))
   )
  )
)











  









