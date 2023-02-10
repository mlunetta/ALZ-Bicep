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
  modPolicyAssignmentLzsDenyStTls: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyStTls-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
}

// Policy Assignments Modules Variables

/* var varPolicyAssignmentRequireTagsOnResourceGroups = {
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/custom/policy_assignment_es_require_tags_on_resourcegroups.tmpl.json')
}

var varPolicyAssignmentDenyKeyvaultSku = {
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/custom/policy_assignment_es_Deny-key-vault-sku-setting.tmpl.json')
}

var varPolicyAssignmentDenyStorageAccountTls = {
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/custom/policy_assignment_es_Deny-Storage-Account-TLS-setting.tmpl.json')
} */

var varCustomPolicyAssignemntsArray = [
  {
    scope: varManagementGroupIds.landingZones
    name: 'Require-Tag-And-Value-From-Set'
    libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/custom/policy_assignment_es_require_tags_on_resourcegroups.tmpl.json')
  }
  {
    scope: varManagementGroupIds.landingZones
    name: 'Deny-Keyvault-Sku-Setting'
    libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/custom/policy_assignment_es_Deny-key-vault-sku-setting.tmpl.json')
  }
  {
    scope: varManagementGroupIds.landingZonesOnline
    name: 'Deny-StorAcc-Tls-Setting'
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


/* // Modules - Policy Assignments - Landing Zones Management Group
// Module - Policy Assignment - Require-Tags-On-Resource-Groups
module modPolicyAssignmentLzsRequireTagsOnResourceGroups '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsRequireTagsOnResourceGroups
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentRequireTagsOnResourceGroups.libDefinition.properties.policyDefinitionId
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
// Module - Policy Assignment - Key vault sku deny
module modPolicyAssignmentLzsDenyKeyvaultSku '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDenyKeyvaultSku
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyKeyvaultSku.libDefinition.properties.policyDefinitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyKeyvaultSku.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyKeyvaultSku.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyKeyvaultSku.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyKeyvaultSku.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyKeyvaultSku.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenyKeyvaultSku.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Modules - Policy Assignments - Online Landing Zones Management Group
// Module - Policy Assignment - Storage account deny TLS
module modPolicyAssignmentLzsDenyStaccTls '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIds.landingZonesOnline)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDenyStTls
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyStorageAccountTls.libDefinition.properties.policyDefinitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyStorageAccountTls.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyStorageAccountTls.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyStorageAccountTls.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyStorageAccountTls.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyStorageAccountTls.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenyStorageAccountTls.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
} */

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
