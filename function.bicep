param name string = 'oyvindfunction180123'
param location string = resourceGroup().location
param storageAccountName string = 'offunctionstorage'
param use32BitWorkerProcess bool = false
param subscriptionId string = '0440339a-9a51-4a90-b6d6-c715483744ce'
param ftpsState string = 'FtpsOnly'
param linuxFxVersion string = 'Python|3.9'
param hostingPlanName string = 'oyvindhostingplan180123'
param serverFarmResourceGroup string = 'rgiacoyvind'
param workerSize int = 0
param numberOfWorkers int = 1
param sku string = 'dynamic'
param workerSizeId int = 1
param skuCode string = 'Y1'
var functionNameComputed = 'HttpTrigger'
param storageSkuName string = 'Standard_LRS'

resource name_resource 'Microsoft.Web/sites@2018-11-01' = {
  name: name
  dependsOn:[
    hostingPlanName_resource
  ]
  kind: 'functionapp,linux'
  location: location
  tags: {
    tst: 'bicep'
  }
  properties: {
    name: name
    siteConfig: {
      appSettings: [
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'python'
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${listKeys(storageAccountName_resource.id, '2019-06-01').keys[0].value};EndpointSuffix=core.windows.net'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${listKeys(storageAccountName_resource.id, '2019-06-01').keys[0].value};EndpointSuffix=core.windows.net'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: '${toLower(name)}a534'
        }
      ]
      cors: {
        allowedOrigins: [
          'https://portal.azure.com'
        ]
      }
      use32BitWorkerProcess: use32BitWorkerProcess
      ftpsState: ftpsState
      linuxFxVersion: linuxFxVersion
    }
    serverFarmId: '/subscriptions/${subscriptionId}/resourcegroups/${serverFarmResourceGroup}/providers/Microsoft.Web/serverfarms/${hostingPlanName}'
    clientAffinityEnabled: false
    virtualNetworkSubnetId: null
    httpsOnly: true
    publicNetworkAccess: 'Enabled'
  }
}

resource hostingPlanName_resource 'Microsoft.Web/serverfarms@2018-11-01' = {
  name: hostingPlanName
  location: location
  kind: 'linux'
  tags: {
    tst: 'bicep'
  }
  properties: {
    name: hostingPlanName
    workerSize: workerSize
    workerSizeId: workerSizeId
    numberOfWorkers: numberOfWorkers
    reserved: true
  }
  sku: {
    tier: sku
    name: skuCode
  }
  dependsOn: []
}

resource storageAccountName_resource 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  kind:'StorageV2'
  sku: {
    name: storageSkuName
  }
  

}
resource function 'Microsoft.Web/sites/functions@2020-12-01' = {
  name: functionNameComputed
  parent: name_resource
  properties: {
    config: {
      disabled: false
    } 
      files: {
       '__init__.py': loadTextContent('HttpTrigger/__init__.py')
      // 'function.json': loadTextContent('HttpTrigger/function.json')
      }
    }
}
