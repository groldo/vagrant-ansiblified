# ansible2vagrant

VM Provisioning with vagrant the ansible way

## Requirements

* vagrant
* vagrant-virtualbox
* virtualbox

## Vagrantfile

No modification should be needed to the `Vagrantfile`
Vagrant loads the box and configures virtualbox

## Create your own scenario

1. Create a value under `children`, this is the name of the scenario
2. adjust the name of the variable `scenario`
3. for all hosts in your scenario:
    1. copy paste the `hostone` directory under `host_vars`
    2. rename to your host names
    3. adjust to your needs, eg. memory and cpu
4. `vagrant up --color --provision` 

## hosts.yml

| Variable | default | description |
|:---:|:---:|:---:|
| scenario | *dev* | The name for your scenario. You can have multiple scenarios |
| group | *dev* | create a group and put all hosts which should be setup in this group |
| hosts | *hostone* | host to create. Multiple values allowed |

### Scenarios

You can have different scenarios in the same directory.

```yaml
all:
  vars:
    scenario: kubernetes
  children:
    dev:
      hosts:
        hostone:
    kubernetes:
      hosts:
        workerone:
        workertwo:
        master:
```

When `scenario: kubernetes` is set,
vagrant only recognizes hosts `workerone`, `workertwo` and `master`.
`vagrant up` creates these hosts

With `scenario: dev` set, all vagrant sees is `hostone`.
`vagrant up` only creates `hostone`.

When using this keep in mind in which scenario you are operating.
Otherwise `vagrant destroy` could break your setup.

## inventory/host_vars/*host*/vagrant.yml

This file should be inside a directory named like the host to be created.
See subsection name for example.

| Variable | default | description |
|:---:|:---:|:---:|
| ansible_user | "vagrant" | This is the user which vagrant uses to connect to the host and run its blobs. Should initially set to vagrant |
| box | "ubuntu/focal64" | Vagrant box to use |
| synced_folder | "sync/" | folder to sync |
| hostname: | "foobar" | hostname |
| gui: | false | When gui is true for hyperv `files/install_xrdp.sh` is executed |
| customize_opts | *truncated* see host_vars/hostone/vagrant.yml | customization options for virtual box see `VBoxManage --help` for an overview |
| forwarded_port | *truncated* see host_vars/hostone/vagrant.yml | Ports to forward |
| file_provision | *truncated* see host_vars/hostone/vagrant.yml | Files to provision |
| shell_provision | *truncated* see host_vars/hostone/vagrant.yml | Shell scripts to run on host |

## Execution

1. Creates VM in virtualbox
2. File provsioning
5. shell execution
3. preinstall.sh | bash
4. ansible execution

## preinstall.sh

Changes vagrant user password to `vagrant`
Install ansible
**NOTE: change password**

## ansible play

Vagrant executes the ansible playbook `converge.yml`
Adjust this to your needs.
Vagrant also installs all the needed roles (if one).
So update the requirements.yml.

## Windows networking

Create bridge interface

```powershell
Get-NetAdapter
New-VMSwitch -Name Internet -NetAdapterName <your online NetAdapter> -AllowManagementOS $true
## Set trunk mode on VSwitch
Set-VMNetworkAdapterVlan -VMName foobar -Trunk -AllowedVlanIdList 0-100 -NativeVlanId 0
```
