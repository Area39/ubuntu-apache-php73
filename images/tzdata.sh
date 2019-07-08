export DEBIAN_FRONTEND=noninteractive

apt-get install -y tzdata

ln -fs /usr/share/zoneinfo/Indian/Maldives /etc/localtime

dpkg-reconfigure --frontend noninteractive tzdata