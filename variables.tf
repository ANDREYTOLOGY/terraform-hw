###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  default     = "b1gopu95il74aq1t5shq"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  default     = "b1gk0ppv6q0vblbiuqsg"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

variable "ssh_user" {
  type        = string
  description = "Linux user for SSH keys metadata"
  default     = "ubuntu"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Path to public SSH key"
  default     = "~/.ssh/id_ed25519.pub"
}

variable "image_family" {
  type        = string
  description = "Image family for instances"
  default     = "ubuntu-2204-lts"
}

variable "each_vm" {
  type = list(object({
    vm_name     = string
    cpu         = number
    ram         = number
    disk_volume = number
  }))

  # 2 ВМ БД: main и replica, с разными cpu/ram/disk_volume
  default = [
    { vm_name = "main", cpu = 2, ram = 4, disk_volume = 20 },
    { vm_name = "replica", cpu = 4, ram = 8, disk_volume = 30 },
  ]
}

variable "sg_name" {
  type        = string
  description = "Security group name"
  default     = "example_dynamic"
}


variable "web_count" {
  type        = number
  default     = 2
}

variable "web_resources" {
  type = object({
    cores  = number
    memory = number
  })
  default = {
    cores  = 2
    memory = 2
  }
}

variable "web_boot_disk" {
  type = object({
    size = number
    type = string
  })
  default = {
    size = 10
    type = "network-hdd"
  }
}

variable "db_disk_type" {
  type    = string
  default = "network-hdd"
}

variable "storage_name" {
  type    = string
  default = "storage"
}

variable "storage_disks" {
  type = object({
    count = number
    size  = number
    type  = string
  })
  default = {
    count = 3
    size  = 1
    type  = "network-hdd"
  }
}

variable "storage_resources" {
  type = object({
    cores  = number
    memory = number
  })
  default = {
    cores  = 2
    memory = 2
  }
}

variable "storage_boot_disk" {
  type = object({
    size = number
    type = string
  })
  default = {
    size = 10
    type = "network-hdd"
  }
}

variable "storage_nat" {
  type    = bool
  default = true
}

variable "metadata" {
  type        = map(string)
  description = "Metadata for instances"
  default     = {}
}
