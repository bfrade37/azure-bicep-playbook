using './main.bicep'

param privateDnsZoneName = 'privatelink.blob.core.windows.net'
param vnetId = '/subscriptions/YOUR_SUBSCRIPTION_ID/resourceGroups/rg-network-dev/providers/Microsoft.Network/virtualNetworks/vnet-dev'
param vnetLinkName = 'link-vnet-dev'
