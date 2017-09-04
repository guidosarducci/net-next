#!/bin/bash
DEV=ens160

tc qdisc del dev ens160 clsact
rmmod nf_conntrack_ipv4
rmmod nf_defrag_ipv4

set -ex
modprobe nf_defrag_ipv4
modprobe nf_conntrack_ipv4

#echo 'module nf_conntrack +p' > /sys/kernel/debug/dynamic_debug/control
#echo 'module nf_conntrack_ipv4 +p' > /sys/kernel/debug/dynamic_debug/control
#echo 'module ip_fragment +p' > /sys/kernel/debug/dynamic_debug/control
#echo 'module icmp +p' > /sys/kernel/debug/dynamic_debug/control

tc qdisc add dev ens160 clsact
tc filter add dev ens160 ingress bpf da obj tcbpf3_kern.o sec ct_lookup
tc filter add dev ens160  egress bpf da obj tcbpf3_kern.o sec ct_commit

exit 0
