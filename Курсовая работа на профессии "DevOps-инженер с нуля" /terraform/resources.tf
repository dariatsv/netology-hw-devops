resource "yandex_compute_instance" "vm-bastion" {
  name = "vm-bastion"
  zone = var.zone_a

  resources {
    cores = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      name = "disk-vm-bastion"
      type = "network-hdd"
      size = 10
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.internal-subnet.id
    nat = true
    security_group_ids = [
      yandex_vpc_security_group.internal-security-group.id,
      yandex_vpc_security_group.bastion-security-group.id]
  }

  metadata = {
    user-data = file("./meta.yaml")
  }

  scheduling_policy {
    preemptible = true
  }
}

resource "yandex_compute_instance" "vm-nginx-1" {
  name = "vm-nginx-1"
  zone = var.zone_a

  resources {
    cores = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      name = "disk-vm-nginx-1"
      type = "network-hdd"
      size = 10
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private-subnet-a.id
    nat = true
    security_group_ids = [
      yandex_vpc_security_group.internal-security-group.id]
  }

  metadata = {
    user-data = file("./meta.yaml")
  }

  scheduling_policy {
    preemptible = true
  }
}

resource "yandex_compute_instance" "vm-nginx-2" {
  name = "vm-nginx-2"
  zone = var.zone_b

  resources {
    cores = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      name = "disk-vm-nginx-2"
      type = "network-hdd"
      size = 10
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private-subnet-b.id
    nat = true
    security_group_ids = [
      yandex_vpc_security_group.internal-security-group.id]
  }

  metadata = {
    user-data = file("./meta.yaml")
  }

  scheduling_policy {
    preemptible = true
  }
}

resource "yandex_compute_instance" "vm-prometheus" {
  name = "vm-prometheus"
  zone = var.zone_a

  resources {
    cores = 2
    memory = 4
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      name = "disk-vm-prometheus"
      type = "network-hdd"
      size = 10
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private-subnet-a.id
    security_group_ids = [
      yandex_vpc_security_group.internal-security-group.id]
  }

  metadata = {
    user-data = file("./meta.yaml")
  }

  scheduling_policy {
    preemptible = true
  }
}

resource "yandex_compute_instance" "vm-grafana" {
  name = "vm-grafana"
  zone = var.zone_a

  resources {
    cores = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      name = "disk-vm-grafana"
      type = "network-hdd"
      size = 10
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.internal-subnet.id
    nat = true
    security_group_ids = [
      yandex_vpc_security_group.internal-security-group.id,
      yandex_vpc_security_group.grafana-security-group.id]
  }

  metadata = {
    user-data = file("./meta.yaml")
  }

  scheduling_policy {
    preemptible = true
  }
}

resource "yandex_compute_instance" "vm-elasticsearch" {
  name = "vm-elasticsearch"
  zone = var.zone_a

  resources {
    cores = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      name = "disk-vm-elasticsearch"
      type = "network-hdd"
      size = 10
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private-subnet-a.id
    security_group_ids = [
      yandex_vpc_security_group.internal-security-group.id]
  }

  metadata = {
    user-data = file("./meta.yaml")
  }

  scheduling_policy {
    preemptible = true
  }
}

resource "yandex_compute_instance" "vm-kibana" {
  name = "vm-kibana"
  zone = var.zone_a

  resources {
    cores = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      name = "disk-vm-kibana"
      type = "network-hdd"
      size = 10
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.internal-subnet.id
    nat = true
    security_group_ids = [
      yandex_vpc_security_group.internal-security-group.id,
      yandex_vpc_security_group.kibana-security-group.id]
  }

  metadata = {
    user-data = file("./meta.yaml")
  }

  scheduling_policy {
    preemptible = true
  }
}