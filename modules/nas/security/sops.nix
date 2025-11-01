# sops-nix configuration for secrets management
{ config, pkgs, ... }:

{
  # sops-nix will be added as a flake input and module
  # This configures how secrets are decrypted at boot time

  # Secrets will be stored in /run/secrets/ (tmpfs, RAM only)
  # Format: config.sops.secrets.<name>.path gives you /run/secrets/<name>

  # Define which secrets exist (actual values in secrets/secrets.yaml)
  sops.secrets = {
    # User passwords (hashed)
    sam-password = {};
    # alice-password = {};
    # bob-password = {};

    # Service passwords
    syncthing-gui-password = {
      owner = "sam";
    };
    # nextcloud-admin-password = {};
    # nextcloud-db-password = {};

    # API keys
    # tailscale-auth-key = {};
  };

  # Point to the encrypted secrets file
  sops.defaultSopsFile = ../../../secrets/secrets.yaml;

  # Age key location (will be generated on the server)
  # The public key will be added to .sops.yaml
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
}
