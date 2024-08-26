@description('Name of the Log Analytics Workspace')
param workspaceName string

@description('Location of the Log Analytics Workspace')
param location string = resourceGroup().location

@description('Retention period for the logs (in days)')
param retentionInDays int = 30

@description('Tags to apply to the Log Analytics Workspace')
param tags object = {}  

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: workspaceName
  location: location
  properties: {
    retentionInDays: retentionInDays
  }
  tags: tags
}

@description('The resource ID of the Log Analytics Workspace')
output workspaceId string = logAnalyticsWorkspace.id

@description('The customer ID (Workspace ID) of the Log Analytics Workspace')
output workspaceCustomerId string = logAnalyticsWorkspace.properties.customerId
