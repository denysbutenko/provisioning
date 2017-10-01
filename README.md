# provisioning
Various server and SBC provisioning scripts and setup notes.

### Generic Debian (Stretch) Server

TODO


### [Orange Pi Zero](https://www.aliexpress.com/store/product/New-Orange-Pi-Zero-H2-Quad-Core-Open-source-512MB-development-board-beyond-Raspberry-Pi/1553371_32761500374.html) (opz.sh)

##### Setup

* Extract the [image](https://www.armbian.com/orange-pi-zero/), verify the checksum, then `dd` it onto a micro SD card
* Connect the board to ethernet
* Connect the board to power via micro USB (ideally 5V at 2A, but amperage can be as low as 1A)
* Find the DHCP-assigned IP (many methods, easiest is to use router's web interface), then login as `root:1234` over SSH.

Armbian has a convenient root login script that interactively sets up a sudo-enabled user. Once complete, reboot (orange pi needs to resize fs), then login as your user and `apt update && sudo apt upgrade`.

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

Logout. Then on the host machine, `ssh-copy-id username@ip`, then ssh back in.

**TODO harden SSH, port forwarding, static ip, and wifi setup**
