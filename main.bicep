targetScope = 'subscription'
@secure()
//param utc string = utcNow()
param resourcegroupname string = 'rgoyvind1201'
param resourcegrouplocation string


resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourcegroupname
  location: resourcegrouplocation
}

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
