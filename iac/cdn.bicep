param utc string = utcNow()
//var profiles_cdncloudresume_name  = 'cdnof${uniqueString(utc)}'
var profiles_cdncloudresume_name = 'cdnofzpcph7h4irqa4'
var profilesname = 'ofprofile${uniqueString(utc)}'
var endpointName = 'finsrudcloud2'
var customdomainna = 'domain${uniqueString(resourceGroup().id)}'

module stg2 'storage2.bicep' = {
  name: 'attach-endpoint-to-cdn'
}



resource cdn 'Microsoft.Cdn/profiles@2021-06-01' = {
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

resource profiles_cdncloudresume_name_finsrudcloud 'Microsoft.Cdn/profiles/endpoints@2021-06-01' = {
  parent: cdn
  name: endpointName
  location: 'Global'
  properties: {
    originHostHeader: stg2.outputs.blobEndpoint
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
          
          hostName: stg2.outputs.blobEndpoint
          httpPort: 80
          httpsPort: 443
          originHostHeader: stg2.outputs.blobEndpoint
          priority: 1
          weight: 1000
          enabled: true
        }
      }
    ]
    originGroups: []
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

resource endpoint2 'Microsoft.Cdn/profiles/endpoints/origins@2021-06-01' = {
  parent: profiles_cdncloudresume_name_finsrudcloud
  name: profilesname
  properties: {
    hostName: stg2.outputs.blobEndpoint
    httpPort: 80
    httpsPort: 443
    originHostHeader: stg2.outputs.blobEndpoint
    priority: 1
    weight: 1000
    enabled: true
  }
  dependsOn: [
    profiles_cdncloudresume_name_finsrudcloud
  ]
}

resource customdomain 'Microsoft.Cdn/profiles/endpoints/customDomains@2022-11-01-preview' ={
  parent: profiles_cdncloudresume_name_finsrudcloud
  name: customdomainna
  properties:{
    hostName: 'resume2.finsrud.cloud'
  }
  dependsOn:[
    profiles_cdncloudresume_name_finsrudcloud
  ]
}

output hostName2 string = endpoint2.properties.hostName
output originHostHeader2 string = endpoint2.properties.originHostHeader
