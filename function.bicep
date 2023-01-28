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
param CosmosDBName string = 'oyvindcosmos3'


resource name_resource 'Microsoft.Web/sites@2018-11-01' = {
  name: name
  dependsOn:[
   storageAccountName_resource
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
          name: 'oyvindfunction2501_DOCUMENTDB'
          value: listConnectionStrings(resourceId('Microsoft.DocumentDB/databaseAccounts', CosmosDBName), '2022-08-15').connectionStrings[0].connectionString
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
resource cosmos 'Microsoft.DocumentDB/databaseAccounts@2022-08-15' = {
  name: CosmosDBName
  location: location
  kind: 'GlobalDocumentDB'
  identity: {
    type:'None'
  }
  properties: {
      publicNetworkAccess: 'Enabled'
      enableAutomaticFailover: false
      enableMultipleWriteLocations: false
      isVirtualNetworkFilterEnabled: false
      virtualNetworkRules: []
      disableKeyBasedMetadataWriteAccess: false
      enableFreeTier: false
      enableAnalyticalStorage: false
      analyticalStorageConfiguration: {
        schemaType: 'WellDefined'
      }
      createMode: 'Default'
      databaseAccountOfferType: 'Standard'
      defaultIdentity: 'FirstPartyIdentity'
      networkAclBypass: 'None'
      disableLocalAuth: false
      enablePartitionMerge: false
      consistencyPolicy: {
        defaultConsistencyLevel: 'Session'
        maxIntervalInSeconds: 5
        maxStalenessPrefix: 100
      }
      cors: [
        {
          allowedOrigins: 'https://functionappcloud.azurewebsites.net, https://inportalediting.azurewebsites.net, https://oyvindfunction2701.azurewebsites.net' 
        }
      ] 
      capabilities: [
        {
          name: 'EnableServerless'
        }
      ]
      ipRules: []
      backupPolicy: {
        type: 'Continuous'
      }
    }
}

resource databaseAccounts_oyvindcloud2_name_visitordb_visit 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2022-08-15' = {
  parent: nosqldb
  name: 'visit'
  properties: {
    resource: {
      id: 'visit'
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
  dependsOn: [
    cosmos
  ]
}

resource nosqldb 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2022-08-15' = {
  parent: cosmos
  name: 'visitordb'
  properties: {
    resource: {
      id: 'visitordb'
    }
  }
}

resource function 'Microsoft.Web/sites/functions@2016-08-01' = {
  name: functionNameComputed
  parent: name_resource
  dependsOn: [
    storageAccountName_resource
  ]
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
       '__init__.py': loadTextContent('HttpTrigger/__init__.py')
       'function.json': loadTextContent('HttpTrigger/function.json')
      }
    }
}
