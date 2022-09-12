targetScope = 'resourceGroup'

@allowed([
  'swedencentral'
  'northeurope'
  'uksouth'
  'westeurope'
  'francecentral'
  'germanywestcentral'
  'norwayeast'
  'switzerlandnorth'
  'francesouth'
  'germanynorth'
  'norwaywest'
  'switzerlandwest'
  'ukwest'
])
param location string = 'westeurope'

var tags = {
  Region: location
  Deployment:deployment().name
}

param aksdnsPrefix: 
param aksManagedRG: 
param aksName: 
param aksWSName: 
param isAksPrivate: 

module aks 'modules/deployAKS-kubenet.bicep' = {
  name: 'AKS-Kubenet-Deployment'
  params: {
    aksdnsPrefix: 
    aksManagedRG: 
    aksName: 
    aksWSName: 
    isAksPrivate: 
    location: location
    tags: tags
    vnetSubnetID: 
  }
}
