# Pi Zero 2W - Ultra minimal wake-on-LAN trigger node
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Enable flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Network
  networking.hostName = "pi-zero";
  networking.useDHCP = true;

  # Bootloader - SD card boot for Pi Zero 2W
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  # Minimal kernel
  boot.kernelPackages = pkgs.linuxPackages;

  # No GUI, no X11, no Wayland
  services.xserver.enable = false;

  # SSH for remote access (REQUIRED)
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  # Tailscale for secure remote access
  services.tailscale.enable = true;

  # Wake-on-LAN tool
  environment.systemPackages = with pkgs; [
    ethtool      # For WOL configuration
    wakeonlan    # Send WOL magic packets
    vim          # Minimal editor
  ];

  # User account
  users.users.sam = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "changeme";
  };

  # Disable documentation to save space
  documentation.enable = false;
  documentation.nixos.enable = false;

  # Minimal services only
  services.udisks2.enable = false;
  services.gvfs.enable = false;

  system.stateVersion = "25.05";
}
