# Ensure SHIR VM has outbound Internet access on port 443
$nsg = (Get-AzNetworkInterface -ResourceGroupName $VMResourceGroupName -VMName $VMName).NetworkSecurityGroup
if (-not (Get-AzNetworkSecurityRuleConfig -Name "AllowInternetOutBound" -NetworkSecurityGroupName $nsg.Name -ResourceGroupName $VMResourceGroupName -ErrorAction SilentlyContinue)) {
    $nsg.SecurityRules.Add((New-AzNetworkSecurityRuleConfig -Name "AllowInternetOutBound" -Description "Allow SHIR to talk to Azure" -Access Allow -Protocol Tcp -Direction Outbound -Priority 65001 -SourceAddressPrefix '*' -SourcePortRange '*' -DestinationAddressPrefix Internet -DestinationPortRange 443))
    Set-AzNetworkSecurityGroup -NetworkSecurityGroup $nsg
}
