<# 
.Synopsis
     Azure CLI related functions
.Description 
    Collection of Azure CLI related functions - see individual functions for examples
#>

Set-StrictMode -Version latest

<#
.Synopsis
   Create a set of VMs which target the Classic deployment model (ASM). Uses Azure CLI.
.Example
   New-ClassicVmSet -VmCount 5 -VmPrefix "aaz"
#>
function New-ClassicVmSet {
[CmdletBinding(SupportsShouldProcess)]
    Param (
        [int] $VmCount = 2,
        [Parameter(mandatory = $true)] $VmPrefix
    )
    try {

        $errorLog = "c:\temp\configErrors.log"
        $username = "thomas"
        $password = "Pathword22!"
        $location = "`"East US`""
        $vmSize = "`"Standard_F4`""

        $image = Get-Image

        1..$vmCount | ForEach-Object {
            $currentVM = $_
            $vmName = $vmPrefix + $currentVM
            $vmCreateArgs = "vm create $vmName $image $username $password --location $location --vm-size $vmSize -r"
            Write-Output "Arguments passed to azure.cmd: $vmCreateArgs"
            $errorLog = "c:\temp\configErrors$vmName.log"
            Start-Process "azure.cmd" -ArgumentList $vmCreateArgs -NoNewWindow -RedirectStandardError $errorLog
            Start-Sleep 15
            if ($errorLog.Length -gt 0) {
                throw
            } 
        }

    } catch {
        "I am in here"
        $errorText = Get-Content $errorLog
        Write-Output [string] $errorText
        "Exception caught and rethrown..."
        throw

    }
}

<#
.Synopsis
   Return the identifier of a Microsoft Azure image. Right now, this is interactive.
.Example
   Get-Image
#>
function Get-Image {
    $imageSet = @{
        "1" = "fb83b3509582419d99629ce476bcb5c8__SQL-Server-2014-SP1-12.0.4100.1-Std-ENU-Win2012R2-cy15su05";
        "2" = "bd507d3a70934695bc2128e3e5a255ba__RightImage-Windows-2012-x64-sqlsvr2012ent-v14.2";
        "3" = "a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-R2-20160812-en.us-127GB.vhd";
    }

    Write-Host "Enter your choice of image as a number between 1 and 3:
        1) [Windows 2012 R2, SqlServer 2014 SP1]
        2) [Windows 2012 (not R2), SqlServer 2012]
        3) [Windows 2012 R2 (no SQLServer)]"

    $image = Read-Host
    if ($image -in 1..$imageSet.Count) {
        Write-Host "You selected [$image]"
        return $imageSet[$image]
    }
    "Bad Image identifier. Exiting..."
    throw

}


#New-ClassicVmSet -VmCount 5 -VmPrefix "aaz"
#$image = Get-Image
#$image


