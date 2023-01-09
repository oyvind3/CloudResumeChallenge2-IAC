targetScope = 'subscription'
@secure()
param utc string = utcNow()
var resourcegroupname  = 'rgof${uniqueString(utc)}'

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourcegroupname
  location: 'westeurope'
}

module stg './storage.bicep' = {
  name: 'storagemodule12'
  scope: rg
}

module storageAccounts_cloudresumeoyvind_name_resource './storage2.bicep' = {
  name: 'storagemodulev2'
  scope: rg
}
