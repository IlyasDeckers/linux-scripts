#!/bin/sh

# Disables root login for ssh.

sed -i '/^PermitRootLogin[ \t]\+\w\+$/{ s//PermitRootLogin no/g; }' /etc/ssh/sshd_config && \
service ssh restart
