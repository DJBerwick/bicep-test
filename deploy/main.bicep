@description('The location into which your Azure resources should be deployed.')
param location string = resourceGroup().location

@description('A unique suffix to add to resource names that need to be globally unique.')
@maxLength(13)
param resourceNameSuffix string = uniqueString(resourceGroup().id)

// @description('The name of the Log Analytics Workspace')
// param workspaceName string = 'myLogAnalyticsWorkspace'

// @description('The Log Analytics Workspace retention period')
// param retentionInDays int = 30

// Define the names for resources.
var storageAccountName = 'mystorage${resourceNameSuffix}'

module tagsModule '../modules/tags.bicep' = {
  name: 'tagsModule'
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

// module logAnalyticsModule '../modules/loganalyticsworkspace.bicep' = {
//   name: 'logAnalyticsDeployment'
//   params: {
//     workspaceName: workspaceName
//     location: location
//     retentionInDays: retentionInDays
//     tags: tagsModule.outputs.tags
//   }
// }
