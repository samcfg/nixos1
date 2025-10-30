# Security module - imports all security configurations
{ ... }:

{
  imports = [
    ./sops.nix
    ./ssh.nix
    ./firewall.nix
    ./tailscale.nix
  ];
}
