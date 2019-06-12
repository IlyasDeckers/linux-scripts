#!/bin/bash
# Script to add a user to Linux system

if [ $(id -u) -eq 0 ]; then
	read -p "Enter username : " username
	read -s -p "Enter password : " password
	egrep "^$username" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
		echo "$username exists!"
		exit 1
	else
		pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
		useradd -m -p $pass $username
        usermod -s /bin/bash $username

		[ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"

        read -r -p "Add user $username to sudo group? [y/N] " response
        case "$response" in
            [yY][eE][sS]|[yY]) 
                adduser $username sudo
                ;;
            *)
                # Nothing to do
                ;;
        esac

        read -r -p "Add public ssh key to authorized_keys? [y/N] " response
        case "$response" in
            [yY][eE][sS]|[yY])
                # Create the .ssh directory and apply 
                # appropriate permissions
                mkdir /home/${username}/.ssh
                chmod 700 /home/${username}/.ssh
                touch /home/${username}/.ssh/authorized_keys
                chmod 600 /home/${username}/.ssh/authorized_keys
                chown -R ${username}:${username} /home/${username}/.ssh
                
                read -p "Enter public ssh key : " p_ssh_key
                printf '%s ' ${p_ssh_key} >>/home/${username}/.ssh/authorized_keys 
                ;;
            *)
                # nothing to do
                ;;
        esac
    fi
else
	echo "Only root may add a user to the system"
	exit 2
fi