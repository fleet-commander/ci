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

cd ~
git clone https://github.com/fleet-commander/fc-admin.git
cd ~/fc-admin/
git submodule init && git submodule update
./autogen.sh
make check && make distcheck
cp tests/test-suite.log /data/
make && make dist
mkdir -p ~/rpmbuild/SOURCES/
cp ~/fc-admin/fleet-commander*.tar.xz ~/rpmbuild/SOURCES/
rpmbuild -ba fleet-commander-admin.spec
mkdir -p /data/packages
cp ~/rpmbuild/RPMS/* /data/packages
