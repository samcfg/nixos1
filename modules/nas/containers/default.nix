# Containers module - imports all containerized services
{ ... }:

{
  imports = [
    ./docker.nix
    # ./nextcloud.nix     # Uncomment when ready to set up
    # ./syncthing.nix     # Uncomment when ready to set up
    # ./vaultwarden.nix   # Uncomment when ready to set up
  ];
}
