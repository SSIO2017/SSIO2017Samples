################################################################################
##
## SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
##
## © 2018 MICROSOFT PRESS
##
################################################################################
##
## CHAPTER 14: AUTOMATING SQL SERVER ADMINISTRATION
## POWERSHELL SAMPLE 3
##

# Retention plan for backup files sample
<#
# Testing scripts to help you test a retention policy, to create files with old create datetimes
New-Item 'F:\Backup\backup_test_201402010200.bak' -ItemType File -Force
$file = Get-Item 'F:\Backup\backup_test_201402010200.bak'
$file.CreationTime = '2/1/2014 2:01am'

New-Item 'F:\Backup\sub\backup_test_201402010200.bak' -ItemType File -Force
$file = Get-Item 'F:\Backup\sub\backup_test_201402010200.bak'
$file.CreationTime = '2/1/2014 2:01am'
#>
$path = "F:\Backup\"
$RetentionDays = -1
$BackupFileExtensions = ".bak", ".trn", ".dif"

Get-ChildItem -Path $path -Recurse | `
    Where-Object { !$_.PSIsContainer `
                 -and $_.CreationTime -lt (get-date).AddDays($RetentionDays) `
                 -and ($_.Extension -In $BackupFileExtensions) `
                 } | Remove-Item -WhatIf
# With -WhatIf on, should see a report of files that would be deleted. Remove -WhatIf to actually delete.
# What if: Performing the operation "Remove File" on target "F:\Backup\backup_test_201402010200.bak".
