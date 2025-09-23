# Ubuntu-VirtualBox-lab
Experimenting with self-hosted services in Ubuntu server on VirtualBox 

This project is about experimenting with Ubuntu Server inside a VirtualBox before trying to run on bare metal.
The goal is to gradually build a mini self hosted environment with tools for ad-blocking, VPN, backup, media server, etc.


## Setup
- **VirtualBox** host
- **Ubuntu Server 22.04 LST** guest vm

## Plans
- Pi-hole for ad-blocking
- Wireguard as VPN for file-sharing
- Gitea for self-hosted Git
- Jellyfin for media server

## Project Layout
- `docs/` - guide for each service and VirtualBox tips
- `script/` - helper scripts
- `screenshots/` - images used in docs
- `examples/` - sample config files
- `.gitignore` - files to exclude from git

## Docs Links

- [VirtualBox Setup](./docs/virtualbox.md)  
- [Pi-hole Setup](./docs/pihole.md)
- [WireGuard Setup](./docs/wireguard.md)
- [Nextcloud Setup](./docs/nextcloud.md)

## License
This repository is released under the MIT License. See `LICENSE`.
