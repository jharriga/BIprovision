# BIprovision
ansible playbook which prepares storage device partitions and builds an LVM configuration,
allowing a ceph-ansible deploy (osd_scenario=lvm) placing both Filestore journals and
RGW bucket indexes on NVMe devices.
* FS_1nvme_noCache.yml  <-- for OSD systems with one NVME device
* FS_2nvme_noCache.yml  <-- for OSD systems with two NVME devices

NOTE: the file osdScenario.txt is an example excerpt to be inserted in group_vars/osds.yml

Key vars in yml file
* TEARDOWNonly    <-- if defined then only peform device teardown
* datadev_size    <-- how large are the HDDs?
* nvmedev_size    <-- how large are the NVMEs?
* nvme_FSjournal_size  <-- set to 5.5G
* datadev1_hdds    <-- list of HDDs

Helper scripts
* calcPartitions.py   <-- determines size of BucketIndex NVMe partition
* makePartitions.sh   <-- creates partitions on NVMe device(s)


USAGE PROCEDURE
---------------
* # git clone https://github.com/jharriga/BIprovision
* # cd BIprovision   
* # ansible-playbook FS_2nvme_noCache.yml
* # cat /tmp/logfile.txt
* # vi /root/ceph-ansible/group_vars/osds.yml   (to use osd_scenario=lvm, mega edits)
osd_scenario: lvm
lvm_volumes:
  - data: lv-cephbi-nvme0n1
    journal: /dev/nvme0n1p2
    data_vg: vg-cephbi-nvme0n1
  - data: lv-cephdata-sdc
    journal: /dev/nvme0n1p3
    data_vg: vg-cephdata-sdc
  - data: lv-cephdata-sdd
    < SNIP >


* # ansible-playbook site.yml
   < RUNS FOR 45 minutes…>
* # ceph -s ← HEALTH_OK  312 OSDs

TO USE THE NVMe-based Bucket Index OSDs
---------------------------------------
Create a new crush rule
* # ceph osd crush rule create-replicated bucketindex default host ssd                       
* # ceph osd crush rule ls
* # ceph osd crush rule dump bucketindex

Create a pool using the new rule
* # ceph osd pool create bucket-pool 256 256 replicated bucketindex
