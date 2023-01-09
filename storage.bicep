param location string = resourceGroup().location
param utc string = utcNow()
var storageaccountname  = 'cloudOF${uniqueString(utc)}'

resource stg 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageaccountname
  tags: {
    'enviroment ' : 'testtags2'
  }
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
 }
