# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.network "forwarded_port", guest: 80, host: 8080, auto_correct: true
  # config.vm.network "forwarded_port", guest: 3306, host: 3306, auto_correct: true

  config.vm.hostname = "sandbox.local"

  config.vm.provider "virtualbox" do |v|
    v.memory = "1024"
    v.cpus = 2
  end

  config.vm.provision "shell", path: "install.sh"
end
