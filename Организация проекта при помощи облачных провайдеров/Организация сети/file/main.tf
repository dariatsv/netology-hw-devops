resource "yandex_compute_instance" "nat_instance" {
  name = var.vm1
  hostname = var.vm1_hostname
  zone = var.default_zone

  boot_disk {
    initialize_params {
      image_id = var.vm1_image
    }
  }

  resources {
    cores   = var.vm1_resources.cores
    memory  = var.vm1_resources.memory
  }

  network_interface {
    subnet_id       = yandex_vpc_subnet.public_subnet.id
    nat             = true
    ip_address      = var.vm1_ip
  }
  metadata = {
    user-data = file("./meta.yaml")
  }
  scheduling_policy {
    preemptible = true
  }
}

resource "yandex_compute_instance" "public_instance" {
  name        = var.vm2
  hostname = var.vm2_hostname
  zone        = var.default_zone

  boot_disk {
    initialize_params {
      image_id = var.VM2_image
    }
  }

  resources {
    cores   = var.vm2_resources.cores
    memory  = var.vm2_resources.memory
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public_subnet.id
    nat       = true
  }
  scheduling_policy {
    preemptible = true
  }

  metadata = {
    user-data = file("./meta.yaml")
  }
}

resource "yandex_compute_instance" "private_instance" {
  name = var.vm3
  hostname = var.vm3_hostname
  zone = var.default_zone

  boot_disk {
    initialize_params {
      image_id = var.vm3_image
    }
  }

  resources {
    cores   = var.vm3_resources.cores
    memory  = var.vm3_resources.memory
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private_subnet.id
  }

  scheduling_policy {
    preemptible = true
  }
}

resource "yandex_vpc_network" "my_network" {
  name = var.vpc_name
  folder_id = var.folder_id
}

resource "yandex_vpc_subnet" "public_subnet" {
  name           = "public"
  network_id     = yandex_vpc_network.my_network.id
  v4_cidr_blocks = var.default_cidr
}

resource "yandex_vpc_subnet" "private_subnet" {
  name           = "private"
  network_id     = yandex_vpc_network.my_network.id
  v4_cidr_blocks = var.default_cidr_private
  route_table_id = yandex_vpc_route_table.private-route.id
}

resource "yandex_vpc_route_table" "private-route" {
  name       = "private-route"
  network_id = yandex_vpc_network.my_network.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "192.168.10.254"
  }
}