#!/bin/bash

source config.sh

sudo ip link delete $VETH_1_HOST
sudo ip link delete $VETH_2_HOST
sudo ip netns delete $NETNS_1
sudo ip netns delete $NETNS_2
