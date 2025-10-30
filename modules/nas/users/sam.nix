# Sam's user account configuration
{ config, pkgs, ... }:

{
  users.users.sam = {
    isNormalUser = true;
    description = "Sam";

    # Password will come from sops-nix secrets
    # TODO: Generate password hash and add to secrets.yaml
    # For now, using temporary password (CHANGE ON FIRST LOGIN)
    initialPassword = "changeme";
    # hashedPasswordFile = config.sops.secrets.sam-password.path;  # Enable after sops setup

    # Groups for permissions
    extraGroups = [
      "wheel"          # Allows sudo (administrative access)
      "networkmanager" # Can manage network connections
      "docker"         # Can run docker commands without sudo
    ];

    # Default shell
    shell = pkgs.bash;

    # SSH authorized keys (add your public key here)
    # openssh.authorizedKeys.keys = [
    #   "ssh-ed25519 AAAAC3Nza... your-key-here"
    # ];
  };
}
