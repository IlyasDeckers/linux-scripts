#!/bin/sh

# Install Configserserver firewall
#
# Next, test whether you have the required iptables modules:
# 
# perl /usr/local/csf/bin/csftest.pl
# 
# Don't worry if you cannot run all the features, so long as the script doesn't
# report any FATAL errors
# 
# You should not run any other iptables firewall configuration script. For
# example, if you previously used APF+BFD you can remove the combination (which
# you will need to do if you have them installed otherwise they will conflict):
# 
# sh /usr/local/csf/bin/remove_apf_bfd.sh
# 
# That's it. You can then configure csf and lfd by reading the documentation and
# configuration files in /etc/csf/csf.conf and /etc/csf/readme.txt directly or
# through the csf User Interface.
# 
# csf installation for cPanel and DirectAdmin is preconfigured to work on those
# servers with all the standard ports open.
# 
# csf auto-configures your SSH port on installation where it's running on a non-
# standard port.
# 
# csf auto-whitelists your connected IP address where possible on installation.
# 
# You should ensure that kernel logging daemon (klogd) is enabled. Typically, VPS
# servers running RedHat/CentOS v5 have this disabled and you should check
# /etc/init.d/syslog and make sure that any klogd lines are not commented out. If
# you change the file, remember to restart syslog.
# 
# See the csf.conf and readme.txt files for more information.
#
# https://download.configserver.com/csf/install.txt

cd /usr/src && \
rm -fv csf.tgz && \
wget https://download.configserver.com/csf.tgz && \
tar -xzf csf.tgz && \
cd csf && \
sh install.sh