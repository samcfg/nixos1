# NAS Server Modules

Modular NixOS configuration for a home NAS server with security layers.

## Structure

```
modules/nas/
├── security/          # Infrastructure security
│   ├── ssh.nix        # SSH remote access
│   ├── firewall.nix   # Network firewall rules
│   ├── tailscale.nix  # VPN mesh network
│   └── sops.nix       # Secrets management
│
├── users/             # User accounts
│   └── sam.nix        # Admin user
│
├── storage/           # File storage
│   ├── zfs.nix        # ZFS filesystem
│   └── samba.nix      # SMB file shares
│
├── containers/        # Containerized services
│   ├── docker.nix     # Docker daemon
│   ├── nextcloud.nix  # Cloud storage (TODO)
│   ├── syncthing.nix  # P2P file sync (TODO)
│   └── vaultwarden.nix # Password manager (TODO)
│
└── system/            # System basics
    ├── packages.nix   # Essential tools
    └── cockpit.nix    # Web management
```

## Security Layers

1. **Infrastructure** (modules/nas/security/)
   - SSH with key-based auth
   - Firewall with default-deny
   - Tailscale VPN for remote access
   - sops-nix for encrypted secrets

2. **User Isolation** (modules/nas/users/ + storage/)
   - Unix file permissions
   - Per-user ZFS datasets
   - Samba share access control

3. **Application Security** (modules/nas/containers/)
   - Vaultwarden: End-to-end encrypted passwords
   - Nextcloud: Multi-user with access control
   - Docker: Container isolation

## Setup Steps

### 1. Initial Installation
- Boot NixOS installer ISO
- Run: `nixos-generate-config --root /mnt`
- Copy generated `hardware-configuration.nix` to `hosts/nas-server/`

### 2. Deploy Configuration
```bash
# From this repo root
sudo nixos-rebuild switch --flake .#nas-server
```

### 3. Set Up Secrets (sops-nix)
```bash
# Generate age key
nix-shell -p age --run "age-keygen -o ~/.config/sops/age/keys.txt"

# Add public key to .sops.yaml

# Edit secrets
nix-shell -p sops --run "sops secrets/secrets.yaml"

# Add password hashes, API keys, etc.
```

### 4. First Boot Tasks
```bash
# Connect to Tailscale
sudo tailscale up

# Change password
passwd

# Set up Samba password
sudo smbpasswd -a sam

# Access Cockpit at http://nas-server:9090
```

### 5. Storage Setup
```bash
# Create ZFS pool (adjust disk IDs)
sudo zpool create tank /dev/disk/by-id/your-disk

# Create datasets
sudo zfs create tank/storage
sudo zfs create tank/storage/sam
sudo chown sam:users /tank/storage/sam

# Configure Samba shares in storage/samba.nix
```

## Adding Services

Services are commented out by default. To enable:

1. Edit `containers/default.nix` - uncomment the service import
2. Configure the service in its file (e.g., `containers/nextcloud.nix`)
3. Rebuild: `sudo nixos-rebuild switch --flake .#nas-server`

## Ports Reference

| Port  | Service    | Protocol |
|-------|------------|----------|
| 22    | SSH        | TCP      |
| 139   | Samba      | TCP      |
| 445   | Samba      | TCP      |
| 137   | Samba      | UDP      |
| 138   | Samba      | UDP      |
| 9090  | Cockpit    | TCP      |
| 443   | Nextcloud  | TCP (future) |
| 8384  | Syncthing  | TCP (future) |
| 22000 | Syncthing  | TCP/UDP (future) |

## Files Not in Git

- `hosts/nas-server/hardware-configuration.nix` (hardware-specific)
- `secrets/secrets.yaml` (encrypted, safe to commit after setup)
- `/var/lib/sops-nix/key.txt` (age private key, lives on server only)
