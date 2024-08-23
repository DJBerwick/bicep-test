targetScope = 'subscription'

var resourceGroupName = 'rg-darren-test'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: deployment().location
}
