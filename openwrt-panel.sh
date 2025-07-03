#!/bin/bash

if [ "$EUID" -ne 0 ]; then

  echo "Please run as root (use sudo)."
  exit 1

fi
if [ "$#" -ne 1 ]; then
  
  echo "Usage: sudo $0 <network interface>"
  exit 1

fi

[[ "$(read -e -p '
--------------------------------------------------------------\
https://github.com/based8/OpenWRT_subnet_VM                   |
--------------------------------------------------------------/
Is your OpenWRT VM running [y/N]> '; echo $REPLY)" == [Yy]* ]]

IP=$(ip addr show $1 | awk '/inet / {print $2}')

if [[ -z "${IP}" ]]; then
  echo "stopping..."
  exit 1
else
  echo "${IP} found on $1"
fi

ip addr del ${IP} dev $1
ip addr add 192.168.1.10/24 dev $1

echo "IP address changed from ${IP} to 192.168.1.10/24 device $1
Try going to 192.168.1.1 in your browser and see if you see a luci panel"


