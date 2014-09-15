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


# Get rest of linux-setup from git
if [ ! -d "$HOME/dev/linux-setup" ]
then
  mkdir -p ~/dev
  git clone git://github.com/zzglitch/linux-setup.git ~/dev/linux-setup
fi


# Link files in dev/home to user's home directory
function link_homedir_files () {
  for file in $1/*; do
  if [[ -d $file ]]; then
    mkdir -p $2/`basename $file`
    link_homedir_files $file $2/`basename $file`
  else
    ln -f $file $2/`basename $file`
  fi
  done
}
shopt -s dotglob
link_homedir_files ~/dev/linux-setup/home ~
shopt -u dotglob
