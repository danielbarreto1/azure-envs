data "azurerm_policy_definition" "policy_definition" {
  display_name = "Allowed locations"
}

resource "azurerm_resource_group_policy_assignment" "resource_group_policy_assignment" {
  for_each = local.user_resource_groups_map

  name                 = format("%s_allowed_locations", each.value.resource_group_name)
  resource_group_id    = module.module_azurerm_resource_group[each.value.resource_group_name].resource_group.id
  policy_definition_id = data.azurerm_policy_definition.policy_definition.id

  parameters = <<PARAMETERS
  {
      "listOfAllowedLocations": {
        "value": [
          "westus3"
        ]
      }
    }
  PARAMETERS
}