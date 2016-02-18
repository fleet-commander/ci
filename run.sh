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

BASEDIR=/vagrant
COMMAND=$0
DIST=23

if [ $UID != 0 ]; then
    echo "You must have root privileges to execute this script"
    exit 1
fi

function usage {
    echo "Usage: $COMMAND [--help]"
}

function help {
    usage
    echo -e "\t--help: Shows this help"
}

if [[ $* == *--help* ]]; then
    help
    exit 1
fi

export ANSIBLE_HOST_KEY_CHECKING=False

# Build packages
rm -rf $BASEDIR/packages > /dev/null 2>&1
ansible-playbook -i $BASEDIR/hosts --private-key=$BASEDIR/id_rsa $BASEDIR/data/$DIST/playbooks/run-containers.yml
ansible-playbook -i $BASEDIR/hosts --private-key=$BASEDIR/id_rsa $BASEDIR/data/$DIST/playbooks/build-packages.yml
docker cp fc-build-$DIST:/root/rpmbuild/RPMS/noarch $BASEDIR/packages

# Reinstall admin package
dnf remove -y fleet-commander-admin
dnf install -y $BASEDIR/packages/fleet-commander-admin*.rpm

# Create link for fleet-commander-admin in httpd
if [ ! -L /etc/httpd/conf.d/fleet-commander-apache.conf ]; then
    ln -s /etc/xdg/fleet-commander-apache.conf /etc/httpd/conf.d/
fi

# Restart httpd service
systemctl restart httpd