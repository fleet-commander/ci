#!/bin/bash
# Copyright (C) 2016 Red Hat, Inc.
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the licence, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this program; if not, see <http://www.gnu.org/licenses/>.
#
# Author: Oliver Gutiérrez <ogutierrez@redhat.com>

systool -m kvm_intel -A nested | grep nested | grep Y > /dev/null 2>&1

if [ $? != 0 ]; then
    echo "##########################################################################"
    echo "# WARNING: KVM module not loaded with nested=1 or error running systool"
    echo "# Please check you have installed systool command in your system and"
    echo "# check that you have loaded your KVM module with nested virtualization"
    echo "# enabled."
    echo "# You can check it by running:"
    echo "#     systool -m kvm_intel -A nested"
    echo "##########################################################################"
    echo -e "Do you want me to try to reload KVM module? (y/n)"
    read answer
    if [ $answer != 'y' ] && [ $answer != 'Y' ]; then
        exit 1
    else
        sudo rmmod kvm_intel
        sudo modprobe kvm_intel nested=1
        if [ $? != 0 ]; then
            echo "KVM module reloaded with nested virtualization enabled"
        fi
    fi
fi

# Check we have our box file
if [ ! -f ./fedora.box ]; then
    echo "##########################################################################"
    echo "# Downloading fedora box"
    echo "##########################################################################"
    wget https://download.fedoraproject.org/pub/fedora/linux/releases/23/Cloud/x86_64/Images/Fedora-Cloud-Base-Vagrant-23-20151030.x86_64.vagrant-libvirt.box -O fedora.box
    if [ $? != 0 ]; then
        echo "Failed to download box"
        exit 1
    fi
    echo "##########################################################################"
    echo "# Adding fedora box"
    echo "##########################################################################"
    vagrant box add ./fedora.box --name fedora/23-cloud-base --force
fi

echo "##########################################################################"
echo "# Bringing up machines"
echo "##########################################################################"
vagrant up
exit $?


