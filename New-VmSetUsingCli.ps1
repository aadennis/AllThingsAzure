#New-VmSet
# Create a set of VMs using the Azure CLI

$errorLog = "c:\temp\configErrors.log"
$win2012R2Image = "a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-R2-20160812-en.us-127GB.vhd" 
$sqlImage = "bd507d3a70934695bc2128e3e5a255ba__RightImage-Windows-2012-x64-sqlsvr2012ent-v14.2" # Windows 2012 (not R2), sqlsvr2012 
$sqlImage2014 = "fb83b3509582419d99629ce476bcb5c8__SQL-Server-2014-SP1-12.0.4100.1-Std-ENU-Win2012R2-cy15su05" # Windows 2012 R2, sqlsvr2014 sp1
$username = "thomas"
$password = "Pathword22!"
$location = "`"East US`""
$vmSize = "`"Standard_F4`""
$vmPrefix = "DemoAZVMn"
$vmCount = 5

#azure login

1..$vmCount | ForEach-Object {
    $temp = $vmCount
    $errorLog = "c:\temp\configErrors_$($temp).txt"
    $vmName = $vmPrefix + $_
    $vmCreateArgs = "vm create $vmName $sqlImage2014 $username $password --location $location --vm-size $vmSize -r"
    Write-Output "Arguments passed to azure.cmd: $vmCreateArgs"
    Start-Process "azure.cmd" -ArgumentList $vmCreateArgs -NoNewWindow -RedirectStandardError $errorLog
    #Start-Sleep 10
    #Start-Process "notepad.exe" -ArgumentList $errorLog
}



