targetScope = 'subscription'

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
