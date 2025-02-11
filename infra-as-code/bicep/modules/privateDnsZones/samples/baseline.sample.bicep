//
// Baseline deployment sample
//

// Use this sample to deploy the minimum resource configuration.

targetScope = 'resourceGroup'

// ----------
// PARAMETERS
// ----------
@description('The Azure Region to deploy the resources into. Default: resourceGroup().location')
param location string = resourceGroup().location
// ---------
// RESOURCES
// ---------

@description('Baseline resource configuration')
module baseline_private_dns '../privateDnsZones.bicep' = {
  name: 'minimum private DNS'
  params: {
    parLocation: location
    parPrivateDnsZones: [
      'privatelink.azure-automation.net'
      'privatelink.database.windows.net'
      'privatelink.sql.azuresynapse.net'
      'privatelink.dev.azuresynapse.net'
      'privatelink.azuresynapse.net'
      'privatelink.blob.core.windows.net'
      'privatelink.table.core.windows.net'
      'privatelink.queue.core.windows.net'
      'privatelink.file.core.windows.net'
      'privatelink.web.core.windows.net'
      'privatelink.dfs.core.windows.net'
      'privatelink.documents.azure.com'
      'privatelink.mongo.cosmos.azure.com'
      'privatelink.cassandra.cosmos.azure.com'
      'privatelink.gremlin.cosmos.azure.com'
      'privatelink.table.cosmos.azure.com'
      'privatelink.${toLower(location)}.batch.azure.com'
      'privatelink.postgres.database.azure.com'
      'privatelink.mysql.database.azure.com'
      'privatelink.mariadb.database.azure.com'
      'privatelink.vaultcore.azure.net'
      'privatelink.managedhsm.azure.net'
      'privatelink.${toLower(location)}.azmk8s.io'
      'privatelink.siterecovery.windowsazure.com'
      'privatelink.servicebus.windows.net'
      'privatelink.azure-devices.net'
      'privatelink.eventgrid.azure.net'
      'privatelink.azurewebsites.net'
      'privatelink.api.azureml.ms'
      'privatelink.notebooks.azure.net'
      'privatelink.service.signalr.net'
      'privatelink.monitor.azure.com'
      'privatelink.oms.opinsights.azure.com'
      'privatelink.ods.opinsights.azure.com'
      'privatelink.agentsvc.azure-automation.net'
      'privatelink.afs.azure.net'
      'privatelink.datafactory.azure.net'
      'privatelink.adf.azure.com'
      'privatelink.redis.cache.windows.net'
      'privatelink.redisenterprise.cache.azure.net'
      'privatelink.purview.azure.com'
      'privatelink.purviewstudio.azure.com'
      'privatelink.digitaltwins.azure.net'
      'privatelink.azconfig.io'
      'privatelink.cognitiveservices.azure.com'
      'privatelink.azurecr.io'
      'privatelink.search.windows.net'
      'privatelink.azurehdinsight.net'
      'privatelink.media.azure.net'
      'privatelink.his.arc.azure.com'
      'privatelink.guestconfiguration.azure.com'
    ]
  parTags: {}
  parVirtualNetworkIdToLink: ''
  parTelemetryOptOut: false
  }
}
