# NAS Server VM - Testing configuration before physical deployment
# This file is nearly identical to the physical server config
# Only differences: hostname and boot configuration
{ config, pkgs, ... }:

{
  imports = [
    # Hardware detection (auto-generated on VM installation)
    ./hardware-configuration.nix

    # Modular configuration (100% identical to physical server)
    ../../modules/nas/security    # SSH, firewall, Tailscale, sops
    ../../modules/nas/users        # User accounts
    ../../modules/nas/storage      # ZFS, Samba
    ../../modules/nas/containers   # Docker, Nextcloud, Syncthing, Vaultwarden
    ../../modules/nas/system       # Cockpit, packages, basics
  ];

  # Host-specific settings
  networking.hostName = "nas-server-vm";
  networking.hostId = "a1b2c3d4";  # Required for ZFS - prevents pool import conflicts

  # Bootloader - VM-specific (QEMU/KVM uses /dev/vda)
  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";  # QEMU/KVM virtual disk
  };

  # Enable flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Allow unfree packages (Tailscale, etc.)
  nixpkgs.config.allowUnfree = true;
}
