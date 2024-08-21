output "platform_outputs_map" {
  value = {
    web_vm_name = yandex_compute_instance.vm_web_platform.name
    web_vm_fqdn = yandex_compute_instance.vm_web_platform.fqdn
    web_vm_external_ip = yandex_compute_instance.vm_web_platform.network_interface[0].nat_ip_address

    db_vm_name = yandex_compute_instance.vm_db_platform.name
    db_vm_fqdn = yandex_compute_instance.vm_db_platform.fqdn
    db_vm_external_ip = yandex_compute_instance.vm_db_platform.network_interface[0].nat_ip_address
  }
}