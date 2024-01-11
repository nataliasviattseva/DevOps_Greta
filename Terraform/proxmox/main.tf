terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.42.0"
    }
  }
}

provider "proxmox" {
  endpoint = "https://192.168.27.180:8006/"
  api_token = var.api_token
  insecure  = true # This ignores SSL verification, use cautiously
  
  ssh {
    agent    = false
    username = "root"
    password = "Azerty123456"
  }
}

data "proxmox_virtual_environment_vms" "template" {
  node_name = var.target_node
  tags      = ["template", var.template_tag]
}

resource "proxmox_virtual_environment_file" "cloud_user_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.target_node

  source_raw {
    data      = file("user_data")
    file_name = "${var.vm_hostname}.${var.domain}-ci-user.yml"
  }
}

resource "proxmox_virtual_environment_file" "cloud_meta_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.target_node

  source_raw {
    data      = templatefile("meta-data", { instance_id = sha1(var.vm_hostname), local_hostname = var.vm_hostname })
    file_name = "${var.vm_hostname}.${var.domain}-ci-meta_data.yml"
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  name      = "${var.vm_hostname}.${var.domain}"
  node_name = var.target_node

  on_boot = var.onboot

  agent {
    enabled = true
  }

  tags = var.vm_tags

  cpu {
    type    = "x86-64-v2-AES"
    cores   = var.cores
    sockets = var.sockets
    flags   = []
  }

  memory {
    dedicated = var.memory
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  # Ignore changes to the network
  lifecycle {
    ignore_changes = [
      network_device,
    ]
  }

  boot_order    = ["scsi0"]
  scsi_hardware = "virtio-scsi-single"

  disk {
    interface    = "scsi0"
    iothread     = true
    datastore_id = "${var.disk.storage}"
    size         = var.disk.size
    discard      = "ignore"
  }

  dynamic "disk" {
    for_each = var.additional_disks
    content {
      interface    = "scsi${1 + disk.key}"
      iothread     = true
      datastore_id = "${disk.value.storage}"
      size         = disk.value.size
      discard      = "ignore"
      file_format  = "raw"
    }
  }

  clone {
    vm_id = data.proxmox_virtual_environment_vms.template.vms[0].vm_id
  }

  initialization {
    datastore_id      = "local"
    interface         = "ide2"
    user_data_file_id = proxmox_virtual_environment_file.cloud_user_config.id
    meta_data_file_id = proxmox_virtual_environment_file.cloud_meta_config.id
  }
}
