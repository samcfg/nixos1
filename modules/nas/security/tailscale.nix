# Tailscale VPN for secure remote access
{ config, pkgs, ... }:

{
  services.tailscale = {
    enable = true;

    # Tailscale creates a virtual network interface (tailscale0)
    # Gives this machine a 100.x.x.x IP address accessible from anywhere

    # TODO: On first boot, authenticate with:
    # sudo tailscale up
    # This will give you a URL to authorize the device in your tailnet

    # For automated setup (optional), you can use an auth key from sops:
    # useRoutingFeatures = "server";  # If you want this to be an exit node
  };

  # Ensure Tailscale can access the network
  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  # Allow Tailscale to manage routes
  networking.firewall.checkReversePath = "loose";
}
