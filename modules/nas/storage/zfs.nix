# ZFS filesystem configuration
{ config, pkgs, ... }:

{
  # Enable ZFS support
  boot.supportedFilesystems = [ "zfs" ];

  # Auto-import ZFS pools on boot
  boot.zfs.extraPools = [ "tank" ];

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
  # For VM testing with virtual disk:
  #   sudo zpool create tank /dev/vdb
  # For physical server:
  #   sudo zpool create tank /dev/disk/by-id/your-disk-id
  #
  # After creating the pool, ZFS will auto-import and auto-mount on boot
  # thanks to boot.zfs.extraPools configuration above
}
