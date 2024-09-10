targetScope = 'subscription'

@description('The location into which your Azure resources should be deployed.')
param location string = 'uksouth'

@description('The location into which your Azure resources should be deployed.')
param resourceGroupName string = 'rg-core-network-dep1'

@description('Timestamp to be generated dynamically (as a placeholder)')
param timestamp string = utcNow()

@description('The list of tags to be deployed with all Azure resources.')
var tags = {
  LastUpdated: timestamp
  ManagedByBicep: 'True'
  Owner: '05_azureplatformengineering@gov.scot'
  CostCentre: '55645'
  ServiceCategory: 'A'
  SNApplicationService: 'Foundation Services'
  SNResolver: 'Azure Platform'
  SNBusinessApplication: 'Azure Platform'
  DataClassification: 'Internal'
}

@description('The Resource Group into which your Azure resources should be deployed.')
resource networkResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}
