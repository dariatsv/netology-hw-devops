resource "local_file" "ansible-inventory" {
  content = <<-EOT

    [all:vars]
    ansible_user=dasha21a
    ansible_ssh_private_key_file=/Users/daracvetkova/.ssh/id_rsa.pub

    [privilege_escalation]
    become = True
    become_user = root
    become_method = sudo

    [bastion]
    bastion ansible_host=${yandex_compute_instance.vm-bastion.network_interface.0.nat_ip_address}

    [non_bastion:children]
    webservers
    elk
    monitoring

    [non_bastion:vars]
    ansible_ssh_common_args='-o ProxyJump={{ansible_user}}@${yandex_compute_instance.vm-bastion.network_interface.0.nat_ip_address}'

    [webservers]
    webserver-1 ansible_host=${yandex_compute_instance.vm-nginx-1.network_interface.0.ip_address}
    webserver-2 ansible_host=${yandex_compute_instance.vm-nginx-2.network_interface.0.ip_address}

    [elk]
    elasticsearch ansible_host=${yandex_compute_instance.vm-elasticsearch.network_interface.0.ip_address}
    kibana ansible_host=${yandex_compute_instance.vm-kibana.network_interface.0.ip_address}

    [monitoring]
    prometheus ansible_host=${yandex_compute_instance.vm-prometheus.network_interface.0.ip_address}
    grafana ansible_host=${yandex_compute_instance.vm-grafana.network_interface.0.ip_address}

    EOT
  filename = "../ansible/inventory.ini"
}

resource "local_file" "filebeat-local-file" {
  content = <<-EOT

    kibana_host: ${yandex_compute_instance.vm-kibana.network_interface.0.nat_ip_address}:5601
    elastic_host: ${yandex_compute_instance.vm-elasticsearch.network_interface.0.nat_ip_address}:9200

    EOT
  filename = "../ansible/filebeat/vars/main.yml"
}

resource "local_file" "grafana-local-file" {
  content = <<-EOT

    user: admin
    password: admin
    grafana_host: ${yandex_compute_instance.vm-grafana.network_interface.0.nat_ip_address}

    EOT
  filename = "../ansible/grafana/vars/main.yml"
}

resource "local_file" "kibana-local-file" {
  content = <<-EOT

    elastic_host: ${yandex_compute_instance.vm-elasticsearch.network_interface.0.nat_ip_address}

    EOT
  filename = "../ansible/kibana/vars/main.yml"
}