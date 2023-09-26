################################################
#  Associate Subscription to Management Group
################################################

resource "azurerm_management_group_subscription_association" "subscription_association" {
  management_group_id = data.azurerm_management_group.managementgroup.id
  subscription_id     = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
}
