
using './nsg.bicep'

param location = 'northeurope'
param nsgName = 'nsg-snet-app'
param vnetName = 'vnet-storage-dev'
param subnetName = 'snet-app'
param subnetAddressPrefix = '10.20.1.0/24'
param httpsPriority = 100


