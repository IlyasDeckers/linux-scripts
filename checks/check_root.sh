#!/bin/bash

if [ "$(id -u)" != 0 ]; then
  echo "This script must be run as root. 'sudo bash $0'"
  exit 1
fi