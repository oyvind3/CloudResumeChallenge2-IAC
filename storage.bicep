param location string = resourceGroup().location
param utc string = utcNow()
var storageaccountname  = 'saof${uniqueString(utc)}'

resource stg 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageaccountname
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}
