vagrant-ghost
=============

Uses [Vagrant](http://www.vagrantup.com) to configure [Ghost](https://ghost.org)
fronted by [nginx](http://nginx.org) as a reverse proxy ready for your blogging pleasure.

Note that this is currently only configured to work with
[Digital Ocean](https://www.digitalocean.com). I'll add other providers when I get the time...
If you haven't got a Digital Ocean account, you can
 [sign up here to get a $10 credit](https://www.digitalocean.com/?refcode=5edce6a2efb4)
 to test it out.
# Install

Install [Vagrant](http://www.vagrantup.com) and
the [Vagrant Digital Ocean Provider Plugin](https://github.com/smdahlen/vagrant-digitalocean).

Clone the repository to get a copy of the code:

```
git clone https://github.com/cruskit/vagrant-ghost.git
```

# Configure

You will need to configure some environment variables to customize the creation process.
These are:

* `DO_AUTH_TOKEN` : the Authorisation Token to use with Digital Ocean.
Log into the Digital Ocean console, use "Apps & Apis" and generate a Personal Access Token to use here.
* `PRIVATE_KEY_PATH` : the location of the private key to use with SSH when provisioning & accessing your Digital Ocean droplet.
* `TARGET_HOST_NAME` : the hostname to give for the provisioned machine. If you have a DNS name for the machine, this would be ideal to use here.

If you are feeling lazy, you may want to just create a file, for example `setenv.sh` with contents:

```
export DO_AUTH_TOKEN="my token"
export PRIVATE_KEY_PATH="~/.ssh/private_key_name"
export TARGET_HOST_NAME="myhostname"
```
and then run `source ./setenv.sh` to set the environment variables.

# Run

To provision your machine run the following from the directory where you cloned the code:

```
vagrant up --provider=digital_ocean
```

This will create you a new Digital Ocean Droplet (virtual machine) and install and configure Ghost & nginx.

Once this completes you can access Ghost at:

* https://<droplet_ip/

You will need to login and create an admin account at:

* https://<droplet_ip/ghost

Note that the server is configured with a self signed certificate so you'll need to click
through the certificate warning in your browser.

Some useful commands for working with your machine:

* `vagrant ssh` : will log you into the Droplet as root so you can do some more fine tuning
* `vagrant destroy` : will terminate the Droplet and remove it so you stop getting charged for it

# Things to note

### SSL Certificates
The install will automatically create you a self signed certificate so that HTTPS connections will work.
nginx is configured to look for the following certificates, so you can replace these if you've generated
some properly signed certificates for your domain:
* /etc/nginx/certs/server.crt;
* /etc/nginx/certs/server.key;

### Managing nginx & ghost

Ghost and nginx are configured to be managed by systemd. They are configured for automatic restart on boot.

If you make a configuration change you can restart them by:

* `systemctl restart nginx`
* `systemctl restart ghost`

Note that there are also corresponding commands for stop/start/status. nginx also supports a reload
command if you have just modified the configuration.

# List of potential future enhancements

These are things that are on the list for later:
* automatically copying certs from the /vagrant to the right location
* support for VirtualBox & AWS Vagrant Providers
* ghost theme installation as part of instance creation
* nginx log file rotation & archiving / cleanup
* npm log file rotation & archiving / cleanup
