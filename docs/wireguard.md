# WireGuard VPN Setup

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
- Enable guest additions in virtualbox. (See ./scripts/vbox-guest-tools.sh)
- Add a shared folder in virtualbox. (See ./docs/virtualbox.md)
- Mount the shared folder inside your VM. (See ./scripts/mount.sh)

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
