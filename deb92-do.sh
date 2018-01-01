#!/usr/bin/env bash

# Run this as root upon first ever login.

set -x

printf '%s\n' 'Enter desired username:'
read username
adduser "$username"
usermod -aG sudo "$username"

apt install -y ufw ssh fail2ban zsh
chsh -s "$(which zsh)" "$username"

apt install -y wget
TMP="$(mktemp -d)"
GURL="https://raw.githubusercontent.com/JoshuaRLi/provisioning/master/generic"
wget "${GURL}/ufw-basecfg.sh" -P "$TMP"
bash "${TMP}/ufw-basecfg.sh"

printf '%s\n' 'Enter new hostname:'
read hn
hostnamectl set-hostname "$hn"
