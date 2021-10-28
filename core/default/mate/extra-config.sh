#!/usr/bin/env bash

sudo -n true
echo "==[START]=="

echo "setting up udroid user..."
useradd -m \
    -p "$(openssl passwd -1 secret)" \
    -G sudo \
    -d /home/udroid \
    -k /etc/skel \
    -s /bin/bash \
    udroid

echo Installing IDEs
echo starting in 5 seconds...
echo -e "\n"

wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'

rm -f packages.microsoft.gpg
sudo apt update -y
sudo apt install code -y
sudo apt clean

echo "==[END]=="