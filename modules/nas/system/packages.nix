# System packages and basic settings
{ config, pkgs, ... }:

{
  # Timezone
  time.timeZone = "America/Los_Angeles";

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";

  # No GUI - this is a headless server
  services.xserver.enable = false;

  # Essential system packages
  environment.systemPackages = with pkgs; [
    # Editors
    vim
    nano

    # Version control
    git

    # System monitoring
    htop        # Interactive process viewer
    btop        # Modern resource monitor
    iotop       # Disk I/O monitor
    ncdu        # Disk usage analyzer

    # Network tools
    wget
    curl
    ethtool     # Network interface info
    iftop       # Network bandwidth monitor

    # ZFS tools
    zfs

    # Container tools
    docker-compose

    # Terminal multiplexer
    tmux

    # Wake-on-LAN
    wakeonlan

    # File utilities
    rsync
    tree
    unzip
    zip
  ];

  # Disable documentation to save space
  documentation.enable = false;
  documentation.nixos.enable = false;

  # Enable NetworkManager for easier network configuration
  networking.networkmanager.enable = true;

  # This value determines the NixOS release compatibility
  # Don't change this after installation
  system.stateVersion = "25.11";
}
