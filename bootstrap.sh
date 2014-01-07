#!/usr/bin/env bash
set -e

if [ "$EUID" -ne "0" ] ; then
        echo "Script must be run as root." >&2
        exit 1
fi

# if which puppet > /dev/null ; then
#         echo "Puppet is already installed"
#         exit 0
# fi

# Ruby
/vagrant/install_ruby-2.0.0.sh

# RubyGems
/vagrant/install_rubygems-2.2.0.sh

# Java
/vagrant/install_java-1.7.sh

# Tomcat
/vagrant/install_tomcat.sh 

# MySQL
/vagrant/install_mysql-5.6.sh
 
