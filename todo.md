## TODO
> Workplan

- [X] Setup gateways with Terraform
	- [X] One load-balancer
	- [X] Two instances with go-ipfs running
		15 USD per month for infrastructure...
- [X] Setup Terraform to use dweb.cat to the loadbalancer
- [ ] Install Datadog client on infra
	DD_API_KEY=X bash -c "$(curl -L https://raw.githubusercontent.com/DataDog/dd-agent/master/packaging/datadog-agent/source/install_agent.sh)"
- [ ] Create website for printing out `content.json`
	- [ ] Use Terraform to DNS-resolve newest website
- [ ] Make use of `subdomains.json`
	- [ ] Terraform should use the json for setting up DNS (could be slow)
- [ ] Setup process for submitting, reviewing and deploying content
	- [ ] Github Issues / Projects?

Test: curl --resolve dweb.cat:443:46.101.163.103 https://dweb.cat/ipfs/QmT78zSuBmuS4z925WZfrqQ1qHaJ56DQaTfyMUF7F8ff5o
