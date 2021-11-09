# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

current_dir     = File.dirname(File.expand_path(__FILE__))
hosts           = YAML.load_file("#{current_dir}/inventory/hosts.yml")
scenario        = hosts['all']['vars']['scenario']
hosts           = hosts['all']['children'][scenario]

Vagrant.configure("2") do |config|
  hosts.each do |host|
    host_config   = YAML.load_file("#{current_dir}/inventory/host_vars/#{host[0]}/vagrant.yml")
    config.vm.boot_timeout = 600
    config.vm.box = host_config['box']
    config.vm.synced_folder host_config['synced_folder'], "/home/vagrant/Documents"
    config.vm.define host_config['hostname']
    config.vm.hostname = host_config['hostname']
    config.vm.provider :virtualbox do |vb|
      vb.name = host_config['hostname']
      vb.gui = host_config['gui']
      if (host_config.has_key? "customize_opts")
        host_config['customize_opts'].each do |opt, setting|
          vb.customize ["modifyvm", :id, opt, setting]
        end
      end
    end

    if (host_config.has_key? "forwarded_port")
      host_config['forwarded_port'].each do |host, guest|
        config.vm.network "forwarded_port", guest: guest, host: host
      end
    end

    config.ssh.username = host_config['ansible_user']
    config.ssh.insert_key = "false"

    if (host_config.has_key? "file_provision")
      host_config['file_provision'].each do |src, dest|
        config.vm.provision "file", source: src, destination: dest
      end
    end

    config.vm.provision "shell", path: "./preinstall.sh"
    config.vm.provision "ansible_local" do |ansible|
      ansible.playbook = "converge.yml"
      ansible.galaxy_role_file = "roles/requirements.yml"
      ansible.limit          = scenario
      ansible.inventory_path = "inventory/hosts.yml"
    end

    if (host_config.has_key? "shell_provision")
      host_config['shell_provision'].each do | cmd |
        config.vm.provision "shell", privileged: false, inline: cmd
      end
    end
  end
end
