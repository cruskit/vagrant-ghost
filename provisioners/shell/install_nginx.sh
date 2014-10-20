echo Installing nginx

yum -y install epel-release
yum -y install nginx

# Add our configuration file that reverse proxies to ghost
cp /vagrant/nginx/nginx.conf /etc/nginx/nginx.conf

# Generate a self signed certificate so we can force HTTPS connections
mkdir -p /etc/nginx/certs
cd /etc/nginx/certs
openssl genrsa -out server.key 2048
openssl req -new -key server.key -out server.csr -subj "/CN=ghost.example.com"
openssl x509 -req -days 3650 -in server.csr -signkey server.key -out server.crt
chown nginx:nginx *
chmod 700 *

# TODO: If user provides certificates in /vagrant, use them instead...

# Start it up & set it to start on boot
systemctl start nginx.service
systemctl enable nginx.service
