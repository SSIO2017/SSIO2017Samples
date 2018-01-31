Import-Module FailoverClusters  
nslookup Listener1 #listenername
Get-ClusterResource -Cluster "CLUSTER1" #Get cluster network name
Get-ClusterResource "AG1_Network" -Cluster "CLUSTER1" | get-clusterparameter RegisterAllProvidersIP -Cluster "CLUSTER1"
Get-ClusterResource "AG1_Network" -Cluster "CLUSTER1" | set-clusterparameter RegisterAllProvidersIP 1 -Cluster "CLUSTER1" # 1 to enable, 0 to disable
#all changes will take effect until AG1 is taken offline and then online again.
Stop-ClusterResource "AG1_Network" -Cluster "CLUSTER1"
Start-ClusterResource "AG1_Network" -Cluster "CLUSTER1"
Start-ClusterResource "AG1" -Cluster "CLUSTER1" #Must bring the AAG Back online
nslookup Listener1 #Should see the appropriate number of IPs listed now
