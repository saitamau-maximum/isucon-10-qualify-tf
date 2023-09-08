terraform {
  required_providers {
    sakuracloud = {
      source  = "sacloud/sakuracloud"
      version = "~> 2"
    }
  }
}

resource "sakuracloud_server" "isucon10q" {
  count = 3

  name = "${var.app_name}-s${count.index + 1}"
  zone = var.zone

  core   = 1
  memory = 2
  disks  = [sakuracloud_disk.isucon10q[count.index].id]

  network_interface {
    upstream = "shared"
  }

  network_interface {
    upstream = sakuracloud_switch.isucon10q-switch.id
  }

  user_data = join("\n", [
    "#cloud-config",
    local.cloud-config,
    yamlencode({
      ssh_pwauth : false,
      ssh_authorized_keys : [
        file(var.public_key_path),
      ],
    }),
  ])
}

data "sakuracloud_archive" "ubuntu" {
  zone = var.zone

  filter {
    names = ["Ubuntu Server 20.04 LTS 64bit (cloudimg)"]
  }
}

resource "sakuracloud_disk" "isucon10q" {
  count = 3

  name = "${var.app_name}-s${count.index + 1}"
  zone = var.zone

  size              = 20
  source_archive_id = data.sakuracloud_archive.ubuntu.id
}

data "http" "cloud-config-source" {
  url = "https://raw.githubusercontent.com/saitamau-maximum/isucon-10-qualify-tf/main/cloud-init/competitor.cfg"
}

locals {
  cloud-config = replace(data.http.cloud-config-source.body, "#cloud-config", "")
}

output "ip_address" {
  value = sakuracloud_server.isucon10q[*].ip_address
}
