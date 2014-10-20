echo Checking whether swap already exists

ls -al /swapfile > /dev/null
if [ $? -ne 0 ] ; then

	echo No existing swap file. Preparing new swap file.
	dd if=/dev/zero of=/swapfile bs=1024 count=1024k
	chmod 0600 /swapfile
	mkswap /swapfile
	swapon /swapfile

	echo Adding to fstab
	echo "/swapfile          swap            swap    defaults        0 0" >> /etc/fstab

	echo Setting swappiness
	echo "vm.swappiness=10" >> /etc/sysctl.conf

fi

echo Swap settings:
swapon -s
