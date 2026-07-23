(defun c:cbbwidth()
  (command "opendcl")
  (dcl-project-import '("YWt6A/IJAADBXI3QBuKr6sUQLT9u+AGluiD8+9w2InRa/Ow+dDwSzjMy+XZ2Dl5/+t7eD5IiMvIT"
"DzXq+Hn+ZGRg/9W60/h4RGD+/Gz3JT15uoLFwGKRMfpeM7pg4w2IRU1FRU1FDQSUtQtKES2+atF7"
"6i66K7Jfep4TcpbIbVRy2s9hN9pXMB7kzR/AOQcbRjWP579AsMzqGlfJzWrLrYIgXtmGUlwxZRC9"
"xMsWC22qtYxHOzW9quW4csvSu8OC5A8IdMocE5lH5RekM6ykVlczw3acsDdwHmUydh9Kecn380/Y"
"QrTWHOi1shWKyNozSw1klSTh0l8NvcOihj7d2PAWNRLDSTW8CfsBdCFpAPdQCnKtZZIpzYIwimlC"
"oCC+f5YP875xzWFt1p5mkWybczd3NbLR9/qCFuF5xUUR4HRBbQBcAjXCw12CIwYvRmSMh/niOIFh"
"8a22lEngSLIunpNuGY92WQ/5xcssMvNXQ7aqpPzTTxNVqzRm2GOH+hpclOd1MV55rVuAu8OWeYGY"
"Ujne8Eswie5FrXyYh8t2jVa25Y2Yz449t4V9n4W8ifrFmyLK9FUATLGu1Sc4TvNA4htb5PWTi1AV"
"2FQC1+OzrkmlC41cUXUJCrMotcm7wTP/gvubN5fM5Wyh1z4Q8aZSeYVHBSEagbGTBmWVQTSbA3Oc"
"D4Thbo0GPqhxeIXhyYztbCEw1BMihvqODx82oRXZkuyCCwqwYpGGBEBIRjKCiPET6o5GtY+0wYsz"
"qMx3VLfU5aerivaRPN09uA7njGShK9DTvlr94/UI2fOBMfMRv3RLAMaHURWHCbD1GZmUTeld6wdj"
"3yh/qVaXktndjoWXw5uzs5QWh9yDizSAOWODyBbHOYpRdtkbg3DXoUNji2AkpYCT/aHB7SaFgMud"
"aULYP2g="))
  (dcl-Form-Show cbbwidth/Dialog1)
  (princ)
); c:cbbwidth

(defun c:cbbwidth/Dialog1#OnInitialize (/)
  (dcl-Control-SetList cbbwidth/Dialog1/cbbList (list "Das ist ein sehr, sehr breiter Eintrag1" "Das ist ein sehr, sehr breiter Eintrag2" "Das ist ein sehr, sehr breiter Eintrag3" "Das ist ein sehr, sehr breiter Eintrag4"))
  (dcl-Control-SetWidth cbbwidth/Dialog1/cbbList 104)
  (princ)
); c:cbbwidth/Dialog1#OnInitialize

(defun c:cbbwidth/Dialog1/cbbList#OnDropDown (/)
  (if (= (dcl-Control-GetWidth cbbwidth/Dialog1/cbbList) 104)
    (dcl-Control-SetWidth cbbwidth/Dialog1/cbbList 204)
  ); if
  (princ)
); c:cbbwidth/Dialog1/cbbList#OnDropDown


(defun c:cbbwidth/Dialog1/cbbList#OnKillFocus (/)
  (if (/= (dcl-Control-GetWidth cbbwidth/Dialog1/cbbList) 104)
    (dcl-Control-SetWidth cbbwidth/Dialog1/cbbList 104)
  ); if
  (princ)
); c:cbbwidth/Dialog1/cbbList#OnKillFocus


(defun c:cbbwidth/Dialog1/pbAccept#OnClicked ()
  (dcl-Form-close cbbwidth/Dialog1)
  (princ)
); c:cbbwidth/Dialog1/pbAccept#OnClicked