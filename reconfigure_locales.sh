#!/bin/bash

# Warning: this can take some time.
#
# While working on linux you may encounter the following error:
# 
# perl: warning: Setting locale failed.
# perl: warning: Please check that your locale settings:
#     LANGUAGE = (unset),
#     LC_ALL = (unset),
#     LANG = "en_US.UTF-8"
#     are supported and installed on your system.
# perl: warning: Falling back to the standard locale ("C").
# locale: Cannot set LC_CTYPE to default locale: No such file or directory
# locale: Cannot set LC_MESSAGES to default locale: No such file or directory
# locale: Cannot set LC_ALL to default locale: No such file or directory
# 
# This small script fixes your locales and this error.

if [ $(id -u) -eq 0 ]; then
	export LANGUAGE=en_US.UTF-8 && \
    export LANG=en_US.UTF-8 &&\
    export LC_ALL=en_US.UTF-8 && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales
else
	echo "Only root may run this script"
	exit 2
fi