param utc string = utcNow()
var profiles_cdncloudresume_name  = 'cdnof${uniqueString(utc)}'
var profilesname = 'ofprofile${uniqueString(utc)}'
var endpointName = 'endpoint-${uniqueString(resourceGroup().id)}'
param storageAccountHostName string


module stg2 'storage2.bicep' = {
  name: 
}



resource cdn 'Microsoft.Cdn/profiles@2022-05-01-preview' = {
  name: profiles_cdncloudresume_name
  location: 'Global'
  sku: {
    name: 'Standard_Microsoft'
  }
  kind: 'cdn'
  properties: {
    extendedProperties: {
    }
  }
}

resource profiles_cdncloudresume_name_finsrudcloud 'Microsoft.Cdn/profiles/endpoints@2022-05-01-preview' = {
  parent: cdn
  name: endpointName
  location: 'Global'
  properties: {
    originHostHeader: storageAccountHostName
    contentTypesToCompress: [
      'application/eot'
      'application/font'
      'application/font-sfnt'
      'application/javascript'
      'application/json'
      'application/opentype'
      'application/otf'
      'application/pkcs7-mime'
      'application/truetype'
      'application/ttf'
      'application/vnd.ms-fontobject'
      'application/xhtml+xml'
      'application/xml'
      'application/xml+rss'
      'application/x-font-opentype'
      'application/x-font-truetype'
      'application/x-font-ttf'
      'application/x-httpd-cgi'
      'application/x-javascript'
      'application/x-mpegurl'
      'application/x-opentype'
      'application/x-otf'
      'application/x-perl'
      'application/x-ttf'
      'font/eot'
      'font/ttf'
      'font/otf'
      'font/opentype'
      'image/svg+xml'
      'text/css'
      'text/csv'
      'text/html'
      'text/javascript'
      'text/js'
      'text/plain'
      'text/richtext'
      'text/tab-separated-values'
      'text/xml'
      'text/x-script'
      'text/x-component'
      'text/x-java-source'
    ]
    isCompressionEnabled: true
    isHttpAllowed: true
    isHttpsAllowed: true
    queryStringCachingBehavior: 'IgnoreQueryString'
    origins: [
      {
        name: profilesname
        properties: {
          hostName: storageAccountHostName
          httpPort: 80
          httpsPort: 443
          originHostHeader: storageAccountHostName
          priority: 1
          weight: 1000
          enabled: true
        }
      }
    ]
    originGroups: []
    geoFilters: []
    deliveryPolicy: {
      rules: [
        {
          name: 'EnforceHTTPS'
          order: 1
          conditions: [
            {
              name: 'RequestScheme'
              parameters: {
                typeName: 'DeliveryRuleRequestSchemeConditionParameters'
                matchValues: [
                  'HTTP'
                ]
                operator: 'Equal'
                negateCondition: false
                transforms: []
              }
            }
          ]
          actions: [
            {
              name: 'UrlRedirect'
              parameters: {
                typeName: 'DeliveryRuleUrlRedirectActionParameters'
                redirectType: 'Found'
                destinationProtocol: 'Https'
              }
            }
            {
              name: 'CacheExpiration'
              parameters: {
                typeName: 'DeliveryRuleCacheExpirationActionParameters'
                cacheBehavior: 'BypassCache'
                cacheType: 'All'
              }
            }
          ]
        }
      ]
    }
  }
}

resource endpoint1 'Microsoft.Cdn/profiles/endpoints/customdomains@2022-05-01-preview' = {
  parent: profiles_cdncloudresume_name_finsrudcloud
  name: 'resume-finsrud-cloud'
  properties: {
    hostName: 'resume.finsrud.cloud'
  }
  dependsOn: [

    cdn
  ]
}

resource endpoint2 'Microsoft.Cdn/profiles/endpoints/origins@2022-05-01-preview' = {
  parent: profiles_cdncloudresume_name_finsrudcloud
  name: profilesname
  properties: {
    hostName: storageAccountHostName
    httpPort: 80
    httpsPort: 443
    originHostHeader: storageAccountHostName
    priority: 1
    weight: 1000
    enabled: true
  }
  dependsOn: [

    cdn
  ]
}
output hostName string = endpoint1.properties.hostName
output originHostHeader string = endpoint1.properties.originHostHeader
output hostName2 string = endpoint2.properties.hostName
output originHostHeader2 string = endpoint2.properties.originHostHeader
