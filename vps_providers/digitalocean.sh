#!/bin/bash

TASK=$1
CONFIG_FILE=$2
USER_DATA_FILE=$3
PUBLIC_KEY_FILE=$4

[[ -z `which doctl` ]] && (>&2 echo "Missing doctl") && exit 1
[[ -z "$TASK" ]] && (>&2 echo "Usage: start|stop config_file") && exit 1
[[ -z "$CONFIG_FILE" ]] && (>&2 echo "No config file.") && exit 1

source "$CONFIG_FILE"

([[ -z $DIGITALOCEAN_AUTH ]] ||
  [[ -z $DIGITALOCEAN_REGION ]] ||
  [[ -z $DIGITALOCEAN_DROPLET_NAME ]]) && (>&2 echo "Missing configurations.") && exit 1

case $TASK in
  "start")
    echo "Checking if the ssh key has been added into the account..."
    SSH_KEY_FINGERPRINT=`ssh-keygen -E md5 -lf $PUBLIC_KEY_FILE | grep -o -E "([0-9a-f]{2}\:){15}[0-9a-f]{2}"`
    KEY_LISTED=`doctl compute ssh-key list --format FingerPrint -t $DIGITALOCEAN_AUTH | grep $SSH_KEY_FINGERPRINT`
    if [[ -z "$KEY_LISTED" ]]; then
      echo ""
      echo "Key not found. Adding ssh key into DigitalOcean account..."
      doctl compute ssh-key create $DIGITALOCEAN_DROPLET_NAME --public-key "`cat $PUBLIC_KEY_FILE`" -t $DIGITALOCEAN_AUTH
      [[ $? != 0 ]] && exit 1
    fi
    echo ""
    echo "Asking digital ocean to start the server..."

    doctl compute droplet create $DIGITALOCEAN_DROPLET_NAME \
      -v \
      --image debian-8-x64 \
      --region $DIGITALOCEAN_REGION \
      --size 512mb \
      --user-data-file $USER_DATA_FILE \
      --ssh-keys $SSH_KEY_FINGERPRINT \
      --wait \
      -t $DIGITALOCEAN_AUTH
    [[ $? != 0 ]] && exit 1

    WAIT_ON_PORT=22
    [[ ! -z "$PORT_TCP" ]] && WAIT_ON_PORT=$PORT_TCP
    echo ""
    echo "Waiting for server to come online on port $WAIT_ON_PORT..."
    REMOTE_IP=`doctl compute droplet list $DIGITALOCEAN_DROPLET_NAME --format PublicIPv4 -v -t $DIGITALOCEAN_AUTH | tail -n 1`
    nc -z -w20 $REMOTE_IP $WAIT_ON_PORT

    sleep 5

    echo ""
    echo "Server started."
  ;;
  "stop")
    echo "Asking digital ocean to remove the server..."
    doctl compute droplet delete $DIGITALOCEAN_DROPLET_NAME \
      -v \
      -t $DIGITALOCEAN_AUTH
    [[ $? != 0 ]] && exit 1
  ;;
  "ip")
    REMOTE_IP=`doctl compute droplet list $DIGITALOCEAN_DROPLET_NAME --format PublicIPv4 -v -t $DIGITALOCEAN_AUTH | tail -n 1`
    if [[ ! -z "$REMOTE_IP" ]]; then
      echo $REMOTE_IP
      exit
    fi
    (>&2 echo "Not started.")
    exit 1
  ;;
  "*")
    (>&2 echo "Usage: start|stop|ip config_file [public_key_file]")
    exit 1
  ;;
esac



