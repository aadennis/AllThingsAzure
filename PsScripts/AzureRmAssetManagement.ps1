<# 
.Synopsis
    Readonly review of Azure Resource Manager (ARM) assets, e.g. Resource Group name, VM names, etc.
    The required parameter is the name of the parent resource group

           
    .Example 
        Get-AzureRmAssets -ResourceGroupName "DENRESOURCEGROUP"
#>
function Get-AzureRmAssets {
    [CmdletBinding(SupportsShouldProcess)]
    Param (
    [Parameter(Mandatory)]
        [string] $ResourceGroupName,
    [Parameter()]
        [int] $LoopCount = 22
    )

    # ToDo
    if ($ResourceGroupName) {
    # get a specific resource
    } else {
    # get all resources...

    }

    $vmStatus = Get-AzureRmVM 

    Format-Arguments -argumentToRender $vmStatus.ResourceGroupName
    
    $vmStatus.ResourceGroupName
    $vmStatus.StatusCode
    $vmStatus.HardwareProfile.VmSize
    $vmStatus.Location
    $vmStatus.StorageProfile.ImageReference.Sku
    $vmStatus.StorageProfile.OsDisk.OsType
    $vmStatus.DataDiskNames

  
}

function Format-Arguments {
    [CmdletBinding(SupportsShouldProcess)]
        Param (
        [Parameter(Mandatory)]
            [string] $argumentToRender
        )

    $commandName = $PSCmdlet.MyInvocation.InvocationName
    $ParameterList = (Get-Command -Name $CommandName).Parameters;
    foreach ($key in $PSCmdlet.MyInvocation.BoundParameters.Keys) {
        $value = (Get-Variable $key).Value
        Write-Host "$key -> $value"
    }




    write-host "`$argumentToRender` $argumentToRender"
}