#! /usr/bin/env bash

set -e

# jq ".[].multihash" content.json | xargs ipfs pin add --progress
HASHES=$(jq ".[].multihash" content.json)

cd gateways/

SSH_HOSTS=$(for s in $(terraform state list | grep ipfs); do
	terraform state show "$s" | grep 'ipv4_address ' | cut -d '=' -f 2 | xargs
done)

for HOST in $SSH_HOSTS; do
	for HASH in $HASHES; do
		echo "Pinning $HOST -> $HASH"
		time ssh root@$HOST ipfs pin add $HASH --progress
	done 
done
