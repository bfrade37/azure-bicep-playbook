using './main.bicep'

param location = 'northeurope'
param vnetName = 'vnet-storage-dev'
param addressSpace = '10.20.0.0/16'

param tags = {
  Environment: 'Dev'
  ManagedBy: 'Bicep'
}
