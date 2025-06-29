#!/bin/bash

if [ "$EUID" -ne 0 ]; then

  echo "Please run as root (use sudo)."
  exit 1

fi
[[ "$(read -e -p 'following setup is meant for a Muxless NVIDIA GPU on a system using dracut.
Are you sure you want to continue? [y/N]> '; echo $REPLY)" == [Yy]* ]]


NVIDIA_ID=$(lspci -nn | \
	grep NVIDIA | \
	awk -v RS=[ -v FS=] 'NR>1{print $1}' | \
       	tail -1)

echo "your nvidia vendor ID is $NVIDIA_ID"

VFIO_CONF="/etc/dracut.conf.d/vfio.conf"
NVIDIA_CONF="/etc/dracut.conf.d/nvidia.conf"
VFIO_MODCONF="/etc/modprobe.d/vfio.conf"
NVIDIA_MODCONF="/etc/modprobe.d/nvidia.conf"

if [ ! -f $VFIO_CONF ]; then
	touch $VFIO_CONF
	echo "created file at $VFIO_CONF"
fi
if [ ! -f $VFIO_MODCONF ]; then
	touch $VFIO_MODCONF
	echo "created file at $VFIO_MODCONF"
fi

echo "add_drivers+=\" vfio vfio_pci vfio_iommu_type1 \"
force_drivers+=\" vfio_pci \"
omit_drivers+=\" nvidia \" " > $VFIO_CONF

echo "options vfio-pci ids='$NVIDIA_ID'
softdep nvidia pre: vfio-pci" > $VFIO_MODCONF

if [ ! -f $NVIDIA_CONF ]; then
	touch $NVIDIA_CONF
	echo "created file at $NVIDIA_CONF"
fi
if [ ! -f $NVIDIA_MODCONF ]; then
	touch $NVIDIA_MODCONF
	echo "created file at $NVIDIA_MODCONF"
fi

echo "add_drivers+=\" nvidia nvidia_modeset nvidia_drm nvidia_uvm \"
force_drivers+=\" nvidia \"
omit_drivers+=\" vfio_pci \" " > $NVIDIA_CONF

echo "blacklist nouveau
blacklist vfio-pci
options nvidia NVreg_OpenRmEnableUnsupportedGpus=1" > $NVIDIA_MODCONF


echo "files have been written to"
