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
    vim \
    zsh

sudo apt -y autoremove

sudo apt install -y ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw logging on
sudo ufw enable

sudo apt install -y fail2ban

# TODO automatic sed script to harden sshd config

printf '%s\n' 'Enter new hostname:'
read hn
sudo hostnamectl set-hostname "$hn"

sudo chsh -s "$(which zsh)" "$(whoami)"
exec zsh
