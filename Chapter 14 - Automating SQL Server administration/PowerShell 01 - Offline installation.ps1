################################################################################
##
## SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
##
## © 2018 MICROSOFT PRESS
##
################################################################################
##
## CHAPTER 14: AUTOMATING SQL SERVER ADMINISTRATION
## POWERSHELL SAMPLE 1
##

#On an online machine:
Save-Module -Name SQLSERVER -LiteralPath "c:\temp\"

#On the offline machine:
$env:PSModulePath.replace(";","`n")

# Copy the folder

Import-Module SQLSERVER

# Verify
Get-Module -ListAvailable -Name '*SQL*' | Select-Object Name, Version, RootModule

