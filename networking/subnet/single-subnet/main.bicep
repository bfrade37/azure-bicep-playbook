@description('Name of the existing Virtual Network')
param vnetName string

@description('Name of the subnet to create')
param subnetName string

@description('Address prefix for the subnet')
param addressPrefix string = '10.0.1.0/24'

@description('Azure region')
param location string = 'northeurope'

resource vnet 'Microsoft.Network/virtualNetworks@2025-05-01' existing = {
  name: vnetName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2025-05-01' = {
  parent: vnet
  name: subnetName
  properties: {
    addressPrefix: addressPrefix
  }
}

output subnetId string = subnet.id
output subnetName string = subnet.name
