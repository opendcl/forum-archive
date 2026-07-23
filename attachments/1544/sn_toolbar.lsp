

(vl-load-com)



(defun c:sn_toolbar ()
	
	(LoadRunTime)
	(dcl_Project_Load "NORMAS" T)
	(dcl_Form_Show normas_FrmMain)
	
	
	;Variables Paginador Toolbar
	(setq sn_LimitePagina (vl-registry-read "HKEY_LOCAL_MACHINE\\Software\\Isercon\\SN_NORMAS\\" "LimitePagina"))
	(if (not sn_LimitePagina) 
		(setq sn_LimitePagina 15)
		(setq sn_LimitePagina (atoi sn_LimitePagina))
	)
	
	(setq tmp (vl-registry-read "HKEY_LOCAL_MACHINE\\Software\\Isercon\\SN_NORMAS\\" "AgrupaVista"))
	(if (= 1 tmp)
		(setq OnOffAgrupaVista T)
		(setq OnOffAgrupaVista nil)
	)
	
	
	(if (not opt_Tipotabla)
		(setq opt_Tipotabla (vl-registry-read "HKEY_LOCAL_MACHINE\\Software\\Isercon\\SN_NORMAS\\" "TipoTabla"))
	)	
	
	
	(dcl_Project_UnLoad "NORMAS")
	(princ)
)

(defun c:Normas_FrmMain_OnInitialize (/)
	;(sn_FillTabDibujarNorma)
	;
	;(setq gApppath (vl-registry-read "HKEY_LOCAL_MACHINE\\Software\\Isercon\\SN_NORMAS\\" "RegistrosPagina"))
	
	(princ)
)




; -----------------------ini config tab de preferecences  ----------------------------------  
;aqui
(defun c:Normas_OptionTab_OnShow (Showing /)
	(if (dcl_Form_IsActive Normas_FrmMain)
		(progn
		(if sn_LimitePagina (dcl_Control_SetText Normas_OptionTab_TxtRegistrosPagina (rtos sn_LimitePagina 2 0)))
		
		(setq tmp (vl-registry-read "HKEY_LOCAL_MACHINE\\Software\\Isercon\\SN_NORMAS\\" "AgrupaVista"))
		(if tmp (dcl_Control_SetValue Normas_OptionTab_ChkAgrupaVista tmp))
		
		(setq tmp (vl-registry-read "HKEY_LOCAL_MACHINE\\Software\\Isercon\\SN_NORMAS\\" "TipoTabla"))
		(if tmp (dcl_Control_SetCurrentSelection Normas_OptionTab_ListaOpt tmp))
		)
	)
)

(defun c:Normas_OptionTab_OnOK (/)
	(if (dcl_Form_IsActive Normas_FrmMain)
		(progn
		(setq tmp (dcl_Control_GetText Normas_OptionTab_TxtRegistrosPagina))
		(vl-registry-write "HKEY_LOCAL_MACHINE\\Software\\Isercon\\SN_NORMAS\\" "LimitePagina" tmp)
		(setq sn_LimitePagina (atoi tmp))	
		
		(c:Normas_FrmMain_CmdInicio_OnClicked)
		(setq tmp (dcl_Control_GetValue Normas_OptionTab_ChkAgrupaVista))
		(vl-registry-write "HKEY_LOCAL_MACHINE\\Software\\Isercon\\SN_NORMAS\\" "AgrupaVista" tmp)
		(if (= 1 tmp)
			(setq OnOffAgrupaVista T)
			(setq OnOffAgrupaVista nil)
		)
		
		(setq opt_Tipotabla (dcl_Control_GetCurrentSelection Normas_OptionTab_ListaOpt))
		(vl-registry-write "HKEY_LOCAL_MACHINE\\Software\\Isercon\\SN_NORMAS\\" "TipoTabla" opt_Tipotabla)
		;
		)
	)
)


; -----------------------Fin config tab de preferecences  ----------------------------------  

