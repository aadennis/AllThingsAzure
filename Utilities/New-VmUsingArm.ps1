# See Utilities for writing password to secure string on disk..
$user = "polkamot" # makes the odd assumption that user and password are somehow divorced
$passwordFile = "$env:USERPROFILE\pass2.txt" # location of a pre-created encrypted password
$passContent = Get-Content $passwordFile
$pass = $passContent | ConvertTo-SecureString -AsPlainText -Force

#$credentials = New-Object -TypeName System.Management.Automation.PSCredential($user, $pass)
$credentials = Get-Credential -UserName "polkamot" -Message "Enter the password for this user"

#-----------------------------------------------

$ResourceGroupName = "DenDemoRG20"  # CHANGE ONCE FOR ALL ITERATIONS 
$Location = "WestEurope"
$StorageName = "denstoragerg20" # CHANGE ONCE FOR ALL ITERATIONS / MUST BE LOWERCASE ALPHANUMERIC ONLY
$StorageType = "Standard_GRS"

## Network
$InterfaceName = "ServerInterface20" # change each iteration
$Subnet1Name = "Subnet1"
$VNetName = "VNet09"
$VNetAddressPrefix = "10.0.0.0/16"
$VNetSubnetAddressPrefix = "10.0.0.0/24"

## Compute
$VMName = "VirtualMachine20"  # change each iteration
$ComputerName = "Server20" # change each iteration
$VMSize = "Standard_F4"
$OSDiskName = $VMName + "OSDisk"

try {


# keep the same one for convenience, i.e. only execute this once for all iterations
New-AzureRmResourceGroup -Name $ResourceGroupName -Location $Location # EXECUTE ONCE ONLY FOR ALL ITERATIONS


# Storage
# keep the same one for convenience, i.e. only execute this once for all iterations
$StorageAccount = New-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageName -Type $StorageType -Location $Location

# Network
# InterfaceName must be unique per VM - execute each iteration
# next action executes on server...
$PIp = New-AzureRmPublicIpAddress -Name $InterfaceName -ResourceGroupName $ResourceGroupName -Location $Location -AllocationMethod Dynamic

#try executing just once...
$SubnetConfig = New-AzureRmVirtualNetworkSubnetConfig -Name $Subnet1Name -AddressPrefix $VNetSubnetAddressPrefix # EXECUTE ONCE ONLY FOR ALL ITERATION
$VNet = New-AzureRmVirtualNetwork -Name $VNetName -ResourceGroupName $ResourceGroupName -Location $Location -AddressPrefix $VNetAddressPrefix -Subnet $SubnetConfig # EXECUTE ONCE ONLY FOR ALL ITERATION
#Get-AzureRmVirtualNetwork -Name "VNet09" -ResourceGroupName 

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

} 
catch {
    write-host "In the throw block"
    throw

}