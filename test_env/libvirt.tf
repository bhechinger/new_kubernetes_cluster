# https://github.com/dmacvicar/terraform-provider-libvirt/blob/main/examples/v0.13/ubuntu/ubuntu-example.tf

terraform {
  required_version = ">= 1.5.2"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = ">= 0.7.6"
    }
    # see https://registry.terraform.io/providers/hashicorp/template
    template = {
      source  = "hashicorp/template"
      version = ">= 2.2.0"
    }
  }
}

variable "vm_condition_poweron" {
  default = true
}

# variables that can be overriden
variable "k8s-master-hostname" {
  type = list(string)
  default = ["master1", "master2", "master3"]
}

variable "k8s-worker-hostname" {
  type = list(string)
  default = ["worker1", "worker2", "worker3"]
}

# different paths to master-worker images
variable "rescue-image" {
  default = "/home/wonko/ISOs/ubuntu-24.04-server-cloudimg-amd64.img"
}

variable "domain" { default = "local" }
variable "ramMB" { default = 1024*4 }
variable "cpu" { default = 2 }

locals {
  master        = "master"
  worker        = "worker"
  disk_master   = 40*1073741824
  disk_worker   = 500*1073741824
  vm_common_list_count = concat(var.k8s-master-hostname, var.k8s-worker-hostname)
  # creates list with condition
  # if hostname contains "m" - use default VAR for masters, otherwise modify VAR( or use another var- for images) for workers
  image_path    = var.rescue-image
  mem_local_var = [
    #for name in local.vm_common_list_count :(strcontains(name, local.master) ? var.ramMB : var.ramMB * 4)
    for name in local.vm_common_list_count :(strcontains(name, local.master) ? var.ramMB : var.ramMB)
  ]
  cpu_local_var = [
    #for name in local.vm_common_list_count :(strcontains(name, local.master) ? var.cpu : var.cpu * 2)
    for name in local.vm_common_list_count :(strcontains(name, local.master) ? var.cpu : var.cpu)
  ]
  disk_size = [
    for name in local.vm_common_list_count :(strcontains(name, local.master) ? local.disk_master : local.disk_worker)
  ]
  ip_offset = [
    for name in local.vm_common_list_count :
    (strcontains(name, local.master) ? 11 : 21 - length(var.k8s-master-hostname))
  ]
}

# instance the provider
provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_pool" "development" {
  name = "development"
  type = "dir"
  path = "/home/wonko/libvirt/images"
}

resource "libvirt_volume" "ubuntu24" {
  name   = "ubuntu24"
  pool   = libvirt_pool.development.name
  source = local.image_path
  format = "qcow2"
}

resource "libvirt_volume" "disk_1" {
  count = length(local.vm_common_list_count)
  name           = "disk_1.${local.vm_common_list_count[count.index]}"
  pool           = libvirt_pool.development.name
  base_volume_id = libvirt_volume.ubuntu24.id
  size           = local.disk_size[count.index]
}

resource "libvirt_volume" "disk_2" {
  count = length(local.vm_common_list_count)
  name   = "os_image.disk1.${local.vm_common_list_count[count.index]}"
  pool   = libvirt_pool.development.name
  format = "qcow2"
  size   = local.disk_size[count.index]
}

resource "libvirt_cloudinit_disk" "commoninit" {
  count = length(local.vm_common_list_count)
  name           = "${local.vm_common_list_count[count.index]}-commoninit.iso"
  pool           = libvirt_pool.development.name
  user_data      = data.template_file.user_data[count.index].rendered
  network_config = data.template_file.network_config.rendered
}

data "template_file" "user_data" {
  count = length(local.vm_common_list_count)
  template = file("${path.module}/cloud_init_ubuntu.cfg")
  vars = {
    hostname = element(local.vm_common_list_count, count.index)
    fqdn = "${local.vm_common_list_count[count.index]}.${var.domain}"
  }
}

data "template_file" "network_config" {
  template = file("${path.module}/network_config_dhcp.cfg")
}

resource "libvirt_network" "kube-public" {
  name      = "kube-public"
  addresses = ["10.22.20.0/24"]
  autostart = true
  domain    = "4amlunch.net"
  dns {
    enabled = true
    forwarders {
      address = "10.42.0.1"
      domain  = "4amlunch.net"
    }
  }
}

resource "libvirt_network" "kube-private" {
  name      = "kube-private"
  mode      = "none"
  autostart = true
}

# Create the machine
resource "libvirt_domain" "domain-k3s" {
  count = length(local.vm_common_list_count)
  name     = local.vm_common_list_count[count.index]
#   firmware = "/run/libvirt/nix-ovmf/OVMF_CODE.fd"
  machine  = "q35"
  xml {
    xslt = file("cdrom-model.xsl")
  }
  running  = var.vm_condition_poweron
  # if list element contains "m"- master node, use defaults, otherwise (worker)- multiply *4
  memory   = local.mem_local_var[count.index]
  vcpu     = local.cpu_local_var[count.index]
  disk {
    volume_id = element(libvirt_volume.disk_1.*.id, count.index)
  }
  disk {
    volume_id = element(libvirt_volume.disk_2.*.id, count.index)
  }

  network_interface {
    network_id     = libvirt_network.kube-public.id
    addresses = ["10.22.20.${count.index+local.ip_offset[count.index]}"]
    wait_for_lease = true
  }

  network_interface {
    network_id = libvirt_network.kube-private.id
  }

  cloudinit = libvirt_cloudinit_disk.commoninit[count.index].id

  # IMPORTANT
  # Ubuntu can hang is a isa-serial is not present at boot time.
  # If you find your cpu 100% and never is available this is why
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = "true"
  }
}


output "vm_list" {
  value = local.vm_common_list_count
}

output "vm_cpu" {
  value = local.cpu_local_var
}

output "vm_images" {
  value = local.image_path
}

output "ips" {
  # show IP, run 'terraform refresh' if not populated
  value = {
    master_ips = [
      for vm in libvirt_domain.domain-k3s : vm.network_interface.0.addresses.0if strcontains(vm.name, local.master)
    ]
    worker_ips = [
      for vm in libvirt_domain.domain-k3s : vm.network_interface.0.addresses.0if strcontains(vm.name, local.worker)
    ]
  }
}


resource "null_resource" "shutdowner" {
  # iterate with for_each over Vms list
  for_each = toset(local.vm_common_list_count)
  triggers = {
    trigger = var.vm_condition_poweron
  }

  provisioner "local-exec" {
    # command = var.vm_condition_poweron?"echo 'do nothing'":"for i in $(virsh -c qemu:///system list --all|tail -n+3|awk '{print $2}'); do virsh -c qemu:///system shutdown $i; done"
    command = var.vm_condition_poweron ? "echo 'do nothing'" : "virsh -c qemu:///system shutdown ${each.value}"
  }
}


# to shutdown execute 
# terraform apply -auto-approve -var 'vm_condition_poweron=false'
