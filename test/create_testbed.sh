#!/bin/bash

source config.sh

sudo ip netns add $NETNS_1
sudo ip netns add $NETNS_2
sudo ip link add $VETH_1_HOST type veth peer name $VETH_1_CTN
sudo ip link add $VETH_2_HOST type veth peer name $VETH_2_CTN
sudo ip link set $VETH_1_HOST up
sudo ip link set $VETH_2_HOST up
sudo ip link set $VETH_1_CTN netns $NETNS_1
sudo ip link set $VETH_2_CTN netns $NETNS_2
sudo ip netns exec $NETNS_1 ip addr add $VETH_1_IP dev $VETH_1_CTN
sudo ip netns exec $NETNS_2 ip addr add $VETH_2_IP dev $VETH_2_CTN
sudo ip netns exec $NETNS_1 ip link set $VETH_1_CTN up
sudo ip netns exec $NETNS_2 ip link set $VETH_2_CTN up

