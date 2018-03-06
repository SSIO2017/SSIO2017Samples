################################################################################
#
# SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
#
# © 2018 MICROSOFT PRESS
#
################################################################################
#
# CHAPTER 6: ADMINISTERING SECURITY AND PERMISSIONS
# POWERSHELL SAMPLE
#
Invoke-SQLCmd -ServerInstance servername -Database master -Query "SELECT @@Servername" -DedicatedAdministratorConnection 
# Or, for a named instance (ensure that the SQL Browser service is running):
Invoke-SQLCmd -ServerInstance servername\instancename -Database master -Query "SELECT @@Servername" -DedicatedAdministratorConnection 
