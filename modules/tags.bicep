@description('Timestamp to be generated dynamically (as a placeholder)')
param timestamp string = utcNow()

var dynamicTags = {
  LastUpdated: timestamp
}

@description('The list of tags to be deployed with all Azure resources.')
var staticTags = {
  ManagedByBicep:         'True'
  Owner:                  '05_azureplatformengineering@gov.scot'
  CostCentre:             '55645'
  ServiceCategory:        'A'
  SNApplicationService:   'Foundation Services'
  SNResolver:             'Azure Platform'
  SNBusinessApplication:  'Azure Platform'
  DataClassification:     'Internal'
}

@description('Merged tags (static + dynamic)')
output tags object = union(staticTags, dynamicTags)
