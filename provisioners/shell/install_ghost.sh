echo Installing latest ghost from ghost.org

# If SE Linux enabled (eg: AWS Centos image), make sure this port not blocked
echo Adding port 2368 to se_linux allowed http ports
semanage port -a -t http_port_t  -p tcp 2368

# Work out what the public IP address for the instance is
# If we had a domain name, this really should get inserted here instead
PUBLIC_IP=`curl -s --connect-timeout 2 http://169.254.169.254/latest/meta-data/public-ipv4`
if [[ $PUBLIC_IP =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
		echo Using AWS reported public IP of $PUBLIC_IP
else
		PUBLIC_IP=`ifconfig eth0 | grep inet | grep -v inet6 | awk {'print $2'}`
		echo Using Host machine IP of $PUBLIC_IP
fi

yum -y install unzip && \
yum -y install wget && \
cd /tmp && \
wget -nv https://ghost.org/zip/ghost-latest.zip && \
unzip -o ghost-latest.zip -d /ghost && \
rm -f ghost-latest.zip && \
cd /ghost && \
npm install --production && \
sed "s~http://my-ghost-blog.com~https://${PUBLIC_IP}~" /ghost/config.example.js > /ghost/config.js;

# Alternate to IP address is to rename to host name (if registered in DNS)
#sed "s/my-ghost-blog.com/`hostname`/" /ghost/config.example.js > /ghost/config.js;

getent passwd ghost > /dev/null 2&>1
if [ $? -eq 0 ]; then
    echo "Ghost user already exists"
else
    useradd ghost --home /ghost
fi

chown -R ghost:ghost /ghost ;

# Configure Ghost to run as a service and start it up
cp /vagrant/ghost/ghost.service /etc/systemd/system/ghost.service
systemctl start ghost.service
systemctl enable ghost.service
