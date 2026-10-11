using './main.bicep'

param location = 'northeurope'
param privateEndpointName = 'pe-storage-blob-dev'

param targetResourceId = '/subscriptions/YOUR_SUBSCRIPTION_ID/resourceGroups/rg-storage-dev/providers/Microsoft.Storage/storageAccounts/YOUR_STORAGE_ACCOUNT'

param subnetId = '/subscriptions/YOUR_SUBSCRIPTION_ID/resourceGroups/rg-network-dev/providers/Microsoft.Network/virtualNetworks/vnet-dev/subnets/snet-private-endpoints'

param privateDnsZoneId = '/subscriptions/YOUR_SUBSCRIPTION_ID/resourceGroups/rg-network-dev/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net'

param groupId = 'blob'

param tags = {
  Environment: 'Dev'
  ManagedBy: 'Bicep'
}
```
