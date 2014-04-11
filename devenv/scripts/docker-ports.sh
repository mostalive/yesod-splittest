#!/bin/sh
# expose docker ports in boot2docker VM to host
# see http://docs.docker.io/en/latest/installation/mac/
# vm must be powered off

for i in {49000..49900}; do
 VBoxManage modifyvm "boot2docker-vm" --natpf1 "tcp-port$i,tcp,,$i,,$i";
 VBoxManage modifyvm "boot2docker-vm" --natpf1 "udp-port$i,udp,,$i,,$i";
done
