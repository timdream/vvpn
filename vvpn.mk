# Makefile used to prepare configuration files
# You are not supposed to run this file directly.

SHELL := /bin/bash

config/bootstrap.yaml: config/common.yaml vvpn_config
	@./vvpn _yaml bootstrap

config/server.yaml: config/common.yaml config/server.tar.gz
	@./vvpn _yaml server

config/common.yaml: config/server_ecdsa config/ddns_url
	@./vvpn _yaml common

config/server_ecdsa:
	@mkdir -p config
	@ssh-keygen -t ecdsa -f config/server_ecdsa -C "" -N ""

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
		config/server.yaml \
		config/common.yaml \
		config/ddns_url
