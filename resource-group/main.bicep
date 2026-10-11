targetScope = 'subscription'

@description('Name of the Resource Group.')
param resourceGroupName string = 'rg-storage-dev'

@description('Azure region where the Resource Group metadata will be stored.')
param location string = 'northeurope'

@description('Resource tags.')
param tags object = {
  Environment: 'Dev'
  ManagedBy: 'Bicep'
}

resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}

output resourceGroupId string = resourceGroup.id
output resourceGroupName string = resourceGroup.name
output resourceGroupLocation string = resourceGroup.location
