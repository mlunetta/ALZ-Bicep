@description('Prefix for the management group hierarchy. DEFAULT VALUE = alz')
@minLength(2)
@maxLength(10)
param parTopLevelManagementGroupPrefix string = 'alz'

@description('Set Parameter to true to Opt-out of deployment telemetry')
param parTelemetryOptOut bool = false

// Customer Usage Attribution Id
var varCuaid = '98cef979-5a6b-403b-83c7-10c8f04ac9a2'

// **Variables**

// Policy Assignments Modules Variables

var varCustomPolicyAssignemntsArray = [
  {
    scope: varManagementGroupIds.landingZones
    name: 'Require-Tag-And-Value-From-Set'
    libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/custom/policy_assignment_es_require_tags_on_resourcegroups.tmpl.json')
  }
  {
    scope: varManagementGroupIds.landingZones
    name: 'Deny-Kv-Sku-Setting'
    libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/custom/policy_assignment_es_Deny-key-vault-sku-setting.tmpl.json')
  }
  {
    scope: varManagementGroupIds.landingZonesOnline
    name: 'Deny-StorageAccount-Tls-Setting'
    libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/custom/policy_assignment_es_Deny-Storage-Account-TLS-setting.tmpl.json')
  }
]

// Managment Groups Varaibles - Used For Policy Assignments
var varManagementGroupIds = {
  intRoot: parTopLevelManagementGroupPrefix
  platform: '${parTopLevelManagementGroupPrefix}-platform'
  platformManagement: '${parTopLevelManagementGroupPrefix}-platform-management'
  platformConnectivity: '${parTopLevelManagementGroupPrefix}-platform-connectivity'
  platformIdentity: '${parTopLevelManagementGroupPrefix}-platform-identity'
  landingZones: '${parTopLevelManagementGroupPrefix}-landingzones'
  landingZonesCorp: '${parTopLevelManagementGroupPrefix}-landingzones-corp'
  landingZonesOnline: '${parTopLevelManagementGroupPrefix}-landingzones-online'
  decommissioned: '${parTopLevelManagementGroupPrefix}-decommissioned'
  sandbox: '${parTopLevelManagementGroupPrefix}-sandbox'
}

var varTopLevelManagementGroupResourceId = '/providers/Microsoft.Management/managementGroups/${varManagementGroupIds.intRoot}'

// **Scope**
targetScope = 'managementGroup'

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../../../../CRML/customerUsageAttribution/cuaIdManagementGroup.bicep' = if (!parTelemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${varCuaid}-${uniqueString(deployment().location)}'
  params: {}
}

module modPolicyAssignment '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = [for policyAssigment in varCustomPolicyAssignemntsArray: {
  scope: managementGroup(policyAssigment.scope)
  name: policyAssigment.name
  params: {
    parPolicyAssignmentDefinitionId: '${varTopLevelManagementGroupResourceId}${policyAssigment.libDefinition.properties.policyDefinitionId}'
    parPolicyAssignmentName: policyAssigment.libDefinition.name
    parPolicyAssignmentDisplayName: policyAssigment.libDefinition.properties.displayName
    parPolicyAssignmentDescription: policyAssigment.libDefinition.properties.description
    parPolicyAssignmentParameters: policyAssigment.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: policyAssigment.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: policyAssigment.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}]
