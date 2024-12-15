variable "token" {
  type        = string
}

variable "cloud_id" {
  type        = string
}

variable "folder_id" {
  type        = string
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "vpc_name" {
  type        = string
  default     = "develop"
}

variable "public_subnet" {
  type        = string
  default     = "public-subnet"
}

variable "yandex_compute_instance_groupvms" {
  type        = list(object({
    name = string
    cores = number
    memory = number
    core_fraction = number
    platform_id = string
  }))

  default = [{
    name = "lamp-group"
    cores         = 2
    memory        = 2
    core_fraction = 5
    platform_id = "standard-v1"
  }]
}

variable "boot_disk" {
  type        = list(object({
    size = number
    type = string
    image_id = string
  }))
  default = [ {
    size = 10
    type = "network-hdd"
    image_id = "fd827b91d99psvq5fjit"
  }]
}