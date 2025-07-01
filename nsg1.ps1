$nsgName = "asdfdsfdf"
$nsg = Get-AzNetworkSecurityGroup -ResourceGroupName $VMResourceGroupName -Name $nsgName

# Check if rule already exists
$existingRule = $nsg.SecurityRules | Where-Object { $_.Name -eq "AllowInternetOutBound" }

if (-not $existingRule) {
    Write-Host "Adding NSG rule AllowInternetOutBound..."

    $nsg.SecurityRules.Add(
        (New-AzNetworkSecurityRuleConfig `
            -Name "AllowInternetOutBound" `
            -Description "Allow SHIR to talk to Azure" `
            -Access Allow `
            -Protocol Tcp `
            -Direction Outbound `
            -Priority 65001 `
            -SourceAddressPrefix * `
            -SourcePortRange * `
            -DestinationAddressPrefix Internet `
            -DestinationPortRange 443)
    )

    Set-AzNetworkSecurityGroup -NetworkSecurityGroup $nsg
} else {
    Write-Host "NSG rule AllowInternetOutBound already exists. Skipping."
}
