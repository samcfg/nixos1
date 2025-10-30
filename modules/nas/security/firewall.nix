# Firewall configuration - default deny, explicit allow
{ config, pkgs, ... }:

{
  networking.firewall = {
    enable = true;

    # TCP ports to allow
    allowedTCPPorts = [
      22    # SSH - remote terminal access
      9090  # Cockpit - web management interface
      445   # Samba - SMB file sharing (main)
      139   # Samba - NetBIOS session service

      # Will add later when services are configured:
      # 443   # Nextcloud HTTPS
      # 8384  # Syncthing web UI
      # 22000 # Syncthing sync protocol
    ];

    # UDP ports to allow
    allowedUDPPorts = [
      137   # Samba - NetBIOS name service
      138   # Samba - NetBIOS datagram service

      # Will add later:
      # 22000 # Syncthing discovery (UDP)
      # 21027 # Syncthing discovery broadcast
    ];

    # Tailscale works through its own interface, doesn't need firewall rules
    # It bypasses these rules via the tailscale0 interface
  };
}
