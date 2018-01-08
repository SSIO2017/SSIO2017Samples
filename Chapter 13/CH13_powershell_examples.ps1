#Backup all databases (except for Tempdb)
#TODO: change value for -ServerInstance parameter
Get-SqlDatabase -ServerInstance 'localhost' | `
    Where-Object { $_.Name -ne 'tempdb' } | `
    ForEach-Object { 
        Backup-SqlDatabase -DatabaseObject $_ `
        -BackupAction "Database" `
        -CompressionOption On  `
        -BackupFile "F:\Backup\$($_.Name)\$($_.Name)_$(Get-Date -Format "yyyyMMdd")_$(Get-Date -Format "HHmmss_FFFF").bak" `
        -Script    ` #The -Script generates TSQL, but does not execute
    }

#Retention plan for backup files sample
<#
#Testing scripts to help you test a retention policy, to create files with old create datetimes
new-item 'F:\Backup\backup_test_201402010200.bak' -ItemType file -Force
$file = get-item 'F:\Backup\backup_test_201402010200.bak'
$file.CreationTime = '2/1/2014 2:01am'

new-item 'F:\Backup\sub\backup_test_201402010200.bak' -ItemType file -Force
$file = get-item 'F:\Backup\sub\backup_test_201402010200.bak'
$file.CreationTime = '2/1/2014 2:01am'
#>
$path = "F:\Backup\"
$RetentionDays = -1
$BackupFileExtensions = ".bak", ".trn", ".dif"

Get-ChildItem -path $path -Recurse | `
    Where-Object { !$_.PSIsContainer `
                 -and $_.CreationTime -lt (get-date).AddDays($RetentionDays) `
                 -and ($_.Extension -In $BackupFileExtensions) `
                 } | Remove-Item -WhatIf
#With -WhatIf on, should see a report of files that would be deleted. Remove -WhatIf to actually delete.
# What if: Performing the operation "Remove File" on target "F:\Backup\backup_test_201402010200.bak".

#Invoke-Sqlcmd samples
#1
Invoke-Sqlcmd -Database master -ServerInstance .\sql2k17 `
-Query "select * from sys.dm_exec_sessions" | `
Format-Table | Out-File -FilePath "C:\Temp\Sessions.txt" -Append 

#2
Invoke-Sqlcmd -Database master -ServerInstance azure-databasename.database.windows.net `
    -Username william -Password 'strongpassword' `
    -Query "select * from sys.dm_exec_sessions" | `
    Format-Table | Out-File -FilePath "C:\Temp\Sessions.txt"  -Append

#3
Invoke-Sqlcmd -Database master -ServerInstance .\sql2k17 `
-Query "select * from sys.dm_exec_sessions" | `
Out-GridView

#Local server install SQLSERVER module sample
    Install-Module -Name SQLSERVER -Force -AllowClobber 
    Import-Module -Name SQLSERVER
    
#Remove server install SQLSERVER module sample
Invoke-Command -script { 
    Install-Module -Name SQLSERVER -Force -AllowClobber 
    Import-Module -Name SQLSERVER
    }  -ComputerName "SQLSERVER-1" 