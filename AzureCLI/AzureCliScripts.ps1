<# 
.Synopsis
     Azure CLI related functions
.Description 
    Collection of Azure CLI related functions - see individual functions for examples
#>

Set-StrictMode -Version latest

<#
.Synopsis
   Create a set of VMs which target the Classic deployment model (ASM). Uses Azure CLI - [azure login]
   https://azure.microsoft.com/en-gb/documentation/articles/virtual-machines-command-line-tools
.Example
   New-VmSet -VmPrefix "aaz" -VmCount 5 
#>
function New-VmSet {
[CmdletBinding()]
    Param (
        [string] $prefix = $null,
        [int] $VmCount = 2
    )

    Set-CliEnvironment $prefix
    1..$vmCount | ForEach-Object {
        Start-Sleep 15
        $currentVM = $_
        $vmName = $vmPrefix + $currentVM
        $vmCreateArgs = "vm create $vmName $image $username $password" + 
            " --location $location --vm-size $vmSize -r"
        Write-Output "Arguments passed to azure.cmd: $vmCreateArgs"
        Start-Process "azure.cmd" -ArgumentList $vmCreateArgs `
            -NoNewWindow -RedirectStandardError $errorLog
    }


}

<#
.Synopsis
    Remove a set of VMs specifying a prefix and a range
.Example
    Remove-VmSet -Prefix "demo" -start 1 -end 5
#>
function Remove-VmSet ($prefix = $null, $start = $null, $end = $null) {
    $msg = "VmSet [$prefix*] will be deleted." +
        "Press ctrl-C to exit, Enter to continue."
    Read-Host $msg
    if ($prefix -eq $null -or $start -eq $null -or $end -eq $null) {
        "You have not specified all Arguments. Exiting..."
        throw
    }
    $start..$end | % {"$prefix$_"; azure vm delete -q $prefix$_}

}

<#
.Synopsis
    Set up global environment variables for a naive example end-to-end of CLI deployment
.Example
    Set-CliEnvironment -Prefix "polkamot-"
#>
function Set-CliEnvironment ($prefix = $null) {
    if (-not $prefix) {
        "VM prefix not set. Exiting..."
        throw
    }
    Get-Password
    $Global:image = "fb83b3509582419d99629ce476bcb5c8__SqlServer-2016-RTM-RServices-13.0.1601.5-Enterprise-ENU-WS2012R2-CY16-SU0310020"
    $Global:username = "polkamot"
    $Global:location = "`"East US`""
    $Global:vmSize = "`"Standard_F4`""
    $global:vmPrefix = $prefix
    $Global:errorLog = "c:\temp\azureRun.err"
}

<#
.Synopsis
   Get a password
.Example
    Get-Password
#>
function Get-Password() {
    if (-not $Global:password) {
        Write-Output "Password is not set. Exiting..."
        throw
    }

}

<#
.Synopsis
   Set a password
.Example
    Set-Password
#>
function Set-Password() {
    if (Test-Path variable:Global:password) {
        Write-Output "Password already set. Exiting..."
        throw
    }
    $Global:password = Read-Host -Prompt "Enter the password"

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
        "4" = "fb83b3509582419d99629ce476bcb5c8__SqlServer-2016-RTM-RServices-13.0.1601.5-Enterprise-ENU-WS2012 R2-CY16-SU0310020";
    }

    Write-Host "Enter your choice of image as a number between 1 and 4:
        1) [Windows 2012 R2, SqlServer 2014 SP1]
        2) [Windows 2012 (not R2), SqlServer 2012]
        3) [Windows 2012 R2 (no SQLServer)]
        4) [Windows, SqlServer 2016]"

    $image = Read-Host
    if ($image -in 1..$imageSet.Count) {
        Write-Host "You selected [$image]"
        return $imageSet[$image]
    }
    "Bad Image identifier. Exiting..."
    throw

}

# Before executing, Set-Password
# Set-Password
# Before executing, call azure login

New-VmSet -prefix "PolkaMot-" -VmCount 1
#Remove-VmSet -prefix "PolkaMot-" -start 1 -end 5

#$image = Get-Image
#$image


