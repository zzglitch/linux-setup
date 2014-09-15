#!/bin/bash

# Make sure this script is NOT run as root
if [ $(id -u) -eq 0 ]
then
  echo 'ERROR: This script should not be run as root.'
  exit
fi


# Generate SSH key if it doesn't exist
if [ ! -r "$HOME/.ssh/id_rsa" ]
then
  ssh-keygen -N '' -t rsa -f ~/.ssh/id_rsa
  ssh-add ~/.ssh/id_rsa
fi


# Update package manifests
sudo add-apt-repository ppa:webupd8team/java -y
sudo apt-get update -y


# Install core packages
sudo apt-get install git-core -y
sudo apt-get install meld -y
sudo apt-get install tree -y


# Install java
sudo apt-get install oracle-java8-installer -y
