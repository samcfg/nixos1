# ZFS filesystem configuration
{ config, pkgs, ... }:

{
  # Enable ZFS support
  boot.supportedFilesystems = [ "zfs" ];

  # Import non-root ZFS pool after boot completes (non-blocking)
  systemd.services.zfs-import-tank = {
    description = "Import ZFS pool 'tank'";
    after = [ "zfs-import.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.zfs}/bin/zpool import -N tank";
      ExecStartPost = "${pkgs.zfs}/bin/zfs mount -a";
    };
    # Don't fail boot if pool can't be imported
    unitConfig.ConditionPathExists = "!/tank";
  };

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
  # The pool will auto-import after boot via the systemd service above
  # This is non-blocking and won't prevent the system from booting
}
