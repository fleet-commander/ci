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
INVENTORY_FILE=.vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory

if [ -z $1 ]; then
    BRANCH="master"
else
    BRANCH=$1
fi

if [ -z $2 ]; then
    REPO="https://github.com/fleet-commander/fc-admin.git"
else
    REPO=$2
fi


echo "##########################################################################"
echo "# Building fleet commander: $BRANCH"
echo "##########################################################################"
PYTHONUNBUFFERED=1 \
ANSIBLE_FORCE_COLOR=true \
ANSIBLE_HOST_KEY_CHECKING=false \
ANSIBLE_SSH_ARGS='-o UserKnownHostsFile=/dev/null -o IdentitiesOnly=yes -o ControlMaster=auto -o ControlPersist=60s' \
ansible-playbook --private-key=$BUILD_PRIVATE_KEY -u vagrant -i $INVENTORY_FILE -vv ansible/playbooks/build.yml --extra-vars "repo_version=$BRANCH repo_address='$REPO'"

