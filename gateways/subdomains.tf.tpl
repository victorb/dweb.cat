resource "digitalocean_record" "${domain}_txt" {
	domain = "${digitalocean_domain.default.name}"
	type = "TXT"
	name = "${domain}"
	value = "dnslink=${value}"
}
resource "digitalocean_record" "${domain}_a" {
	domain = "${digitalocean_domain.default.name}"
	type = "A"
	name = "${domain}"
	value = "${digitalocean_droplet.front.0.ipv4_address}"
}
