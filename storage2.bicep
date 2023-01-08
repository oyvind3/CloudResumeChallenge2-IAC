param storageAccounts_cloudresumeoyvind_name string = 'cloudresumeoyvind'

resource storageAccounts_cloudresumeoyvind_name_resource 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: storageAccounts_cloudresumeoyvind_name
  location: 'westeurope'
  tags: {
    'ms-resource-usage': 'azure-cloud-shell'
  }
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    dnsEndpointType: 'Standard'
    defaultToOAuthAuthentication: false
    publicNetworkAccess: 'Enabled'
    allowCrossTenantReplication: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: true
    allowSharedKeyAccess: true
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      requireInfrastructureEncryption: false
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
    customDomain: {
      name: 'www.finsrud.cloud'
    }
  }
}

resource storageAccounts_cloudresumeoyvind_name_default 'Microsoft.Storage/storageAccounts/blobServices@2022-05-01' = {
  parent: storageAccounts_cloudresumeoyvind_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    changeFeed: {
      enabled: false
    }
    restorePolicy: {
      enabled: false
    }
    containerDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: true
      days: 7
    }
    isVersioningEnabled: false
  }
}

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_cloudresumeoyvind_name_default 'Microsoft.Storage/storageAccounts/fileServices@2022-05-01' = {
  parent: storageAccounts_cloudresumeoyvind_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    protocolSettings: {
      smb: {
      }
    }
    cors: {
      corsRules: []
    }
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}

resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_cloudresumeoyvind_name_default 'Microsoft.Storage/storageAccounts/queueServices@2022-05-01' = {
  parent: storageAccounts_cloudresumeoyvind_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_cloudresumeoyvind_name_default 'Microsoft.Storage/storageAccounts/tableServices@2022-05-01' = {
  parent: storageAccounts_cloudresumeoyvind_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource storageAccounts_cloudresumeoyvind_name_default_web 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' = {
  parent: storageAccounts_cloudresumeoyvind_name_default
  name: '$web'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [

    storageAccounts_cloudresumeoyvind_name_resource
  ]
}

resource storageAccounts_cloudresumeoyvind_name_default_azure_webjobs_hosts 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' = {
  parent: storageAccounts_cloudresumeoyvind_name_default
  name: 'azure-webjobs-hosts'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [

    storageAccounts_cloudresumeoyvind_name_resource
  ]
}

resource storageAccounts_cloudresumeoyvind_name_default_azure_webjobs_secrets 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' = {
  parent: storageAccounts_cloudresumeoyvind_name_default
  name: 'azure-webjobs-secrets'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [

    storageAccounts_cloudresumeoyvind_name_resource
  ]
}

resource storageAccounts_cloudresumeoyvind_name_default_http3todownload 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' = {
  parent: storageAccounts_cloudresumeoyvind_name_default
  name: 'http3todownload'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [

    storageAccounts_cloudresumeoyvind_name_resource
  ]
}

resource storageAccounts_cloudresumeoyvind_name_default_scm_releases 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' = {
  parent: storageAccounts_cloudresumeoyvind_name_default
  name: 'scm-releases'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [

    storageAccounts_cloudresumeoyvind_name_resource
  ]
}

resource storageAccounts_cloudresumeoyvind_name_default_test 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' = {
  parent: storageAccounts_cloudresumeoyvind_name_default
  name: 'test'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [

    storageAccounts_cloudresumeoyvind_name_resource
  ]
}

resource storageAccounts_cloudresumeoyvind_name_default_cli 'Microsoft.Storage/storageAccounts/fileServices/shares@2022-05-01' = {
  parent: Microsoft_Storage_storageAccounts_fileServices_storageAccounts_cloudresumeoyvind_name_default
  name: 'cli'
  properties: {
    accessTier: 'TransactionOptimized'
    shareQuota: 6
    enabledProtocols: 'SMB'
  }
  dependsOn: [

    storageAccounts_cloudresumeoyvind_name_resource
  ]
}

resource storageAccounts_cloudresumeoyvind_name_default_storageAccounts_cloudresumeoyvind_name_9827 'Microsoft.Storage/storageAccounts/fileServices/shares@2022-05-01' = {
  parent: Microsoft_Storage_storageAccounts_fileServices_storageAccounts_cloudresumeoyvind_name_default
  name: '${storageAccounts_cloudresumeoyvind_name}9827'
  properties: {
    accessTier: 'TransactionOptimized'
    shareQuota: 5120
    enabledProtocols: 'SMB'
  }
  dependsOn: [

    storageAccounts_cloudresumeoyvind_name_resource
  ]
}

resource storageAccounts_cloudresumeoyvind_name_default_storageAccounts_cloudresumeoyvind_name_9971 'Microsoft.Storage/storageAccounts/fileServices/shares@2022-05-01' = {
  parent: Microsoft_Storage_storageAccounts_fileServices_storageAccounts_cloudresumeoyvind_name_default
  name: '${storageAccounts_cloudresumeoyvind_name}9971'
  properties: {
    accessTier: 'TransactionOptimized'
    shareQuota: 5120
    enabledProtocols: 'SMB'
  }
  dependsOn: [

    storageAccounts_cloudresumeoyvind_name_resource
  ]
}

resource storageAccounts_cloudresumeoyvind_name_default_storageAccounts_cloudresumeoyvind_name_a37d 'Microsoft.Storage/storageAccounts/fileServices/shares@2022-05-01' = {
  parent: Microsoft_Storage_storageAccounts_fileServices_storageAccounts_cloudresumeoyvind_name_default
  name: '${storageAccounts_cloudresumeoyvind_name}a37d'
  properties: {
    accessTier: 'TransactionOptimized'
    shareQuota: 5120
    enabledProtocols: 'SMB'
  }
  dependsOn: [

    storageAccounts_cloudresumeoyvind_name_resource
  ]
}

resource storageAccounts_cloudresumeoyvind_name_default_functionappclouda570 'Microsoft.Storage/storageAccounts/fileServices/shares@2022-05-01' = {
  parent: Microsoft_Storage_storageAccounts_fileServices_storageAccounts_cloudresumeoyvind_name_default
  name: 'functionappclouda570'
  properties: {
    accessTier: 'TransactionOptimized'
    shareQuota: 5120
    enabledProtocols: 'SMB'
  }
  dependsOn: [

    storageAccounts_cloudresumeoyvind_name_resource
  ]
}

resource storageAccounts_cloudresumeoyvind_name_default_inportalediting9260 'Microsoft.Storage/storageAccounts/fileServices/shares@2022-05-01' = {
  parent: Microsoft_Storage_storageAccounts_fileServices_storageAccounts_cloudresumeoyvind_name_default
  name: 'inportalediting9260'
  properties: {
    accessTier: 'TransactionOptimized'
    shareQuota: 5120
    enabledProtocols: 'SMB'
  }
  dependsOn: [

    storageAccounts_cloudresumeoyvind_name_resource
  ]
}

resource storageAccounts_cloudresumeoyvind_name_default_oyvindcloud8a4f 'Microsoft.Storage/storageAccounts/fileServices/shares@2022-05-01' = {
  parent: Microsoft_Storage_storageAccounts_fileServices_storageAccounts_cloudresumeoyvind_name_default
  name: 'oyvindcloud8a4f'
  properties: {
    accessTier: 'TransactionOptimized'
    shareQuota: 5120
    enabledProtocols: 'SMB'
  }
  dependsOn: [

    storageAccounts_cloudresumeoyvind_name_resource
  ]
}

resource storageAccounts_cloudresumeoyvind_name_default_oyvindfunctionapib9fe 'Microsoft.Storage/storageAccounts/fileServices/shares@2022-05-01' = {
  parent: Microsoft_Storage_storageAccounts_fileServices_storageAccounts_cloudresumeoyvind_name_default
  name: 'oyvindfunctionapib9fe'
  properties: {
    accessTier: 'TransactionOptimized'
    shareQuota: 5120
    enabledProtocols: 'SMB'
  }
  dependsOn: [

    storageAccounts_cloudresumeoyvind_name_resource
  ]
}

resource storageAccounts_cloudresumeoyvind_name_default_template 'Microsoft.Storage/storageAccounts/fileServices/shares@2022-05-01' = {
  parent: Microsoft_Storage_storageAccounts_fileServices_storageAccounts_cloudresumeoyvind_name_default
  name: 'template'
  properties: {
    accessTier: 'TransactionOptimized'
    shareQuota: 5
    enabledProtocols: 'SMB'
  }
  dependsOn: [

    storageAccounts_cloudresumeoyvind_name_resource
  ]
}
