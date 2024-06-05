variable "token" {
  description = "IAM-токен"
  type = string
  sensitive = true
}

variable "cloud_id" {
  description = "Идентификатор облака"
  type = string
  sensitive = true
}

variable "folder_id" {
  description = "Идентификатор каталога"
  type = string
  sensitive = true
}

variable "image_id" {
  description = "Образ установочного дистрибутива"
  default = "fd89ls0nj4oqmlhhi568"
  #Ubuntu 22.04 LTS OS Login
  type = string
}

variable "zone_a" {
  description = "Зона доступности A"
  default = "ru-central1-a"
  type = string
}

variable "zone_b" {
  description = "Зона доступности B"
  default = "ru-central1-b"
  type = string
}

variable "zone_d" {
  description = "Зона доступности D"
  default = "ru-central1-d"
  type = string
}