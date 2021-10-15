# ansible2vagrant

VM Provisioning with vagrant the ansible way

## Requirements

* vagrant
* vagrant-virtualbox
* virtualbox

## Vagrantfile

No modification should be needed to the `Vagrantfile`
Vagrant loads the box and configures virtualbox

## hosts.yml

| Variable | default | description |
|:---:|:---:|:---:|
| scenario | *dev* | The name for your scenario. You can have multiple scenarios |
| group | *dev* | create a group and put all hosts which should be setup in this group |
| hosts | *host_one* | host to create. Multiple values allowed |

## inventory/host_vars/*host*/vagrant.yml

This file should be inside a directory named like the host to be created.
See subsection name for example.

| Variable | default | description |
|:---:|:---:|:---:|
| ansible_user | "vagrant" | This is the user which vagrant uses to connect to the host and run its blobs. Should initially set to vagrant |
| box | "ubuntu/focal64" | Vagrant box to use |
| synced_folder | "sync/" | folder to sync |
| hostname: | "foobar" | hostname |
| gui: | false | true if gui is used |
| customize_opts | *truncated* see host_vars/host_one/vagrant.yml | customization options for virtual box see `VBoxManage --help` for an overview |
| forwarded_port | *truncated* see host_vars/host_one/vagrant.yml | Ports to forward |
| file_provision | *truncated* see host_vars/host_one/vagrant.yml | Files to provision |
| shell_provision | *truncated* see host_vars/host_one/vagrant.yml | Shell scripts to run on host |

## Execution

1. Creates VM in virtualbox
2. File provsioning
3. preinstall.sh | bash
4. ansible execution
5. shell execution

## preinstall.sh

Changes vagrant user password to `vagrant`
Install ansible
**NOTE: change password**

## ansible play

Vagrant executes the ansible playbook `converge.yml`
Adjust this to your needs.
Vagrant also installs all the needed roles (if one).
So update the requirements.yml.
