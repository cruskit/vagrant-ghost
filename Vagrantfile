# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "digital_ocean"
  config.vm.hostname = ENV['TARGET_HOST_NAME']
  config.ssh.private_key_path = ENV['PRIVATE_KEY_PATH']

  config.vm.provider :digital_ocean do |provider|

      provider.token=ENV['DO_AUTH_TOKEN']
      provider.image = "CentOS 7.0 x64"
      provider.region = "sgp1"
      provider.size = "512MB"
  end

  config.vm.provision "shell", path: "provisioners/shell/create_swap.sh"
  config.vm.provision "shell", path: "provisioners/shell/install_npm.sh"
  config.vm.provision "shell", path: "provisioners/shell/install_ghost.sh"
  config.vm.provision "shell", path: "provisioners/shell/install_nginx.sh"

end
