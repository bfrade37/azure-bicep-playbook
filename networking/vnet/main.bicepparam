using './main.bicep'

param location = 'northeurope'
param vnetName = 'vnet-dev'
param addressSpace = '10.10.0.0/16'

param tags = {
  Environment: 'Dev'
  ManagedBy: 'Bicep'
}
