#On an online machine:

#save-module -Name SQLSERVER -LiteralPath "c:\temp\"

#On the offline machine:

$env:PSModulePath.replace(";","`n")

#Copy the folder

Import-Module SQLSERVER

#Verify

#get-module -ListAvailable -Name '*SQL*' | Select-Object Name, Version, RootModule

