# BIprovision
ansible playbook which prepares storage device partitions and builds an LVM configuration,
allowing a ceph-ansible deploy (osd_scenario=lvm) placing both Filestore journals and
RGW bucket indexes on NVMe devices.
* FS_1nvme_noCache.yml  <-- for OSD systems with one NVME device
* FS_2nvme_noCache.yml  <-- for OSD systems with two NVME devices

Key vars in yml file
* TEARDOWNonly    <-- if defined then only peform device teardown
* datadev_size    <-- how large are the HDDs?
* nvmedev_size    <-- how large are the NVMEs?
* nvme_FSjournal_size  <-- set to 5.5G
* datadev1_hdds    <-- list of HDDs

Helper scripts
* calcPartitions.py   <-- determines size of BucketIndex NVMe partition
* makePartitions.sh   <-- creates partitions on NVMe device(s)
