using './main.bicep'

param location = 'northeurope'
param nsgName = 'nsg-dev'

param allowHttpsInbound = true
param allowSshInbound = false

param httpsSourceAddressPrefix = '*'
param sshSourceAddressPrefix = '10.10.0.0/16'

param tags = {
  Environment: 'Dev'
  ManagedBy: 'Bicep'
}
```
