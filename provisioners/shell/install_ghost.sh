echo Installing latest ghost from ghost.org

yum -y install unzip && \
cd /tmp && \
wget -nv https://ghost.org/zip/ghost-latest.zip && \
unzip -o ghost-latest.zip -d /ghost && \
rm -f ghost-latest.zip && \
cd /ghost && \
npm install --production && \
ifconfig eth0 | grep inet | grep -v inet6 | awk {'print $2'}
sed "s~http://my-ghost-blog.com~https://`ifconfig eth0 | grep inet | grep -v inet6 | awk {'print $2'}`~" /ghost/config.example.js > /ghost/config.js;

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
