# provisioning
Various server provisioning scripts, mostly for SBCs

Also general setup notes.

### Orange Pi Zero Plus 2 (opzp2.sh)

ARMbian image: https://www.armbian.com/orange-pi-zero-2-h3/
As of October 2017, the mainline kernel is the only one with working ethernet.

##### Setup

* Extract the image, verify the checksum, then `dd` it onto a micro SD card
* Connect the board to ethernet
* Connect the board to power via micro USB (ideally 5V at 2A, but amperage can be as low as 1A)
* Find the DHCP-assigned IP (easiest is to use router's web interface), then login as `root:1234` over SSH.

Armbian has a convenient root login script that interactively sets up a sudo-enabled user. Once complete, `apt update && apt upgrade` then reboot to update. Then, login as your user and set up my dotfiles:

```bash
sudo apt install git stow wget
git clone --recursive https://github.com/JoshuaRLi/universal ~/universal
rm -f ~/.bashrc
cd ~/universal && stow --ignore='(server-provisioning|.gitmodules)' -v .
cp "${HOME}/.tmux/.tmux.conf.local" "$HOME"
```

Finally, finish installing core software and configuration:

```bash
TMP="$(mktemp -d)"
wget https://raw.githubusercontent.com/JoshuaRLi/provisioning/master/opzp2.sh "$TMP"
bash "${TMP}/opzp2.sh"
```

