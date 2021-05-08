
variable "config_file" {
  type    = string
  default = "fedora34-kickstart.cfg"
}

variable "cpu" {
  type    = string
  default = "1"
}

variable "disk_size" {
  type    = string
  default = "20000"
}

variable "headless" {
  type    = string
  default = "true"
}

variable "iso_checksum" {
  type    = string
  default = "e1a38b9faa62f793ad4561b308c31f32876cfaaee94457a7a9108aaddaeec406"
}

variable "iso_checksum_type" {
  type    = string
  default = "sha256"
}

variable "iso_urls" {
  type    = string
  default = "https://download.fedoraproject.org/pub/fedora/linux/releases/34/Server/x86_64/iso/Fedora-Server-netinst-x86_64-34-1.2.iso"
}

variable "name" {
  type    = string
  default = "fedora"
}

variable "ram" {
  type    = string
  default = "2048"
}

variable "ssh_password" {
  type    = string
  default = "helmsman"
}

variable "ssh_private_key_file" {
  type    = string
  default = "./sshkeys/id_rsa"
}

variable "ssh_username" {
  type    = string
  default = "user"
}

variable "version" {
  type    = string
  default = "34"
}

source "qemu" "fedora" {
  accelerator          = "kvm"
  boot_command         = ["<tab> linux text net.ifnames=0 biosdevname=0 inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/http/${var.config_file}<enter><wait>"]
  boot_wait            = "10s"
  disk_cache           = "none"
  disk_compression     = true
  disk_discard         = "unmap"
  disk_interface       = "virtio"
  disk_size            = "${var.disk_size}"
  format               = "qcow2"
  headless             = "${var.headless}"
  http_directory       = "."
  iso_checksum         = "${var.iso_checksum}"
  iso_urls             = ["${var.iso_urls}"]
  net_device           = "virtio-net"
  output_directory     = "artifacts/qemu/${var.name}${var.version}"
  qemu_binary          = "/usr/bin/qemu-system-x86_64"
  qemuargs             = [["-m", "${var.ram}M"], ["-smp", "${var.cpu}"]]
  shutdown_command     = "sudo /usr/sbin/shutdown -h now"
  ssh_password         = "${var.ssh_password}"
  ssh_private_key_file = "${var.ssh_private_key_file}"
  ssh_username         = "${var.ssh_username}"
  ssh_wait_timeout     = "30m"
}

build {
  sources = ["source.qemu.fedora"]

  provisioner "shell" {
    execute_command = "{{ .Vars }} sudo -E bash '{{ .Path }}'"
    inline          = ["dnf -y install ansible"]
  }

}
