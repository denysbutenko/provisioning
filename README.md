# provisioning
Various server and SBC provisioning scripts and setup notes.

## Prerequisites

In order to authenticate yourself over `ssh` to servers, you'll need to first establish your identity by generating a public and private keypair:

`ssh-keygen -t rsa -b 4096 -C "your_email@example.com"`

The rest of the process is interactive. It is up to you whether or not to use one default private key `~/.ssh/id_rsa` for everything, or generate separate keys for separate things.


## [Raspberry Pi Zero (W)ireless](https://www.raspberrypi.org/products/raspberry-pi-zero-w/) (rpizw-sou.sh (optional) and rpizw.sh)

TODO blog post

### Base Setup

* Extract the [Raspbian lite image](), verify the checksum, burn onto a micro SD card

3 paths:
1. connect directly to ethernet by using a usb data cable to ethernet adapter (TODO need to test this on vanilla image), then find ip over router
2. run my ssh over usb script to modify the image
connect usb cable to USB (data), not pwr, make sure usb cable has data lines (usually the wire is just thicker) and not just power over usb.

`ssh pi@raspberrypi.local` pw is raspberry

3. TODO setup wifi by directly editing wpa_supplicant.conf and etc netwrok interfaces, then find ip with router


## [Orange Pi Zero](http://www.orangepi.org/orangepizero) (opz.sh)

Blog post with detailed write-up is [here](https://tildeslash.io/2017/10/26/Setup-Orange-Pi-Zero-running-Armbian-on-WLAN/). It essentially includes the below (excluding personal dotfile setup) and explains what `opz.sh` is doing.


### Base Setup

* Extract the [Armbian image](https://www.armbian.com/orange-pi-zero/), verify the checksum, burn onto a micro SD card
* Connect the board to ethernet
* Connect the board to power via micro USB (ideally 5V at 2A - most phone chargers should suffice, 1A is an acceptable lower bound)
* Find the DHCP-assigned IP (many methods like `nmap`, but easiest is to use router's web interface), then login as `root:1234` over `ssh`.

Armbian has a convenient root login script that interactively sets up a sudo-enabled user. Once complete, you **must reboot** because orange pi needs to resize its filesystem. Then, **login as your user** and `sudo apt update && sudo apt upgrade`.

Optionally, begin by installing my universal server dotfiles:

```bash
sudo apt install -y git stow
rm -f ~/.bashrc  # this is so stow doesn't choke
git clone --recursive https://github.com/JoshuaRLi/universal "${HOME}/universal"
cd "${HOME}/universal" && stow --ignore='(bin|.gitmodules)' -v .
cp "${HOME}/.tmux/.tmux.conf.local" "$HOME"
```

Install core software and configuration using the provisioning script:

```bash
sudo apt install -y wget
TMP="$(mktemp -d)"
wget https://raw.githubusercontent.com/JoshuaRLi/provisioning/master/opz.sh -P "$TMP"
bash "${TMP}/opz.sh"
```

`opz.sh` does quite a bit of stuff behind the scenes. Again, refer to my [blog post](https://tildeslash.io/2017/10/26/Setup-Orange-Pi-Zero-running-Armbian-on-WLAN/) for details, or review the script's source. To summarize:

* Installs a minimal amount of essential software, including `ufw` and `fail2ban`
* Configures and enables `ufw` to only allow incoming `ssh` on port 22
* Hardens `/etc/ssh/sshd_config`
* Interactively sets hostname, changes login shell to `zsh`

Once done, logout. Then `ssh-copy-id username@ip` and done!


### Setup WLAN Networking

Setting up WiFi on the OPZ is easy with the `nmtui` front-end to NetworkManager that comes with armbian:

`sudo nmtui-connect`


## Generic Debian (Stretch) Server

TODO
