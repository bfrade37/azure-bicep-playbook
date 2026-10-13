
using './multiple-subnets.bicep'

param vnetName = 'vnet-storage-dev'

param subnets = [
  {
    name: 'snet-app'
    addressPrefix: '10.20.1.0/24'
  }
  {
    name: 'snet-private-endpoints'
    addressPrefix: '10.20.2.0/24'
  }
]
