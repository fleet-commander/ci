# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.define "admin" do |admin|
    admin.vm.box = "fedora/23-cloud-base"

    admin.vm.network "forwarded_port", guest: 8008, host: 8088
    admin.vm.network "forwarded_port", guest: 8181, host: 8188

    admin.vm.provider "libvirt" do |domain|
      domain.memory = 1024
      #domain.cpus = 2
      #domain.nested = true
      #domain.volume_cache = 'none'
    end

    config.vm.provision "shell", inline: <<-SHELL
      sudo dnf install -y docker ansible python-docker-py
      #sudo dnf update -y
      sudo systemctl enable docker
      sudo systemctl start docker
      sudo /vagrant/rebuild-images.sh 23
      sudo /vagrant/run.sh 23
    SHELL
  end

end


#build.vm.box = "fedora/23-cloud-base"
#build.vm.box_check_update = false
#build.vm.network "private_network", ip: "192.168.33.10"
#build.vm.network "public_network"
#build.vm.synced_folder "../data", "/vagrant_data"