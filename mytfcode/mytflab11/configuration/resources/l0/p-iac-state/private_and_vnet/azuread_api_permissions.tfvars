azuread_api_permissions = {
  level0 = {
    microsoft_graph = {
      resource_app_id = "00000003-0000-0000-c000-000000000000"
      resource_access = {
        AppRoleAssignment_ReadWrite_All = {
          id   = "06b708a9-e830-4db3-a914-8e69da51d44f"
          type = "Role"
        }
        DelegatedPermissionGrant_ReadWrite_All = {
          id   = "8e8e4742-1d95-4f68-9d56-6ee75648c72a"
          type = "Role"
        }
        Application_ReadWrite_OwnedBy = {
          id   = "18a4783c-866b-4cc7-a460-3d5e5662c884"
          type = "Role"
        }
      }
    }
  }
  # identity = {
  #   microsoft_graph = {
  #     resource_app_id = "00000003-0000-0000-c000-000000000000"
  #     resource_access = {
  #       AppRoleAssignment_ReadWrite_All = {
  #         id   = "06b708a9-e830-4db3-a914-8e69da51d44f"
  #         type = "Role"
  #       }
  #       DelegatedPermissionGrant_ReadWrite_All = {
  #         id   = "8e8e4742-1d95-4f68-9d56-6ee75648c72a"
  #         type = "Role"
  #       }
  #       GroupReadWriteAll = {
  #         id   = "62a82d76-70ea-41e2-9197-370581804d09"
  #         type = "Role"
  #       }
  #       RoleManagement_ReadWrite_Directory = {
  #         id   = "9e3f62cf-ca93-4989-b6ce-bf83c28f9fe8"
  #         type = "Role"
  #       }
  #     }
  #   }
  # }
}