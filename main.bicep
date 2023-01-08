targetScope = 'subscription'
param utc string = utcNow()
var resourcegroupname  = 'RGOF${uniqueString(utc)}'

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourcegroupname
  location: 'westeurope'
}

module stg './storage.bicep' = {
  name: 'storagemodule12'
  scope: rg
}
