{ config, pkgs, ... }:

{
  # Allow unfree packages in home-manager
  nixpkgs.config.allowUnfree = true;

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
    spotify      # Music streaming
  ];

  # Basic git configuration
  programs.git = {
    enable = true;
    userName = "sam";
    userEmail = "sam@example.com";  # Change this to your email
  };

  # GNOME keybindings
  dconf.settings = {
    # Workspace switching
    "org/gnome/desktop/wm/keybindings" = {
      switch-to-workspace-1 = ["<Super>1"];
      switch-to-workspace-2 = ["<Super>2"];
      switch-to-workspace-3 = ["<Super>3"];
      switch-to-workspace-4 = ["<Super>4"];
    };

    # Custom keybindings list
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
      ];
    };

    # Super+E: File Manager
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Files";
      command = "nautilus";
      binding = "<Super>e";
    };

    # Super+B: Browser
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "Browser";
      command = "firefox";
      binding = "<Super>b";
    };

    # Super+V: VSCodium
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      name = "VSCodium";
      command = "codium";
      binding = "<Super>v";
    };

    # Super+M: Spotify
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      name = "Spotify";
      command = "spotify";
      binding = "<Super>m";
    };
  };
}
