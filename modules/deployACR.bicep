param location string
param acrName string
param tags object

@allowed([
  'Basic'
  'Standard'
  'Premium'
])
@description('Tier of your Azure Container Registry. Select Premium to use Private Endpoint')
param acrSKU string

@description('Enable admin user that have push / pull permission to the ARC')
param acradminUserEnabled bool

resource acr 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' = {
  name: acrName
  location: location
  tags: tags
  sku: {
    name: acrSKU
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    adminUserEnabled: acradminUserEnabled
  }
}

output acrLoginServer string = acr.properties.loginServer
output acrID string = acr.id
