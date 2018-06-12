# BIprovision
ansible playbook to prepare the LVM cfg allowing a ceph-ansible deploy using
RGW bucket indexes on NVMe devices

Key vars in yml file
* TEARDOWNonly    <-- if defined then only peform device teardown
* datadev_size    <-- how large are the HDDs?
* nvmedev_size    <-- how large are the NVMEs?
* nvme_FSjournal_size  <-- set to 5.5G
* datadev1_hdds    <-- list of HDDs

Helper scripts
* calcPartitions.py   <-- determines size of BucketIndex NVMe partition
* makePartitions.sh   <-- creates partitions on NVMe device(s)
