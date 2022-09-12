param location string
param aksName string
param tags object
param isAksPrivate bool

@description('Provide the ID of the Subnet. Can be found at the Azure Portal, Properties')
param vnetSubnetID string

@description('Whether to enable Kubernetes Role-Based Access Control')
param enableRBAC bool = true

@description('DNS prefix specified when creating the managed cluster, like: aks_cluster_name')
@minLength(1)
@maxLength(54)
param aksdnsPrefix string

@description('Name of the resource group containing agent pool nodes')
param aksManagedRG string

//Sytem node settings

@minValue(0)
@maxValue(1023)
@description('OS Disk Size in GB to be used to specify the disk size for every machine in this master/agent pool. If you specify 0, it will apply the default osDisk size according to the vmSize specified.')
param systemOsDiskSizeGB int = 80

@minValue(0)
@maxValue(1000)
@description('Number of agents (VMs) to host docker containers. Allowed values must be in the range of 0 to 1000 (inclusive) for user pools and in the range of 1 to 1000 (inclusive) for system pools. The default value is 1.')
param systemAgentCount int = 2

@description('SKU of the system agent VMs')
param systemAgentVMSize string = 'Standard_DS2_v2'

@minValue(30)
@maxValue(250)
@description('Maximum number of pods that can run on a system node')
param systemMaxPods int = 30

//User node settings

@minValue(0)
@maxValue(1023)
@description('OS Disk Size in GB to be used to specify the disk size for every machine in this master/agent pool. If you specify 0, it will apply the default osDisk size according to the vmSize specified.')
param userOsDiskSizeGB int = 120

@minValue(0)
@maxValue(1000)
@description('Number of agents (VMs) to host docker containers. Allowed values must be in the range of 0 to 1000 (inclusive) for user pools and in the range of 1 to 1000 (inclusive) for system pools. The default value is 1.')
param userAgentCount int = 3

@minValue(30)
@maxValue(250)
@description('Maximum number of pods that can run on a node')
param userMaxPods int = 90

@description('SKU of the user agent VMs')
param userAgentVMSize string = 'Standard_DS2_v2'



resource aks 'Microsoft.ContainerService/managedClusters@2022-07-02-preview' = {
  name: aksName
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    enableRBAC: enableRBAC
    dnsPrefix: aksdnsPrefix
    nodeResourceGroup: aksManagedRG
    agentPoolProfiles: [
      {
        name: 'systempool'
        osDiskSizeGB: systemOsDiskSizeGB
        osDiskType: 'Ephemeral'
        count: systemAgentCount
        vmSize: systemAgentVMSize
        osType: 'Linux'
        maxPods: systemMaxPods
        type: 'VirtualMachineScaleSets'
        mode: 'System'
        nodeTaints: [
          'CriticalAddonsOnly=true:NoSchedule'
        ]
        enableAutoScaling: true
        minCount: systemAgentCount
        maxCount: systemAgentCount + 2
        vnetSubnetID: vnetSubnetID
        availabilityZones: [
          '1'
          '2'
          '3'
        ]
      }
      {
        name: 'userpool'
        osDiskSizeGB: userOsDiskSizeGB
        osDiskType: 'Ephemeral'
        count: userAgentCount
        vmSize: userAgentVMSize
        osType: 'Linux'
        maxPods: userMaxPods
        type: 'VirtualMachineScaleSets'
        mode: 'User'
        enableAutoScaling: true
        minCount: userAgentCount
        maxCount: 5 * userAgentCount + 2
        vnetSubnetID: vnetSubnetID
        availabilityZones: [
          '1'
          '2'
          '3'
        ]
      }
    ]
    apiServerAccessProfile: {
      enablePrivateCluster: isAksPrivate
    }
    servicePrincipalProfile: {
      clientId: 'msi'
    }
    networkProfile: {
      networkPlugin: 
    }
  }
}
