output "external-ip-bastion" {
  value = yandex_compute_instance.vm-bastion.network_interface.0.nat_ip_address
}
output "internal-ip-bastion" {
  value = yandex_compute_instance.vm-bastion.network_interface.0.ip_address
}

output "internal-ip-vm-nginx-1" {
  value = yandex_compute_instance.vm-nginx-1.network_interface.0.ip_address
}
output "external-ip-vm-nginx-1" {
  value = yandex_compute_instance.vm-nginx-1.network_interface.0.nat_ip_address
}

output "internal-ip-vm-nginx-2" {
  value = yandex_compute_instance.vm-nginx-2.network_interface.0.ip_address
}
output "external-ip-vm-nginx-2" {
  value = yandex_compute_instance.vm-nginx-2.network_interface.0.nat_ip_address
}

output "external-ip-grafana" {
  value = yandex_compute_instance.vm-grafana.network_interface.0.nat_ip_address
}
output "internal-ip-grafana" {
  value = yandex_compute_instance.vm-grafana.network_interface.0.ip_address
}

output "external-ip-kibana" {
  value = yandex_compute_instance.vm-kibana.network_interface.0.nat_ip_address
}
output "internal-ip-kibana" {
  value = yandex_compute_instance.vm-kibana.network_interface.0.ip_address
}

output "internal-ip-prometheus" {
  value = yandex_compute_instance.vm-prometheus.network_interface.0.ip_address
}

output "internal-ip-elasticsearch" {
  value = yandex_compute_instance.vm-elasticsearch.network_interface.0.ip_address
}

output "external-ip-alb" {
  value = yandex_alb_load_balancer.alb.listener.0.endpoint.0.address.0.external_ipv4_address
}