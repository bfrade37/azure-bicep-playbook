```bicep
using './main.bicep'

param resourceGroupName = 'rg-storage-dev'
param location = 'northeurope'

param tags = {
  Environment: 'Dev'
  ManagedBy: 'Bicep'
  Project: 'AzureBicepPlaybook'
}
```
