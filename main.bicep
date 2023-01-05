targetScope = 'subscription'

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'testbicepRG'
  location: 'West Europe'
}

module stg './storage.bicep' = {
  name: 'StorageDeployment'
  scope: rg
  params: {
    storageAccountName: 'oyvindbicep'
  }
}
