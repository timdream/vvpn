#!/bin/bash

[[ -z "$1" ]] && (>&2 echo "No config file.") && exit 1

source "$1"

([[ -z $DNSDYNAMIC_HOSTNAME ]] ||
  [[ -z $DNSDYNAMIC_PASSWORD ]] ||
  [[ -z $DNSDYNAMIC_USERNAME ]]) && (>&2 echo "Missing configurations.") && exit 1

echo -n "https://$DNSDYNAMIC_USERNAME:$DNSDYNAMIC_PASSWORD@www.dnsdynamic.org/api/?hostname=$DNSDYNAMIC_HOSTNAME&myip="
