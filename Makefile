#!/bin/bash
.ONESHELL:

cluster.yml:
	git clone -b release-2.19 --single-branch https://github.com/kubernetes-sigs/kubespray.git
	cp -nprf kubespray/* myfiles/* .
	
.PHONY: clean
clean:
	rm -rf kubespray/

.PHONY: install
install:
	/usr/bin/env python3 -m venv venv
	. venv/bin/activate
	pip install -r requirements.txt
	ansible-playbook id_rsa_generating.yml
	terraform init
	terraform apply -auto-approve
	if [ ! -f ~/.vault_pass ]; then echo testpass > ~/.vault_pass; fi
	ansible-galaxy install -r requirements.yml
	ansible-playbook -i dynamic_inventory.py --vault-password-file ~/.vault_pass -b -u=root main.yml -vv
	ansible-playbook -i dynamic_inventory.py kubectl_localhost.yml --ask-become-pass
	kubectl top node
