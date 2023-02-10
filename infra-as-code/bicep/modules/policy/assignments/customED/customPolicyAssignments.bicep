@description('Prefix for the management group hierarchy. DEFAULT VALUE = alz')
@minLength(2)
@maxLength(10)
param parTopLevelManagementGroupPrefix string = 'alz'

@description('Set Parameter to true to Opt-out of deployment telemetry')
param parTelemetryOptOut bool = false

// Customer Usage Attribution Id
var varCuaid = '98cef979-5a6b-403b-83c7-10c8f04ac9a2'

// **Variables**
// Orchestration Module Variables
var varDeploymentNameWrappers = {
  basePrefix: 'ALZBicep'
  #disable-next-line no-loc-expr-outside-params //Policies resources are not deployed to a region, like other resources, but the metadata is stored in a region hence requiring this to keep input parameters reduced. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  baseSuffixTenantAndManagementGroup: '${deployment().location}-${uniqueString(deployment().location, parTopLevelManagementGroupPrefix)}'
}

var varModuleDeploymentNames = {
  modPolicyAssignmentLzsRequireTagsOnResourceGroups: take('${varDeploymentNameWrappers.basePrefix}-polAssi-requireTags-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDenyKeyvaultSku: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyKvSku-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
}

// Policy Assignments Modules Variables

var varPolicyAssignmentRequireTagsOnResourceGroups = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Require-Tags-On-Resource-Groups'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/custom/policy_assignment_es_require_tags_on_resourcegroups.tmpl.json')
}

var varPolicyAssignmentDenyKeyvaultSku = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/key-vault-sku-setting-deny'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/custom/policy_assignment_es_deny_keyvault_sku_settings.tmpl.json')
}

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


// Modules - Policy Assignments - Landing Zones Management Group
// Module - Policy Assignment - Require-Tags-On-Resource-Groups
module modPolicyAssignmentLzsRequireTagsOnResourceGroups '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsRequireTagsOnResourceGroups
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentRequireTagsOnResourceGroups.definitionId
    parPolicyAssignmentName: varPolicyAssignmentRequireTagsOnResourceGroups.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentRequireTagsOnResourceGroups.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentRequireTagsOnResourceGroups.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentRequireTagsOnResourceGroups.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentRequireTagsOnResourceGroups.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentRequireTagsOnResourceGroups.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Modules - Policy Assignments - Online Landing Zones Management Group
// Module - Policy Assignment - key-vault-sku-setting-deny
/* module modPolicyAssignmentLzsDenyKeyvaultSku '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIds.landingZonesOnline)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDenyKeyvaultSku
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyKeyvaultSku.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyKeyvaultSku.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyKeyvaultSku.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyKeyvaultSku.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyKeyvaultSku.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyKeyvaultSku.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenyKeyvaultSku.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}
 */
