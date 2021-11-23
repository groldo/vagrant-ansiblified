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

    config.vm.define host[0] do |machine|

      machine.vm.boot_timeout = host_config['boot_timeout']
      machine.vm.box = host_config['box']
      machine.vm.hostname = host[0]

      if (host_config.has_key? "network")
        host_config['network'].each do |opt, setting|
          machine.vm.network opt, bridge: setting
        end
      end

      ### hyper-v config
      if (host_config['provider'] = 'hyper-v')

        machine.vm.synced_folder ENV['USERPROFILE']+"/Documents", '/home/vagrant/Documents', type: "smb"

        $preStartScript = <<-SCRIPT
        Set-VM #{host[0]} -EnhancedSessionTransportType HVSocket -verbose
        Set-VMProcessor -VMName #{host[0]} -HwThreadCountPerCore 2
        Set-VMFirmware -VMName #{host[0]} -FirstBootDevice (Get-VMHardDiskDrive -VMName #{host[0]})
        SCRIPT

        machine.vm.provider "hyperv" do |h,override|
            #h.enable_enhanced_session_mode = true
            h.enable_virtualization_extensions = true
            h.vmname = host[0]
            h.cpus = host_config['cpus']
            h.memory = host_config['memory']

            override.trigger.before :'VagrantPlugins::HyperV::Action::StartInstance', type: :action do |trigger|
                trigger.info = "---------------- Running pre Start Triggers -----------------"
                trigger.run = {inline: $preStartScript}
            end
        end
      end
     ### hyper-v config

      ### virtualbox config
      if (host_config['provider'] == 'virtualbox')

        machine.vm.synced_folder host_config['synced_folder'], "/home/vagrant/Documents"

        machine.vm.provider :virtualbox do |vb|
          vb.name = host[0]
          vb.gui = host_config['gui']
          if (host_config.has_key? "customize_opts")
            host_config['customize_opts'].each do |opt, setting|
              vb.customize ["modifyvm", :id, opt, setting]
            end
          end
        end
      end
      ### virtualbox config


      if (host_config.has_key? "forwarded_port")
        host_config['forwarded_port'].each do |host, guest|
          machine.vm.network "forwarded_port", guest: guest, host: host
        end
      end

      machine.ssh.username = host_config['ansible_user']
      machine.ssh.insert_key = "false"

      if (host_config.has_key? "file_provision")
        host_config['file_provision'].each do |src, dest|
          machine.vm.provision "file", source: src, destination: dest
        end
      end

      if (host_config.has_key? "shell_provision")
        host_config['shell_provision'].each do | cmd |
          machine.vm.provision "shell", privileged: false, inline: cmd
        end
      end

      machine.vm.provision "shell", path: "./preinstall.sh"
      machine.vm.provision "ansible_local" do |ansible|
        ansible.inventory_path = "inventory/hosts.yml"
        ansible.limit = "all"
        ansible.playbook = "converge.yml"
        ansible.galaxy_role_file = "roles/requirements.yml"
        ansible.limit          = host[0]
        ansible.inventory_path = "inventory/hosts.yml"
      end
    end
  end
end
  