################################################################################
##
## SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
##
## © 2018 MICROSOFT PRESS
##
################################################################################
##
## CHAPTER 14: AUTOMATING SQL SERVER ADMINISTRATION
## POWERSHELL SAMPLE 2
##

# Backup all databases (except for Tempdb)
# TODO: change value for -ServerInstance parameter
Get-SqlDatabase -ServerInstance 'localhost' | `
    Where-Object { $_.Name -ne 'tempdb' } | `
    ForEach-Object { 
        Backup-SqlDatabase -DatabaseObject $_ `
        -BackupAction "Database" `
        -CompressionOption On  `
        -BackupFile "F:\Backup\$($_.Name)\$($_.Name)_$(Get-Date -Format "yyyyMMdd")_$(Get-Date -Format "HHmmss_FFFF").bak" `
        -Script    ` #The -Script generates TSQL, but does not execute
    }