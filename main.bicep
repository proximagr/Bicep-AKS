// Register Microsoft.OperationsManagement

targetScope = 'resourceGroup'

param deployACR bool

param acrName string
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
@description('Tier of your Azure Container Registry. Select Premium to use Private Endpoint')
param acrSKU string

@description('Enable admin user that have push / pull permission to the ARC')
param acradminUserEnabled bool

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
@description('Provide the ID of the Node Subnet. az network vnet subnet list -g asktestvnet --vnet-name aksvnet')
param vnetSubnetID string
@description('True for kubenet, False for Azure CNI')
param kubenet bool

module aks 'modules/deployAKS.bicep' = {
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
    kubenet: kubenet
  }
}

module acr 'modules/deployACR.bicep' = if (deployACR) {
  name: 'ACR-Deployment'
  params: {
    acradminUserEnabled: acradminUserEnabled
    acrName: acrName
    acrSKU: acrSKU
    location: location
    tags: tags
  }
}
