#!/bin/bash

cd ~
git clone https://github.com/fleet-commander/fc-admin.git
cd ~/fc-admin/
git submodule init && git submodule update
./autogen.sh
make check && make distcheck; cat tests/test-suite.log
make && make dist
mkdir -p ~/rpmbuild/SOURCES/
cp ~/fc-admin/fleet-commander*.tar.xz ~/rpmbuild/SOURCES/
rpmbuild -ba fleet-commander-admin.spec
