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

    #build.vm.network "public_network" bridge => 'em1', :dev => 'em1'
    #build.vm.network "private_network", ip: "192.168.121.111"
    #build.vm.network "forwarded_port", guest: 8008, host: 8088
    #build.vm.network "forwarded_port", guest: 8989, host: 8989

    build.vm.provider "libvirt" do |domain|
      # Libvirt configuration
      #domain.uri = "qemu:///session"
      #domain.storage_pool_name = "gnome-boxes"

      # Domain configuration
      #domain.memory = 512
      #domain.cpus = 2
      #domain.nested = true
      #domain.volume_cache = 'none'
    end

    build.vm.provision "ansible" do |ansible|
      ansible.verbose = "v"
      ansible.playbook = "ansible/playbooks/provision.yml"
    end
  end

  config.vm.define "admin" do |admin|
    admin.vm.box = "fedora/23-cloud-base"

    admin.vm.provider "libvirt" do |domain|
      # Libvirt configuration
      #domain.uri = "qemu:///session"
      #domain.storage_pool_name = "gnome-boxes"
    end

    admin.vm.provision "ansible" do |ansible|
      ansible.verbose = "v"
      ansible.playbook = "ansible/playbooks/provision.yml"
    end
  end

end
