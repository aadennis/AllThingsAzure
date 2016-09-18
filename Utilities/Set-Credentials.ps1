$passwordFile = "$env:USERPROFILE\pass2.txt"

# Create a "secure" version of the password on disk...
ConvertTo-SecureString "a_Path9!!Tomakeus#Sile" -AsPlainText -Force | `
     ConvertFrom-SecureString | Out-File -FilePath $passwordFile

# Now a session where want to use that...
$user = "polkamot" # makes the odd assumption that user and password are somehow divorced
$pass = Get-Content $passwordFile
$passStuff = $pass | ConvertTo-SecureString -AsPlainText -Force

$credentials = New-Object -TypeName System.Management.Automation.PSCredential($user, $passStuff)
$credentials






read-host -AsSecureString | ConvertFrom-SecureString | out-file C:\cred.txt

$password = get-content C:\cred.txt | convertto-securestring



$credentials = new-object -typename System.Management.Automation.PSCredential -argumentlist "myusername",$pass


