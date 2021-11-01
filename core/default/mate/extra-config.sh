#!/usr/bin/env bash

# => thanks to @GxmerSam for script

sudo -n true
echo "==[START]=="

function list_parser() {
    export count
    export include_list
    
    count=0
    include_list=""

    list_file=$1

    if [ -f "$list_file" ]; then
        buffer=$(cat "$list_file")
        for line in $buffer; do
            ((count++))
            include_list+=" $line"
        done
    else
        echo "File $list_file not found.."
    fi
}

function if_found_install_extras() {
    include_file="/root/include-i.list"
    if [ -f $include_file ]; then
        list_parser "$include_file"
        if [ -n "$include_list" ]; then
            apt install -y --force-yes "$include_list"
        else
            echo "No extra packages to install. FileEmpty.."
        fi
    fi
}
#######################################

if_found_install_extras
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
sudo apt install code sublime-text -y
sudo apt clean

echo "==[END]=="