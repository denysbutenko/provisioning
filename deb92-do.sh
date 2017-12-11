#!/usr/bin/env bash

set -x

printf '%s\n' 'Enter username:'
read username
adduser "$username"
usermod -aG sudo "$username"

printf '%s\n' 'Enter new hostname:'
read hn
hostnamectl set-hostname "$hn"

apt install -y ufw ssh fail2ban zsh
chsh -s "$(which zsh)" "$username"

TMP="$(mktemp -d)"
GURL="https://raw.githubusercontent.com/JoshuaRLi/provisioning/master/generic"
wget "${GURL}/ufw-basecfg.sh" -P "$TMP"
bash "${TMP}/ufw-basecfg.sh"
wget "${GURL}/harden-ssh.sh" -P "$TMP"
bash "${TMP}/harden-ssh.sh"
