<#
$user = "polkamot" # makes the odd assumption that user and password are somehow divorced

$passwordFile = "$env:USERPROFILE\pass2.txt"
$pass = Get-Content $passwordFile
$passStuff = $pass | ConvertTo-SecureString -AsPlainText -Force

$credentials = New-Object -TypeName System.Management.Automation.PSCredential($user, $passStuff)
$credentials

$password = get-content C:\cred.txt | convertto-securestring
$credentials = new-object -typename System.Management.Automation.PSCredential -argumentlist $user,$password
#>

$ResourceGroupName = "ResourceGroup11a"
$Location = "WestEurope"

$StorageName = "denstorage2016"
$StorageType = "Standard_GRS"

## Network
$InterfaceName = "ServerInterface16" # change each iteration
$Subnet1Name = "Subnet1"
$VNetName = "VNet09"
$VNetAddressPrefix = "10.0.0.0/16"
$VNetSubnetAddressPrefix = "10.0.0.0/24"

## Compute
$VMName = "VirtualMachine16"  # change each iteration
$ComputerName = "Server22"
$VMSize = "Standard_A2"
$OSDiskName = $VMName + "OSDisk"


# keep the same one for convenience, i.e. only execute this once for all iterations
#New-AzureRmResourceGroup -Name $ResourceGroupName -Location $Location


# Storage
# keep the same one for convenience, i.e. only execute this once for all iterations
#$StorageAccount = New-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageName -Type $StorageType -Location $Location

# Network
# InterfaceName must be unique per VM - execute each iteration
# next action executes on server...
$PIp = New-AzureRmPublicIpAddress -Name $InterfaceName -ResourceGroupName $ResourceGroupName -Location $Location -AllocationMethod Dynamic




#try executing just once...
#$SubnetConfig = New-AzureRmVirtualNetworkSubnetConfig -Name $Subnet1Name -AddressPrefix $VNetSubnetAddressPrefix
#$VNet = New-AzureRmVirtualNetwork -Name $VNetName -ResourceGroupName $ResourceGroupName -Location $Location -AddressPrefix $VNetAddressPrefix -Subnet $SubnetConfig

# once every iteration...
$Interface = New-AzureRmNetworkInterface -Name $InterfaceName -ResourceGroupName $ResourceGroupName -Location $Location -SubnetId $VNet.Subnets[0].Id -PublicIpAddressId $PIp.Id



## Setup local VM object
#$Credential = Get-Credential
# all this once each iteration...
$VirtualMachine = New-AzureRmVMConfig -VMName $VMName -VMSize $VMSize
$VirtualMachine = Set-AzureRmVMOperatingSystem -VM $VirtualMachine -Windows -ComputerName $ComputerName -Credential $credentials -ProvisionVMAgent -EnableAutoUpdate

$VirtualMachine = Set-AzureRmVMSourceImage -VM $VirtualMachine -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2012-R2-Datacenter -Version "latest"
$VirtualMachine = Add-AzureRmVMNetworkInterface -VM $VirtualMachine -Id $Interface.Id
$OSDiskUri = $StorageAccount.PrimaryEndpoints.Blob.ToString() + "vhds/" + $OSDiskName + ".vhd"
$VirtualMachine = Set-AzureRmVMOSDisk -VM $VirtualMachine -Name $OSDiskName -VhdUri $OSDiskUri -CreateOption FromImage

## Create the VM in Azure
New-AzureRmVM -ResourceGroupName $ResourceGroupName -Location $Location -VM $VirtualMachine 

# Start-Job -ScriptBlock {New-AzureRmVM -ResourceGroupName $ResourceGroupName -Location $Location -VM $VirtualMachine} 