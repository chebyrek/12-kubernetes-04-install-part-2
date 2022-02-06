terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.69.0"
    }
  }
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = "ru-central1-a"
}

resource "yandex_compute_instance" "cp" {

  name     = "cp"
  hostname = "cp"

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8qqvji2rs2lehr7d1l" # ubuntu 20.04
      size     = 15
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.netology.id
    nat       = true

  }

  scheduling_policy {
    preemptible = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("id_rsa.pub")}"
  }

  # чтобы не перетирался hostname меняем конфиг cloud-init

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.network_interface.0.nat_ip_address
    private_key = file("/home/user/.ssh/id_rsa")

  }

  provisioner "remote-exec" {
    inline = ["sudo chown -R ubuntu: /etc/cloud/"]
  }

  provisioner "file" {
    source      = "cloud.cfg"
    destination = "/etc/cloud/cloud.cfg"
  }

  provisioner "remote-exec" {
    inline = ["sudo chown -R root: /etc/cloud/"]
  }

}

resource "yandex_compute_instance" "node" {

  count = 2

  name     = "node${count.index}"
  hostname = "node${count.index}"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8qqvji2rs2lehr7d1l" # ubuntu 20.04
      size     = 15
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.netology.id
    nat       = true

  }

  scheduling_policy {
    preemptible = true
  }

  # чтобы не перетирался hostname меняем конфиг cloud-init

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.network_interface.0.nat_ip_address
    private_key = file("/home/user/.ssh/id_rsa")

  }

  provisioner "remote-exec" {
    inline = ["sudo chown -R ubuntu: /etc/cloud/"]
  }

  provisioner "file" {
    source      = "cloud.cfg"
    destination = "/etc/cloud/cloud.cfg"
  }

  provisioner "remote-exec" {
    inline = ["sudo chown -R root: /etc/cloud/"]
  }

  metadata = {
    ssh-keys = "ubuntu:${file("id_rsa.pub")}"
  }

}

resource "yandex_vpc_network" "netology" {}

resource "yandex_vpc_subnet" "netology" {
  v4_cidr_blocks = ["10.2.35.0/24"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.netology.id
}

output "cp_ext_ip" {
  value = yandex_compute_instance.cp.network_interface.0.nat_ip_address
}

output "node_ext_ip" {
  value = ["${yandex_compute_instance.node.*.network_interface.0.nat_ip_address}"]
}
