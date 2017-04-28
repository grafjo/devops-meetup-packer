#!/bin/bash -eux


if [[ ! -e /usr/bin/lsb_release ]]
then
    echo "going to install lsb-release!"
    apt-get update
    apt-get install -y lsb-release
fi

if [[ ! -e /usr/bin/wget ]]
then
    echo "going to install wget!"
    apt-get install -y wget
fi

DEB_RELEASE=$(/usr/bin/lsb_release -cs)
DEB_NAME="puppetlabs-release-pc1-${DEB_RELEASE}.deb"

echo "==> Installing Puppet Collections"
wget http://apt.puppetlabs.com/${DEB_NAME}
dpkg -i ${DEB_NAME}
apt-get update

echo "==> Installing latest puppet-agent version"
apt-get install -y puppet-agent
rm -f ${DEB_NAME}
