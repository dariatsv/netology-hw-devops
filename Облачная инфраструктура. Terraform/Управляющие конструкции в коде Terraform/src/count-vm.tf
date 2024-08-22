variable "minimal_web_settings" {
  type = object({
    platform_id   = string,
    core_count    = number,
    core_fraction = number,
    memory_count  = number,
    hdd_size      = number,
    hdd_type      = string,
    preemptible   = bool,
    nat           = bool
  })
  default = {
    core_count    = 2,
    core_fraction = 20,
    memory_count  = 2,
    hdd_size      = 10,
    hdd_type      = "network-hdd",
    platform_id   = "standard-v3",
    preemptible   = true,
    nat           = true
  }
}

resource "yandex_compute_instance" "web" {
  count = 2
  depends_on = [ yandex_compute_instance.db ]
  name        = "web-${count.index + 1}"
  hostname    = "web-${count.index + 1}"
  platform_id = var.minimal_web_settings.platform_id

  resources {
    core_fraction = var.minimal_web_settings.core_fraction
    cores         = var.minimal_web_settings.core_count
    memory        = var.minimal_web_settings.memory_count
  }
  scheduling_policy {
    preemptible = var.minimal_web_settings.preemptible
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = var.minimal_web_settings.hdd_type
      size     = var.minimal_web_settings.hdd_size
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    security_group_ids = toset([yandex_vpc_security_group.example.id])
    nat                = var.minimal_web_settings.nat
  }

  allow_stopping_for_update = true

  metadata = local.metadata
}