# Docker daemon configuration
{ config, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;

    # Automatically clean up old images and containers
    autoPrune = {
      enable = true;
      dates = "weekly";  # Run cleanup weekly
      flags = [
        "--all"  # Remove all unused images, not just dangling ones
      ];
    };

    # Docker daemon settings
    # Store docker data on ZFS if needed:
    # extraOptions = "--data-root /tank/docker";
  };

  # Install docker-compose for managing multi-container apps
  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
