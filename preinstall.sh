echo -e "vagrant\nvagrant" | sudo passwd vagrant
export DEBIAN_FRONTEND=noninteractive
ansible --version || (  
    sudo apt-get -y purge python2.7 python-minimal
    sudo apt-get update && sudo apt-get -q --option \"Dpkg::Options::=--force-confold\" --assume-yes upgrade -y -qq
    sudo -E apt-get -q --option \"Dpkg::Options::=--force-confold\" --assume-yes install -y -qq python3-pip     
    sudo pip3 install ansible 
)
