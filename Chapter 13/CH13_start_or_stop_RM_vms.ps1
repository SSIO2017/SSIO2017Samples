#--Begin Setup Block
#Get AzureRM Module
#Install-Module AzureRM -AllowClobber
#Associate Azure RM Account
Login-AzureRmAccount
#
#--End Setup Block #

$ResourceGroupName = "w-ag-20170915"
$vms = "sqlserver-1","sqlserver-0","cluster-fsw","ad-secondry-dc","ad-primary-dc" #Order matters!
$Startup_or_Shutdown = "shutdown" # "Shutdown" or "Startup"

#To startup, reverse the order so that DC's come online first.
IF($Startup_or_Shutdown -eq "Startup") {[array]::Reverse($vms)}

#Begin startup/shutdown loop
ForEach ($vm in $vms) {       
    If ($Startup_or_Shutdown -eq "Startup") 
    { 
    Write-Output "Starting VM:($vm.ToString) $(Get-Date -Format G)" 
    Start-AzureRMVM  -ResourceGroupName $ResourceGroupName -Name $vm  
    Write-Output "Started VM:($vm.ToString) $(Get-Date -Format G)" 
    }
    If ($Startup_or_Shutdown -eq "Shutdown") 
    { 
    Write-Output "Stopping VM:($vm.ToString) $(Get-Date -Format G)" 
    Stop-AzureRMVM  -ResourceGroupName $ResourceGroupName -Name $vm -Force  
    Write-Output "Stopped VM:($vm.ToString) $(Get-Date -Format G)" 
    }
}
