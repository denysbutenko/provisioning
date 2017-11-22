#!/usr/bin/env sh

sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw logging on
sudo ufw enable
