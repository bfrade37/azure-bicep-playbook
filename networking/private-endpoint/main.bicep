targetScope = 'resourceGroup'

@description('Azure region where the Private Endpoint will be deployed.')
param location string = 'northeurope'

@description('Name of the Private Endpoint.')
param privateEndpointName string = 'pe-storage-blob-dev'

@description('Resource ID of the existing Storage Account.')
param targetResourceId string

@description('Resource ID of the existing subnet.')
param subnetId string

@description('Resource ID of the existing Private DNS Zone.')
param privateDnsZoneId string

@description('Private Link subresource to connect to.')
param groupId string = 'blob'

@description('Resource tags.')
param tags object = {
  Environment: 'Dev'
  ManagedBy: 'Bicep'
}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2024-05-01' = {
  name: privateEndpointName
  location: location
  tags: tags
  properties: {
    subnet: {
      id: subnetId
    }
    privateLinkServiceConnections: [
      {
        name: '${privateEndpointName}-connection'
        properties: {
          privateLinkServiceId: targetResourceId
          groupIds: [
            groupId
          ]
        }
      }
    ]
  }
}

resource dnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2025-07-01' = {
  parent: privateEndpoint
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'blob-dns-config'
        properties: {
          privateDnsZoneId: privateDnsZoneId
        }
      }
    ]
  }
}

output privateEndpointId string = privateEndpoint.id
output privateEndpointName string = privateEndpoint.name
output privateEndpointNicId string = privateEndpoint.properties.networkInterfaces[0].id
```
