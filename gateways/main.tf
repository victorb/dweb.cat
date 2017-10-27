variable "do_token" {}

provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_domain" "default" {
  name       = "dweb.cat"
  ip_address = "${digitalocean_droplet.front.0.ipv4_address}"
}

resource "digitalocean_domain" "backup" {
  name       = "catalunya.network"
  ip_address = "${digitalocean_droplet.front.0.ipv4_address}"
}

resource "digitalocean_record" "default" {
  domain = "${digitalocean_domain.default.name}"
  name   = "@"
  type   = "A"
  value  = "${digitalocean_droplet.front.0.ipv4_address}"
}

resource "digitalocean_record" "backup" {
  domain = "${digitalocean_domain.backup.name}"
  name   = "@"
  type   = "A"
  value  = "${digitalocean_droplet.front.0.ipv4_address}"
}

resource "digitalocean_record" "gateway" {
  domain = "${digitalocean_domain.default.name}"
  name   = "gateway"
  type   = "A"
  value  = "${digitalocean_droplet.front.0.ipv4_address}"
}

resource "digitalocean_record" "email-spool" {
  domain = "${digitalocean_domain.default.name}"
  type   = "MX"
  name   = "email-spool"
	priority = 10
  value  = "spool.mail.gandi.net."
}

resource "digitalocean_record" "email-fb" {
  domain = "${digitalocean_domain.default.name}"
  type   = "MX"
  name   = "email-fb"
	priority = 50
  value  = "fb.mail.gandi.net."
}

resource "digitalocean_record" "email-txt" {
  domain = "${digitalocean_domain.default.name}"
  type   = "TXT"
  name   = "email-txt"
  value  = "v=spf1 include:_mailcust.gandi.net ?all"
}

data "template_file" "caddyfile" {
  template = "${file("${path.module}/Caddyfile.tpl")}"

  vars {
    upstreams = "${join(" ", formatlist("%s:8080", digitalocean_droplet.ipfs.*.ipv4_address_private))}"
  }
}

resource "digitalocean_droplet" "front" {
  image  = "ubuntu-16-04-x64"
  name   = "front-${count.index}"
  region = "fra1"
  size   = "512mb"
  count  = 1

  ssh_keys           = ["6351718", "6161470"]
  private_networking = true

  provisioner "file" {
    content     = "${data.template_file.caddyfile.rendered}"
    destination = "/root/Caddyfile"
  }

  provisioner "file" {
    source      = "caddy.service"
    destination = "/etc/systemd/system/caddy.service"
  }

  provisioner "remote-exec" {
    inline = [
      "curl https://getcaddy.com | bash",
      "systemctl start caddy",
    ]
  }
}

resource "digitalocean_droplet" "ipfs" {
  image              = "ubuntu-16-04-x64"
  name               = "ipfs-${count.index}"
  region             = "fra1"
  size               = "2gb"
  ssh_keys           = ["6351718", "6161470"]
  private_networking = true
  count              = 2

  provisioner "file" {
    source      = "ipfs.service"
    destination = "/etc/systemd/system/ipfs.service"
  }

  provisioner "remote-exec" {
    inline = [
      "fallocate -l 1G /swapfile",
      "chmod 600 /swapfile",
      "mkswap /swapfile",
      "swapon /swapfile",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "wget https://dist.ipfs.io/go-ipfs/v0.4.10/go-ipfs_v0.4.10_linux-amd64.tar.gz",
      "tar xfv go-ipfs_v0.4.10_linux-amd64.tar.gz",
      "cd go-ipfs/ && ./install.sh",
      "ipfs init",
      "ipfs config Addresses.Gateway /ip4/${self.ipv4_address_private}/tcp/8080",
      "systemctl start ipfs",
    ]
  }
}

output "ipfs nodes" {
  value = "${digitalocean_droplet.ipfs.*.ipv4_address}"
}

output "front nodes" {
  value = "${digitalocean_droplet.front.*.ipv4_address}"
}
