#!/bin/bash

NETNS_1=container1
NETNS_2=container2

VETH_1_HOST=veth1
VETH_1_CTN=veth2
VETH_2_HOST=veth3
VETH_2_CTN=veth4

VETH_1_IP=10.0.0.2/24
VETH_2_IP=10.0.0.3/24

VETH_1_IP_NO_MASK=$(echo $VETH_1_IP | cut -d '/' -f 1)
VETH_2_IP_NO_MASK=$(echo $VETH_2_IP | cut -d '/' -f 1)