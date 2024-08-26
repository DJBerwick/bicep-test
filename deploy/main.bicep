@description('The location into which your Azure resources should be deployed.')
param location string = resourceGroup().location

@description('The list of tags to be deployed with all Azure resources.')
param tags object = {
  AzptManagedByTerraform: 'True'
  Owner:                  '05_azureplatformengineering@gov.scot'
  CostCentre:             '55645'
  ServiceCategory:        'A'
  SNApplicationService:   'Foundation Services'
  SNResolver:             'Azure Platform'
  SNBusinessApplication:  'Azure Platform'
  DataClassification:     'Internal'
}

@description('A unique suffix to add to resource names that need to be globally unique.')
@maxLength(13)
param resourceNameSuffix string = uniqueString(resourceGroup().id)

// Define the names for resources.
var logAnalyticsWorkspaceName = 'workspace-${resourceNameSuffix}'
var storageAccountName = 'mystorage${resourceNameSuffix}'

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  tags: tags
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  tags: tags
}
