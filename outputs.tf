//cluster ID

output "cluster_id" {
  value = azurerm_kubernetes_cluster.cluster.id
}

output "kube_admin_config" {
  value = azurerm_kubernetes_cluster.cluster.kube_admin_config
}