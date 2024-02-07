Param(
    [Parameter(Mandatory)]
    [string]$sourceVaultName,
    [Parameter(Mandatory)]
    [string]$destVaultName,
    [Parameter(Mandatory = $False)]
    [string[]]$secretNames
)

if (!$secretNames) {
    $secretInput = Read-Host -Prompt 'Enter comma separated list of secret names to copy, press Enter to copy all secrets'
    $secretNames = $($secretInput -replace '\s', '') -split ','
} 

#authenticate to Azure
Connect-AzAccount

$isAllSecrets = $False

if (!$secretNames) {
    #get all secrets from value
    $secretNames = (Get-AzKeyVaultSecret -VaultName $sourceVaultName).Name
    $isAllSecrets = $True
}

$secretNames.foreach{
    $exists = $isAllSecrets -eq $True
    if (!$exists) {
        #check secret exists
        $exists = (Get-AzKeyVaultSecret -VaultName $sourceVaultName -Name $_)
    }
    if ($exists) {
        Write-Host "Copying Secret '$($_)'"
        Set-AzKeyVaultSecret -VaultName $destVaultName -Name $_ `
            -SecretValue (Get-AzKeyVaultSecret -VaultName $sourceVaultName -Name $_).SecretValue
    }
}