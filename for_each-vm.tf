data "yandex_compute_image" "os_image" {
  family = var.image_family
}

locals {
  ssh_public_key = file(pathexpand(var.ssh_public_key_path))
}

resource "yandex_compute_instance" "db" {
  for_each = { for vm in var.each_vm : vm.vm_name => vm }

  name     = each.key
  hostname = each.key
  zone     = var.default_zone

  resources {
    cores  = each.value.cpu
    memory = each.value.ram
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.os_image.id
      size     = each.value.disk_volume
      type     = var.db_disk_type
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.example.id] # SG из задания 1
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${local.ssh_public_key}"
  }
}
