targetScope = 'subscription'

param resourceGroupName string
param location string = 'UK South'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
}
