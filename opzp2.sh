#!/usr/bin/env bash

set -x

# Implied packages (see README):
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
    ufw \
    util-linux \
    vim \
    zsh

sudo apt -y autoremove

sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw logging on
sudo ufw enable

printf '%s\n' 'Enter new hostname:'
read hn
sudo hostnamectl set-hostname "$hn"

sudo chsh -s "$(which zsh)" "$(whoami)"
exec zsh
