# void-linux-helper-scripts
Void linux scripts for VM management

## First
```
git clone https://github.com/based8/void-linux-helper-scripts.git
chmod 770 ./void-linux-helper-scripts/*.sh
```


## VFIO to NVIDIA driver switch
To use vfio-to-nvidia.sh you already need a modprobe and dracut file for the vfio and nvidia drivers because what it does is it hashes out one config file and unhashes the other one.
To switch to using nvidia use
```
sudo sh vfio-to-nvidia.sh nvidia
```
To switch to using vfio use
```
sudo sh vfio-to-nvidia.sh vfio
```
## CPU isolation
To isolate cpu cores you need to specify what cpu range to isolate.
Lets use cpuset 4-11 for example
```
sudo ./cpu-isol-add.sh 4-11
```
to remove the isolation use
```
sudo ./cpu-isol-rem.sh
```
## VFIO configuration setup
Set-up the required config files for vfio-pci to work. Be ware that this script only works on a Muxless NVIDIA GPU system with dracut
```
sudo ./vfio-setup.sh
```
## OpenWRT panel
Basically this script just switches ips of the selected device to 192.168.1.10/24
More on the OpenWRT section is here https://github.com/based8/OpenWRT_subnet_VM
