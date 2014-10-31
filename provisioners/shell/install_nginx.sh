echo Installing nginx

yum -y install epel-release
yum -y install nginx

# Add our configuration file that reverse proxies to ghost
cp /vagrant/nginx/nginx.conf /etc/nginx/nginx.conf

mkdir -p /etc/nginx/certs
cd /etc/nginx/certs

# If user provides certificates in /vagrant/certificates, use them instead...
if [ -e /vagrant/certificates/server.crt -a -e /vagrant/certificates/server.key ]; then
  echo "Using user provided certificates for Server"
  cp /vagrant/certificates/server.crt /etc/nginx/certs/server.crt
  cp /vagrant/certificates/server.key /etc/nginx/certs/server.key
else
  echo Generating a self signed certificate to allow HTTPS connections
  openssl genrsa -out server.key 2048
  openssl req -new -key server.key -out server.csr -subj "/CN=ghost-example.thecruskit.com"
  openssl x509 -req -days 3650 -in server.csr -signkey server.key -out server.crt
fi
chown nginx:nginx *
chmod 700 *


# Start it up & set it to start on boot
systemctl start nginx.service
systemctl enable nginx.service
