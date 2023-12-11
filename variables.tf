variable "cluster_name" {
  description = "The name of the AKS cluster to create. Changing this forces a new resource to be created."
  default     = "cluster01"
}

variable "location" {
  description = "The region where the AKS cluster will be created. Changing this forces a new resource to be created. Ensure all enabled AKS features are supported in the region selected."
  default     = "eastus"
}

variable "resource_group_name" {
  description = "The name of the Resource Group the AKS cluster resource will be created in."
}

variable "sku_tier" {
  description = "The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Paid (which includes the Uptime SLA). Defaults to Free. If set to Free, API server Availability is 99.5%. If set to Free, API server Availability is 99.95%."
  default     = "Free"
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace Resource ID."
  default     = null
}

variable "kubernetes_version" {
  description = "Version of Kubernetes to use when creating the managed cluster. If not specified, the latest recommended version will be used at provisioning time (but won't auto-upgrade)."
  default     = null
}

variable "node_resource_group" {
  description = "The name of the Resource Group where the Kubernetes nodes should exist. Resource Group is created with the cluster and can not already exist. Changing this forces a new resource to be created."
  default     = null
}

variable "user_identity_id" {
  description = "User Identity assigned to AKS Cluster "
  default     = null
}

variable "user_identity_principalid" {
  description = "User Identity assigned to AKS Cluster used to create Private DNS Zone "
  default     = null
}

variable "private_cluster_enabled" {
  description = "Should this Kubernetes Cluster have its API server only exposed on internal IP addresses? This provides a Private IP Address for the Kubernetes API on the Virtual Network where the Kubernetes Cluster is located. Defaults to true. Changing this forces a new resource to be created."
  default     = true
}

variable "public_network_access_enabled" {
  description = "Whether public network access is allowed for this Kubernetes Cluster. Defaults to false. Changing this forces a new resource to be created."
  default     = false
}

variable "private_dns_prefix" {
  description = "DNS prefix to use when creating the managed cluster. Changing this forces a new resource to be created. Must contain between 3 and 45 characters, and can contain only letters, numbers, and hyphens. It must start with a letter and must end with a letter or a number. If left unset dns_prefix will default to the var.cluster_name."
  default     = null
}

variable "private_dns_zone_id" {
  description = "Either the ID of Private DNS Zone which should be delegated to this Cluster, System to have AKS manage this or None. In case of None you will need to bring your own DNS server and set up resolving, otherwise cluster will have issues after provisioning. Changing this forces a new resource to be created."
  default     = null
}

variable "public_dns_prefix" {
  description = "DNS prefix to use when creating the managed cluster. Changing this forces a new resource to be created. Must contain between 3 and 45 characters, and can contain only letters, numbers, and hyphens. It must start with a letter and must end with a letter or a number. If left unset dns_prefix will default to the var.cluster_name."
  default     = null
}

variable "vnet_id" {
  description = "Vnet ID used for the Network Contributor Role Assignment"
  default     = null
}

variable "network_plugin" {
  description = "Kubernetes network plugin configured on the cluster. Currently supported values are azure or kubenet. Changing this forces a new resource to be created."
  default     = "azure"
}

variable "network_plugin_mode" {
  description = "Specifies the network plugin mode used for building the Kubernetes network. Possible value is Overlay. Changing this forces a new resource to be created."
  default     = null
}

variable "azure_policy_enabled" {
  description = "Should the Azure Policy Add-On be enabled?"
  default     = true
}

variable "network_policy" {
  description = "Kubernetes network policy configured on the cluster. Network policy allows for the control the traffic flow between pods. Currently supported values are azure or calico. Changing this forces a new resource to be created. When network_policy is set to azure, the network_plugin field can only be set to azure."
  default     = "azure"
}

variable "authorized_ip_ranges" {
  description = "List of IP range(s) to whitelist for incoming traffic to a public cluster API (master service). Supports single IPs and CIDR block notation. Is not supported for private clusters."
  default     = []
}

variable "admin_username" {
  description = "The Linux or Windows admin username for cluster nodes. Changing this forces a new resource to be created."
  default     = "azureadmin"
}

variable "ssh_key_data" {
  description = "The local path to the SSH public key for authentication with admin_username user."
  default     = null
}

variable "admin_password" {
  description = "The admin password for Windows agent node VMs. Length must be between 14 and 123 characters."
  default     = null
}

variable "pod_cidr" {
  description = "The network range assigned to cluster pods in CIDR notation. This field should only be set when network_plugin is set to kubenet and the module will default to 172.16.0.0/16 if left unset. Changing this forces a new resource to be created."
  default     = "172.16.0.0/16"
}

# variable "docker_bridge_cidr" {
#   description = "IP address (in CIDR notation) used as the Docker bridge IP address on nodes. This is required when network_plugin is set to azure. Changing this forces a new resource to be created."
#   default     = "172.17.0.1/16"
# }

variable "service_cidr" {
  description = "The network IP range assigned to Kubernetes services. CIDR range must be smaller than a /12 subnet. This is required when network_plugin is set to azure. Changing this forces a new resource to be created."
  default     = "172.18.0.0/16"
}

variable "dns_service_ip" {
  description = "IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns/core-dns). This is required when network_plugin is set to azure. Changing this forces a new resource to be created. **Default value is calculated to the 10th usable IP in the service_cidr IP block**"
  default     = null
}

locals {
  dns_service_ip = var.dns_service_ip == null ? cidrhost(var.service_cidr, 10) : var.dns_service_ip
}

variable "outbound_type" {
  description = "The outbound (egress) routing method which should be used for this Kubernetes Cluster. Possible values are loadBalancer and userDefinedRouting."
  default     = "userDefinedRouting"
}

variable "enable_oms" {
  description = "Enables OMS/Log Analytics add-on. Requires log_analytics_workspace_id if true. Enabling this sets up Container Insight"
  default     = true
}

variable "enable_csi" {
  description = "Enables Key Vault Secrets add-on. If enabled it will also create client ID and secret as well as User Identity that can then be given permission to the KeyVault you create"
  default     = true
}

variable "noderg_role_assignment" {
  description = "list of principal ids to add as Contributor to node RG"
  default     = []
}

variable "default_node_pool" {
  description = "Default node pool configuration"
  default = {
    name                   = "nodepool1"
    vm_size                = "Standard_Ds2_v2"
    os_sku                 = "Ubuntu"
    enable_host_encryption = false
    enable_node_public_ip  = false
    max_pods               = 110
    orchestrator_version   = null
    os_disk_size_gb        = 86
    os_disk_type           = "Ephemeral"
    type                   = "VirtualMachineScaleSets"
    vnet_subnet_id         = null
    node_count             = 3
    node_labels            = {}
    tags                   = {}
    autoscaling            = null
  }
}

variable "user_node_pool" {
  description = "User node pool configuration"
  default     = {}
}

variable "lb_sku" {
  description = "Specifies the SKU of the Load Balancer used for this Kubernetes Cluster. Supported values are basic or standard."
  default     = "standard"
}

# lb_standard_config must specify exactly one of ManagedOutboundIPs, OutboundIPPrefixes or OutboundIPs. The other 2 should be defined with null values.
variable "lb_standard_config" {
  description = "load balancer config"
  default = {
    outbound_ports_allocated  = 0
    idle_timeout_in_minutes   = 30
    managed_outbound_ip_count = 1
    outbound_ip_prefix_ids    = null
    outbound_ip_address_ids   = null
  }
}

variable "enable_rbac" {
  description = " Enables RBAC AKS cluster. Note: The following are required input vars when enabled: client_app_id, server_app_id, server_app_secret. Changing this forces a new resource to be created."
  default     = "true"
}

variable "enabled_managed_rbac_integration" {
  description = "Enable support for Azure to create/manage the Service Principal(s) used for RBAC integration. If enabled, client_app_id, server_app_id, and server_app_secret are not required."
  default     = true
}

variable "azure_rbac_enabled" {
  description = "Is Role Based Access Control based on Azure AD enabled?"
  default     = true
}

variable "local_account_disabled" {
  description = "Is the local 'admin' account disabled on the Kubernetes Cluster? If local_account_disabled is set to true, it is required to enable Kubernetes RBAC and AKS-managed Azure AD integration."
  default     = true
}
variable "admin_group_object_ids" {
  description = "A list of Object IDs of Azure Active Directory Groups which should have Admin Role on the Cluster."
  default     = []
}

variable "client_app_id" {
  description = "The Client ID of an Azure Active Directory Application. Changing this forces a new resource to be created."
  default     = null
}

variable "server_app_id" {
  description = "The Server ID of an Azure Active Directory Application. Changing this forces a new resource to be created."
  default     = null
}

variable "server_app_secret" {
  description = "The Server Secret of an Azure Active Directory Application. Changing this forces a new resource to be created."
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  default     = {}
}