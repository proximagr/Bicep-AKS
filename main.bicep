// Register Microsoft.OperationsManagement

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

@description('DNS prefix specified when creating the managed cluster, like: aks_cluster_name')
@minLength(1)
@maxLength(54)
param aksdnsPrefix string
@description('Name of the resource group containing agent pool nodes')
param aksManagedRG string
param aksName string
param aksWSName string
param isAksPrivate bool
@description('Provide the ID of the Subnet. Can be found at the Azure Portal, Properties')
param vnetSubnetID string

module aks 'modules/deployAKS-kubenet.bicep' = {
  name: 'AKS-Kubenet-Deployment'
  scope: resourceGroup()
  params: {
    aksdnsPrefix: aksdnsPrefix
    aksManagedRG: aksManagedRG
    aksName: aksName
    aksWSName: aksWSName
    isAksPrivate: isAksPrivate
    location: location
    tags: tags
    vnetSubnetID: vnetSubnetID
  }
}
