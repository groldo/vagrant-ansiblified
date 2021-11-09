# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

current_dir     = File.dirname(File.expand_path(__FILE__))
hosts           = YAML.load_file("#{current_dir}/inventory/hosts.yml")
scenario        = hosts['all']['vars']['scenario']
hosts           = hosts['all']['children'][scenario]['hosts']

ENV["VAGRANT_EXPERIMENTAL"]="1"
Vagrant.configure("2") do |config|
  hosts.each do |host|
    host_config   = YAML.load_file("#{current_dir}/inventory/host_vars/#{host[0]}/vagrant.yml")
    $preStartScript = <<-SCRIPT
    Set-VM #{host_config['hostname']} -EnhancedSessionTransportType HVSocket -verbose
    Set-VMProcessor -VMName #{host_config['hostname']} -HwThreadCountPerCore 2
    Set-VMFirmware -VMName #{host_config['hostname']} -FirstBootDevice (Get-VMHardDiskDrive -VMName #{host_config['hostname']})
    SCRIPT
    config.vm.boot_timeout = 600
    config.vm.box = host_config['box']
    #config.vm.synced_folder host_config['synced_folder'], "/home/vagrant/Documents"
    config.vm.synced_folder ENV['USERPROFILE']+"/Documents", '/home/vagrant/Documents', type: "smb"
    config.vm.define host_config['hostname']
    config.vm.hostname = host_config['hostname']
    config.vm.network "public_network", bridge: "Internet"
    config.vm.provider "hyperv" do |h,override|
        h.enable_virtualization_extensions = true
        h.enable_enhanced_session_mode = true
        h.vmname = host_config['hostname']
        h.cpus = 2
        h.memory = 4096

        override.trigger.before :'VagrantPlugins::HyperV::Action::StartInstance', type: :action do |trigger|
            trigger.info = "---------------- Running pre Start Triggers -----------------"
            trigger.run = {inline: $preStartScript}
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
      ansible.inventory_path = "inventory/hosts.yml"
      ansible.limit = "all"
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
  