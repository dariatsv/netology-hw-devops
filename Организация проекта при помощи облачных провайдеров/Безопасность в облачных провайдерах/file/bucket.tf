locals {
  secure_bucket_name = "tsvetkova.netology-hw-03.secure"
  web_bucket_name    = "tsvetkova.netology-hw-03.com"
  img_object_name    = "mountain.png"
}

resource "yandex_iam_service_account" "sa" {
  name = "service-account"
}

resource "yandex_resourcemanager_folder_iam_member" "viewer" {
  folder_id = var.folder_id
  role      = "viewer"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
}

resource "yandex_storage_bucket" "secure" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = local.secure_bucket_name

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.netology.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "yandex_storage_bucket" "web" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = local.web_bucket_name

  anonymous_access_flags {
    read = true
    list = true
  }
}

resource "yandex_storage_object" "secure_main_mountain" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = yandex_storage_bucket.secure.bucket
  key        = local.img_object_name
  source     = "img/1.png"
  acl        = "public-read"
}

resource "yandex_storage_object" "web_main_mountain" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = yandex_storage_bucket.web.bucket
  key        = local.img_object_name
  source     = "img/1.png"
  acl        = "public-read"
}

resource "yandex_storage_object" "web_index" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = yandex_storage_bucket.web.bucket
  key        = local.img_object_name
  source     = "img/1.png"
  acl        = "public-read"
}

resource "yandex_kms_symmetric_key" "netology" {
  name              = "netology"
  default_algorithm = "AES_128"
  rotation_period   = "4380h"
}