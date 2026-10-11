
targetScope = 'resourceGroup'

@description('Azure region where network resources will be deployed.')
param location string = 'northeurope'

@description('Name of the virtual network.')
param vnetName string = 'vnet-app-dev'

@description('Virtual network address space in CIDR notation.')
param addressSpace string = '10.10.0.0/16'

@description('Address prefix for the application subnet.')
param appSubnetPrefix string = '10.10.1.0/24'

@description('Address prefix for the data subnet.')
param dataSubnetPrefix string = '10.10.2.0/24'

@description('Resource tags.')
param tags object = {
  Environment: 'Dev'
  ManagedBy: 'Bicep'
  Project: 'AzureBicepPlaybook'
}

var appNsgName = 'nsg-app-dev'
var dataNsgName = 'nsg-data-dev'

// Network Security Groups

resource nsgApp 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: appNsgName
  location: location
  tags: tags
  properties: {}
}

resource nsgData 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: dataNsgName
  location: location
  tags: tags
  properties: {}
}

// Application NSG rules

resource allowHttpsInbound 'Microsoft.Network/networkSecurityGroups/securityRules@2024-05-01' = {
  parent: nsgApp
  name: 'Allow-HTTPS-Inbound'
  properties: {
    description: 'Allow inbound HTTPS traffic.'
    priority: 100
    direction: 'Inbound'
    access: 'Allow'
    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRange: '443'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
  }
}

// Data NSG rules

resource allowSqlFromApp 'Microsoft.Network/networkSecurityGroups/securityRules@2024-05-01' = {
  parent: nsgData
  name: 'Allow-SQL-From-App'
  properties: {
    description: 'Allow SQL traffic from the application subnet.'
    priority: 100
    direction: 'Inbound'
    access: 'Allow'
    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRange: '1433'
    sourceAddressPrefix: appSubnetPrefix
    destinationAddressPrefix: '*'
  }
}

resource denyOtherVnetInbound 'Microsoft.Network/networkSecurityGroups/securityRules@2024-05-01' = {
  parent: nsgData
  name: 'Deny-Other-VNet-Inbound'
  properties: {
    description: 'Deny other inbound traffic originating from the virtual network.'
    priority: 200
    direction: 'Inbound'
    access: 'Deny'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '*'
    sourceAddressPrefix: 'VirtualNetwork'
    destinationAddressPrefix: '*'
  }
}

// Virtual Network

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

// Subnets

resource appSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  parent: vnet
  name: 'snet-app'
  properties: {
    addressPrefix: appSubnetPrefix
    networkSecurityGroup: {
      id: nsgApp.id
    }
  }
}

resource dataSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  parent: vnet
  name: 'snet-data'
  properties: {
    addressPrefix: dataSubnetPrefix
    networkSecurityGroup: {
      id: nsgData.id
    }
  }
}

// Outputs

output vnetId string = vnet.id
output vnetName string = vnet.name
output appSubnetId string = appSubnet.id
output dataSubnetId string = dataSubnet.id
output appNsgId string = nsgApp.id
output dataNsgId string = nsgData.id
