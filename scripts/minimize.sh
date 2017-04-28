#!/bin/bash -eux

set -o nounset

echo "==> Disk usage before minimization"
df -h

echo "==> Installed packages before cleanup"
dpkg --get-selections | grep -v deinstall

if [[ "${PACKER_BUILDER_TYPE:=empty}" != "docker" ]]; then
    # Remove some packages to get a minimal install
    echo "==> Removing all linux kernels except the currrent one"
    dpkg --list | awk '{ print $2 }' | grep 'linux-image-3.*-generic' | grep -v $(uname -r) | xargs apt-get -y purge
    echo "==> Removing linux headers"
    dpkg --list | awk '{ print $2 }' | grep linux-headers | xargs apt-get -y purge
    rm -rf /usr/src/linux-headers*
    echo "==> Removing linux source"
    dpkg --list | awk '{ print $2 }' | grep linux-source | xargs apt-get -y purge
    echo "==> Removing development packages"
    dpkg --list | awk '{ print $2 }' | grep -- '-dev$' | xargs apt-get -y purge
    echo "==> Removing documentation"
    dpkg --list | awk '{ print $2 }' | grep -- '-doc$' | xargs apt-get -y purge
    apt-get -y purge build-essential
    echo "==> Removing desktop components"
    apt-get -y purge gnome-getting-started-docs
    apt-get -y purge $(dpkg --get-selections | grep -v deinstall | grep libreoffice | cut -f 1)
    echo "==> Removing obsolete networking components"
    apt-get -y purge ppp pppconfig pppoeconf
    echo "==> Removing other oddities"
    apt-get -y purge popularity-contest installation-report wireless-tools wpasupplicant
    if [[ "${PACKER_BUILDER_TYPE:=empty}" =~ "virtualbox" ]]; then
      echo "==> Removing default system Ruby"
      apt-get -yf purge ruby ri doc libffi5
      echo "==> Removing default system Python"
      apt-get -yf purge python-dbus libnl1 python-smartpm python-twisted-core libiw30 python-twisted-bin libdbus-glib-1-2 python-pexpect python-pycurl python-serial python-gobject python-pam python-openssl
    fi;
fi;
echo "==> Removing puppet"
apt-get purge -y puppet-agent puppetlabs-*
# Clean up the apt cache
echo "==> Cleaning up the apt cache"
apt-get -y autoremove --purge
apt-get -y autoclean
apt-get -y clean

echo "==> Removing man pages"
find /usr/share/man -type f -delete
echo "==> Removing APT files"
find /var/lib/apt -type f -delete
echo "==> Removing any docs"
find /usr/share/doc -type f -delete
echo "==> Removing caches"
find /var/cache -type f -delete
echo "==> Removing groff info lintian linda"
rm -rf /usr/share/groff/* /usr/share/info/* /usr/share/lintian/* /usr/share/linda/*

echo "==> Disk usage after cleanup"
df -h
