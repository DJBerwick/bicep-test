@description('Required: The name of the Virtual Network (vNet).')
param vnetName string

@description('Optional: Location for all resources.')
param location string = resourceGroup().location

@description('Required: An Array of 1 or more IP Address Prefixes for the Virtual Network.')
param addressPrefixes array

@description('Optional: Tags of the resource.')
param tags object = resourceGroup().tags

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }
  }
  tags: tags
}
