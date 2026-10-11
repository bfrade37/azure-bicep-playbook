using './main.bicep'

param resourceGroupName = 'rg-storage-lab'
param location = 'northeurope'

param tags = {
  Environment: 'Dev'
  ManagedBy: 'Bicep'
  Project: 'AzureBicepPlaybook'
}
