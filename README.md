## dweb.cat
> Portal for Catalan content on the distributed web

> Archive and entrypoint for Catalan culture and language on the distributed web

# Purpose

The purpose of this repository and the beloning infrastructure is to provide
ability to archive and host content relevant to Catalan culture and language.

Infrastructure costs are paid by a fund from donations. Once these run out, we
can no longer guarantee that the content will be available.

Each submission will be reviewing to make sure it's:

* Actually relevant to Catalan culture and/or language
* Not too big (submitting content of 1TB is too big [depending on current funding])

Anything that passes those two criterias will be provided space and bandwidth
to live on dweb.cat for as long as possible.

See it as the Internet Archive, but specifically for Catalunya and Catalan content.

# Process

Content needs to go through a process of verification, hosting and then publishing.

It works the following way:

- If you already have the content ready, proceed to the next step. If the content
	is NOT ready for hosting yet, open a issue before pulling down the data locally
	so you don't waste your bandwidth on something that won't be accepted.
- Add the content to IPFS and save the resulting hash. The basics of IPFS can be
	read in the file IPFS.md in the root of this repository
- Submit a PR adding your hash and the metadata to `content.json`
- Upon approved, the content will be pushed out to the gateways and applicable
	subdomains created in the infrastructure.

# Process for operators

- Once a change is in master, the following commands should be run:
- `./pin-content.sh`
- `./build-website.js`
- `(cd gateways/ && terraform plan -out wanted-change)`
- Confirm changes
- `(cd gateways/ && terraform apply wanted-change)`

# Architecture

Website is a simple HTML website that lists all the content that is available
and some metadata if available.

Content that gets added to `content.json` is hosted by a couple of gateway
nodes that are running under `https://dweb.cat/ipfs/:hash`. These gateways
are also connected to the general IPFS network so can be fetched from anywhere
as well as from dweb.cat

Shortlinks can also be made by adding them to `subdomains.json` which is a
object that lists names to their hashes. The hash linked must exists in `content.json`
if it's listed in `subdomains.json`.

# Deployment

Deployment is handled with Terraform in the `gateways/` directory.

# Website

Steps taken upon deploy of website:

- Build website in `website/`
- Add to IPFS
- If website changed (content.json updated)
	- `last-website-publish` will be different from new hash
	- Update DNS record for `archive.dweb.cat`

# Replication

All content on `content.json` is replicated to at least four places (please 
contact us if you can help replicate it more):

- Gateways running under dweb.cat/ipfs
- Online IPFS node running at Victor Bjelkholm's house
- Offline cache available at Victor's house
- S3 backup hosted by Amazon

# Domains

- dweb.cat
- catalan-gateway.com

# License

2017 MIT - Victor Bjelkholm
