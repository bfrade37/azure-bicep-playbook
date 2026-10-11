targetScope = 'resourceGroup'

@description('Azure region where the NSG will be deployed.')
param location string = 'northeurope'

@description('Name of the Network Security Group.')
param nsgName string = 'nsg-dev'

@description('Whether to allow inbound HTTPS traffic.')
param allowHttpsInbound bool = true

@description('Whether to allow inbound SSH traffic. Disabled by default.')
param allowSshInbound bool = false

@description('Source address prefix allowed to access HTTPS.')
param httpsSourceAddressPrefix string = '*'

@description('Source address prefix allowed to access SSH.')
param sshSourceAddressPrefix string = '10.10.0.0/16'

@description('Resource tags.')
param tags object = {
  Environment: 'Dev'
  ManagedBy: 'Bicep'
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: nsgName
  location: location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'Allow-HTTPS-Inbound'
        properties: {
          description: 'Allow inbound HTTPS traffic.'
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: httpsSourceAddressPrefix
          destinationAddressPrefix: '*'
        }
      }
      if (allowSshInbound) {
        name: 'Allow-SSH-Inbound'
        properties: {
          description: 'Allow inbound SSH from the configured source.'
          priority: 110
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: sshSourceAddressPrefix
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

output nsgId string = nsg.id
output nsgName string = nsg.name
```
