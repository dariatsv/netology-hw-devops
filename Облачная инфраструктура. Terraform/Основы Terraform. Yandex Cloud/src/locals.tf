locals {
  db_vm_name    = "${var.project}-${var.env}-${var.app}-db"
  web_vm_name   = "${var.project}-${var.env}-${var.app}-web"

  vms_resources = {
    web = {
      cores         = 2
      memory        = 1
      core_fraction = 5
    },
    db = {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }
  }

  vm_meta = {
    web = {
      serial-port-enable = 1
      ssh-keys           = ""
    },
    db = {
      serial-port-enable = 1
      ssh-keys           = ""
    }
  }
}