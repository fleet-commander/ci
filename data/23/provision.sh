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

echo "##########################################################################"
echo "# Installation of needed packages"
echo "##########################################################################"
dnf install -y docker ansible python-docker-py httpd

echo "##########################################################################"
echo "# Enabling needed services"
echo "##########################################################################"
systemctl enable docker
systemctl start docker
systemctl enable httpd
systemctl start httpd

echo "##########################################################################"
echo "# Building docker image for package building"
echo "##########################################################################"
/vagrant/rebuild-images.sh

echo "##########################################################################"
echo "# Build and install packages"
echo "##########################################################################"
/vagrant/run.sh

echo "##########################################################################"
echo "# Finshed provisioning. Connect to http://$(ip address show eth0 | grep 'inet ' | sed -e 's/^.*inet //' -e 's/\/.*$//' | cat -v | sed -e 's/\^M//g' | sed -e 's/ //g'):8008"
echo "##########################################################################"
