(vl-load-com)

(if (not (vl-bb-ref 'paletteTest))
  (vl-bb-set
    'paletteTest
    (dcl_project_import
      '("YWt6A28CAAB+iqdkBuIL7j8wfD9uO4HWNltSMqYGfiPG57ofODhRvqRmUf4wzfzm/i+duHXGmVxW"
"VUj6e5BC/nmObviIKUUa3mzFrNeEg9UhKYS+0UK0o8Y6aQNGok1i0Mc50lx+4Qs+yhPh/IfG9WJ7"
"TCLOl3jZ9tew5w0oZ09nC7KSDmiwLDjl7805w2DD6isGpFVP391Zd907IfdX51BuJcab8+bE3tGS"
"QcxsBeK+zzSmr5jGc/uUqnoFYjxckt4iyhRjoh/2f4Ub95ikVyWadAWVXRu2NTYfA+1ZsZ9x/NOR"
"tv2vTarOz7plARCCGLshzuxRrYEWihDKQ6HKxGEGETjBZUNPhKuOuThBZwOKkRkAEkfu7ZTb4UyB"
"fM5BE7w=")
      )
    )
  )
(dcl_form_show paletteTest_form1)