# Syncthing - peer-to-peer file synchronization
{ config, pkgs, ... }:

{
  # TODO: Set up Syncthing after basic system is working
  # Syncthing provides:
  # - Direct device-to-device sync (no central server needed)
  # - Works offline - devices sync when they see each other
  # - Good for folders you want on multiple devices
  # - Lightweight alternative to Nextcloud for simple syncing

  # Can run as Docker container or native NixOS service
  # Native service example:
  # services.syncthing = {
  #   enable = true;
  #   user = "sam";
  #   dataDir = "/home/sam";
  #   configDir = "/home/sam/.config/syncthing";
  #   overrideDevices = true;
  #   overrideFolders = true;
  # };

  # Web UI will be on port 8384
  # Sync protocol uses port 22000 (TCP/UDP)
}
