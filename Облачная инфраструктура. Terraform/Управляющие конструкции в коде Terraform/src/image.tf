### common
variable "ubuntu_os_name" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "family os name"
}


data "yandex_compute_image" "ubuntu" {
  family = var.ubuntu_os_name
}