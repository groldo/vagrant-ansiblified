# Only mind when running on hyper-v
# Installs xrdp for enahnced session mode
# Got to be run twice with reboots
wget -O install.sh https://raw.githubusercontent.com/Hinara/linux-vm-tools/ubuntu20-04/ubuntu/20.04/install.sh
sudo chmod +x install.sh
sudo ./install.sh || :
