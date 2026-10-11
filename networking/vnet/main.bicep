targetScope = 'resourceGroup'

@description('Azure region where the VNet will be deployed.')
param location string = 'northeurope'

@description('Name of the Virtual Network.')
param vnetName string = 'vnet-dev'

@description('Address space of the Virtual Network in CIDR notation.')
param addressSpace string = '10.10.0.0/16'

@description('Resource tags.')
param tags object = {
  Environment: 'Dev'
  ManagedBy: 'Bicep'
}

resource vnet 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressSpace
      ]
    }
  }
}

output vnetId string = vnet.id
output vnetName string = vnet.name
output addressSpace string = vnet.properties.addressSpace.addressPrefixes[0]

