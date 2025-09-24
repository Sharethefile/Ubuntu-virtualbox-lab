# Uptime Kuma (Service Monitoring)

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
