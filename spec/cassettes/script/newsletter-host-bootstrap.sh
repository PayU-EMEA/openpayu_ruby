#!/usr/bin/env bash

# Require root to install it.
if [[ $(id -u) -ne 0 ]]; then
  echo "Please rerun this installer as root." >&2
  exit 1
fi

# Update system packages
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
apt-get -y update
apt-get -y dist-upgrade

# Install required packages
apt-get -y install curl libcurl4-openssl-dev git-core build-essential zlib1g-dev libssl-dev libreadline5-dev libmysqlclient-dev postfix libpcre3-dev htop imagemagick libmagickcore-dev libmagickwand-dev libxml2 libxml2-dev libxslt1-dev

# Install RVM - Ruby version manager
bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)
export PATH=$PATH:/usr/local/rvm/bin
source /usr/local/rvm/scripts/rvm
rvm install 1.9.2-p136
rvm --default 1.9.2-p136

# Install God
gem install god bundler --no-ri --no-rdoc
ln -s `which god` /usr/bin/god
echo "GOD_CONFIG=/home/rails_app/config/god/config.god" > /etc/default/god
wget -O /etc/init.d/god https://raw.github.com/gist/1150137/608a5aed9e30cda72874541dd78c9509a761e03a/god-init
chmod +x /etc/init.d/god
/usr/sbin/update-rc.d -f god defaults

# Create app system user
useradd -m -s /bin/bash -G rvm rails_app
su - -c "ssh-keygen -t dsa -f /home/rails_app/.ssh/id_dsa -N ''" rails_app
su - -c "mkdir -p ~/config/{nginx,god}" rails_app