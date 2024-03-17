#!/bin/bash

TYPE=$1
if [[ $TYPE != 1 && $TYPE != 2 && $TYPE != 3 ]]; then
    echo "Please specify program type (1, 2 or 3)."
    exit 1
fi

source config.sh

IFINDEX_1_H=$(ip link show dev $VETH_1_HOST | grep -m 1 -o '^[^:]*')
IFINDEX_1_C=$(sudo ip netns exec $NETNS_1 ip link show dev $VETH_1_CTN | grep -m 1 -o '^[^:]*')
IFINDEX_2_H=$(ip link show dev $VETH_2_HOST | grep -m 1 -o '^[^:]*')
IFINDEX_2_C=$(sudo ip netns exec $NETNS_2 ip link show dev $VETH_2_CTN | grep -m 1 -o '^[^:]*')

cd ../libbpf-bootstrap/examples/c
make IFINDEX_1_H=$IFINDEX_1_H IFINDEX_1_C=$IFINDEX_1_C IFINDEX_2_H=$IFINDEX_2_H IFINDEX_2_C=$IFINDEX_2_C

if [[ $TYPE == 3 ]]; then
    TC1_NETNS="ip netns exec $NETNS_1"
    TC2_NETNS="ip netns exec $NETNS_2"
fi
sudo $TC1_NETNS ./tc1 $TYPE > /dev/null 2>&1 &
PID_1=$!
sudo $TC2_NETNS ./tc2 $TYPE > /dev/null 2>&1 &
PID_2=$!

cd -
sudo ip netns exec $NETNS_1 netserver
sudo ip netns exec $NETNS_2 netperf -t TCP_RR -H $VETH_1_IP_NO_MASK -l 3 >> out.txt 2>&1

sudo kill -SIGINT $PID_1 $PID_2
