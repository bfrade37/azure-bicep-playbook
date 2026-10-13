@description('Name of the existing Virtual Network')
param vnetName string

@description('Subnets to create')
param subnets array = [
  {
    name: 'snet-app'
    addressPrefix: '10.0.1.0/24'
  }
  {
    name: 'snet-db'
    addressPrefix: '10.0.2.0/24'
  }
]

resource vnet 'Microsoft.Network/virtualNetworks@2025-05-01' existing = {
  name: vnetName
}

resource subnetResources 'Microsoft.Network/virtualNetworks/subnets@2025-05-01' = [for subnet in subnets: {
  parent: vnet
  name: subnet.name
  properties: {
    addressPrefix: subnet.addressPrefix
  }
}]

output subnetIds array = [for (subnet, i) in subnets: subnetResources[i].id]
