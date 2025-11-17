# Containers module - imports all containerized services
{ ... }:

{
  imports = [
    ./docker.nix
    # ./immich.nix        # Uncomment when ready to set up
    # ./nextcloud.nix     # Uncomment when ready to set up
    ./syncthing.nix
    # ./vaultwarden.nix   # Uncomment when ready to set up
  ];
}
