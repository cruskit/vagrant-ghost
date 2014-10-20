echo Installing nodejs

yum -y install epel-release && \
yum -y install nodejs npm;

echo nodejs version: `node --version`
