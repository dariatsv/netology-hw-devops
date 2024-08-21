variable "vm_web_cores" {
  type    = number
  default = 2
}

variable "vm_web_memory" {
  type    = number
  default = 2
}

variable "vm_web_core_fraction" {
  type    = number
  default = 5
}

variable "vm_web_platform_id" {
  type    = string
  default = "standard-v1"
}

variable "vm_web_compute_instance_name" {
  type    = string
  default = "netology-develop-platform-web"
}

variable "vm_db_cores" {
  type    = number
  default = 2
}

variable "vm_db_memory" {
  type    = number
  default = 2
}

variable "vm_db_core_fraction" {
  type    = number
  default = 5
}

variable "vm_db_platform_id" {
  type    = string
  default = "standard-v1"
}

variable "vm_db_compute_instance_name" {
  type    = string
  default = "netology-develop-platform-db"
}

variable "vms_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
  }))
}

variable "vms_meta" {
  type = map(object({
    serial-port-enable = number
    ssh-keys           = string
  }))
}

