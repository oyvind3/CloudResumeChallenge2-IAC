param name string = 'oyvindfunction3001'
param location string = resourceGroup().location
param use32BitWorkerProcess bool = false
param subscriptionId string = '0440339a-9a51-4a90-b6d6-c715483744ce'
param ftpsState string = 'FtpsOnly'
param linuxFxVersion string = 'Python|3.9'
param hostingPlanName string = 'oyvindhostingplan3001'
param serverFarmResourceGroup string = 'rgiacoyvind3'
param workerSize int = 0
param numberOfWorkers int = 1
param sku string = 'dynamic'
param workerSizeId int = 1
param skuCode string = 'Y1'
var functionNameComputed = 'HttpTrigger'
param storageSkuName string = 'Standard_LRS'
param storageAccountName string = 'saof${toLower(uniqueString(resourceGroup().id))}'
param accountName string = 'oyvindcosmos3'
param containerName string = 'visit'
param databaseName string = 'visitordb'


resource name_resource 'Microsoft.Web/sites@2018-11-01' = {
  name: name
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
          name: 'oyvindfunction2501_DOCUMENTDB'
          value: listConnectionStrings(resourceId('Microsoft.DocumentDB/databaseAccounts', databaseName), '2022-08-15').connectionStrings[0].connectionString
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
          'https://portal.azure.com', 'https://resume.finsrud.cloud'
        ]
      }
      use32BitWorkerProcess: use32BitWorkerProcess
      ftpsState: ftpsState
      linuxFxVersion: linuxFxVersion
    }
    serverFarmId: hostingPlanName_resource.id
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
}

resource storageAccountName_resource 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  kind:'StorageV2'
  sku: {
    name: storageSkuName
  }
}

resource cosmos 'Microsoft.DocumentDB/databaseAccounts@2022-11-15' = {
  name: accountName
  tags:{
    location: location
    enviroment: 'prod'
  }
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    locations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    consistencyPolicy:{
      defaultConsistencyLevel: 'Session'
    }
    capabilities:[
      {
        name: 'EnableServerless'
      }
    ]
    databaseAccountOfferType: 'Standard'
    cors: [
      {
        allowedOrigins: 'https://oyvindfunction3001.azurewebsites.net'
      }
    ]
    backupPolicy: {
      type:'Continuous'
    }
  }
}

//Creates cosmosdb database under account accountName
resource nosqldb 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2022-08-15' = {
  parent: cosmos
  name: databaseName
  properties: {
    resource: {
      id: databaseName

    }
  }
}

//creates the actual containter within the cosmos db database
resource databaseAccounts_oyvindcloud2_name_visitordb_visit 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2022-08-15' = {
  name: containerName
  parent: nosqldb
  properties: {
    resource: {
      id: containerName
      indexingPolicy: {
        indexingMode: 'consistent'
        automatic: true
        includedPaths: [
          {
            path: '/*'
          }
        ]
        excludedPaths: [
          {
            path: '/"_etag"/?'
          }
        ]
      }
      partitionKey: {
        paths: [
          '/testpartitionkey'
        ]
        kind: 'Hash'
      }
      uniqueKeyPolicy: {
        uniqueKeys: []
      }
      conflictResolutionPolicy: {
        mode: 'LastWriterWins'
        conflictResolutionPath: '/_ts'
      }
    }
  }
}

resource function 'Microsoft.Web/sites/functions@2016-08-01' = {
  name: functionNameComputed
  parent: name_resource
  properties: {
    config: {
      disabled: false
      bindings: [
        {
          name: 'req'
          type: 'httpTrigger'
          direction: 'in'
          authLevel: 'anonymous'
          methods: [
            'get'
            'set'
          ]
          route: 'visit/testpartitionkey/{name}'
        }
        {
         type: 'cosmosDB'
         direction: 'out'
         name: 'outputDocument'
         databaseName: 'visitordb'
         collectionName: 'visit'
         createIfNotExists: false
         connectionStringSetting: 'oyvindfunction2501_DOCUMENTDB'
        }
        {
          type: 'cosmosDB'
          direction: 'in'
          name: 'inputDocument'
          databaseName: 'visitordb'
          collectionName: 'visit'
          connectionStringSetting: 'oyvindfunction2501_DOCUMENTDB'
         }
        {
          name: '$return'
          type: 'http'
          direction: 'out'
        }
      ]
    }
    files: {
       '__init__.py': loadTextContent('../HttpTrigger/__init__.py')
       'function.json': loadTextContent('../HttpTrigger/function.json')
      }
    }
}
