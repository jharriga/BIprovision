#!/bin/bash -x
# input units are MB
dev=$1
parts=$2
BI_sz=$3
ceph_journal_sz=$4
if [ -z "$ceph_journal_sz" ] ; then exit 1 ; fi 
partprobe $dev

delay()
{
  echo 'import time; time.sleep(0.2)' | python
}

# first partition is always for Bucket Index OSD
b=1
(( e = $b + $BI_sz )) 
delay
(parted -s -a optimal $dev mkpart logical ${b}M ${e}M && \
  parted -s $dev name 1 bi) || exit 1
(( b = $b + $BI_sz ))

# now add FS journal partitions
for p in `seq 2 $parts` ; do
  (( e = $b + $ceph_journal_sz ))
  delay
  (parted -s -a optimal $dev mkpart logical ${b}M ${e}M && \
   parted -s $dev name $p ceph_journal_$p) || exit 1
  (( b = $b + $ceph_journal_sz ))
done
partprobe $dev
