# Change me
$subscriptionName = 'Pay-As-You-Go'

Install-Module AzureRM
Update-Module AzureRM

Login-AzureRmAccount
Get-AzureRmSubscription
Select-AzureRmSubscription -SubscriptionName $subscriptionName

# Change me
$resourceGroupName = 'SSIO2017'
$location = "southcentralus"

# Create a new resource group in the current subscription
New-AzureRmResourceGroup -ResourceGroupName $resourceGroupName `
    -Location $location

################################################################################
# CREATING
################################################################################

$serverName = $resourceGroupName.ToLower()
$Cred = Get-Credential -UserName dbadmin -Message "Pwd for server admin"
# Create a logical SQL Server
New-AzureRmSqlServer -ResourceGroupName $resourceGroupName `
    -ServerName $serverName `
    -Location $location -SqlAdministratorCredentials $Cred

$databaseName = ‘Contoso’
# Create a database on the new server
New-AzureRmSqlDatabase -ResourceGroupName $resourceGroupName `
    -ServerName $serverName -DatabaseName $databaseName -Edition Standard `
    -RequestedServiceObjectiveName "S0" -CollationName Latin1_General_CI_AS

# Retrieve details of the new database
Get-AzureRmSqlDatabase -ResourceGroupName $resourceGroupName `
    -ServerName $serverName -DatabaseName $databaseName

# Create a new elastic pool
$poolName = 'Contoso-Pool'
New-AzureRmSqlElasticPool -ResourceGroupName $resourceGroupName `
    -ServerName $serverName -ElasticPoolName $poolName `
    -Edition 'Standard' -Dtu 50 `
    -DatabaseDtuMin 10 -DatabaseDtuMax 20
# Move the database to the new elastic pool
Set-AzureRmSqlDatabase -ResourceGroupName $resourceGroupName `
    -ServerName $serverName -DatabaseName $databaseName `
    -ElasticPoolName $poolName

################################################################################
# AUDITING
################################################################################

$storageAccountName = "azuresqldbaudit"
$storageAccount = New-AzureRmStorageAccount -ResourceGroupName $resourceGroupName `
    -Name $storageAccountName -Location $location -Kind Storage `
    -SkuName Standard_LRS -EnableHttpsTrafficOnly $true
$auditSettings = Set-AzureRmSqlDatabaseAuditing `
    -ResourceGroupName $resourceGroupName `
    -ServerName $serverName -DatabaseName $databaseName `
    -StorageAccountName $storageAccountName -StorageKeyType Primary `
    -RetentionInDays 365 -State Enabled

################################################################################
# EXPORTING
################################################################################
	
$d = (Get-Date).ToUniversalTime()
$databaseCopyName = "$databaseName-Copy-" + ($d.ToString("yyyyMMddHHmmss"))
$storageAccountName = 'azuresqldbexport'
$cred = Get-Credential
$storAcct = New-AzureRmStorageAccount -ResourceGroupName $resourceGroupName `
    -Name $storageAccountName -Location $location `
    -SkuName Standard_LRS
$storageKey = Get-AzureRmStorageAccountKey -ResourceGroupName $resourceGroupName `
    -Name $storageAccountName
$newDB = New-AzureRmSqlDatabaseCopy -ResourceGroupName $resourceGroupName `
    -ServerName $serverName -DatabaseName $databaseName `
    -CopyDatabaseName $databaseCopyName
$containerName = "mydbbak"
$container = New-AzureStorageContainer -Context $storAcct.Context `
    -Name $containerName
$bacpacUri = $container.CloudBlobContainer.StorageUri.PrimaryUri.ToString() + "/" + `
    $databaseCopyName + ".bacpac"
$fwRule = New-AzureRmSqlServerFirewallRule -ResourceGroupName $resourceGroupName `
    -ServerName $serverName -AllowAllAzureIPs
$exportRequest = New-AzureRmSqlDatabaseExport –ResourceGroupName $resourceGroupName `
    –ServerName $NewDB.ServerName –DatabaseName $databaseCopyName `
    –StorageKeytype StorageAccessKey –StorageKey $storageKey[0].Value `
    -StorageUri $bacpacUri `
    –AdministratorLogin $cred.UserName –AdministratorLoginPassword $cred.Password
Do {
    $exportStatus = Get-AzureRmSqlDatabaseImportExportStatus `
        -OperationStatusLink $ExportRequest.OperationStatusLink
    Write-Host "Exporting... sleeping for 1 second..."
    Start-Sleep -Seconds 1
} While ($exportStatus.Status -eq "InProgress")
Remove-AzureRmSqlDatabase –ResourceGroupName $resourceGroupName `
    –ServerName $serverName –DatabaseName $databaseCopyName
Remove-AzureRmSqlServerFirewallRule -ResourceGroupName $resourceGroupName `
    -ServerName $serverName -FirewallRuleName $fwRule.FirewallRuleName