# Makefile used to prepare configuration files
# You are not supposed to run this file directly.

SHELL := /bin/bash

config/bootstrap-runcmd.yaml: config/bootstrap.yaml
config/bootstrap.yaml: config/common.yaml vvpn vvpn_config
	@./vvpn _yaml bootstrap

config/server.yaml: config/common.yaml vvpn config/server.tar.gz
	@./vvpn _yaml server

config/common.yaml: config/server_ecdsa config/server_ecdsa.pub vvpn config/ddns_url
	@./vvpn _yaml common vvpn

config/server_ecdsa.pub: config/server_ecdsa
config/server_ecdsa:
	@mkdir -p config
	@ssh-keygen -t ecdsa -f config/server_ecdsa -C "" -N ""

config/id_ed25519.pub: config/id_ed25519
config/id_ed25519:
	@mkdir -p config
	@ssh-keygen -t ed25519 -f config/id_ed25519 -C "" -N ""

config/known_hosts: config/server_ecdsa.pub vvpn_config
	@mkdir -p config
	@. vvpn_config; \
	echo -n "$$SERVER_HOSTNAME " > config/known_hosts; \
	cat config/server_ecdsa.pub >> config/known_hosts;

config/ddns_url: vvpn_config
	@mkdir -p config
	@. vvpn_config; \
	[[ ! -f ./ddns_providers/$$DDNS_PROVIDER.sh ]] && exit 1; \
	./ddns_providers/$$DDNS_PROVIDER.sh vvpn_config > config/ddns_url; \
	if [[ $$? -ne 0 ]]; then \
		cat config/ddns_url; \
		rm config/ddns_url; \
		exit 1; \
	fi

.PHONY: clean
clean:
	rm -f config/bootstrap.yaml \
		config/bootstrap-runcmd.yaml \
		config/server.yaml \
		config/common.yaml \
		config/known_hosts \
		config/ddns_url
