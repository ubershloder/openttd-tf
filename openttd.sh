#!/bin/bash
sudo apt-get update
#sudo apt-get upgrade -y

if [[ "${?}" -ne 0 ]]
then
  echo "something went wrong during update" >&2
  exit 1
fi

sudo apt-get build-dep openttd -y
sudo apt-get install libsdl2-2.0-0 -y
wget https://cdn.openttd.org/openttd-releases/1.10.3/openttd-1.10.3-linux-ubuntu-focal-amd64.deb
sudo dpkg -i openttd-1.10.3-linux-ubuntu-focal-amd64.deb
sudo apt-get -f install -y
sudo apt-get install -y openttd-opengfx

sudo -i | /usr/games/openttd -f -D


if [[ "${?}" -eq 0 ]]
then 
  echo "DONE!"
fi

