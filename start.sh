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


BUILD_PRIVATE_KEY=.vagrant/machines/build/libvirt/private_key
ADMIN_PRIVATE_KEY=.vagrant/machines/admin/libvirt/private_key
INVENTORY_FILE=.vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory

if [ -z $1 ]; then
    BRANCH="master"
else
    BRANCH=$1
fi

# Setup variables for ansible
export PYTHONUNBUFFERED=1
export ANSIBLE_FORCE_COLOR=true
export ANSIBLE_HOST_KEY_CHECKING=false
export ANSIBLE_SSH_ARGS='-o UserKnownHostsFile=/dev/null -o IdentitiesOnly=yes -o ControlMaster=auto -o ControlPersist=60s'

echo "##########################################################################"
echo "# Bringing up machines"
echo "##########################################################################"
vagrant up

echo "##########################################################################"
echo "# Building fleet commander: $BRANCH"
echo "##########################################################################"
ansible-playbook --private-key=$BUILD_PRIVATE_KEY -u vagrant -i $INVENTORY_FILE -v ansible/playbooks/build.yml --extra-vars repo_version=$BRANCH

echo "##########################################################################"
echo "# Syncing vagrant directory"
echo "##########################################################################"
vagrant rsync

echo "##########################################################################"
echo "# Installing fleet commander in admin machine"
echo "##########################################################################"
ansible-playbook --private-key=$ADMIN_PRIVATE_KEY -u vagrant -i $INVENTORY_FILE -v ansible/playbooks/install.yml

echo "##########################################################################"
echo "# Finshed. Connect to http://$(vagrant ssh admin -c "ip address show eth0 | grep 'inet ' | sed -e 's/^.*inet //' -e 's/\/.*$//' | cat -v | sed -e 's/\^M//g' | sed -e 's/ //g'"):8008"
echo "##########################################################################"
