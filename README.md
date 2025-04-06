these are the existing systems that I still need to migrate:

- [x] zeta.meeru
- [x] zeta.mem
- [x] zeta.fin
- [x] zeta.net
- [x] zeta.mc
- [x] roxy
- [x] templates.lxc "aoi" & "beta"

after that, then switch zeta hypervisor and OS from proxmox -> NixOS w/

- 2 vms running opnsense libvirt
- 9 microvms running:
  - 3 k3s server
  - 6 k3s agents (workload)

services:

- private DNS, DHCP server
- mc server exposed through self-hosted reverse proxy mesh (headscale)
- smb/nfs shares
- backup cron jobs
- mail server exposed through headscale

macos

- [x] install nix and nix-darwin

- install
  - [x] zen-browser (through mac installer not nix)
  - [x] zed-editor
  - [x] helix
  - [x] scroll reverser through nix-brew
  - [x] setup basic ssh
  - [x] setup ssh through existing nix mods and w/ sops.nix
  - [x] setup cross-compilation
  - [x] setup ~golang~ java dev
