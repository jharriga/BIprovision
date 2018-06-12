#!/usr/bin/python
from sys import argv

# units should be MB

# convert to MiB for LVM

MiB_per_MB = 1/1.024/1.024

fastdev_size = int(argv[1])
num_journals = int(argv[2])
ssd_journal_size = int(argv[3])

tot_journals = num_journals + 1      # add the extra journal for BI partition
journal_space = ssd_journal_size * tot_journals
bi_space = (fastdev_size - 1000.0) - journal_space

bi_size = bi_space / MiB_per_MB
print('%d' % int(bi_size))
