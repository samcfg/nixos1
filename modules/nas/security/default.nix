# Security module - imports all security configurations
{ ... }:

{
  imports = [
    # ./sops.nix  # Disabled for VM testing - will re-enable for physical deployment
    ./ssh.nix
    ./firewall.nix
    ./tailscale.nix
  ];
}
