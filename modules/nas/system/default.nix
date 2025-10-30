# System module - imports all system-level configurations
{ ... }:

{
  imports = [
    ./packages.nix
    ./cockpit.nix
  ];
}
