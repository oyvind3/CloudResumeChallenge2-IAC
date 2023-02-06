param location string = resourceGroup().location
var storageaccountname  = uniqueString(resourceGroup().id)

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
