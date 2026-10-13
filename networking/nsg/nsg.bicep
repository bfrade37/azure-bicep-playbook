@description('Azure region for the NSG')
param location string = resourceGroup().location

@description('Name of the new Network Security Group')
param nsgName string = 'nsg-https'

@description('Name of the existing Virtual Network')
param vnetName string

@description('Name of the existing subnet')
param subnetName string

@description('Priority of the HTTPS inbound rule')
param httpsPriority int = 100

param subnetAddressPrefix string

resource nsg 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-HTTPS-Inbound'
        properties: {
          description: 'Allow inbound HTTPS traffic'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          direction: 'Inbound'
          priority: httpsPriority
        }
      }
    ]
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2024-05-01' existing = {
  name: vnetName
}

// Update the existing subnet to associate it with the new NSG.
resource subnetAssociation 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  parent: vnet
  name: subnetName
  properties: {
    addressPrefix: subnetAddressPrefix
    networkSecurityGroup: {
      id: nsg.id
    }
  }
}

output nsgId string = nsg.id
output subnetId string = subnetAssociation.id
