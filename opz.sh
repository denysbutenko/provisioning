#!/usr/bin/env bash

set -x

sudo apt install -y \
    htop \
    nano \
    ncdu \
    tree \
    wget

sudo apt install -y ufw ssh fail2ban zsh
sudo chsh -s "$(which zsh)" "$(whoami)"

TMP="$(mktemp -d)"
GURL="https://raw.githubusercontent.com/JoshuaRLi/provisioning/master/generic"
wget "${GURL}/ufw-basecfg.sh" -P "$TMP"
bash "${TMP}/ufw-basecfg.sh"

printf '%s\n' 'Enter new hostname:'
read hn
hostnamectl set-hostname "$hn"

exec zsh
