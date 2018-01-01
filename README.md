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

Once done, logout. Then `ssh-copy-id username@ip`, login as your user, and **run the [Snippet](#snippets) to harden ssh configuration**. Optionally, install my [server dotfiles][1] with the appropriate [Snippet](#snippets).


## Armbian on [Orange Pi Zero](http://www.orangepi.org/orangepizero) (opz.sh)

### Initial SSH Session

* Extract the [Armbian image](https://www.armbian.com/orange-pi-zero/), verify that checksums match, then burn onto a micro SD card
* Connect the board to ethernet, then power (ideally 5V at 2A) via micro USB
* Find the DHCP-assigned IP (easiest way is to use your router's admin interface, or `nmap`), then login as `root:1234` over `ssh`.
* Optionally, reserve a static IP for the board and add a corresponding host entry to your `~/.ssh/config`


### Base Setup

Armbian has a convenient root login script that interactively sets up a sudo-enabled user. Once complete, you **must reboot** because orange pi needs to resize its filesystem. Then, **login as your user** and `sudo apt update && sudo apt upgrade -y`.

Install core software and configuration using the provisioning script:

```bash
sudo apt install -y wget
TMP="$(mktemp -d)"
wget https://raw.githubusercontent.com/JoshuaRLi/provisioning/master/opz.sh -P "$TMP"
bash "${TMP}/opz.sh"
```

Once done, logout. Then `ssh-copy-id username@ip`, login as your user, and **run the [Snippet](#snippets) to harden ssh configuration**. Optionally, install my [server dotfiles][1] with the appropriate [Snippet](#snippets).


### Setup WLAN Networking

Setting up WiFi on the OPZ is easy with the `nmtui` front-end to NetworkManager that comes with armbian: `sudo nmtui-connect`


## Snippets

Install my [server dotfiles][1] (you'll need `git` and `stow` installed):

```bash
rm -f ~/.bashrc  # you may need to remove more files that stow conflicts with
git clone --recursive https://github.com/JoshuaRLi/dotfiles "${HOME}/dotfiles"
cd "${HOME}/dotfiles" && bash link.sh base
```

Harden `sshd` configuration (you'll need `wget` installed):

```bash
TMP="$(mktemp -d)"
GURL="https://raw.githubusercontent.com/JoshuaRLi/provisioning/master/generic"
wget "${GURL}/harden-ssh.sh" -P "$TMP"
bash "${TMP}/harden-ssh.sh"
```

[1]: https://github.com/JoshuaRLi/dotfiles
