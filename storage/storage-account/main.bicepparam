using './main.bicep'

param location = 'northeurope'
param storageAccountName = 'stbicepdev12345'

param skuName = 'Standard_LRS'
param kind = 'StorageV2'

param allowPublicAccess = false
param allowSharedKeyAccess = false

param enableBlobVersioning = true
param enableBlobSoftDelete = true
param blobSoftDeleteRetentionDays = 7

param tags = {
  Environment: 'Dev'
  ManagedBy: 'Bicep'
  Project: 'AzureBicepPlaybook'
}
