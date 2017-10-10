# provisioning
Various server and SBC provisioning scripts and setup notes.

## Generic Debian (Stretch) Server

TODO


## [Orange Pi Zero](https://www.aliexpress.com/store/product/New-Orange-Pi-Zero-H2-Quad-Core-Open-source-512MB-development-board-beyond-Raspberry-Pi/1553371_32761500374.html) (opz.sh)

Blog post with write-up [here](TODO). Content is essentially the stuff below.


### Setup (base)

* Extract the [image](https://www.armbian.com/orange-pi-zero/), verify the checksum, burn onto a micro SD card
* Connect the board to ethernet
* Connect the board to power via micro USB (ideally 5V at 2A, but amperage can be as low as 1A)
* Find the DHCP-assigned IP (many methods like `nmap`, but easiest is to use router's web interface), then login as `root:1234` over SSH.

Armbian has a convenient root login script that interactively sets up a sudo-enabled user. Once complete, reboot (orange pi needs to resize fs), then login as your user and `sudo apt update && sudo apt upgrade`.

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


### Setup ([W]LAN networking)

Setting up WiFi is easy with the `nmtui` front-end to NetworkManager that comes with armbian: `sudo nmtui-connect`

Once you have a successful access point configuration, you are free to disconnect ethernet and reboot. As with any device exposed to the open, at the very least the firewall should be set up (most easily via `ufw`), `sshd` configuration should be hardened, and `fail2ban` should be installed for ssh intrusion prevention.

The first is easy - hence `ufw` ("uncomplicated" firewall). It's a frontend to `iptables` which suffices for most firewall-related tasks.

```bash
sudo apt install ufw
sudo ufw default allow outgoing  # fail safe default
sudo ufw default deny incoming  # fail safe default
sudo ufw allow ssh  # ssh is a human alias for port 22
sudo ufw logging on  # or off to save CPU load and disk space
sudo ufw enable
```

Secondly, you'll want to edit `/etc/ssh/sshd_config` file to have these lines:
```
PermitRootLogin no
PermitEmptyPasswords no
PasswordAuthentication no
AuthorizedKeysFile %h/.ssh/authorized_keys
AuthenticationMethods publickey
```
(TODO a sed script to automate this, also there are more security defaults, see [here](ftp://ftp.wayne.edu/ldp/en/solrhe/chap15sec122.html))

Then restart the ssh daemon. Armbian uses `systemd`, so `sudo systemctl restart sshd`.

The last is the easiest. `sudo apt install fail2ban` comes with a default configuration for ssh intrusion prevention and the service is started automatically. Install and forget, but [additional configuration](https://www.linode.com/docs/security/using-fail2ban-for-security) may be of interest to more advanced users.


### Setup (real internet exposure)

**TODO router port forwarding, static ip and dynamic DNS, sample web server deployment, maybe two-factor SSH**
