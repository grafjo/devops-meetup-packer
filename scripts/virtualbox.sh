#!/bin/bash -eux

if [[ $PACKER_BUILDER_TYPE =~ virtualbox ]]; then
    echo "==> Installing VirtualBox guest additions"
    apt-get install -y linux-headers-$(uname -r) build-essential perl
    apt-get install -y dkms
    VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
    mount -o loop /home/vagrant/VBoxGuestAdditions_${VBOX_VERSION}.iso /mnt
    sh /mnt/VBoxLinuxAdditions.run --nox11
    umount /mnt
    rm /home/vagrant/VBoxGuestAdditions_${VBOX_VERSION}.iso
    rm /home/vagrant/.vbox_version

    if [[ $VBOX_VERSION = "5.1.20" ]]; then
        # thx to https://www.virtualbox.org/ticket/16670 we need this MONKEY patch!
        rm -f /sbin/mount.vboxsf
        ln -s /opt/VBoxGuestAdditions-5.1.20/lib/VBoxGuestAdditions/mount.vboxsf /sbin/mount.vboxsf
    fi
fi
