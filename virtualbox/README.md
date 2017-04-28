
## Virtualbox ovf Basis Image erstellen:

```bash
packer build virtualbox-iso.json
virtualbox-iso output will be in this color.

==> virtualbox-iso: Downloading or copying Guest additions
    virtualbox-iso: Downloading or copying: file:///usr/share/virtualbox/VBoxGuestAdditions.iso
==> virtualbox-iso: Downloading or copying ISO
    virtualbox-iso: Downloading or copying: file:///home/joo/git/packer_meetup/demo/virtualbox/isos/debian-8.7.1-amd64-CD-1.iso
==> virtualbox-iso: Starting HTTP server on port 8817
==> virtualbox-iso: Creating virtual machine...
==> virtualbox-iso: Creating hard drive...
==> virtualbox-iso: Creating forwarded port mapping for communicator (SSH, WinRM, etc) (host port 3058)
==> virtualbox-iso: Executing custom VBoxManage commands...
    virtualbox-iso: Executing: modifyvm debian8 --memory 2048
    virtualbox-iso: Executing: modifyvm debian8 --cpus 2
==> virtualbox-iso: Starting the virtual machine...
    virtualbox-iso: The VM will be run headless, without a GUI. If you want to
    virtualbox-iso: view the screen of the VM, connect via VRDP without a password to
    virtualbox-iso: rdp://127.0.0.1:5938
==> virtualbox-iso: Waiting 10s for boot...
==> virtualbox-iso: Typing the boot command...
==> virtualbox-iso: Waiting for SSH to become available...
==> virtualbox-iso: Connected to SSH!
==> virtualbox-iso: Uploading VirtualBox version info (5.1.20)
==> virtualbox-iso: Uploading VirtualBox guest additions ISO...
==> virtualbox-iso: Provisioning with shell script: ../scripts/virtualbox.sh
    virtualbox-iso:
    virtualbox-iso: We trust you have received the usual lecture from the local System
    virtualbox-iso: Administrator. It usually boils down to these three things:
    virtualbox-iso:
    virtualbox-iso: #1) Respect the privacy of others.
    virtualbox-iso: #2) Think before you type.
    virtualbox-iso: #3) With great power comes great responsibility.
    virtualbox-iso:
    virtualbox-iso: ==> Installing VirtualBox guest additions
    virtualbox-iso: Reading package lists...
    virtualbox-iso: Building dependency tree...
    virtualbox-iso: Reading state information...
    virtualbox-iso: perl is already the newest version.
    virtualbox-iso: build-essential is already the newest version.
    virtualbox-iso: linux-headers-3.16.0-4-amd64 is already the newest version.
    virtualbox-iso: 0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
    virtualbox-iso: Reading package lists...
    virtualbox-iso: Building dependency tree...
    virtualbox-iso: Reading state information...
    virtualbox-iso: dkms is already the newest version.
    virtualbox-iso: 0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
    virtualbox-iso: [sudo] password for vagrant: mount: /dev/loop0 is write-protected, mounting read-only
    virtualbox-iso: Verifying archive integrity... All good.
    virtualbox-iso: Uncompressing VirtualBox 5.1.20 Guest Additions for Linux...........
    virtualbox-iso: VirtualBox Guest Additions installer
    virtualbox-iso: Copying additional installer modules ...
    virtualbox-iso: Installing additional modules ...
    virtualbox-iso: vboxadd.sh: Starting the VirtualBox Guest Additions.
==> virtualbox-iso: Provisioning with shell script: ../scripts/remove-cdrom-sources.sh
    virtualbox-iso: ==> Disabling CDROM entries to avoid prompts to insert a disk
    virtualbox-iso: [sudo] password for vagrant:
==> virtualbox-iso: Gracefully halting virtual machine...
    virtualbox-iso: [sudo] password for vagrant:
==> virtualbox-iso: Preparing to export machine...
    virtualbox-iso: Deleting forwarded port mapping for the communicator (SSH, WinRM, etc) (host port 3058)
==> virtualbox-iso: Exporting virtual machine...
    virtualbox-iso: Executing: export debian8 --output output-debian8-virtualbox-iso/debian8.ovf
==> virtualbox-iso: Unregistering and deleting virtual machine...
Build 'virtualbox-iso' finished.

==> Builds finished. The artifacts of successful builds are:
--> virtualbox-iso: VM files in directory: output-debian8-virtualbox-iso
```
