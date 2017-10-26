# provisioning
Various server and SBC provisioning scripts and setup notes.

## Prerequisites

TODO generate ssh key on host machine


## [Orange Pi Zero](https://www.aliexpress.com/store/product/New-Orange-Pi-Zero-H2-Quad-Core-Open-source-512MB-development-board-beyond-Raspberry-Pi/1553371_32761500374.html) (opz.sh)

Blog post with detailed write-up is [here](TODO). It essentially includes the below and explains what `opz.sh` is doing.


### Base Setup

* Extract the [image](https://www.armbian.com/orange-pi-zero/), verify the checksum, burn onto a micro SD card
* Connect the board to ethernet
* Connect the board to power via micro USB (ideally 5V at 2A - most phone chargers should suffice, 1A is an acceptable lower bound)
* Find the DHCP-assigned IP (many methods like `nmap`, but easiest is to use router's web interface), then login as `root:1234` over `ssh`.

Armbian has a convenient root login script that interactively sets up a sudo-enabled user. Once complete, you **must reboot** because orange pi needs to resize its filesystem. Then, **login as your user** and `sudo apt update && sudo apt upgrade`.

Optionally, begin by installing my universal server dotfiles:

```bash
sudo apt install -y git stow
git clone --recursive https://github.com/JoshuaRLi/universal ~/universal
rm -f ~/.bashrc  # this is so stow doesn't choke
cd ~/universal && stow --ignore='(server-provisioning|.gitmodules)' -v .
cp "${HOME}/.tmux/.tmux.conf.local" "$HOME"
```

Install core software and configuration using the provisioning script:

```bash
sudo apt install -y wget
TMP="$(mktemp -d)"
wget https://raw.githubusercontent.com/JoshuaRLi/provisioning/master/opz.sh -P "$TMP"
bash "${TMP}/opz.sh"
```

`opz.sh` does quite a bit of stuff behind the scenes. Again, refer to my [blog post](TODO) for details, or review the script's source. To summarize:

* Installs a minimal amount of essential software, including `ufw` and `fail2ban`
* Configures and enables `ufw` to only allow incoming `ssh` on port 22
* Hardens `/etc/ssh/sshd_config`
* Interactively sets hostname, changes login shell to `zsh`

Once done, logout. Then on your machine, `ssh-copy-id username@ip` to copy your pubkey to the orange pi zero. You are now all set for administration over key-based `ssh` on your WLAN.


### Setup WLAN Networking

Setting up WiFi on the orange pi zero is easy with the `nmtui` front-end to NetworkManager that comes with armbian: `sudo nmtui-connect`

Once you have a successful access point configuration, you are free to disconnect ethernet from the board and reboot.


## Generic Debian (Stretch) Server

TODO
