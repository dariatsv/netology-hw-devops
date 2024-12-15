variable "token" {
  type = string
}

variable "cloud_id" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "default_zone" {
  type    = string
  default = "ru-central1-a"
}

variable "vm1" {
  type        = string
  default     = "nat"
}

variable "vm1_hostname" {
  default = "nat"
}

variable "vm1_image" {
  type        = string
  default     = "fd80mrhj8fl2oe87o4e1"
}

variable "vm1_ip" {
  type        = string
  default     = "192.168.10.254"
}

variable "vm1_resources" {
  type = map(number)
  default = {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }
}

variable "vm2" {
  type        = string
  default     = "public"
}

variable "vm2_hostname" {
  default = "public"
}

variable "VM2_image" {
  type        = string
  default     = "fd8pqclrbi85ektgehlf"
}

variable "vm2_resources" {
  type = map(number)
  default = {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }
}

variable "vm3" {
  type        = string
  default     = "private"
}

variable "vm3_hostname" {
  default = "private"
}

variable "vm3_image" {
  type        = string
  default     = "fd8pqclrbi85ektgehlf"
}

variable "vm3_resources" {
  type = map(number)
  default = {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }
}

variable "default_cidr" {
  type = list(string)
  default = ["192.168.10.0/24"]
}

variable "vpc_name" {
  type        = string
  default     = "netology"
}

variable "default_cidr_private" {
  type = list(string)
  default = ["192.168.20.0/24"]
}