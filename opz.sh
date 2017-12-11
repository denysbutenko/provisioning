#!/usr/bin/env bash

set -x

# Implied packages (see README setup):
#   * stow
#   * wget
#   * git

sudo apt install -y \
    curl \
    gnupg2 \
    htop \
    ncdu \
    tmux \
    tree \
    util-linux \
    vim

sudo apt install -y ufw ssh fail2ban zsh
sudo chsh -s "$(which zsh)" "$(whoami)"

TMP="$(mktemp -d)"
GURL="https://raw.githubusercontent.com/JoshuaRLi/provisioning/master/generic"
wget "${GURL}/ufw-basecfg.sh" -P "$TMP"
bash "${TMP}/ufw-basecfg.sh"
wget "${GURL}/harden-ssh.sh" -P "$TMP"
bash "${TMP}/harden-ssh.sh"

printf '%s\n' 'Enter new hostname:'
read hn
hostnamectl set-hostname "$hn"

exec zsh
