# void-linux-helper-scripts
Void linux scripts for VM management

## First
```
$ chmod 770 vfio-to-nvidia.sh
$ chmod 770 cpu-isol-add.sh
$ chmod 770 cpu-isol-rem.sh
```

## Usage
To use vfio-to-nvidia.sh you already need a modprobe and dracut file for the vfio and nvidia drivers
To switch to using nvidia use
```
$ sudo sh vfio-to-nvidia.sh nvidia
```
To switch to using vfio use
```
$ sudo sh vfio-to-nvidia.sh vfio
```

To isolate cpu cores you need to specify what cpu range to isolate
Lets use cpuset 4-11 for example
```
$ sudo ./cpu-isol-add.sh 4-11
```
to remove the isolation use
```
$ sudo ./cpu-isol-rem.sh
```
