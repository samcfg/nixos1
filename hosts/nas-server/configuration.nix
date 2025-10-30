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

  # Bootloader - CHANGE THIS for your actual hardware
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";  # Update this to match your boot disk
  };

  # Enable flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Allow unfree packages (Tailscale, etc.)
  nixpkgs.config.allowUnfree = true;
}
