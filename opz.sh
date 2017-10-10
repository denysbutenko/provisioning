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
    python3 \
    python3-pip \
    rsync \
    silversearcher-ag \
    tmux \
    tree \
    util-linux \
    vim \
    zsh

sudo apt -y autoremove

sudo apt install ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw logging on
sudo ufw enable

sudo apt install fail2ban

# TODO automatic sed script to harden sshd config

printf '%s\n' 'Enter new hostname:'
read hn
sudo hostnamectl set-hostname "$hn"

sudo chsh -s "$(which zsh)" "$(whoami)"
exec zsh
