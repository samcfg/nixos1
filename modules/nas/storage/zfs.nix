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
    frequent = 4;   # Keep 4 15-minute snapshots
    hourly = 24;    # Keep 24 hourly snapshots
    daily = 7;      # Keep 7 daily snapshots
    weekly = 4;     # Keep 4 weekly snapshots
    monthly = 12;   # Keep 12 monthly snapshots
  };

  # TODO: After hardware setup, create ZFS pool:
  # sudo zpool create tank /dev/disk/by-id/your-disk
  # sudo zfs create tank/storage
  # sudo zfs create tank/storage/sam
  # sudo chown sam:users /tank/storage/sam
}
