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

COMMAND=$0

if [ $UID != 0 ]; then
    echo "You must have root privileges to execute this script"
    exit 1
fi

function usage {
    echo "Usage: $COMMAND FEDORA_RELEASE [--help]"
}

function help {
    usage
    echo -e "\t--help: Shows this help"
}

if [[ $* == *--help* ]]; then
    help
    exit 1
fi

if [ -z $1 ]; then
    usage
    exit 1
fi

export ANSIBLE_HOST_KEY_CHECKING=False

ansible-playbook -i hosts --private-key=id_rsa data/$1/playbooks/remove-containers.yml
ansible-playbook -i hosts --private-key=id_rsa data/$1/playbooks/run-containers.yml
ansible-playbook -i hosts --private-key=id_rsa data/$1/playbooks/build-packages.yml