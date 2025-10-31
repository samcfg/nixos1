# ZFS filesystem configuration
{ config, pkgs, ... }:

{
  # Enable ZFS support
  boot.supportedFilesystems = [ "zfs" ];

  # Automatic scrubbing - checks data integrity weekly
  services.zfs.autoScrub = {
    enable = true;
    interval = "weekly";  # Can be: daily, weekly, monthly
  };

  # Automatic snapshots - point-in-time backups
  services.zfs.autoSnapshot = {
    enable = true;
    frequent = 0;   # Disabled - too frequent for home use
    hourly = 0;     # Disabled
    daily = 7;      # Keep 7 daily snapshots (1 week)
    weekly = 3;     # Keep 4 weekly snapshots (1 month)
    monthly = 3;    # Keep 3 monthly snapshots (3 months)
  };

  # ZFS pool must be created manually (one-time setup):
  # For VM testing:
  #   sudo zpool create tank /dev/loop0
  # For physical server:
  #   sudo zpool create tank /dev/disk/by-id/your-disk-id
  #
  # Then create datasets:
  #   sudo zfs create tank/storage
  #   sudo zfs create tank/storage/sam

  # Declarative mount points (assumes pool already exists)
  fileSystems."/tank" = {
    device = "tank";
    fsType = "zfs";
  };

  fileSystems."/tank/storage/sam" = {
    device = "tank/storage/sam";
    fsType = "zfs";
  };

  # Set ownership declaratively
  systemd.tmpfiles.rules = [
    "d /tank/storage/sam 0755 sam users -"
  ];
}
