targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional: The location into which your Azure resources should be deployed.')
param location string = 'uksouth'

@description('Required: The prefix/shortened name of the customer workload.')
param customerPrefix string = 'cdo'

@description('Required: The environment into which your Azure resources should be deployed.')
@allowed([
  'prd'
  'uat'
  'dev'
  'tst'
])
param environment string = 'prd'

@description('The Resource Group Name into which your Azure resources should be deployed.')
@maxLength(90)
param resourceGroupName string = 'rg-core-network-${customerPrefix}-${environment}'

@description('Timestamp to be generated dynamically (as a placeholder)')
param timestamp string = utcNow('dd-MMM-yyyy HH:mm:ss')

// ========= //
// Variables //
// ========= //

@description('The list of tags to be deployed with all Azure resources.')
var tags = {
  LastUpdated: timestamp
  ManagedByBicep: 'True'
  Owner: 'azureplatformengineering@gov.scot'
  CostCentre: '55645'
  ServiceCategory: 'A'
  SNApplicationService: 'Foundation Services'
  SNResolver: 'Azure Platform'
  SNBusinessApplication: 'Azure Platform'
  DataClassification: 'Internal'
}

// ============ //
// Dependencies //
// ============ //

@description('The Resource Group into which your Azure resources should be deployed.')
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}

// ========== //
// Networking //
// ========== //

module network '../modules/network.bicep' = {
  scope: resourceGroup
  name: '${deployment().name}-vnet-${customerPrefix}-${environment}'
  params: {
    vnetName: 'vnet-${customerPrefix}-${environment}'
    location: location
    addressPrefixes: ['10.0.0.0/16']
    tags: tags

    subnets: [
      {
        name: 'snet1-vnet-${customerPrefix}-${environment}'
        address_prefixes: ['10.0.1.0/24']
        // service_endpoints: ['Microsoft.Storage', 'Microsoft.KeyVault']
      }
      {
        name: 'snet2-vnet-${customerPrefix}-${environment}'
        address_prefixes: ['10.0.2.0/24']
        // service_endpoints: ['Microsoft.Storage']
      }
    ]
  }
}
