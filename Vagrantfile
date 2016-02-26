# -*- mode: ruby -*-
# vi: set ft=ruby :
#
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

Vagrant.configure(2) do |config|

  config.vm.define "build" do |build|
    build.vm.box = "fedora/23-cloud-base"

    build.vm.provision "ansible" do |ansible|
      ansible.limit = "build"
      ansible.verbose = "vv"
      ansible.playbook = "ansible/playbooks/provision.yml"
    end
  end

  config.vm.define "admin" do |admin|
    admin.vm.box = "fedora/23-cloud-base"

    admin.vm.provision "ansible" do |ansible|
      ansible.limit = "admin"
      ansible.verbose = "vv"
      ansible.playbook = "ansible/playbooks/provision.yml"
    end
  end

  config.vm.define "hyper" do |hyper|
    hyper.vm.box = "fedora/23-cloud-base"

    hyper.vm.provider "libvirt" do |domain|
      domain.nested = true
      domain.cpu_mode = "host-model"
      domain.memory = 1024
    end

    hyper.vm.provision "ansible" do |ansible|
      ansible.limit = "hyper"
      ansible.verbose = "vv"
      ansible.playbook = "ansible/playbooks/provision.yml"
    end
  end

end
