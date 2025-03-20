these are the existing systems that I still need to migrate:

- [ ] zeta.meeru
  - will need to temporarily migrate all *@hidek.xyz email addresses to another email provider (such as proton)
- [x] zeta.mem
- [x] zeta.fin
- [x] zeta.net
- [x] zeta.mc
- [ ] roxy
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
