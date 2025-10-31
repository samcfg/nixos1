# NAS Server - Main storage and services host
# This file is now minimal - all configuration lives in modules
{ config, pkgs, ... }:

{
  imports = [
    # Hardware detection (auto-generated on installation)
    ./hardware-configuration.nix

    # Modular configuration
    ../../modules/nas/security    # SSH, firewall, Tailscale, sops
    ../../modules/nas/users        # User accounts
    ../../modules/nas/storage      # ZFS, Samba
    ../../modules/nas/containers   # Docker, Nextcloud, Syncthing, Vaultwarden
    ../../modules/nas/system       # Cockpit, packages, basics
  ];

  # Host-specific settings
  networking.hostName = "nas-server";
  networking.hostId = "fedcba98";  # Required for ZFS - different from VM to prevent conflicts

  # Bootloader - Legacy BIOS (GA-EP45-UD3P motherboard)
  # Will likely be /dev/sda for your physical hardware, verify after installation
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";  # Update after checking 'lsblk' on physical server
  };

  # Enable flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Allow unfree packages (Tailscale, etc.)
  nixpkgs.config.allowUnfree = true;
}
