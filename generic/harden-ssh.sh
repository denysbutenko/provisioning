#!/usr/bin/env bash

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

sudo systemctl restart ssh  # systemd only
