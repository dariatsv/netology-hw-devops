resource "yandex_vpc_network" "vpc" {
  name = "vpc"
}

resource "yandex_vpc_subnet" "internal-subnet" {
  name = "internal-subnet"
  zone = "ru-central1-a"
  network_id = yandex_vpc_network.vpc.id
  v4_cidr_blocks = [
    "192.168.10.0/24"]
}

resource "yandex_vpc_route_table" "nat-bastion" {
  network_id = yandex_vpc_network.vpc.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address = yandex_compute_instance.vm-bastion.network_interface[0].ip_address
  }
}

resource "yandex_vpc_subnet" "private-subnet-a" {
  name = "private-subnet-a"
  zone = "ru-central1-a"
  network_id = yandex_vpc_network.vpc.id
  v4_cidr_blocks = [
    "192.168.20.0/24"]
  route_table_id = yandex_vpc_route_table.nat-bastion.id
}

resource "yandex_vpc_subnet" "private-subnet-b" {
  name = "private-subnet-b"
  zone = "ru-central1-b"
  network_id = yandex_vpc_network.vpc.id
  v4_cidr_blocks = [
    "192.168.30.0/24"]
  route_table_id = yandex_vpc_route_table.nat-bastion.id
}

resource "yandex_alb_target_group" "target-group" {
  name = "target-group"

  target {
    subnet_id = yandex_compute_instance.vm-nginx-1.network_interface[0].subnet_id
    ip_address = yandex_compute_instance.vm-nginx-1.network_interface[0].ip_address
  }

  target {
    subnet_id = yandex_compute_instance.vm-nginx-2.network_interface[0].subnet_id
    ip_address = yandex_compute_instance.vm-nginx-2.network_interface[0].ip_address
  }
}

resource "yandex_alb_backend_group" "web-backend-group" {
  name = "web-backend-group"
  http_backend {
    name = "backend2"
    weight = 1
    port = 80
    target_group_ids = [
      yandex_alb_target_group.target-group.id]
    load_balancing_config {
      panic_threshold = 90
    }
    healthcheck {
      timeout = "10s"
      interval = "5s"
      http_healthcheck {
        path = "/"
      }
    }
  }
}

resource "yandex_alb_http_router" "http-router" {
  name = "http-router"
}

resource "yandex_alb_virtual_host" "virtual-host" {
  name = "virtual-host"
  http_router_id = yandex_alb_http_router.http-router.id
  route {
    name = "core"
    http_route {
      http_match {
        path {
          prefix = "/"
        }
      }
      http_route_action {
        backend_group_id = yandex_alb_backend_group.web-backend-group.id
        timeout = "3s"
      }
    }
  }
}

resource "yandex_alb_load_balancer" "alb" {
  name = "alb"
  network_id = yandex_vpc_network.vpc.id
  security_group_ids = [
    yandex_vpc_security_group.internal-security-group.id,
    yandex_vpc_security_group.load-balancer-security-group.id]

  allocation_policy {
    location {
      zone_id = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.internal-subnet.id
    }
  }
  listener {
    name = "my-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [
        80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.http-router.id
      }
    }
  }
}

resource "yandex_vpc_security_group" "internal-security-group" {
  name = "internal-security-group"
  network_id = yandex_vpc_network.vpc.id

  ingress {
    protocol = "ANY"
    description = "allow any connection from internal subnets"
    predefined_target = "self_security_group"
  }

  egress {
    protocol = "ANY"
    description = "allow any outgoing connections"
    v4_cidr_blocks = [
      "0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "bastion-security-group" {
  name = "bastion-security-group"
  network_id = yandex_vpc_network.vpc.id

  ingress {
    protocol = "ICMP"
    description = "allow ping"
    v4_cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    protocol = "TCP"
    description = "allow ssh"
    v4_cidr_blocks = [
      "0.0.0.0/0"]
    port = 22
  }

  egress {
    protocol = "ANY"
    description = "allow any outgoing connection"
    v4_cidr_blocks = [
      "0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "grafana-security-group" {
  name = "grafana-security-group"
  network_id = yandex_vpc_network.vpc.id

  ingress {
    protocol = "TCP"
    description = "allow grafana connections from internet"
    v4_cidr_blocks = [
      "0.0.0.0/0"]
    port = 3000
  }

  ingress {
    protocol = "TCP"
    description = "allow grafana connections from internet"
    v4_cidr_blocks = [
      "0.0.0.0/0"]
    port = 80
  }

  ingress {
    protocol = "ICMP"
    description = "allow ping"
    v4_cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    protocol = "ANY"
    description = "allow any outgoing connection"
    v4_cidr_blocks = [
      "0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "kibana-security-group" {
  name = "kibana-security-group"
  network_id = yandex_vpc_network.vpc.id

  ingress {
    protocol = "TCP"
    description = "allow kibana connections from internet"
    v4_cidr_blocks = [
      "0.0.0.0/0"]
    port = 5601
  }

  ingress {
    protocol = "ICMP"
    description = "allow ping"
    v4_cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    protocol = "ANY"
    description = "allow any outgoing connection"
    v4_cidr_blocks = [
      "0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "load-balancer-security-group" {
  name = "load-balancer-security-group"
  network_id = yandex_vpc_network.vpc.id

  ingress {
    protocol = "ANY"
    description = "Health checks"
    v4_cidr_blocks = [
      "0.0.0.0/0"]
    predefined_target = "loadbalancer_healthchecks"
  }

  ingress {
    protocol = "TCP"
    description = "allow HTTP connections from internet"
    v4_cidr_blocks = [
      "0.0.0.0/0"]
    port = 80
  }

  ingress {
    protocol = "ICMP"
    description = "allow ping"
    v4_cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    protocol = "ANY"
    description = "allow any outgoing connection"
    v4_cidr_blocks = [
      "0.0.0.0/0"]
  }
}