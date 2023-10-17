// Apply the built-in 'Container registries should have anonymous authentication disabled' policy. Azure RBAC only is allowed.
var pdAnonymousContainerRegistryAccessDisallowedId = tenantResourceId('Microsoft.Authorization/policyDefinitions', '9f2dea28-e834-476c-99c5-3507b4728395')
resource paAnonymousContainerRegistryAccessDisallowed 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: guid(resourceGroup().id, pdAnonymousContainerRegistryAccessDisallowedId)
  location: 'global'
  scope: resourceGroup()
  properties: {
    displayName: take('[acraks${subRgUniqueString}] ${reference(pdAnonymousContainerRegistryAccessDisallowedId, '2021-06-01').displayName}', 120)
    description: reference(pdAnonymousContainerRegistryAccessDisallowedId, '2021-06-01').description
    enforcementMode: 'Default'
    policyDefinitionId: pdAnonymousContainerRegistryAccessDisallowedId
    parameters: {
      effect: {
        value: 'Deny'
      }
    }
  }
}

// Apply the built-in 'Container registries should have local admin account disabled' policy. Azure RBAC only is allowed.
var pdAdminAccountContainerRegistryAccessDisallowedId = tenantResourceId('Microsoft.Authorization/policyDefinitions', 'dc921057-6b28-4fbe-9b83-f7bec05db6c2')
resource paAdminAccountContainerRegistryAccessDisallowed 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: guid(resourceGroup().id, pdAdminAccountContainerRegistryAccessDisallowedId)
  location: 'global'
  scope: resourceGroup()
  properties: {
    displayName: take('[acraks${subRgUniqueString}] ${reference(pdAdminAccountContainerRegistryAccessDisallowedId, '2021-06-01').displayName}', 120)
    description: reference(pdAdminAccountContainerRegistryAccessDisallowedId, '2021-06-01').description
    enforcementMode: 'Default'
    policyDefinitionId: pdAdminAccountContainerRegistryAccessDisallowedId
    parameters: {
      effect: {
        value: 'Deny'
      }
    }
  }
}
