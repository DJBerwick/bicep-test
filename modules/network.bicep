@description('Required: The name of the Virtual Network (vNet).')
param vnetName string

@description('Required: An Array of 1 or more IP Address Prefixes for the Virtual Network.')
param addressPrefixes array

@description('Optional: Location for all resources.')
param location string = resourceGroup().location

@description('Optional: Tags of the resource.')
param tags object = resourceGroup().tags

@description('Optional: DNS Servers associated to the Virtual Network.')
param dnsServers string[]?

@description('Optional: Indicates if encryption is enabled on virtual network and if VM without encryption is allowed in encrypted VNet. Requires the EnableVNetEncryption feature to be registered for the subscription and a supported region to use this property.')
param vnetEncryption bool = false

@allowed([
  'AllowUnencrypted'
  'DropUnencrypted'
])
@description('Optional: If the encrypted VNet allows VM that does not support encryption. Can only be used when vnetEncryption is enabled.')
param vnetEncryptionEnforcement string = 'AllowUnencrypted'

@maxValue(30)
@description('Optional: The flow timeout in minutes for the Virtual Network, which is used to enable connection tracking for intra-VM flows. Possible values are between 4 and 30 minutes. Default value 0 will set the property to null.')
param flowTimeoutInMinutes int = 0

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }
    dhcpOptions: !empty(dnsServers)
      ? {
          dnsServers: array(dnsServers)
        }
      : null
    encryption: vnetEncryption == true
      ? {
          enabled: vnetEncryption
          enforcement: vnetEncryptionEnforcement
        }
      : null
    flowTimeoutInMinutes: flowTimeoutInMinutes != 0 ? flowTimeoutInMinutes : null
  }
}
