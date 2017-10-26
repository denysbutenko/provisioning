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

sudo bash -c "cat > /etc/ssh/sshd_config <<EOF
AllowUsers $(whoami)

ServerKeyBits 1024
LoginGraceTime 120
KeyRegenerationInterval 3600
IgnoreRhosts yes
IgnoreUserKnownHosts yes
StrictModes yes
PrintMotd yes
SyslogFacility AUTH
LogLevel INFO

PermitRootLogin no
PermitEmptyPasswords no
RhostsAuthentication no
RhostsRSAAuthentication no
X11Forwarding no

RSAAuthentication yes
PasswordAuthentication yes
AuthenticationMethods publickey,password
EOF"

sudo service restart ssh

printf '%s\n' 'Enter new hostname:'
read hn
sudo hostnamectl set-hostname "$hn"

sudo chsh -s "$(which zsh)" "$(whoami)"
exec zsh
