#!/bin/bash

# This will perform a certificate renewal using letsencrypt for the domain
#
# TODO: note that you need to change the domain names below

DIR=/wwwroot/letsencrypt
mkdir -p $DIR

# Fix SELinux permissions so that nginx can read it
chcon -Rt httpd_sys_content_t ${DIR}

# Perform the certificate renewal
/root/.local/share/letsencrypt/bin/letsencrypt certonly \
  --renew-by-default \
  --server  https://acme-v01.api.letsencrypt.org/directory \
  --webroot \
  --webroot-path=${DIR} \
  --agree-tos \
  --email webmaster@cruskit.com \
  -d localhost.com \
  -d www.localhost.com 

# Reload the certificates in nginx
systemctl reload nginx