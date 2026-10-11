
using './main.bicep'

param location = 'northeurope'

param vnetName = 'vnet-app-dev'

param addressSpace = '10.10.0.0/16'

param appSubnetPrefix = '10.10.1.0/24'

param dataSubnetPrefix = '10.10.2.0/24'

param tags = {
  Environment: 'Dev'
  ManagedBy: 'Bicep'
  Project: 'AzureBicepPlaybook'
}
