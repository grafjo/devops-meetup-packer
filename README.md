# Wartbare Machine oder Container Images mit Packer

Demo Beispiele des [Meetups DevOps Karlsruhe](https://www.meetup.com/de-DE/devops-karlsruhe/events/238926100)

## Voraussetzungen

* [Packer](https://www.packer.io/downloads.html)
* [Virtualbox](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](https://www.vagrantup.com/downloads.html)
* [Docker](https://docs.docker.com/engine/installation/)
* Virtualisierungsfunktion Intel VT-x im Bios aktiviert
* ein paar GB freien Arbeitsspeicher


## Packer Inspect / validate

Dummy VM hochfahren, wichtig ist `default: SSH address: 127.0.0.1:2222`

```bash
vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'debian/jessie64'...
==> default: Matching MAC address for NAT networking...
==> default: Checking if box 'debian/jessie64' is up to date...
==> default: Setting the name of the VM: demo_default_1493368731567_39813
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
==> default: Forwarding ports...
    default: 22 (guest) => 2222 (host) (adapter 1)
==> default: Running 'pre-boot' VM customizations...
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 127.0.0.1:2222
    default: SSH username: vagrant
    default: SSH auth method: private key
    default:
    default: Vagrant insecure key detected. Vagrant will automatically replace
    default: this with a newly generated keypair for better security.
    default:
    default: Inserting generated public key within guest...
    default: Removing insecure key from the guest if it's present...
    default: Key inserted! Disconnecting and reconnecting using new SSH key...
==> default: Machine booted and ready!
==> default: Checking for guest additions in VM...
    default: No guest additions were detected on the base box for this VM! Guest
    default: additions are required for forwarded ports, shared folders, host only
    default: networking, and more. If SSH fails on this machine, please install
    default: the guest additions and repackage the box to continue.
    default:
    default: This is not an error message; everything may continue to work properly,
    default: in which case you may ignore this message.
==> default: Installing rsync to the VM...
==> default: Rsyncing folder: /home/joo/git/talks/devops-meetup-packer/demo/ => /vagrant

==> default: Machine 'default' has a post `vagrant up` message. This is a message
==> default: from the creator of the Vagrantfile, and not from Vagrant itself:
==> default:
==> default: Vanilla Debian box. See https://atlas.hashicorp.com/debian/ for help and bug reports
```

Ansehen, was variables_demo.json alles verwendet

```bash
packer inspect variables_demo.json
Optional variables and their defaults:

  ssh_host     = {{env `PACKER_SSH_HOST`}}
  ssh_password = vagrant
  ssh_port     = {{env `PACKER_SSH_PORT`}}
  ssh_username = vagrant

Builders:

  null

Provisioners:

  shell

Note: If your build names contain user variables or template
functions such as 'timestamp', these are processed at build time,
and therefore only show in their raw form here.
```

Template validieren

```bash
packer validate variables_demo.json
Template validation failed. Errors are shown below.

Errors validating build 'null'. 1 error(s) decoding:

* cannot parse 'ssh_port' as int: strconv.ParseInt: parsing "": invalid syntax
```

Wir müssen erst die benötigten Environent Variablen setzten:
```bash
export PACKER_SSH_HOST=127.0.0.1
export PACKER_SSH_PORT=2222
packer validate variables_demo.json
Template validated successfully.
```

```bash
packer build variables_demo.json
null output will be in this color.

==> null: Waiting for SSH to become available...
==> null: Connected to SSH!
==> null: Provisioning with shell script: /tmp/packer-shell805071147
    null: precise64
    null: MAIL=/var/mail/vagrant
    null: SSH_CLIENT=10.0.2.2 59766 22
    null: USER=vagrant
    null: SHLVL=1
    null: HOME=/home/vagrant
    null: LOGNAME=vagrant
    null: _=/tmp/script_8523.sh
    null: PACKER_BUILDER_TYPE=null
    null: PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games
    null: SSH_AUTH_SOCK=/tmp/ssh-szwETU1167/agent.1167
    null: SHELL=/bin/bash
    null: PACKER_BUILD_NAME=null
    null: LC_ALL=en_US
    null: PWD=/home/vagrant
    null: SSH_CONNECTION=10.0.2.2 59766 10.0.2.15 22
Build 'null' finished.

==> Builds finished. The artifacts of successful builds are:
--> null: Did not export anything. This is the null builder
```


## Packer build / Urlaubsverwaltung

Kurzen Überblick, was das Template benötigt und macht:

```bash
packer inspect urlaubsverwaltung.json
Required variables:

  uv_version

Optional variables and their defaults:

  aws_access_key      = {{env `AWS_ACCESS_KEY`}}
  aws_instance_type   = t2.micro
  aws_region          = us-west-1
  aws_secret_key      = {{env `AWS_SECRET_KEY`}}
  aws_source_ami      = ami-94bdeef4
  docker_hub_password = {{env `DOCKER_HUB_PASSWORD`}}
  docker_hub_username = {{env `DOCKER_HUB_USERNAME`}}
  headless            = true
  install_vagrant_key = true
  ssh_password        = vagrant
  ssh_username        = vagrant
  vm_name             = urlaubsverwaltung

Builders:

  amazon-ebs    
  docker        
  virtualbox-ovf

Provisioners:

  shell
  shell
  shell
  puppet-masterless
  shell

Note: If your build names contain user variables or template
functions such as 'timestamp', these are processed at build time,
and therefore only show in their raw form here.
```

Vor einem Build das Template validieren:

```bash
packer validate \
   -var-file=docker_hub_credentials.json \
   -var-file=aws-credentials.json \
   -var uv_version=2.24.0 \
   urlaubsverwaltung.json
Template validation failed. Errors are shown below.

Errors validating build 'amazon-ebs'. 1 error(s) occurred:

* module_path[0] is invalid: stat puppet/modules/: no such file or directory

Errors validating build 'docker'. 1 error(s) occurred:

* module_path[0] is invalid: stat puppet/modules/: no such file or directory

Errors validating build 'virtualbox-ovf'. 1 error(s) occurred:

* module_path[0] is invalid: stat puppet/modules/: no such file or directory
```

Wir müssen die benötigten [Puppet Module](puppet/Puppetfile) runterladen

```bash
cd puppet
./setup.sh
==> installing librarian-puppet
Fetching gem metadata from https://rubygems.org/........
Fetching version metadata from https://rubygems.org/..
Fetching dependency metadata from https://rubygems.org/.
Installing CFPropertyList 2.2.8
Installing facter 2.4.6
Installing multipart-post 2.0.0
Installing fast_gettext 1.1.0
Installing locale 2.1.2
Installing text 1.3.1
Installing hiera 3.3.1
Installing json_pure 1.8.6
Installing thor 0.19.4
Installing minitar 0.6.1
Installing rsync 1.0.9
Using bundler 1.13.6
Installing faraday 0.9.2
Installing gettext 3.2.2
Installing librarianp 0.6.3
Installing faraday_middleware 0.10.1
Installing gettext-setup 0.24
Installing semantic_puppet 0.1.4
Installing puppet 4.10.0
Installing puppet_forge 2.2.4
Installing librarian-puppet 2.2.3
Bundle complete! 2 Gemfile dependencies, 21 gems now installed.
Bundled gems are installed into ./vendor/bundle.
Post-install message from minitar:
The `minitar` executable is no longer bundled with `minitar`. If you are
expecting this executable, make sure you also install `minitar-cli`.
==> running librarian-puppet
==> finished running librarian-puppet
```

Danach sollte die Validierung erfogleich verlaufen:

```bash
packer validate \
   -var-file=aws-credentials.json \
   -var-file=docker_hub_credentials.json \
   -var uv_version=2.24.0 \
   urlaubsverwaltung.json
Template validated successfully.
```


### Virtualbox / Vagrant Box

Zuerst muss das [Basis-Image](virtualbox/README.md) mit Debian jessie und Virtualbox Guest Additions) erstellt werden.

Danach kann das Urlaubsverwaltung-Image gebaut werden:

```bash
packer build \
  -only=virtualbox-ovf \
  -var uv_version=2.24.0 \
  urlaubsverwaltung.json
...
```

Fertige Vagrant Box liegt hier box/virtualbox/urlaubsverwaltung-2.24.0.box

### Amazon Machine Image (AMI)

_Hinweis_: [AWS Credentials](aws-credentials.json) eintragen!

```bash
packer build \
  -only=amazon-ebs \
  -var-file=aws-credentials.json \
  -var uv_version=2.24.0 \
  urlaubsverwaltung.json
...
```

### Docker Image

Docker Container erstellen und veröffentlichen:

_Hinweis_: [Docker Hub Credentials](docker_hub_credentials.json) eintragen!

```bash
packer build \
  -only=docker \
  -var-file=docker_hub_credentials.json \
  -var uv_version=2.24.0 \
  urlaubsverwaltung.json
...
```

### Images parallel bauen

```bash
packer build \
  -var-file=docker_hub_credentials.json \
  -var-file=aws-credentials.json \
  -var uv_version=2.24.0 \
  urlaubsverwaltung.json
...
```


## Packer Debugging

```bash
export PACKER_LOG=1
packer build -debug demo_debug.json
...
```


## Weiterführende Links

* [Demo-Anwendung Urlaubsverwaltung](https://github.com/synyx/urlaubsverwaltung)
* [Boxcutter](https://github.com/boxcutter)
* [Bento von Chef](https://github.com/chef/bento)
