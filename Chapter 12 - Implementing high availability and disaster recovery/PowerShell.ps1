################################################################################
##
## SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
##
## © 2018 MICROSOFT PRESS
##
################################################################################
##
## CHAPTER 11: DEVELOPING, DEPLOYING, AND MANAGING DATA RECOVERY
## POWERSHELL SAMPLE
##

Import-Module FailoverClusters  

nslookup Listener1 #listenername

# Get cluster network name
Get-ClusterResource -Cluster "CLUSTER1"
Get-ClusterResource "AG1_Network" -Cluster "CLUSTER1" | Get-ClusterParameter RegisterAllProvidersIP -Cluster "CLUSTER1"
# 1 to enable, 0 to disable
Get-ClusterResource "AG1_Network" -Cluster "CLUSTER1" | Set-ClusterParameter RegisterAllProvidersIP 1 -Cluster "CLUSTER1" 
# All changes will take effect when AG1 is taken offline and then online again.
Stop-ClusterResource "AG1_Network" -Cluster "CLUSTER1"
Start-ClusterResource "AG1_Network" -Cluster "CLUSTER1"
# Must bring the AAG Back online
Start-ClusterResource "AG1" -Cluster "CLUSTER1" 

# Should see the appropriate number of IPs listed now
nslookup Listener1 
