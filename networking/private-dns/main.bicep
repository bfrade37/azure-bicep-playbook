targetScope = 'resourceGroup'

@description('Name of the Private DNS Zone.')
param privateDnsZoneName string = 'privatelink.blob.core.windows.net'

@description('Resource ID of the existing Virtual Network.')
param vnetId string

@description('Name of the Virtual Network link.')
param vnetLinkName string = 'link-vnet-dev'

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: privateDnsZoneName
  location: 'global'
}

resource vnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  parent: privateDnsZone
  name: vnetLinkName
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnetId
    }
  }
}

output privateDnsZoneId string = privateDnsZone.id
output privateDnsZoneName string = privateDnsZone.name
output vnetLinkId string = vnetLink.id
```
