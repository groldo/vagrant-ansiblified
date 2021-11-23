echo -e "vagrant\nvagrant" | sudo passwd vagrant
export DEBIAN_FRONTEND=noninteractive
ansible --version || (  
    sudo apt-get -y purge python2.7 python-minimal
    sudo apt-get update && sudo apt-get -q --option \"Dpkg::Options::=--force-confold\" --assume-yes upgrade -y -qq
    sudo -E apt-get -q --option \"Dpkg::Options::=--force-confold\" --assume-yes install -y -qq python3-pip     
    sudo pip3 install ansible 
)

# Only mind when running on hyper-v
# Installs xrdp for enahnced session mode
# Got to be run twice with reboots
# wget -O install.sh https://raw.githubusercontent.com/Hinara/linux-vm-tools/ubuntu20-04/ubuntu/20.04/install.sh
# sudo chmod +x install.sh
# sudo ./install.sh || :
