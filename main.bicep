targetScope = 'subscription'

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'testbicepRG'
  location: 'westeurope'
}

module stg './storage.bicep' = {
  name: 'StorageDeployment2'
  scope: rg
  params: {
    storageAccountName: 'oyvindbicep'
  }
}
