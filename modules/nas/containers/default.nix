# Containers module - imports all containerized services
{ ... }:

{
  imports = [
    ./docker.nix
    # ./nextcloud.nix     # Uncomment when ready to set up
    ./syncthing.nix
    # ./vaultwarden.nix   # Uncomment when ready to set up
  ];
}
