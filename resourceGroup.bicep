targetScope = 'subscription'

param resourceGroupName string
param resourceGroupLocation string = deployment().location

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: resourceGroupLocation
}
