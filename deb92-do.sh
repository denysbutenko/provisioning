#!/usr/bin/env bash

set -x

printf '%s\n' 'Enter username:'
read username
adduser "$username"
usermod -aG sudo "$username"

apt install -y ufw fail2ban zsh

ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw logging on
ufw enable

cat > /etc/ssh/sshd_config <<EOF
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
EOF

systemctl restart ssh

printf '%s\n' 'Enter new hostname:'
read hn
hostnamectl set-hostname "$hn"

chsh -s "$(which zsh)" "$username"
