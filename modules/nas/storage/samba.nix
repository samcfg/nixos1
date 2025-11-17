# Samba file sharing configuration
{ config, pkgs, ... }:

{
  services.samba = {
    enable = true;
    openFirewall = true;    # Automatically opens required firewall ports

    # Global Samba settings
    settings = {
      global = {
        workgroup = "WORKGROUP";
        "server string" = "NAS Server";
        security = "user";  # Users must authenticate with username/password
        "guest account" = "nobody";
        "map to guest" = "bad user";

        # Performance tuning
        "socket options" = "TCP_NODELAY IPTOS_LOWDELAY SO_RCVBUF=524288 SO_SNDBUF=524288";
        "read raw" = "yes";
        "write raw" = "yes";
        "max xmit" = 65535;
        "dead time" = 15;
        "getwd cache" = "yes";
      };

      # Sam's personal files
      sam = {
        path = "/tank/sam";
        browseable = "yes";
        writable = "yes";
        "valid users" = "sam";
        "create mask" = "0644";
        "directory mask" = "0755";
      };

      # Shared family folder (example)
      # shared = {
      #   path = "/tank/storage/shared";
      #   browseable = "yes";
      #   writable = "yes";
      #   "valid users" = "sam alice bob";
      #   "create mask" = "0664";
      #   "directory mask" = "0775";
      # };
    };
  };

  # Samba users must be added manually after first boot:
  # sudo smbpasswd -a sam
  # This sets a Samba-specific password (can be different from system password)
}
