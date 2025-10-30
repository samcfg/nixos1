# Cockpit - web-based server management interface
{ config, pkgs, ... }:

{
  services.cockpit = {
    enable = true;
    port = 9090;
    openFirewall = true;

    # Cockpit provides a web UI for:
    # - System resource monitoring (CPU, RAM, disk, network)
    # - Service management (start/stop/restart services)
    # - Log viewing
    # - Terminal access via browser
    # - Storage management
    # - User management
    # - Container management (if cockpit-podman is installed)

    # Access at: http://nas-server:9090 or http://100.x.x.x:9090 (Tailscale IP)
    # Login with your system user credentials (sam / password)
  };

  # Optional: Add podman plugin for container management
  # environment.systemPackages = with pkgs; [
  #   cockpit-podman
  # ];
}
