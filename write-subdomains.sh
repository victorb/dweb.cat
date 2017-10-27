#! /usr/bin/env bash

set -e

# cat gateways/subdomains.tf.tpl

DOMAINS=$(jq -r "del(.[] | select(.subdomain==null))[] | \"\(.subdomain)|\(.multihash)\"" content.json)

TO_WRITE=""

for LINE in ${DOMAINS[@]}; do
	export DOMAIN=$(echo $LINE | cut -d '|' -f 1)
	export VALUE=$(echo $LINE | cut -d '|' -f 2)
	TO_WRITE+=$(cat <<EOF

resource "digitalocean_record" "$DOMAIN-txt" {
	domain = "\${digitalocean_domain.default.name}"
	type = "TXT"
	name = "$DOMAIN"
	value = "dnslink=$VALUE"
}
resource "digitalocean_record" "$DOMAIN-a" {
	domain = "\${digitalocean_domain.default.name}"
	type = "A"
	name = "$DOMAIN"
	value = "\${digitalocean_droplet.front.0.ipv4_address}"
}

EOF
)
done

echo "# This file is created by ../write-subdomains.sh, don't change manually" > gateways/subdomains.tf
echo "$TO_WRITE" >> gateways/subdomains.tf
