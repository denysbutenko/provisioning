# provisioning
Various server and SBC provisioning scripts and setup notes.

Snippets for common tasks that are downloaded and executed by the top level scripts reside in `generic/`.


## Prerequisites

In order to authenticate yourself over `ssh` to servers, you'll need to first establish your identity by generating a public and private keypair:

`ssh-keygen -t rsa -b 4096 -C "your_email@example.com"`

The rest of the process is interactive. It is up to you whether or not to use one default private key `~/.ssh/id_rsa` for everything, or generate separate keys for separate things.


## Debian Stretch 9.2 VPS - [DigitalOcean](https://www.digitalocean.com) (deb92-do.sh)

On first login as the root user:

```bash
apt update && apt upgrade -y
TMP="$(mktemp -d)"
wget https://raw.githubusercontent.com/JoshuaRLi/provisioning/master/deb92-do.sh -P "$TMP"
bash "${TMP}/deb92-do.sh"
```

Once done, logout. Then `ssh-copy-id username@ip`, login as your user, and **run the [Snippet](#snippets) to harden ssh configuration**.

Optionally, install my [server dotfiles][1] with the appropriate [Snippet](#snippets).



## Armbian on [Orange Pi Zero](http://www.orangepi.org/orangepizero) (opz.sh)

Blog post with detailed write-up is [here](https://tildeslash.io/2017/10/26/Setup-Orange-Pi-Zero-running-Armbian-on-WLAN/).


### Initial SSH Session

* Extract the [Armbian image](https://www.armbian.com/orange-pi-zero/), verify the checksum, burn onto a micro SD card
* Connect the board to ethernet
* Connect the board to power via micro USB (ideally 5V at 2A - most phone chargers should suffice, 1A is an acceptable lower bound)
* Find the DHCP-assigned IP (many methods like `nmap`, but easiest is to use router's web interface), then login as `root:1234` over `ssh`.

Move on to Base Setup.


### Base Setup

Armbian has a convenient root login script that interactively sets up a sudo-enabled user. Once complete, you **must reboot** because orange pi needs to resize its filesystem. Then, **login as your user** and `sudo apt update && sudo apt upgrade`.

Install core software and configuration using the provisioning script:

```bash
sudo apt install -y wget
TMP="$(mktemp -d)"
wget https://raw.githubusercontent.com/JoshuaRLi/provisioning/master/opz.sh -P "$TMP"
bash "${TMP}/opz.sh"
```

`opz.sh` does quite a bit of stuff behind the scenes. Again, refer to my [blog post](https://tildeslash.io/2017/10/26/Setup-Orange-Pi-Zero-running-Armbian-on-WLAN/) for details, or review the script's source.

Once done, logout. Then `ssh-copy-id username@ip`, login as your user, and **run the [Snippet](#snippets) to harden ssh configuration**.

Optionally, install my [server dotfiles][1] with the appropriate [Snippet](#snippets).


### Setup WLAN Networking

Setting up WiFi on the OPZ is easy with the `nmtui` front-end to NetworkManager that comes with armbian:

`sudo nmtui-connect`


## Raspbian on [Raspberry Pi Zero (W)ireless](https://www.raspberrypi.org/products/raspberry-pi-zero-w/) (rpizw-sou.sh (optional) and rpizw.sh)

Blog post with detailed write-up is [here](https://tildeslash.io/TODO).

### Initial SSH Session

* Extract the [Raspbian lite image](), verify the checksum, burn onto a micro SD card

3 paths to achieve initial ssh session:
1. connect directly to ethernet by using a usb data cable to ethernet adapter (TODO need to test this on vanilla image), then find ip over router
2. run my ssh over usb script to modify the image
connect usb cable to USB (data), not pwr, make sure usb cable has data lines (usually the wire is just thicker) and not just power over usb.

`ssh pi@raspberrypi.local` pw is raspberry

3. TODO setup wifi by directly editing wpa_supplicant.conf and etc netwrok interfaces, then find ip with router


### Base Setup

Optionally, install my [server dotfiles][1] with the appropriate [Snippet](#snippets).

TODO rewrite personal notes here


## Snippets

Personal "universal" [server dotfiles][1] installation:

```bash
sudo apt install -y git stow
rm -f ~/.bashrc  # this is so stow doesn't choke
git clone --recursive https://github.com/JoshuaRLi/universal "${HOME}/universal"
cd "${HOME}/universal" && stow --ignore='(bin|.gitmodules)' -v .
cp "${HOME}/.tmux/.tmux.conf.local" "$HOME"
```

Harden `sshd` configuration:

```bash
TMP="$(mktemp -d)"
GURL="https://raw.githubusercontent.com/JoshuaRLi/provisioning/master/generic"
wget "${GURL}/harden-ssh.sh" -P "$TMP"
bash "${TMP}/harden-ssh.sh"
```

[1]: https://github.com/JoshuaRLi/universal
