# VirtualBox: Create an Ubuntu Server VM

## Recommended VM Settings
- Name: ubuntu-server
- Type: Linux
- Version: Ubuntu (64-bit)
- Memory: 2048-4096 MB
- Virtual Disk: VDI, Dynamically allocated, 20-40 GB (depending on services)

## Storage
- Attach the Ubuntu Server ISO to the M's optical drive in Settings -> Storage

![VirtualBox-VM-settings] (./screenshots/vm-settings.png)

## Network (important)
- **Recommended:** Bridged Adapter - VM gets an IP from your router. It is regarded as a seperate machine in your LAN.
- Settings -> Network -> Adapter 1 -> Attached to: **Bridged Adapter** -> Advanced -> Adapter Type: Intel Pro/1000 MT Desktop -> check Cable Connected
- **Alternative:** NAt with port forwarding - more complex and limits Pi-hole being reached by host ports only.

## Starting the VM and login
- Click on the gren start button after the VM is created and follow the setup instructions for installing Ubuntu Server.
- After installation the the login page is displayed.
- The initial login is the root login with the password being the one you set during the setup.

![Ubuntu-login] (./screenshots/vm-login.png)

## Notes about interfaces
- Interface names may vary (`ens33`, `enp0s3`, etc)
- Use `ip a` to see the exact name (required for most services).

## Shut-down VM 
- To properly shutdown the VM use: `sudo shutdown now`