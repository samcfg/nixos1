{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = "sam";
  home.homeDirectory = "/home/sam";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "25.11";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # User packages
  home.packages = with pkgs; [
    claude-code  # Anthropic's Claude CLI
  ];

  # Basic git configuration
  programs.git = {
    enable = true;
    userName = "sam";
    userEmail = "sam@example.com";  # Change this to your email
  };
}
