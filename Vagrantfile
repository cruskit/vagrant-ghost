# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "dummy"
  config.vm.hostname = ENV['TARGET_HOST_NAME']
  config.ssh.private_key_path = ENV['PRIVATE_KEY_PATH']

  config.vm.provider :digital_ocean do |digitalocean, override|

    override.vm.box = 'digital_ocean'
    digitalocean.vm.box = 'digital_ocean'
    digitalocean.token=ENV['DO_AUTH_TOKEN']

    # It seems as though the image name has changed
    #digitalocean.image = "CentOS 7.0 x64"
    digitalocean.image = "7.0 x64"

    digitalocean.region = "sgp1"
    digitalocean.size = "512MB"

  end

  config.vm.provider :aws do |aws, override|

    # Need this to get a tty session so that sudo will work on the Centos image
    config.ssh.pty='true'
    override.vm.box = 'dummy'
    override.ssh.username = "centos"

    override.ssh.private_key_path = ENV['AWS_PRIVATE_KEY_PATH']
    aws.access_key_id = ENV['AWS_ACCESS_KEY_ID']
    aws.secret_access_key = ENV['AWS_ACCESS_KEY']
    aws.keypair_name = ENV['AWS_KEYPAIR_NAME']

    aws.ami = 'ami-c7d092f7' # Centos 7
    aws.region = 'us-west-2'
    aws.instance_type = 't2.micro'
    aws.security_groups = ['WebServer']

    # Let's use SSD disks for more speed
    aws.block_device_mapping = [{
      'DeviceName' => '/dev/sda1',
      'Ebs.VolumeSize' => 8,
      'Ebs.VolumeType' => 'gp2',
      'Ebs.DeleteOnTermination' => 'true' }]

    aws.tags = {
    'Name' => 'blog'
    }

  end

  config.vm.provision "shell", path: "provisioners/shell/create_swap.sh"
  config.vm.provision "shell", path: "provisioners/shell/install_npm.sh"
  config.vm.provision "shell", path: "provisioners/shell/install_ghost.sh"
  config.vm.provision "shell", path: "provisioners/shell/install_nginx.sh"

end
