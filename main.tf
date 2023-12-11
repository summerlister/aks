
#############################################################################
# PRIVATE DNS CONFIG
#############################################################################

resource "azurerm_role_assignment" "DNSContribroleassign" {
  count                = var.private_cluster_enabled == true ? 1 : 0
  scope                = azurerm_private_dns_zone.privatezone[0].id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = var.user_identity_principalid
}

resource "azurerm_role_assignment" "Reader" {
  count                = var.private_cluster_enabled == true ? 1 : 0
  scope                = azurerm_private_dns_zone.privatezone[0].id
  role_definition_name = "Reader"
  principal_id         = var.user_identity_principalid
}


resource "azurerm_role_assignment" "NetworkContribroleassign" {
  count                = var.private_cluster_enabled == true ? 1 : 0
  scope                = azurerm_private_dns_zone.privatezone[0].id
  role_definition_name = "Network Contributor"
  principal_id         = var.user_identity_principalid
}

resource "azurerm_role_assignment" "NetworkContribVnetroleassign" {
  scope                = var.vnet_id
  role_definition_name = "Network Contributor"
  principal_id         = var.user_identity_principalid
}

resource "azurerm_private_dns_zone" "privatezone" {
  count               = var.private_cluster_enabled == true ? 1 : 0
  name                = "${var.cluster_name}.privatelink.eastus2.azmk8s.io"
  resource_group_name = var.resource_group_name
}


#############################################################################
# NODE RESOURCE GROUP IAM
#############################################################################

data "azurerm_resource_group" "noderg" {
  name = azurerm_kubernetes_cluster.cluster.node_resource_group
}

resource "azurerm_role_assignment" "contributor_noderg" {
  for_each             = toset(var.noderg_role_assignment_principal_ids)
  scope                = data.azurerm_resource_group.noderg.id
  role_definition_name = "Contributor"
  principal_id         = each.value
}


#############################################################################
# CLUSTER CONFIG
#############################################################################

resource "azurerm_kubernetes_cluster" "cluster" {
  name                              = var.cluster_name
  location                          = var.location
  resource_group_name               = var.resource_group_name
  sku_tier                          = var.sku_tier
  kubernetes_version                = var.kubernetes_version
  dns_prefix                        = var.public_dns_prefix
  dns_prefix_private_cluster        = var.private_dns_prefix
  private_dns_zone_id               = var.private_cluster_enabled == true ? azurerm_private_dns_zone.privatezone[0].id : null
  node_resource_group               = var.node_resource_group
  private_cluster_enabled           = var.private_cluster_enabled
  azure_policy_enabled              = var.azure_policy_enabled
  role_based_access_control_enabled = var.enable_rbac

  dynamic "api_server_access_profile" {
    for_each = var.private_cluster_enabled ? [1] : []
    content {
      authorized_ip_ranges = var.authorized_ip_ranges
      # subnet_id = var.default_node_pool.vnet_subnet_id
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [var.user_identity_id]
  }

  default_node_pool {
    name                  = lower(var.default_node_pool.name)
    vm_size               = var.default_node_pool.vm_size
    zones                 = (var.default_node_pool.type == "VirtualMachineScaleSets" && var.lb_sku == "standard") ? var.lb_standard_config.availability_zones : null
    enable_auto_scaling   = (var.default_node_pool.autoscaling_config != null && var.default_node_pool.type == "VirtualMachineScaleSets") ? true : false
    enable_node_public_ip = var.default_node_pool.enable_node_public_ip
    max_pods              = (var.network_plugin == "kubenet" && var.default_node_pool.max_pods > 110) ? 110 : var.default_node_pool.max_pods
    node_labels           = var.default_node_pool.node_labels
    orchestrator_version  = var.default_node_pool.orchestrator_version
    os_sku                = var.default_node_pool.os_sku
    os_disk_size_gb       = var.default_node_pool.os_disk_size_gb
    type                  = var.default_node_pool.type
    tags                  = var.default_node_pool.tags
    # vnet_subnet_id        = var.network_plugin == "azure" ? var.default_node_pool.vnet_subnet_id : null
    vnet_subnet_id = var.default_node_pool.vnet_subnet_id
    node_count     = var.default_node_pool.node_count
    max_count      = var.default_node_pool.autoscaling_config != null ? var.default_node_pool.autoscaling_config.max_count : null
    min_count      = var.default_node_pool.autoscaling_config != null ? var.default_node_pool.autoscaling_config.min_count : null
  }

  lifecycle {
    ignore_changes = [default_node_pool.0.node_count]
  }

  dynamic "azure_active_directory_role_based_access_control" {
    for_each = var.enable_rbac ? [1] : []
    content {
      managed                = var.enabled_managed_rbac_integration
      azure_rbac_enabled     = var.enabled_managed_rbac_integration == true ? var.azure_rbac_enabled : null
      admin_group_object_ids = var.enabled_managed_rbac_integration == true ? var.admin_group_object_ids : null
      client_app_id          = var.enabled_managed_rbac_integration ? null : var.client_app_id
      server_app_id          = var.enabled_managed_rbac_integration ? null : var.server_app_id
      server_app_secret      = var.enabled_managed_rbac_integration ? null : var.server_app_secret
    }
  }

  local_account_disabled = var.enabled_managed_rbac_integration == true && var.azure_rbac_enabled == true ? var.local_account_disabled : false



  #   dynamic "linux_profile" {
  #     for_each = var.ssh_key_data != null ? [1] : []
  #     content {
  #       admin_username = var.admin_username
  #       ssh_key {
  #         key_data = file(var.ssh_key_data)
  #       }
  #     }
  #   }

  #   dynamic "windows_profile" {
  #     for_each = var.admin_password != null ? [1] : []
  #     content {
  #       admin_username = var.admin_username
  #       admin_password = var.admin_password
  #     }
  #   }

  dynamic "oms_agent" {
    for_each = var.enable_oms ? [1] : []
    content {
      log_analytics_workspace_id = var.log_analytics_workspace_id
    }
  }

  dynamic "key_vault_secrets_provider" {
    for_each = var.enable_csi ? [1] : []
    content {
      secret_rotation_enabled = true
    }
  }

  network_profile {
    network_plugin      = var.network_plugin
    network_plugin_mode = var.network_plugin == "azure" ? var.network_plugin_mode : null
    network_policy      = var.network_plugin == "azure" ? "azure" : var.network_policy
    dns_service_ip      = local.dns_service_ip
    service_cidr        = var.service_cidr
    pod_cidr            = var.network_plugin == "kubenet" ? var.pod_cidr : null
    outbound_type       = var.outbound_type
    network_mode        = var.network_plugin == "azure" ? "transparent" : null
    load_balancer_sku   = var.lb_sku

    dynamic "load_balancer_profile" {
      for_each = var.lb_sku == "standard" && var.outbound_type == "loadBalancer" ? [1] : []
      content {
        outbound_ports_allocated  = var.lb_standard_config.outbound_ports_allocated
        idle_timeout_in_minutes   = var.lb_standard_config.idle_timeout_in_minutes
        managed_outbound_ip_count = var.lb_standard_config.managed_outbound_ip_count
        outbound_ip_prefix_ids    = var.lb_standard_config.outbound_ip_prefix_ids
        outbound_ip_address_ids   = var.lb_standard_config.outbound_ip_address_ids
      }
    }
  }

  tags = var.tags

  depends_on = [azurerm_role_assignment.DNSContribroleassign, azurerm_role_assignment.NetworkContribroleassign, azurerm_role_assignment.NetworkContribVnetroleassign]
}


#############################################################################
# CLUSTER NODE POOL CONFIG
#############################################################################

resource "azurerm_kubernetes_cluster_node_pool" "user" {
  for_each              = var.default_node_pool.type == "VirtualMachineScaleSets" ? var.user_node_pool : {}
  kubernetes_cluster_id = azurerm_kubernetes_cluster.cluster.id
  name                  = lower(each.key)
  vm_size               = each.value.vm_size
  zones                 = each.value.availability_zones
  enable_auto_scaling   = each.value.autoscaling_config != null ? true : false
  enable_node_public_ip = each.value.enable_node_public_ip
  max_pods              = (var.network_plugin == "kubenet" && each.value.max_pods > 110) ? 110 : each.value.max_pods
  node_labels           = each.value.node_labels
  orchestrator_version  = each.value.orchestrator_version
  os_type               = var.network_plugin == "azure" ? each.value.os_type : "Linux"
  os_sku                = each.value.os_sku
  os_disk_size_gb       = each.value.os_disk_size_gb
  tags                  = each.value.tags
  vnet_subnet_id        = var.network_plugin == "azure" ? var.default_node_pool.vnet_subnet_id : null
  node_count            = each.value.node_count
  max_count             = each.value.autoscaling_config != null ? each.value.autoscaling_config.max_count : null
  min_count             = each.value.autoscaling_config != null ? each.value.autoscaling_config.min_count : null

  lifecycle {
    ignore_changes = [node_count]
  }
}


#############################################################################
# DIAGNOSTIC SETTINGS
#############################################################################

data "azurerm_monitor_diagnostic_categories" "aks" {
  resource_id = azurerm_kubernetes_cluster.cluster.id
}

resource "azurerm_monitor_diagnostic_setting" "aks" {
  name                       = "${var.cluster_name}-diagnostics"
  target_resource_id         = azurerm_kubernetes_cluster.cluster.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    iterator = log_category
    for_each = data.azurerm_monitor_diagnostic_categories.aks.log_category_types

    content {
      category = log_category.value

      retention_policy {
        enabled = false
        days    = 0
      }
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }
}