
;; TextButton pressed EnterKey TEST !.
;; 2010. 08. 26.


(defun c:btntest ( / *Test_Form )

   (setq *Test_Form

'("YWt6AxwNAAA/h9VeBuKr6KM1Kj9muOGduUTXand7L/rv7+oVx6WErztpG6b52Nguaf/KlRBh0HRX"
"V6MGZZoLe4txegOsaQonSQuZYa4bOu6oIzrnpYXwueMNYLO7dNINRpWCmOMHGZjjB6APIxBQeYFV"
"ZztkXWb7eR7Ucibde0+q2s5xsxY83cIPWm7rDGIZm/X0W1cRJDSzFu9JV9vmDt0OLEb/6uodrFBA"
"QS4wQxiuUYj6qtSpWJftbgFPoR396m3AucqCOBOV5gIXGporIXMsaTl3VKrX49ZCpnKd33aA3fW0"
"HmbpTnaNZCt1iwB9DSyEeWBNH2Onmf0GTUc6AooKag37hkiPcZy1ulEvZGTRtPMJLYdTy2FdUIi8"
"jQOQhCUANILyhnePWofBP4LjBuJGnPsHqLsteUylvSWv9b2WP1Gy5S5DMtPlqdICCDX12y7XSwvC"
"21hXGQp2+e7r02PvXc+qqGi/mumnl6IV2/f6outHOWOU0upoK2ckiqhqiB0/VgMmRiMDnjeL362Z"
"ddz+f9eX+Qc2eZBvj310jgOcBboJ97UXfYa+c/soIKdfpS9ToQfnIyigFMq0kUfm9QdBSAwY5gZO"
"YS+R9XQb/pInnL4/odwC45jHv6fxVAlHANIC86ink5ITFOENnScB4RaC54LEmYUB2n2Gp9O5yOE4"
"J/YV1oFwSYDWpDFG0C9AMDwVWZBeQDhyUWJhaLIw9CE+PieGfKz2Kxaz/zt8lOuDYOnnYerNRFDn"
"yu7+iK4OBfd9B43lYPlsCZLSQ16+WBvopkzMzoOp0C5o+xrOgGHvu3Vp6WcToTIPdrYYbejusxD0"
"jSv0PeyGag8+CEN2tZDwDGNjtVZPtUwzwvWojfSYAZWpzJAohWfMEXVZkEhHwKvsKPlPWNeoqsWg"
"IVkoSVdiP0ZXClcZFksB5FokVsRVNmzZn1l3ky/QS4viWlyTjDEmrFTeDvx2Wv4XNH6oYDZ+gyYK"
"fenItC49iPBSDoVoMGuBn3OEkAksO15Lqhz3Km7uiDj624NgtaHWyINU9DmBlXX0GWwBnzgj/0bY"
"gsFBf4/04MQ=")
	 
   ) ;_ End of setq


   (dcl_project_import *Test_Form nil nil)
   (dcl_Form_Show test_form)

) ;_ End of defun



(defun c:test_form_btnClose_OnClicked (/)

   (alert "\n I'm Closing")

   (dcl_Form_Close test_form)
   
)

