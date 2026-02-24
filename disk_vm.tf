resource "yandex_compute_disk" "storage_disks" {
  count = var.storage_disks.count

  name = "storage-disk-${count.index + 1}"
  type = var.storage_disks.type
  zone = var.default_zone
  size = var.storage_disks.size
}

resource "yandex_compute_instance" "storage" {
  name     = var.storage_name
  hostname = var.storage_name
  zone     = var.default_zone

  resources {
    cores  = var.storage_resources.cores
    memory = var.storage_resources.memory
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.os_image.id
      size     = var.storage_boot_disk.size
      type     = var.storage_boot_disk.type
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = var.storage_nat
    security_group_ids = [yandex_vpc_security_group.example.id] # SG из задания 1
  }

  # Подключение 3-х дополнительных дисков через dynamic + for_each
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage_disks
    content {
      disk_id = secondary_disk.value.id
    }
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${local.ssh_public_key}"
  }
}
