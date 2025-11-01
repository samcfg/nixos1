# Syncthing - peer-to-peer file synchronization
{ config, pkgs, ... }:

{
  services.syncthing = {
    enable = true;
    user = "sam";
    dataDir = "/tank/sam";
    configDir = "/home/sam/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;
    guiAddress = "0.0.0.0:8384";  # Listen on all interfaces, not just localhost

    settings = {
      gui = {
        user = "sam";
        # Password managed through web UI (set manually on first login)
        # Syncthing persists the hashed password in its config file
        # Password stored encrypted in secrets/secrets.yaml (decrypt with: sops secrets/secrets.yaml)
      };
    };
  };

  # Web UI will be on port 8384
  # Sync protocol uses port 22000 (TCP/UDP)
  networking.firewall.allowedTCPPorts = [ 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 ];
}
