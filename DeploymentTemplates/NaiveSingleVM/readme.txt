$SubId = "enter this"
$rg = "DWRG"
$location = "uksouth"
$depName = "stuff"
.\deploy.ps1 -templateFilePath .\SingleVMwithSQL.json -subscriptionId $subId `
-resourceGroupName $rg -resourceGroupLocation $location -deploymentName $depName -Verbose