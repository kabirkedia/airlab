#!/bin/bash
apt-get update
apt-get install -y sudo python3-pip curl lsb-release
sudo apt-get install dpkg-dev
cd /straps/airlab
chmod -R a+rX *
cd ..
dpkg-deb --build airlab
sudo dpkg -i ./airlab.deb