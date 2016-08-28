#!/bin/bash

# Don't run as root
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
sudo add-apt-repository ppa:webupd8team/sublime-text-3
sudo apt-get update -y

# Base Ubuntu packages
sudo apt-get install -y dkms

# Install core packages
sudo apt-get install -y git subversion cmake wget curl tmux meld tree

# Java
sudo apt-get install -y openjdk-8-jdk maven ant

# Scala
sudo apt-get install -y scala

# Python
sudo apt-get install -y python-pip
sudo pip install virtualenv virtualenvwrapper
mkdir ~/.venv
echo "" >> ~/.bashrc
echo "# Python Virtualenv Wrapper" >> ~/.bashrc
echo "export WORKON_HOME=~/.venv" >> ~/.bashrc
echo "source /usr/local/bin/virtualenvwrapper.sh" >> ~/.bashrc

# Go
sudo apt-get install -y golang

# Erlang
sudo apt-get install -y erlang elixir

# Sublime
sudo apt-get install -y sublime-text-installer
ln -s /opt/sublime_text/sublime_text ~/bin/sublime

# Docker
curl -sSL https://get.docker.com/ | sh
sudo pip install docker-compose

# Get rest of linux-setup from git
if [ ! -d "$HOME/projects/linux-setup" ]
then
  mkdir -p ~/projects
  git clone git://github.com/zzglitch/linux-setup.git ~/projects/linux-setup
fi

# Link files in linux-setup/home to user's home directory
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
link_homedir_files ~/projects/linux-setup/home ~
shopt -u dotglob
