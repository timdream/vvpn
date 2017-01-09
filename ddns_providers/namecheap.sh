#!/bin/bash

[[ -z "$1" ]] && (>&2 echo "No config file.") && exit 1

source "$1"

([[ -z $NAMECHEAP_HOST ]] ||
  [[ -z $NAMECHEAP_DOMAIN ]] ||
  [[ -z $NAMECHEAP_PASSWORD ]]) && (>&2 echo "Missing configurations.") && exit 1

echo -n "https://dynamicdns.park-your-domain.com/update?host=$NAMECHEAP_HOST&domain=$NAMECHEAP_DOMAIN&password=$NAMECHEAP_PASSWORD&ip="
