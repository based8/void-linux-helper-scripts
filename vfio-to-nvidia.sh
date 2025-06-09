#!/bin/bash

if [ "$EUID" -ne 0 ]; then

  echo "Please run as root (use sudo)."
  exit 1

fi

if [ "$#" -ne 1 ]; then

  echo "Usage: sudo $0 <nvidia|vfio>"
  exit 1

fi


ARG=$1
VFIO_CONF="/etc/dracut.conf.d/vfio.conf"
NVIDIA_CONF="/etc/dracut.conf.d/nvidia.conf"
VFIO_MODCONF="/etc/modprobe.d/vfio.conf"
NVIDIA_MODCONF="/etc/modprobe.d/nvidia.conf"

if [ ! -f "$VFIO_CONF" ]; then

  echo "File not found: $VFIO_CONF"
  exit 1

fi

if [ ! -f "$NVIDIA_CONF" ]; then

  echo "File not found: $NVIDIA_CONF"
  exit 1

fi

comment_all_lines() {

  local file="$1"
  cp "$file" "${file}.bak"
  sed -i -E 's/^([^#])/#\1/' "$file"

}

uncomment_all_lines() {

  local file="$1"
  cp "$file" "${file}.bak"
  sed -i -E 's/^#//' "$file"

}


case "$ARG" in

  nvidia)

    comment_all_lines "$VFIO_CONF"
    comment_all_lines "$VFIO_MODCONF"
    uncomment_all_lines "$NVIDIA_CONF"
    uncomment_all_lines "$NVIDIA_MODCONF"

    echo "Commented out all lines in $VFIO_CONF and uncommented all lines in $NVIDIA_CONF."

    ;;

  vfio)

    comment_all_lines "$NVIDIA_CONF"
    comment_all_lines "$NVIDIA_MODCONF"
    uncomment_all_lines "$VFIO_CONF"
    uncomment_all_lines "$VFIO_MODCONF"
    echo "Commented out all lines in $NVIDIA_CONF and uncommented all lines in $VFIO_CONF."

    ;;

  *)

    echo "Invalid argument. Use 'nvidia' or 'vfio'."
    exit 1

    ;;

esac

dracut -f
