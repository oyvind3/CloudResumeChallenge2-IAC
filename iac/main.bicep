targetScope = 'subscription'
//param utc string = utcNow()

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  name: 'rgoyvind1201'
}

//resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
//  name: resourcegroupname
//  location: resourcegrouplocation
//}

//module stg './storage.bicep' = {
//  name: 'storagemodule12'
//  scope: rg
//}

module stg2 './storage2.bicep' = {
  name: 'Correctstorage12'
  scope: rg
}

module cdn 'cdn.bicep' = {
  name: 'moduleforbicepcdn'
  params: {
    
   }
   dependsOn: [
    stg2
   ]
  scope: rg
}
