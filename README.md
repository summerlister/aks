# aks
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_kubernetes_cluster.cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |
| [azurerm_kubernetes_cluster_node_pool.user](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) | resource |
| [azurerm_monitor_diagnostic_setting.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_private_dns_zone.privatezone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_role_assignment.DNSContribroleassign](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.NetworkContribVnetroleassign](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.NetworkContribroleassign](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.Reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.contributor_noderg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_monitor_diagnostic_categories.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) | data source |
| [azurerm_resource_group.noderg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_group_object_ids"></a> [admin\_group\_object\_ids](#input\_admin\_group\_object\_ids) | A list of Object IDs of Azure Active Directory Groups which should have Admin Role on the Cluster. | `list` | `[]` | no |
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | The admin password for Windows agent node VMs. Length must be between 14 and 123 characters. | `any` | `null` | no |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | The Linux or Windows admin username for cluster nodes. Changing this forces a new resource to be created. | `string` | `"azureadmin"` | no |
| <a name="input_authorized_ip_ranges"></a> [authorized\_ip\_ranges](#input\_authorized\_ip\_ranges) | List of IP range(s) to whitelist for incoming traffic to a public cluster API (master service). Supports single IPs and CIDR block notation. Is not supported for private clusters. | `list` | `[]` | no |
| <a name="input_azure_policy_enabled"></a> [azure\_policy\_enabled](#input\_azure\_policy\_enabled) | Should the Azure Policy Add-On be enabled? | `bool` | `true` | no |
| <a name="input_azure_rbac_enabled"></a> [azure\_rbac\_enabled](#input\_azure\_rbac\_enabled) | Is Role Based Access Control based on Azure AD enabled? | `bool` | `true` | no |
| <a name="input_client_app_id"></a> [client\_app\_id](#input\_client\_app\_id) | The Client ID of an Azure Active Directory Application. Changing this forces a new resource to be created. | `any` | `null` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the AKS cluster to create. Changing this forces a new resource to be created. | `string` | `"cluster01"` | no |
| <a name="input_default_node_pool"></a> [default\_node\_pool](#input\_default\_node\_pool) | Default node pool configuration | `map` | <pre>{<br>  "autoscaling": null,<br>  "enable_host_encryption": false,<br>  "enable_node_public_ip": false,<br>  "max_pods": 110,<br>  "name": "nodepool1",<br>  "node_count": 3,<br>  "node_labels": {},<br>  "orchestrator_version": null,<br>  "os_disk_size_gb": 86,<br>  "os_disk_type": "Ephemeral",<br>  "os_sku": "Ubuntu",<br>  "tags": {},<br>  "type": "VirtualMachineScaleSets",<br>  "vm_size": "Standard_Ds2_v2",<br>  "vnet_subnet_id": null<br>}</pre> | no |
| <a name="input_dns_service_ip"></a> [dns\_service\_ip](#input\_dns\_service\_ip) | IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns/core-dns). This is required when network\_plugin is set to azure. Changing this forces a new resource to be created. **Default value is calculated to the 10th usable IP in the service\_cidr IP block** | `any` | `null` | no |
| <a name="input_enable_csi"></a> [enable\_csi](#input\_enable\_csi) | Enables Key Vault Secrets add-on. If enabled it will also create client ID and secret as well as User Identity that can then be given permission to the KeyVault you create | `bool` | `true` | no |
| <a name="input_enable_oms"></a> [enable\_oms](#input\_enable\_oms) | Enables OMS/Log Analytics add-on. Requires log\_analytics\_workspace\_id if true. Enabling this sets up Container Insight | `bool` | `true` | no |
| <a name="input_enable_rbac"></a> [enable\_rbac](#input\_enable\_rbac) | Enables RBAC AKS cluster. Note: The following are required input vars when enabled: client\_app\_id, server\_app\_id, server\_app\_secret. Changing this forces a new resource to be created. | `string` | `"true"` | no |
| <a name="input_enabled_managed_rbac_integration"></a> [enabled\_managed\_rbac\_integration](#input\_enabled\_managed\_rbac\_integration) | Enable support for Azure to create/manage the Service Principal(s) used for RBAC integration. If enabled, client\_app\_id, server\_app\_id, and server\_app\_secret are not required. | `bool` | `true` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Version of Kubernetes to use when creating the managed cluster. If not specified, the latest recommended version will be used at provisioning time (but won't auto-upgrade). | `any` | `null` | no |
| <a name="input_lb_sku"></a> [lb\_sku](#input\_lb\_sku) | Specifies the SKU of the Load Balancer used for this Kubernetes Cluster. Supported values are basic or standard. | `string` | `"standard"` | no |
| <a name="input_lb_standard_config"></a> [lb\_standard\_config](#input\_lb\_standard\_config) | load balancer config | `map` | <pre>{<br>  "idle_timeout_in_minutes": 30,<br>  "managed_outbound_ip_count": 1,<br>  "outbound_ip_address_ids": null,<br>  "outbound_ip_prefix_ids": null,<br>  "outbound_ports_allocated": 0<br>}</pre> | no |
| <a name="input_local_account_disabled"></a> [local\_account\_disabled](#input\_local\_account\_disabled) | Is the local 'admin' account disabled on the Kubernetes Cluster? If local\_account\_disabled is set to true, it is required to enable Kubernetes RBAC and AKS-managed Azure AD integration. | `bool` | `true` | no |
| <a name="input_location"></a> [location](#input\_location) | The region where the AKS cluster will be created. Changing this forces a new resource to be created. Ensure all enabled AKS features are supported in the region selected. | `string` | `"eastus"` | no |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | Log Analytics Workspace Resource ID. | `any` | `null` | no |
| <a name="input_network_plugin"></a> [network\_plugin](#input\_network\_plugin) | Kubernetes network plugin configured on the cluster. Currently supported values are azure or kubenet. Changing this forces a new resource to be created. | `string` | `"azure"` | no |
| <a name="input_network_plugin_mode"></a> [network\_plugin\_mode](#input\_network\_plugin\_mode) | Specifies the network plugin mode used for building the Kubernetes network. Possible value is Overlay. Changing this forces a new resource to be created. | `any` | `null` | no |
| <a name="input_network_policy"></a> [network\_policy](#input\_network\_policy) | Kubernetes network policy configured on the cluster. Network policy allows for the control the traffic flow between pods. Currently supported values are azure or calico. Changing this forces a new resource to be created. When network\_policy is set to azure, the network\_plugin field can only be set to azure. | `string` | `"azure"` | no |
| <a name="input_node_resource_group"></a> [node\_resource\_group](#input\_node\_resource\_group) | The name of the Resource Group where the Kubernetes nodes should exist. Resource Group is created with the cluster and can not already exist. Changing this forces a new resource to be created. | `any` | `null` | no |
| <a name="input_noderg_role_assignment"></a> [noderg\_role\_assignment](#input\_noderg\_role\_assignment) | list of principal ids to add as Contributor to node RG | `list` | `[]` | no |
| <a name="input_outbound_type"></a> [outbound\_type](#input\_outbound\_type) | The outbound (egress) routing method which should be used for this Kubernetes Cluster. Possible values are loadBalancer and userDefinedRouting. | `string` | `"userDefinedRouting"` | no |
| <a name="input_pod_cidr"></a> [pod\_cidr](#input\_pod\_cidr) | The network range assigned to cluster pods in CIDR notation. This field should only be set when network\_plugin is set to kubenet and the module will default to 172.16.0.0/16 if left unset. Changing this forces a new resource to be created. | `string` | `"172.16.0.0/16"` | no |
| <a name="input_private_cluster_enabled"></a> [private\_cluster\_enabled](#input\_private\_cluster\_enabled) | Should this Kubernetes Cluster have its API server only exposed on internal IP addresses? This provides a Private IP Address for the Kubernetes API on the Virtual Network where the Kubernetes Cluster is located. Defaults to true. Changing this forces a new resource to be created. | `bool` | `true` | no |
| <a name="input_private_dns_prefix"></a> [private\_dns\_prefix](#input\_private\_dns\_prefix) | DNS prefix to use when creating the managed cluster. Changing this forces a new resource to be created. Must contain between 3 and 45 characters, and can contain only letters, numbers, and hyphens. It must start with a letter and must end with a letter or a number. If left unset dns\_prefix will default to the var.cluster\_name. | `any` | `null` | no |
| <a name="input_private_dns_zone_id"></a> [private\_dns\_zone\_id](#input\_private\_dns\_zone\_id) | Either the ID of Private DNS Zone which should be delegated to this Cluster, System to have AKS manage this or None. In case of None you will need to bring your own DNS server and set up resolving, otherwise cluster will have issues after provisioning. Changing this forces a new resource to be created. | `any` | `null` | no |
| <a name="input_public_dns_prefix"></a> [public\_dns\_prefix](#input\_public\_dns\_prefix) | DNS prefix to use when creating the managed cluster. Changing this forces a new resource to be created. Must contain between 3 and 45 characters, and can contain only letters, numbers, and hyphens. It must start with a letter and must end with a letter or a number. If left unset dns\_prefix will default to the var.cluster\_name. | `any` | `null` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Whether public network access is allowed for this Kubernetes Cluster. Defaults to false. Changing this forces a new resource to be created. | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the Resource Group the AKS cluster resource will be created in. | `any` | n/a | yes |
| <a name="input_server_app_id"></a> [server\_app\_id](#input\_server\_app\_id) | The Server ID of an Azure Active Directory Application. Changing this forces a new resource to be created. | `any` | `null` | no |
| <a name="input_server_app_secret"></a> [server\_app\_secret](#input\_server\_app\_secret) | The Server Secret of an Azure Active Directory Application. Changing this forces a new resource to be created. | `any` | `null` | no |
| <a name="input_service_cidr"></a> [service\_cidr](#input\_service\_cidr) | The network IP range assigned to Kubernetes services. CIDR range must be smaller than a /12 subnet. This is required when network\_plugin is set to azure. Changing this forces a new resource to be created. | `string` | `"172.18.0.0/16"` | no |
| <a name="input_sku_tier"></a> [sku\_tier](#input\_sku\_tier) | The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Paid (which includes the Uptime SLA). Defaults to Free. If set to Free, API server Availability is 99.5%. If set to Free, API server Availability is 99.95%. | `string` | `"Free"` | no |
| <a name="input_ssh_key_data"></a> [ssh\_key\_data](#input\_ssh\_key\_data) | The local path to the SSH public key for authentication with admin\_username user. | `any` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map` | `{}` | no |
| <a name="input_user_identity_id"></a> [user\_identity\_id](#input\_user\_identity\_id) | User Identity assigned to AKS Cluster | `any` | `null` | no |
| <a name="input_user_identity_principalid"></a> [user\_identity\_principalid](#input\_user\_identity\_principalid) | User Identity assigned to AKS Cluster used to create Private DNS Zone | `any` | `null` | no |
| <a name="input_user_node_pool"></a> [user\_node\_pool](#input\_user\_node\_pool) | User node pool configuration | `map` | `{}` | no |
| <a name="input_vnet_id"></a> [vnet\_id](#input\_vnet\_id) | Vnet ID used for the Network Contributor Role Assignment | `any` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->