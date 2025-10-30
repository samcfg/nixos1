# Storage module - imports all storage configurations
{ ... }:

{
  imports = [
    ./zfs.nix
    ./samba.nix
  ];
}
