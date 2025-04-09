#! /bin/bash

iptables -t mangle -A PREROUTING -j TEE -i eth0 --gateway zeek

iptables -t mangle -L -n >> /root/

tail -f /dev/null
