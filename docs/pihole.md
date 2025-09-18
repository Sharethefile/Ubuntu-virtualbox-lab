# Pi-hole on Ubuntu Server

## What Pi-hole does
- Pi-hole acts a DNS sinkhole.
- It blocks ads for every device pointed at it.
- It blocks website banner ads, in-app ads, tracker domains, etc

## Before install
- Ensure the VM has a static IP. 
- For network-wide blocking a staticIP is the best. See `examples/netplan-static.yaml`.

## Recommended install

Option A: Official quick installer:
```bash
curl -sSL https://install.pi-hole.net | bash
```
Option B: clone from official github page:
```bash
git clone --depth 1 https://github.com/pi-hole/pi-hole.git Pi-hole
cd "Pi-hole/automated install/"
sudo bash basic-install.sh
```
## After install
- The web admin UI wiil be at: `http://<VM_IP>/admin`
- To set/change the admin password: pihole -a -p
- Log in using the password you choose.

![Pi-hole Dashboard](https://raw.githubusercontent.com/Sharethefile/Ubuntu-virtualbox-lab/main/screenshots/pihole-dashboard.png)

## Network-wide ad blocking
- Configure your router to use <VM_IP> as DNS -> all devices on LAN use Pi-hole

## Select Devices only
- Set DNS manually on each individual device to <VM_IP>
