targetScope = 'subscription'

@description('The location into which your Azure resources should be deployed.')
param location string = 'uksouth'
param resourceGroupName string = 'rg-darren-dep1'

// @description('A unique suffix to add to resource names that need to be globally unique.')
// @maxLength(13)
// param resourceNameSuffix string = uniqueString(resourceGroup().id)

// @description('The name of the Log Analytics Workspace')
param workspaceName string = 'myLogAnalyticsWorkspace'

// @description('The Log Analytics Workspace retention period')
param retentionInDays int = 30

// Define the names for resources.
// var storageAccountName = 'mystorage${resourceNameSuffix}'
// var storageAccountName = 'mystorage666'

@description('Resource Group for Test Deployment.')
resource darrenResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module tagsModule '../modules/tags.bicep' = {
  scope: resourceGroup(darrenResourceGroup.name)
  name: 'tagsModule'
}

// resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
//   scope: resourceGroup(darrenResourceGroup.name)
//   name: storageAccountName
//   location: location
//   kind: 'StorageV2'
//   sku: {
//     name: 'Standard_LRS'
//   }
// }

module logAnalyticsModule '../modules/loganalyticsworkspace.bicep' = {
  scope: resourceGroup(darrenResourceGroup.name)
  name: 'logAnalyticsDeployment'
  params: {
    workspaceName: workspaceName
    location: location
    retentionInDays: retentionInDays
    tags: tagsModule.outputs.tags
  }
}
