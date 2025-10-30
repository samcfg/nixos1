# SSH configuration for remote access
{ config, pkgs, ... }:

{
  services.openssh = {
    enable = true;

    settings = {
      # Disable root login - always use regular user + sudo
      PermitRootLogin = "no";

      # TODO: Change to false after setting up SSH keys
      # For initial setup, password auth is easier
      # After you have keys working, disable passwords for better security
      PasswordAuthentication = true;

      # Disable password authentication for root (extra safety)
      PermitEmptyPasswords = false;

      # Use stronger key exchange algorithms
      KexAlgorithms = [
        "curve25519-sha256"
        "curve25519-sha256@libssh.org"
        "diffie-hellman-group16-sha512"
        "diffie-hellman-group18-sha512"
      ];
    };

    # Allow X11 forwarding (useful for GUI apps over SSH)
    # Disable if you don't need it
    # settings.X11Forwarding = false;
  };
}
