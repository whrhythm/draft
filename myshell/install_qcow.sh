#!/bin/bash

/usr/bin/qemu-system-x86_64 \
-m 2048 -smp 2 -M pc \
-name kvmgt -cpu host -hda /home/ub-64.qcow \
-net nic -net tap,script=/etc/qemu-ifup \
-enable-kvm \
-machine kernel_irqchip=on \
-serial /dev/ttyS0 \
-cdrom /home/jzg/Downloads/CentOS-7-x86_64-DVD-1511.iso

