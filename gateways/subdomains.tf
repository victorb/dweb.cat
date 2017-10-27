# This file is created by ../write-subdomains.sh, don't change manually

resource "digitalocean_record" "referendum-txt" {
	domain = "${digitalocean_domain.default.name}"
	type = "TXT"
	name = "referendum"
	value = "dnslink=/ipfs/QmQZzfs7LjkEnmG3zU92YF7ViCcuCXkNokuYoiNe6pKvDZ"
}
resource "digitalocean_record" "referendum-a" {
	domain = "${digitalocean_domain.default.name}"
	type = "A"
	name = "referendum"
	value = "${digitalocean_droplet.front.0.ipv4_address}"
}
resource "digitalocean_record" "test-txt" {
	domain = "${digitalocean_domain.default.name}"
	type = "TXT"
	name = "test"
	value = "dnslink=/ipfs/QmT78zSuBmuS4z925WZfrqQ1qHaJ56DQaTfyMUF7F8ff5o"
}
resource "digitalocean_record" "test-a" {
	domain = "${digitalocean_domain.default.name}"
	type = "A"
	name = "test"
	value = "${digitalocean_droplet.front.0.ipv4_address}"
}
resource "digitalocean_record" "ipfs-website-txt" {
	domain = "${digitalocean_domain.default.name}"
	type = "TXT"
	name = "ipfs-website"
	value = "dnslink=/ipfs/QmPCawMTd7csXKf7QVr2B1QRDZxdPeWxtE4EpkDRYtJWty"
}
resource "digitalocean_record" "ipfs-website-a" {
	domain = "${digitalocean_domain.default.name}"
	type = "A"
	name = "ipfs-website"
	value = "${digitalocean_droplet.front.0.ipv4_address}"
}
