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

@description('Required: An Array of configuration for 1 or more Subnets for the Virtual Network.')
param subnets array

@description('Optional: The service endpoints to enable on the subnet.')
param serviceEndpoints string[] = []

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2024-01-01' = [for subnet in subnets: {
  name: subnet.name
  parent: virtualNetwork
  properties: {
    addressPrefixes: subnet.address_prefixes
    // serviceEndpoints: [
    //   for endpoint in serviceEndpoints: {
    //     service: endpoint
    //   }
    // ]
    serviceEndpoints: subnet.service_endpoints
  }
}]




// service_endpoints                             = toset(each.value.service_endpoints)
// service_endpoint_policy_ids                   = toset(each.value.service_endpoint_policy_ids)
// private_endpoint_network_policies_enabled     = each.value.private_endpoint_network_policies_enabled
// private_link_service_network_policies_enabled = each.value.private_link_service_network_policies_enabled

// dynamic "delegation" {
//   for_each = each.value.delegation != null ? each.value.delegation : []
//   content {
//     name = delegation.value.type
//     service_delegation {
//       name    = delegation.value.type
//       actions = lookup(var.subnet_delegations_actions, delegation.value.type, delegation.value.action)
//     }
//   }
// }
