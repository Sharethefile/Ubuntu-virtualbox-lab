# Ubuntu-VirtualBox-lab
Experimenting with self-hosted services in Ubuntu server on VirtualBox 

This project is about experimenting with Ubuntu Server inside a VirtualBox before trying to run on bare metal.
The goal is to gradually build a mini self hosted environment with tools for ad-blocking, VPN, backup, media server, etc.

---

## Setup
- **VirtualBox** host
- **Ubuntu Server 22.04 LST** guest vm

## Plans
- Pi-hole for ad-blocking
- Wireguard as VPN for file-sharing
- Nextcloud for storage
- Uptime Kuma for monitoring services
- Jellyfin for media server

## Project Layout
- `docs/` - guide for each service and VirtualBox tips
- `script/` - helper scripts
- `screenshots/` - images used in docs
- `examples/` - sample config files
- `.gitignore` - files to exclude from git

## Contents

- [VirtualBox Setup](./docs/virtualbox.md)  
- [Pi-hole Setup](./docs/pihole.md)
- [WireGuard Setup](./docs/wireguard.md)
- [Nextcloud Setup](./docs/nextcloud.md)
- [Uptime Kuma Setup](./docs/uptimekuma.md)

---

# VirtualBox Setup

## VirtualBox: Create an Ubuntu Server VM

This guide documents how to configure the Ubuntu Server VM.

---

## Recommended VM Settings
- Name: ubuntu-server
- Type: Linux
- Version: Ubuntu (64-bit)
- Memory: 2048-4096 MB
- Virtual Disk: VDI, Dynamically allocated, 20-40 GB (depending on services)

## Storage
- Attach the Ubuntu Server ISO to the M's optical drive in Settings -> Storage

![VirtualBox-VM-settings](https://raw.githubusercontent.com/Sharethefile/Ubuntu-virtualbox-lab/main/screenshots/vm-settings.png)

## Network (important)
- **Recommended:** Bridged Adapter - VM gets an IP from your router. It is regarded as a seperate machine in your LAN.
- Settings -> Network -> Adapter 1 -> Attached to: **Bridged Adapter** -> Advanced -> Adapter Type: Intel Pro/1000 MT Desktop -> check Cable Connected
- **Alternative:** NAt with port forwarding - more complex and limits Pi-hole being reached by host ports only.

## Add a shared folder (For wireguard)
- In VirutalBox Manager -> Select your VM -> Settings -> Shared Folder
- Click the add icon
    - Folder Path: Pick a folder on your host. (eg: C:\Shared)
    - folder Name: Pick a name for the folder. (eg: Shared)
    - Check **Auto-mount** and **Make Permanent**
- This creates a shared folder between your VM and host.
- You can then access this folder from your mobile device through wireguard.

![Shared-folder](https://raw.githubusercontent.com/Sharethefile/Ubuntu-virtualbox-lab/main/screenshots/shared-folder.png)

## Starting the VM and login
- Click on the gren start button after the VM is created and follow the setup instructions for installing Ubuntu Server.
- After installation the the login page is displayed.
- The initial login is the root login with the password being the one you set during the setup.

![Ubuntu-login](https://raw.githubusercontent.com/Sharethefile/Ubuntu-virtualbox-lab/main/screenshots/vm-login.png)

## Notes about interfaces
- Interface names may vary (`ens33`, `enp0s3`, etc)
- Use `ip a` to see the exact name (required for most services).

## Shut-down VM 
- To properly shutdown the VM use: `sudo shutdown now`

# Pi-hole Setup

## Pi-hole on Ubuntu Server

This guide documents how to install Pi-hole inside the Ubuntu Server VM.

---

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

# Wireguard Setup

## WireGuard VPN Setup

This guide documents the setup of WireGuard on the Ubuntu Server VM and accessing shared files from a mobile device.

---

## Install WireGuard on the VM

```bash
sudo apt update
sudo apt install wireguard -y
```
## Connect to a phone
- Install qrencode to generate a QR code for your phone config.

```bash
sudo apt install qrencode
```

## Create server and client key pairs
- Go into WireGuard directory 

```bash
cd /etc/wireguard/
```

- To generate public and private keys

```bash
sudo wg genkey | sudo tee server_private.key | sudo wg pubkey | sudo tee server_public.key
sudo wg genkey | sudo tee client_private.key | sudo wg pubkey | sudo tee client_public.key
```

- This generates four files inside the wireguard directory

    - server_private.key
    - server_public.key
    - client_private.key
    - client_public.key

## Build server config
- Go into wireguard config file

```bash
sudo nano /etc/wireguard/wg0.conf
```

- Put your interface and peers here. See `./examples/wireguard-server-config.conf` for more

## Build your client config
- Go into wireguard client config file

```bash
sudo nano /etc/wireguard/client.conf
```
- Put your interface and peers here. See `./examples/wireguard-client-config.conf` for more

## Enable wireguard as a service 

```bash
sudo systemctl enable wg-quick@wg0
sudo systemctl start wg-quick@wg0
sudo wg show
```

## Generate QR code to transfer client config to mobile device

```bash
sudo cat /etc/wireguard/client.conf | qrencode -t ansiutf8
```

- This generates a QR code that you can scan from your mobile device.

## WireGuard on mobile device
- Install WireGuard fron Google Play Store.
- Tap + (Add tunnel) and scan the QR code that you generated.
- Put a tunnel name. (Eg: VPN)
- Connect to the tunnel.

## Verify the connection
- On your Ubuntu Server

```bash
sudo wg show
```

- You should see your mobile device listed under peer.

## Make a Shared folder.
- Enable guest additions in virtualbox. See `./scripts/vbox-guest-tools.sh`
- Add a shared folder in virtualbox. See `./docs/virtualbox.md`
- Mount the shared folder inside your VM. See `./scripts/mount.sh`

## Access the folder from your mobile device
- Install **CX File Explorer** through Google Play Store on your mobile device.
- Turn on your WireGuard tunnel.
- Open **CX File Explorer** -> Network -> New Connection -> SFTP
    - Host: 10.10.0.1 (This is your VM's VPN IP)
    - User: your Ubuntu Server username
    - Password: your Ubuntu Server password
    - Port: 22
- Navigate to /mnt/Shared
- Anything that you put on the **Shared** folder on your host appears on your mobile device thruogh the VPN securely.

# Nextcloud Setup

## Nextcloud Setup

This guide documents how to install Nextcloud inside the Ubuntu Server VM.

---

## Update system

```bash
sudo apt update && sudo apt upgrade -y
```

## Install Nextcloud dependencies

```bash
sudo apt install apache2 mariadb-server libapache2-mod-php -y
sudo apt install php php-gd php-json php-mysql php-curl php-mbstring php-intl php-xml php-zip php-bz2 php-bcmath -y
```
- This install the dependencies like Apache, MariaDB, and all the php modules that Nextcloud needs.

## Run secure MariaDB (Optional)
- A guided installation script to make your database safer. (Built-in script) See `scripts/secure-install.sh`
- Used to set a root password, remove anonymous user, remove test database, etc.

## Log into MariaDB and create a database and user

```bash
sudo mysql -u root -p
```
- To create database and user see `examples/nextcloud-user.sql`

## Download Nextcloud

```bash
cd /tmp
wget https://download.nextcloud.com/server/releases/latest-30.tar.bz2
tar -xjf latest.tar.bz2
sudo mv nextcloud /var/www/
```

## Set Permission

```bash
sudo chown -R www-data:www-data /var/www/html/nextcloud
sudo chmod -R 755 /var/www/html/nextcloud
```

## Configure Apache

- Create /etc/apache2/sites-avilable/nextcloud.conf
- Configure your port, localdomain and grant access to nextcloud directory. See `examples/nextcloud-setup.conf`
- Enable modules and sites

```bash
sudo a2ensite nextcloud.conf
sudo a2enmod rewrite headers env dir mime
sudo systemctl restart apache2
```

## Finish Setup

- In your browser (or mobile device connected with WireGuard) open

```bash
http://10.10.0.1:8080
```
- You will see the NextCloud setup page.

![nextcloud-setup](https://raw.githubusercontent.com/Sharethefile/Ubuntu-virtualbox-lab/main/screenshots/nextcloud-login.png)

- Fill the details
    - Create a admin user
    - Add password
    - Database user: (Eg: user)
    - Database password: (Eg: password)
    - Database name: (Eg: nextcloud)

- Click install
- You will see the dashboard once installed

![nextcloud-dashboard](https://raw.githubusercontent.com/Sharethefile/Ubuntu-virtualbox-lab/main/screenshots/nextcloud-dashboard.png)

# Uptime Kuma Setup

## Uptime Kuma (Service Monitoring)

This guide documents how to install Uptime Kuma inside the Ubuntu Server VM.

---

## Update System

```bash
sudo apt update && sudo apt upgrade -y
```

## Install Uptime Kuma dependencies

```bash
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install nodejs -y
```

- You can verify the version of nodejs and npm by using

```bash
node -v
npm -v
```

- Uptime Kuma currently requires node version 20+

## Create a new database and user in MariaDB

- Log in as root into the database

```bash
sudo mysql -u root -p
```

- Create a new database and user. See `examples/kuma-user.sql`

## Install Uptime Kuma

```bash
cd /opt
sudo git clone https://github.com/louislam/uptime-kuma.git
sudo chown -R $USER:$USER uptime-kuma
cd uptime-kuma
npm install --omit=dev
```

## Test run

```bash 
node server/server.js
```

- In browser open

```bash
http://<VM_IP>:3001
```
- Fill all the details to complete the setup 
    - Database Type: `MariaDB/MySQL`
    - Hostname: `localhost`
    - Database: `uptimekuma`
    - Username: `uptimekumauser`
    - Password: `password`

- Create a new user in Uptime Kuma

![uptime-setup](https://raw.githubusercontent.com/Sharethefile/Ubuntu-virtualbox-lab/main/screenshots/uptime-kuma-setup.png)

## Run as a service
- Create a systemd service.

```bash
sudo nano /etc/systemd/system/uptime-kuma.service
```

- Configure the system service. See `examples/uptime-kuma-service.conf`
- Enable and start the service.

```bash
sudo systemctl daemon-reload
sudo systemctl enable uptime-kuma
sudo systemctl start uptime-kuma
sudo systemctl status uptime-kuma
```

![uptime-dash](https://raw.githubusercontent.com/Sharethefile/Ubuntu-virtualbox-lab/main/screenshots/uptime-kuma-dashboard.png)

## Add monitors
- Add monitors to see othr service that you are running.
    - Pihole -> HTTP(s) monitor -> **http://<VM_IP>/admin**
    - Nextcloud -> HTTP(s) monitor -> **http://<VM_IP>:<port>**
    - WireGuard -> Ping or TCP monitoe -> **VPN IP or Port**

![uptime-monitor](https://raw.githubusercontent.com/Sharethefile/Ubuntu-virtualbox-lab/main/screenshots/uptime-kuma-monitor.png)


## License
This repository is released under the MIT License. See `LICENSE`.
