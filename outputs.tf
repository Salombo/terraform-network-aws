output "network_cidr_blocks" {
  value       = tomap(local.addrs_by_name)
  description = "Mappage des réseaux aux noms donnés"
}

output "networks" {
  value       = tolist(local.network_objs)
  description = "Une liste des objets fournis dans la description des réseaux"
}

output "base_cidr_block" {
  value       = var.main_network
  description = "Affiche la base du réseau"
}